--[[
	https://github.com/awesomeusername69420/meth_tools
	
	Convars:
		info_debug (0/1) - Controls displaying average stats
]]

local stuff = {
	convars = {
		debug = CreateClientConVar("info_debug", 0, true, false, "Controls debug mode for the infobar", 0, 1),
		fps_max = GetConVar("fps_max")
	},
	
	colors = {
		black = Color(0, 0, 0, 255),
		black_transparent = Color(0, 0, 0, 150),
		red = Color(255, 0, 0, 255),
		orange = Color(255, 150, 0, 255)
	},

	hostname = GetHostName(),
	tickrate = math.Round(1 / engine.TickInterval()),
	tps = 0,
	fps = 0,
	ping = LocalPlayer():Ping(),
	playercount = player.GetCount(),
	
	tickrate_third = 0,
	tickrate_two_thirds = 0,
	
	-- Debug
	
	cache = {},
	
	fps_average = 0,
	tps_average = 0,
	ping_average = 0
}

stuff.tickrate_third = math.Round(stuff.tickrate / 3)
stuff.tickrate_two_thirds = math.Round(stuff.tickrate * (2 / 3))

local function getFPS()
	local maxfps = stuff.convars.fps_max:GetInt()
	
	if maxfps == 0 then
		maxfps = math.huge
	end
	
	local curfps = math.Clamp(math.Round(1 / RealFrameTime()), 0, maxfps)
	
	stuff.cache.fps = stuff.cache.fps or {}
	stuff.cache.fps[#stuff.cache.fps + 1] = curfps
	
	if #stuff.cache.fps > 15 then
		table.remove(stuff.cache.fps, 1)
	end

	
	return curfps
end

local function getTPS()
	local curtps = math.Clamp(math.Round(1 / engine.ServerFrameTime()), 0, stuff.tickrate)
	
	stuff.cache.tps = stuff.cache.tps or {}
	stuff.cache.tps[#stuff.cache.tps + 1] = curtps
	
	if #stuff.cache.tps > 15 then
		table.remove(stuff.cache.tps, 1)
	end

	return curtps
end

local function getPing()
	local curping = LocalPlayer():Ping()
	
	stuff.cache.ping = stuff.cache.ping or {}
	stuff.cache.ping[#stuff.cache.ping + 1] = curping
	
	if #stuff.cache.ping > 15 then
		table.remove(stuff.cache.ping, 1)
	end
	
	return curping
end

-- Debug

local function getAverageFPS()
	local cur = 0
	
	for _, v in ipairs(stuff.cache.fps) do
		cur = cur + v
	end
	
	return math.Round(cur / #stuff.cache.fps)
end

local function getAverageTPS()
	local cur = 0
	
	for _, v in ipairs(stuff.cache.tps) do
		cur = cur + v
	end
	
	return math.Round(cur / #stuff.cache.tps)
end

local function getAveragePing()
	local cur = 0
	
	for _, v in ipairs(stuff.cache.ping) do
		cur = cur + v
	end
	
	return math.Round(cur / #stuff.cache.ping)
end

timer.Create("bbbb", 0.3, 0, function() -- Update stuff every now and then to avoid lag (Except tickrate, that will never change)
	stuff.hostname = GetHostName()
	stuff.tps = getTPS()
	stuff.fps = getFPS()
	stuff.ping = getPing()
	stuff.playercount = player.GetCount()
	
	if stuff.convars.debug:GetBool() then
		stuff.fps_average = getAverageFPS()
		stuff.tps_average = getAverageTPS()
		stuff.ping_average = getAveragePing()
	end
end)

meth_lua_api.callbacks.Add("OnHUDPaint", "bbbb", function()
	local ScrW = ScrW()
	local w, h = 0, 20

	surface.SetFont("BudgetLabel")
	surface.SetTextColor(color_white)

	local hostname = stuff.hostname .. " | "
	local tpsstr = "TPS: " .. stuff.tps .. " / " .. stuff.tickrate
	
	local str = hostname .. tpsstr .. " | FPS: " .. stuff.fps .. " | Ping: " .. stuff.ping .. "ms | Players: " .. stuff.playercount
	
	local tw, th = surface.GetTextSize(str)

	w = tw + 10

	local x = (ScrW - w) - 10

	surface.SetDrawColor(stuff.colors.black_transparent)
	surface.DrawRect(x, 10, w, h)
	
	surface.SetTextPos(x + ((w / 2) - (tw / 2)), 10 + (10 - (th / 2)))
	surface.DrawText(str)
	
	if stuff.tps < stuff.tickrate_two_thirds then
		surface.SetTextColor(stuff.colors.orange)
		
		if stuff.tps < stuff.tickrate_third then
			surface.SetTextColor(stuff.colors.red)
		end
	end
	
	local hw, hh = surface.GetTextSize(hostname)
	surface.SetTextPos(x + ((w / 2) - (tw / 2)) + hw, 10 + (10 - (th / 2)))
	surface.DrawText(tpsstr)
	
	-- Debug
	
	if stuff.convars.debug:GetBool() then
		str = "Average TPS: " .. stuff.tps_average .. " | Average FPS: " .. stuff.fps_average .. " | Average Ping: " .. stuff.ping_average .. "ms"
		
		tw, th = surface.GetTextSize(str)
		
		local dh = 10 + (2 * h)
		local dw = tw + 10
		local dx = (ScrW - dw) - 10
		
		surface.DrawRect(dx, 10 + h, dw, h)
		
		surface.SetDrawColor(stuff.colors.black)
		surface.DrawLine(x, 10, x + w, 10)
		surface.DrawLine(x + w, 10, x + w, dh)
		surface.DrawLine(x + w, dh, dx, dh)
		surface.DrawLine(dx, dh, dx, 10 + h)
		surface.DrawLine(dx, 10 + h, x, 10 + h)
		surface.DrawLine(x, 10 + h, x, 10)
		
		surface.SetTextColor(color_white)
		surface.SetTextPos(dx + ((dw / 2) - (tw / 2)), (10 + h) + (10 - (th / 2)))
		surface.DrawText(str)
	else
		surface.SetDrawColor(stuff.colors.black)
		surface.DrawOutlinedRect(x, 10, w, h)
	end
end)
