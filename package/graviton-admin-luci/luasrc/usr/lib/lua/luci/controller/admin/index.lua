--[[
LuCI - Lua Configuration Interface

Copyright 2008 Steven Barth <steven@midlink.org>
Copyright 2008 Jo-Philipp Wich <xm@leipzig.freifunk.net>

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

	http://www.apache.org/licenses/LICENSE-2.0

$Id$
]]--

module("luci.controller.admin.index", package.seeall)

function index()
	local uci_state = luci.model.uci.cursor_state()

	if uci_state:get_first('graviton-admin', 'admin', 'running', '0') ~= '1' then
		return
	end

	local root = node()
	if not root.lock then
		root.target = alias("admin")
		root.index = true
	end

	local page = entry({"admin"}, alias("admin", "index"), _("Advanced settings"), 10)
	page.sysauth = "root"
	page.sysauth_authenticator = "htmlauth"
	page.index = true

	entry({"index"}, cbi("status"), _("Status"), 1).ignoreindex = true
	entry({"remote"}, cbi("advanced"), _("Advanced"), 10)
end
