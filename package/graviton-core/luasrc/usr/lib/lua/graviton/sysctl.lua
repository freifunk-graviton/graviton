local util = require 'graviton.util'


module 'graviton.sysctl'

function set(name, value)
	util.replace_prefix('/etc/sysctl.conf', name .. '=', name .. '=' .. value .. '\n')
end
