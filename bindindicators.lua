-- Meth stuff

if not meth_lua_api then
	return
end

local mvar, mcall = meth_lua_api.var, meth_lua_api.callbacks

if not mvar or not mcall then
	return
end

-- Locals

local table = table.Copy(table)

local debug = table.Copy(debug)
local pairs = pairs
local type = type

local function tCopy(n, t)
	if not n then
		return nil
	end
	
	local c = {}
	
	debug.setmetatable(c, debug.getmetatable(n))
	
	for k, v in pairs(n) do
		if type(v) ~= "table" then
			c[k] = v
		else
			t = t or {}
			t[n] = c
			
			if t[v] then
				c[k] = t[v]
			else
				c[k] = tCopy(v, t)
			end
		end
	end
	
	return c
end

local Color = Color
local concommand = tCopy(concommand)
local draw = tCopy(draw)
local gui = tCopy(gui)
local input = tCopy(input)
local language = tCopy(language)
local LocalPlayer = LocalPlayer
local render = tCopy(render)
local ScrH = ScrH
local ScrW = ScrW
local string = tCopy(string)
local surface = tCopy(surface)
local tobool = tobool
local tonumber = tonumber
local vgui = tCopy(vgui)

local meta_pl = tCopy(debug.getregistry()["Player"])

local settings = {
	["accent"] = "255 150 0 255",
	["doalways"] = true,
}

local bindcodes = {
	[37] = 89, -- KP left
	[38] = 88, -- KP up
	[106] = 48, -- KP mult
	[109] = 49, -- KP minus
	[111] = 47, -- KP div
	[39] = 91, -- kp right
	[40] = 90, -- kp down
	[107] = 50, -- kp plus
	[13] = 64, -- enter
	[46] = 73, -- delete
	
	[96] = 37, -- numpad 0
	[97] = 38, -- numpad 1
	[98] = 39, -- numpad 2
	[99] = 40, -- numpad 3
	[100] = 41, -- numpad 4
	[101] = 42, -- numpad 5
	[102] = 43, -- numpad 6
	[103] = 44, -- numpad 7
	[104] = 45, -- numpad 8
	[105] = 46, -- numpad 9
	
	[12] = nil, -- keypad clear (???)
	
	[20] = 68, -- Capslock
	
	[33] = 76, -- Page up
	[34] = 77, -- Page down
	[35] = 75, -- End
	[36] = 74, -- Home
	
	[1] = 107, -- Mouse 1
	[2] = 108, -- Mouse 2
	[4] = 109, -- Mouse 3
	[5] = 110, -- Mouse 4
	[6] = 111, -- Mouse 5
	
	[91] = 85, -- Left Win
	[16] = 79, -- Shift
	[18] = 81, -- Alt
	[17] = 83, -- control
	[93] = 87, -- Apps
}

local encheck = {
	["Aimbot..Enabled"] = {
		["toggle"] = {},
		["hold"] = {
			["Aimbot.Options.Key"] = "Aimbot",
		},
	},
	
	["Triggerbot..Enabled"] = {
		["toggle"] = {},
		["hold"] = {
			["Triggerbot.Options.Key"] = "Triggerbot",
		},
	},
	
	["ESP..Enabled"] = {
		["toggle"] = {
			["ESP..Visuals Toggle Key"] = {"ESP..Enabled", "ESP"},
			["Player.Third Person.Third Person Key"] = {"Player.Third Person.Third Person", "Thirdperson"},
			["Player.Free Cam.Free Cam Key"] = {"Player.Free Cam.Free Cam", "Freecam"},
		},
		["hold"] = {},
	},
	
	["General.Exploits.Fake Duck"] = {
		["toggle"] = {},
		["hold"] = {
			["General.Exploits.Fake Duck Key"] = "Fake Duck",
		},
	},
	
	["General.Exploits.Toos Freeze"] = {
		["toggle"] = {},
		["hold"] = {
			["General.Exploits.Freeze Key"] = "TOOS Freeze",
		},
	},
	
	["Misc.Server Lagger.Server Lagger"] = {
		["toggle"] = {},
		["hold"] = {
			["Misc.Server Lagger.Server Lagger Key"] = "Lagger",
		},
	},
	
	["*"] = {
		["toggle"] = {},
		["hold"] = {
			["Misc.Movement.Warp Charge Key"] = "Warp Charge",
			["Misc.Movement.Warp Deplete Key"] = "Warp Deplete",
			["Misc.Other.Magneto Toss Key"] = "Magneto Toss",
			["Misc.Other.Click To Add"] = "Click to Add",
		},
	}
}

-- Functions

local function strColor(str)
	local ret = Color(255, 255, 255, 255)
	
	if not str then
		return ret
	end
	
	ret = string.Split(str, " ")
	
	if not ret[1] then
		ret[1] = 255
	end
	
	if not ret[2] then
		ret[2] = 255
	end
	
	if not ret[3] then
		ret[3] = 255
	end
	
	ret[4] = 255
	
	return Color(tonumber(ret[1]) % 256, tonumber(ret[2]) % 256, tonumber(ret[3]) % 256, 255)
end

local function canRender()
	return not vgui.CursorVisible() and not gui.IsConsoleVisible() and not gui.IsGameUIVisible() and not meta_pl.IsTyping(LocalPlayer())
end

local function getOption(option)
	local ret = mvar.GetVarInt(option) % 256
	
	return ret
end

local function getKey(status)
	if status < 1 then
		return nil
	end
	
	if status > 47 and status < 91 then
		return input.GetKeyCode(string.char(status))
	end
	
	return bindcodes[status] or 0
end

local function getKeyStatus(option, istoggle, togglevar)
	if istoggle == nil then
		istoggle = false
	end

	local status = mvar.GetVarInt(option)
	
	if status < 1 then
		status = 0
	end

	status = status % 256
	
	local key = getKey(status) or 0
	local keystat = false
	
	if not istoggle then
		if key > 0 and (input.IsKeyDown(key) or input.IsMouseDown(key)) then
			keystat = true
		end
	else
		if togglevar and getOption(togglevar) == 1 then
			keystat = true
		end
	end
	
	return key, keystat
end

local function getBinds()
	local ret = {}
	
	for k, v in pairs(encheck) do
		if k ~= "*" then
			if getOption(k) ~= 1 then
				continue
			end
		end
		
		for option, optiondata in pairs(v.toggle) do
			local key, stat = getKeyStatus(option, true, optiondata[1])
			
			if key == 0 then
				if not settings["doalways"] then
					continue
				end
			
				stat = true
			end
			
			local keyname = input.GetKeyName(key) or "ALWAYS"
			
			table.insert(ret, {
				["name"] = optiondata[2],
				["type"] = "Toggle",
				["key"] = string.upper(keyname),
				["status"] = stat
			})
		end
		
		for option, name in pairs(v.hold) do
			local key, stat = getKeyStatus(option, false)
			
			if key == 0 then
				if not settings["doalways"] then
					continue
				end
			
				stat = true
			end
			
			local keyname = input.GetKeyName(key) or "ALWAYS"
			
			table.insert(ret, {
				["name"] = name,
				["type"] = "Hold",
				["key"] = string.upper(keyname),
				["status"] = stat
			})
		end
	end
	
	return ret
end

-- Hooks

mcall.Add("OnHUDPaint", "", function()
	if canRender() then
		draw.NoTexture()
		surface.SetFont("BudgetLabel")
		surface.SetTextColor(255, 255, 255, 255)
		
		local binds = getBinds()
		
		local x, h = 10, 47 + (15 * #binds)
		local y, w = (ScrH() / 2) - (h / 2), 245
		
		for _, v in ipairs(binds) do
			local tw, th = surface.GetTextSize(v.key)
			
			if (x + 190) + tw > w then
				w = (x + 190) + tw
			end
		end
		
		render.SetScissorRect(x, y, x + w, y + h, true)
		
		surface.SetDrawColor(0, 0, 0, 255)
		surface.DrawRect(x, y, w ,h)
		
		local c = 55
		local cs = c
		
		for i = 1, cs do
			surface.SetDrawColor(Color(c, c, c, 255))
			surface.DrawLine(x, y + i, x + w, y + i)
			
			c = c - 1
		end
		
		local tww, thh = surface.GetTextSize("Binds")
		surface.SetTextPos((w / 2) - (tww / 4), y + 5)
		surface.DrawText("Binds")
		
		surface.SetDrawColor(45, 45, 45, 255)
		surface.DrawRect(x + 10, y + 25, w - 20, h - 35)
		
		local offset = 0
		
		for _, v in ipairs(binds) do
			local ty = (y + 32) + (15 * offset)
		
			if v.status then
				surface.SetTextColor(255, 255, 255, 255)
			else
				surface.SetTextColor(150, 150, 150, 255)
			end
		
			surface.SetTextPos(x + 75, ty)
			surface.DrawText(v.name)
		
			if v.status then
				surface.SetTextColor(strColor(settings["accent"]))
			else
				surface.SetTextColor(150, 150, 150, 255)
			end
			
			surface.SetTextPos(x + 20, ty)
			surface.DrawText(v.type)

			surface.SetTextPos(x + 180, ty)
			surface.DrawText(v.key)
			
			offset = offset + 1
		end
		
		surface.SetDrawColor(12, 12, 12, 255)
		surface.DrawOutlinedRect(x + 10, y + 25, w - 20, h - 35)
		surface.DrawOutlinedRect(x, y, w, h)
		
		surface.SetDrawColor(strColor(settings["accent"]))
		surface.DrawLine(x + 10, y + 25, (x + w) - 10, y + 25)
		
		render.SetScissorRect(0, 0, 0, 0, false)
	end
end)

-- ConCommands

concommand.Add("bindindicators_accent_color_set", function(p, c, args, argstr)
	if not argstr then
		argstr = "nil"
	end
	
	settings["accent"] = argstr
end)

concommand.Add("bindindicators_display_always", function(p, c, args)
	if not args[1] then
		args[1] = false
	end
	
	settings["doalways"] = tobool(args[1])
end)
