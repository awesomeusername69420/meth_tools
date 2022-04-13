--[[
	https://github.com/awesomeusername69420/meth_tools
]]

local stuff = {
	color_black = Color(0, 0, 0, 150),

	hostname = GetHostName(),
	tickrate = math.Round(1 / engine.TickInterval()),
	tps = 0,
	fps = 0,
	ping = LocalPlayer():Ping(),
	playercount = player.GetCount()
}

local function getFPS()
	return math.Round(1 / RealFrameTime())
end

local function getTPS()
	return math.Clamp(math.Round(1 / engine.ServerFrameTime()), 0, stuff.tickrate)
end

timer.Create(tostring({}), 0.3, 0, function() -- Update stuff every now and then to avoid lag (Except tickrate, that will never change)
	stuff.hostname = GetHostName()
	stuff.tps = getTPS()
	stuff.fps = getFPS()
	stuff.ping = LocalPlayer():Ping()
	stuff.playercount = player.GetCount()
end)

meth_lua_api.callbacks.Add("OnHUDPaint", tostring({}), function()
	local w, h = 0, 20

	surface.SetFont("BudgetLabel")
	surface.SetTextColor(color_white)

	local str = stuff.hostname .. " | TPS: " .. stuff.tps .. " / " .. stuff.tickrate .. " | FPS: " .. stuff.fps .. " | PING: " .. stuff.ping .. "ms | Players: " .. stuff.playercount
	local tw, th = surface.GetTextSize(str)

	w = tw + 10

	local x = (ScrW() - w) - 10

	surface.SetDrawColor(stuff.color_black)
	surface.DrawRect(x, 10, w, h)

	surface.SetTextPos(x + ((w / 2) - (tw / 2)), 10 + (10 - (th / 2)))
	surface.DrawText(str)
end)
