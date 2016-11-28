local uci = luci.model.uci.cursor()
local fs = require 'nixio.fs'
local iwinfo = require 'iwinfo'

-- functions
local function find_phy_by_path(path)
  for phy in fs.glob("/sys/devices/" .. path .. "/ieee80211/phy*") do
    return phy:match("([^/]+)$")
  end
end


local function find_phy_by_macaddr(macaddr)
  local addr = macaddr:lower()

  for file in fs.glob("/sys/class/ieee80211/*/macaddress") do
    if luci.util.trim(fs.readfile(file)) == addr then
      return file:match("([^/]+)/macaddress$")
    end
  end
end


local function country_list(phy)
  local list = iwinfo.nl80211.countrylist(phy) or { }
  local new  = { }
  local _, val

  for _, val in ipairs(list) do
    table.insert(new, {
      display_alpha2  = val.alpha2,
      display_country = val.name,
      driver_ccode    = val.ccode,
    })
  end

  return new
end


local function channel_list(phy)
  local list = iwinfo.nl80211.freqlist(phy) or { }
  local new  = { }
  local _, val

  for _, val in ipairs(list) do
    local dfs = ''

    if val.restricted == true then dfs = '(DFS) ' end
    table.insert(new, {
      display_mhz    = val.mhz,
      display_dfs    = dfs
      driver_channel = val.channel,
    })
  end

  return new
end


local function hwmode_list(phy)
  local list = iwinfo.nl80211.hwmodelist(phy) or { }
  local new  = { }
  local ht   = false
  local vht  = false
  local key, val

  for key, val in list do
    if val == true then
      if key == 'ac' then 
        vht = true
      elseif key == 'n' then 
         ht = true
      end

      table.insert(new, {
        display_hwmode = '802.11' .. tostring(key),
        driver_hwmode  = '11' .. tostring(val),
      })
    end
  end

  new['ht']  = ht
  new['vht'] = vht
  return new
end


local function txpower_list(phy)
  local list = iwinfo.nl80211.txpwrlist(phy) or { }
  local off  = tonumber(iwinfo.nl80211.txpower_offset(phy)) or 0
  local new  = { }
  local prev = -1
  local _, val

  for _, val in ipairs(list) do
    local dbm = val.dbm + off
    local mw  = math.floor(10 ^ (dbm / 10))
    if mw ~= prev then
      prev = mw
      table.insert(new, {
        display_dbm = dbm,
        display_mw  = mw,
        driver_dbm  = val.dbm,
      })
    end
  end

  new['offset'] = off
  return new
end


--Form
local f = SimpleForm("wifi", translate("WLAN"))
f.template = "admin/expertmode"

local s = f:section(SimpleSection, nil, translate(
                "Here you can configure wireless and TDMA-settings"
))

local radios = {}

-- look for wifi interfaces and add them to the array
uci:foreach('wireless', 'wifi-device',
  function(s)
    table.insert(radios, s['.name'])
  end
)

-- add settings for each interface
for _, radio in ipairs(radios) do
  local radioconfig = uci:get_all('wireless', radio)
  local p

  if radioconfig.hwmode == '11g' or radioconfig.hwmode == '11ng' then
    p = f:section(SimpleSection, translate("2.4 GHz"))
  elseif radioconfig.hwmode == '11a' or radioconfig.hwmode == '11na' then
    p = f:section(SimpleSection, translate("5 GHz"))
  end

  if p then
    local o
    local phy
    local gravconfig = uci:getall('wireless', 'graviton_' .. radio)

    if radioconfig.path then
      phy = find_phy_by_path(radioconfig.path)
    elseif radioconfig.macaddr then
      phy = find_phy_by_macaddr(radioconfig.macaddr)
    end

    if gravconfig and phy then
      local channels  = channel_list(phy)
      local txpowers  = txpower_list(phy)
      local countries = country_list(phy)
      local hwmodes   = hwmode_list(phy)
      local ht        = false
      local vht       = false

      o = p:option(Flag, radio .. '_graviton_enabled', translate("Enable"))
      o.default = gravconfig.disabled and o.disabled or o.enabled
      o.rmempty = false

      o = p:option(ListValue, radio .. '_mode', translate("BSS Mode"))
      o.rmempty = false
      o.default = gravconfig.mode or 'ap'
      o:value('ap', 'Access Point')
      o:value('sta', 'Client')
      o:value('wds', 'WDS')
      o:value('tdma', 'TDMA')
      o:value('mesh', 'Mesh')
      o:value('monitor', 'Monitor')

      o = p:option(Value, radio .. "_graviton_essid", translate("ESSID"))
      o.rmempty = false
      o.datatype = "maxlength(32)"
      o.default = gravconfig.ssid or 'Graviton'

      o = p:option(Flag, radio .. '_graviton_hidden', translate("Hide ESSID in beacons"))
      o.rmempty = false
      o.default = gravconfig.hidden and o.enabled or o.disabled
      
      o = p:option(Value, radio .. "_graviton_bssid", translate("BSSID"))
      o.datatype = "macaddr"
      o.default = gravconfig.bssid or get_default_bssid(phy)
      o.rmempty = true

      o = p:option(Value, radio .. "_distance", translate("Distance (in Meters)"))
      o.datatype = "uinteger"
      o.default = radioconfig.distance

      o = p:option(Flag, radio .. "_ht_coex", translate("Ignore HT40 intolerance (may be illegal in your country)"))
      o.default = radioconfig.ht_coex and o.enabled or o.disabled

      o = p:option(ListValue, radio .. '_chanbw', translate("Channel width"))
      o.rmempty = true
      o.default = uci:get('wireless', radio, 'chanbw') or 'default'
      o:value('default', '(driver default)')
      if radioconfig.type == 'ath5k' or radioconfig.type == 'ath9k' then
        o:value(5, translate("5 MHz"))
        o:value(10, translate("10 MHz"))
        o:value(20, translate("20 MHz"))
      end

      if #channels > 1 then
        o = p:option(ListValue, radio .. '_channel', translate("Channel"))

        o.default = radioconfig.channel or 'auto'
        o:value('auto', translate("(auto)"))

        table.sort(channels, function(a, b) return a.driver_channel > b.driver_channel end)
        for _, entry in ipairs(channels) do
          o:value(entry.driver_channel, "%s%i (%i MHz)" % {entry.display_dfs, entry.driver_channel, entry.display_mhz})
        end
      end

      o = p:option(Value, radio .. "_admin_antenna_gain", translate("Antenna gain"))
      o.datatype = "uinteger"
      o.default = radioconfig.admin_antenna_gain
      o = p:option(Value, radio .. "_admin_cable_loss", translate("Cable loss"))
      o.datatype = "uinteger"
      o.default = radioconfig.admin_cable_loss

      if #txpowers > 2 then
        o = p:option(ListValue, radio .. '_txpower', translate("Transmission power"))
        o.rmempty = true
        o.default = radioconfig.txpower or 'default'
        o:value('default', translate("(driver default)"))

        table.sort(txpowers, function(a, b) return a.driver_dbm > b.driver_dbm end)
        for _, entry in ipairs(txpowers) do
          o:value(entry.driver_dbm, "%i+%i dBi dBm (%i mW)" % {entry.display_dbm, , entry.display_mw})
        end
      end

      if #countries > 0 then
        local tp = p:option(ListValue, radio .. '_country', translate("Country"))
        o.rmempty = true
        o.default = radioconfig.country or 'default'
        o:value('default', translate("(driver default)"))
        o:value('00', translate("00 (strictest)"))

        table.sort(countries, function(a, b) return a.display_alpha2 > b.display_alpha2 end)
        for _, entry in ipairs(countries) do
          o:value(entry.driver_ccode, "%s (%s)" % {entry.display_alpha2, entry.display_country})
        end
      end

      if #hwmodes > 2 then
	ht  = hwmodes['ht']
        vht = hwmodes['vht']
        hwmodes['ht'] = nil
        hwmodes['vht'] = nil
        o = p:option(ListValue, radio .. '_hwmode', translate("Modes"))
        o.rmempty = true
        o.default = radioconfig.hwmode or 'default'

        table.sort(hwmodes, function(a, b) return a.driver_hwmode > b.driver_hwmode end)
        for _, entry in ipairs(hwmodes) do
          o:value(entry.driver_hwmode, entry.display_hwmode)
        end
      end
      
      o = p:option(ListValue, radio .. '_graviton_apmode', translate("(V)HT mode"))
      o.rmempty = true
      o.default = radioconfig.htmode or 'default'
      o:value('default', translate("(driver default)"))
      if ht == true then
        o:value('HT20', translate("HT20"))
        o:value('HT40', translate("HT40 (auto)"))
        o:value('HT40-', translate("HT40-"))
        o:value('HT40+', translate("HT40+"))
      end
      if vht == true then
        o:value('VHT20', translate("VHT20"))
        o:value('VHT40', translate("VHT40"))
        o:value('VHT80', translate("VHT80"))
        o:value('VHT160', translate("VHT160"))
      end
    end
  end
end



--when the save-button is pushed
function f.handle(self, state, data)
  if state == FORM_VALID then

    for _, radio in ipairs(radios) do
      if uci:get('wireless', 'graviton_' .. radio) then
	local disabled = '0' == data[radio .. '_graviton_enabled']
	local hidden   = data[radio .. '_graviton_hidden']
        local mode     = data[radio .. '_graviton_mode']
        local essid    = data[radio .. '_graviton_essid']
        local bssid    = data[radio .. '_graviton_bssid']
        local bssid    = data[radio .. '_graviton_bssid']

	uci:set('wireless', 'graviton_' .. radio, "mode", mode)
	uci:set('wireless', 'graviton_' .. radio, "disabled", disabled)
      end

      if data[radio .. '_channel'] then
        uci:set('wireless', radio, 'channel', data[radio .. '_channel'])
      end

      if data[radio .. '_chanbw'] then
        uci:set('wireless', radio, 'chanbw', data[radio .. '_chanbw'])
      end

      if data[radio .. '_country'] then
        if data[radio .. '_country'] == 'default' then
          uci:delete('wireless', radio, 'country')
        else
          uci:set('wireless', radio, 'country', data[radio .. '_country'])
        end
      end

      if data[radio .. '_hwmode'] then
        uci:set('wireless', radio, 'hwmode', data[radio .. '_hwmode'])
      end

      if data[radio .. '_txpower'] then
        if data[radio .. '_txpower'] == 'default' then
          uci:delete('wireless', radio, 'txpower')
        else
          uci:set('wireless', radio, 'txpower', data[radio .. '_txpower'])
        end
      end

      if data[radio .. '_admin_antenna_gain'] or data[radio .. '_admin_cable_loss'] then
        local loss = data[radio .. '_admin_cable_loss']
        local gain = data[radio .. '_admin_antenna_gain']
        if not loss then
          loss=0
        end
        if not gain then
          gain=0
        end
        uci:set('wireless', radio, 'antenna_gain', data[radio .. '_admin_antenna_gain'] - loss)
        uci:set('wireless', radio, 'admin_antenna_gain', data[radio .. '_admin_antenna_gain'])
        uci:set('wireless', radio, 'admin_cable_loss', data[radio .. '_admin_antenna_gain'])
      end

      if data[radio .. '_htmode'] then
        if data[radio .. '_htmode'] == 'default' then
          uci:delete('wireless', radio, 'htmode')
        else
          uci:set('wireless', radio, 'htmode', data[radio .. '_htmode'])
        end
      end

    end

    uci:save('wireless')
    uci:commit('wireless')
  end
end

return f
