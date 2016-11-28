module("luci.controller.wireless", package.seeall)

function index()
  entry({"wireless"}, cbi("wireless"), _("Wireless"), 20)
end
