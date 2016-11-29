-- Writes all lines from the file input to the file output except those starting with prefix
-- Doesn't close the output file, but returns the file object
local function do_filter_prefix(input, output, prefix)
  local f = io.open(output, 'w+')
  local l = prefix:len()

  for line in io.lines(input) do
    if line:sub(1, l) ~= prefix then
      f:write(line, '\n')
    end
  end

  return f
end


local function escape_args(ret, arg0, ...)
  if not arg0 then
    return ret
  end

  return escape_args(ret .. "'" .. string.gsub(arg0, "'", "'\\''") .. "' ", ...)
end


local io = io
local os = os
local string = string
local tonumber = tonumber
local ipairs = ipairs
local table = table

local nixio = require 'nixio'
local hash = require 'hash'
local sysconfig = require 'graviton.sysconfig'
local site = require 'graviton.site_config'
local uci = require('luci.model.uci').cursor()
local lutil = require 'luci.util'
local fs = require 'nixio.fs'


module 'graviton.util'

function exec(...)
  return os.execute(escape_args('', 'exec', ...))
end

-- Removes all lines starting with a prefix from a file, optionally adding a new one
function replace_prefix(file, prefix, add)
  local tmp = file .. '.tmp'
  local f = do_filter_prefix(file, tmp, prefix)
  if add then
  	f:write(add)
  end
  f:close()
  os.rename(tmp, file)
end

function readline(fd)
  local line = fd:read('*l')
  fd:close()
  return line
end

function lock(file)
  exec('lock', file)
end

function unlock(file)
  exec('lock', '-u', file)
end

function node_id()
  return string.gsub(sysconfig.primary_mac, ':', '')
end


local function find_phy_by_path(path)
  for phy in fs.glob('/sys/devices/' .. path .. '/ieee80211/phy*') do
    return phy:match('([^/]+)$')
  end
end

local function find_phy_by_macaddr(macaddr)
  local addr = macaddr:lower()
  for file in fs.glob('/sys/class/ieee80211/*/macaddress') do
    if lutil.trim(fs.readfile(file)) == addr then
      return file:match('([^/]+)/macaddress$')
    end
  end
end

local function find_phy(radio)
  local config = uci:get_all('wireless', radio)

  if not config or config.type ~= 'mac80211' then
    return nil
  elseif config.path then
    return find_phy_by_path(config.path)
  elseif config.macaddr then
    return find_phy_by_macaddr(config.macaddr)
  else
    return nil
  end
end

local function get_addresses(radio)
  local phy = find_phy(radio)
  if not phy then
    return function() end
  end

  return io.lines('/sys/class/ieee80211/' .. phy .. '/addresses')
end

-- Should generates a unique MAC address
-- The parameter defines the ID to add to the MAC address
--
-- IDs defined so far:
-- 0: client0; WAN
-- 1: mesh0
-- 2: ibss0
-- 3: wan_radio0 (private WLAN); batman-adv primary address
-- 4: client1; LAN
-- 5: mesh1
-- 6: ibss1
-- 7: wan_radio1 (private WLAN); mesh VPN
function generate_mac(i)
  -- generate MAC like Aruba 
  -- (https://community.arubanetworks.com/t5/Controller-Based-WLANs/
  --  How-is-the-BSSID-derived-from-the-Access-Point-ethernet-MAC/ta-p/176290)

  local oui1, oui2, oui3, _, mm, suf1,suf2, suf3, suf4, suf5, suf6 = 
        string.match(sysconfig.primary_mac, '(%x%x):(%x%x):(%x%x):%x%x:%x%x:%x%x:%x%x')  

  -- It's necessary that the first 45 bits of the MAC address don't
  -- vary on a single hardware interface, since some chips are using
  -- a hardware MAC filter. (e.g 'rt305x')
  if i > 7 or i < 0 then return nil end -- max allowed id (0b111)

  mm = tonumber(mm, 16)
  oui1 = tonumber(oui1, 16)

  mm = nixio.bin.bxor(mm, 0x08) -- Only Aruba style? What about other vendors?
  oui1 = nixio.bit.band(oui1, 0xFE) -- unset the multicast bit
  oui1 = nixio.bit.bor(oui1, 0x02)  -- set locally administered bit

  return string.format('%02x:%s:%01x%01x:%01x%01x:%01x%01x%01x',
                       oui1, oui2, mm, suf1, suf2, suf3, suf4, suf5, i)
end

local function get_wlan_mac_from_driver(radio, vif)
  local primary = sysconfig.primary_mac:lower()

  local i = 1
  for addr in get_addresses(radio) do
    if addr:lower() ~= primary then
      if i == vif then
        return addr
      end

      i = i + 1
    end
  end
end

function get_wlan_mac(radio, index, vif)
  local addr = get_wlan_mac_from_driver(radio, vif)
  if addr then
    return addr
  end

  return generate_mac(4*(index-1) + (vif-1))
end

-- Iterate over all radios defined in UCI calling
-- f(radio, index, site.wifiX) for each radio found while passing
--  site.wifi24 for 2.4 GHz devices and site.wifi5 for 5 GHz ones.
function iterate_radios(f)
  local radios = {}

  uci:foreach('wireless', 'wifi-device',
    function(s)
      table.insert(radios, s['.name'])
    end
  )

  for index, radio in ipairs(radios) do
    local hwmode = uci:get('wireless', radio, 'hwmode')

    if hwmode == '11g' or hwmode == '11ng' then
      f(radio, index, site.wifi24)
    elseif hwmode == '11a' or hwmode == '11na' then
      f(radio, index, site.wifi5)
    end
  end
end
