--[[
	Fixes some bugs and improves some things relating to meth
	Place this is your autorun folder (C:\MTHRW\LUA\autorun)

	https://github.com/awesomeusername69420/meth_tools
]]

if not meth_lua_api or not meth_lua_api.util or not meth_lua_api.var then
	return
end

local _reg = debug.getregistry()

local stuff = {
	name = string.char(math.random(97, 122)) .. tostring(math.random(-123456, 123456)),
	ogdebug = _reg[1],
	ogapi = table.Copy(meth_lua_api),
	apiperms = meth_lua_api.util.GetPermissions() or {},

	getvarwhitelist = { -- Fixing these vars will break them
		"color",
		"custom.config",
		"entity.misc entity.max distance",
		"player.ignore.max distance",
		"player.config.player font weight",
		"entity.config.entity font weight",
		"general.exploits.freeze power",
		"misc.server lagger.server lagger custom value",
		"aimbot.position adjustment.fake latency"
	}
}

local function isWhiteListed(var)
	var = string.lower(var or "")

	for _, v in ipairs(stuff.getvarwhitelist) do
		if string.find(var, v) then
			return true
		end
	end

	return false
end

local function normalizeAngle(n, r)
	n = n or 0
	r = r or 0

	while n > r do
		n = n - r
	end

	while n < 0 - r do
		n = n + r
	end

	return n
end

if stuff.apiperms.CheatSettings then
	if not stuff.ogaa then
		stuff.ogaa = meth_lua_api.var.GetVarInt("General.Options.Enabled") % 256
	end
end

hook.Add("InitPostEntity", stuff.name, function()
	if stuff.ogaa then
		meth_lua_api.var.SetVarInt("General.Options.Enabled", stuff.ogaa)
		stuff.ogaa = nil
	end

	timer.Create(stuff.name, 3, 0, function() -- Stop stupid crash / breaker
		_reg[1] = stuff.ogdebug
	end)

	hook.Add("PreRender", stuff.name, function()
		render.PopCustomClipPlane()
	end)
	
	hook.Add("ShutDown", stuff.name, function()
		render.PopCustomClipPlane()
	end)

	hook.Add("PreDrawEffects", stuff.name, function()
		render.PushCustomClipPlane(Vector(0, 0, 0), 0) -- Fix clipping issues

		if stuff.apiperms.CheatSettings then -- Prevent fake angle chams rendering in mirrors, cameras, etc (in first person)
			meth_lua_api.var.SetVarInt("Player.Misc Players.Fake Angle Chams", meth_lua_api.var.GetVarInt("Player.Third Person.Third Person"))
		end
	end)

	hook.Add("CreateMove", stuff.name, function(cmd)
		if stuff.apiperms.CheatSettings then
			if not stuff.ogaa then -- Fix antiaim in water
				stuff.ogaa = meth_lua_api.var.GetVarInt("General.Options.Enabled")
			end
		
			if LocalPlayer():WaterLevel() > 1 then
				meth_lua_api.var.SetVarInt("General.Options.Enabled", 0)
			else
				meth_lua_api.var.SetVarInt("General.Options.Enabled", stuff.ogaa)
				stuff.ogaa = nil
			end
			
			if meth_lua_api.var.GetVarInt("Player.Free Cam.Free Cam") == 1 then
				cmd:ClearButtons()
				cmd:ClearMovement()
			end
		end
	end)

	if stuff.apiperms.CheatSettings then -- API fixes + Additions
		meth_lua_api.var.GetVarInt = function(var) -- Stop API returning retarded numbers sometimes
			if not var then
				return
			end

			var = string.Trim(var)

			local og = stuff.ogapi.var.GetVarInt(var)

			if isWhiteListed(var) then -- Fix certain calls
				return og
			end

			return og % 256
		end

		meth_lua_api.var.GetVarFloat = function(var)
			if not var then
				return
			end

			var = string.Trim(var)

			local og = stuff.ogapi.var.GetVarFloat(var)

			if isWhiteListed(var) then -- Fix certain calls
				return og
			end

			return og % 256
		end

		meth_lua_api.var.SetVarFloat = function(var, val) -- Fix crashes from setting fucky custom antiaim angles + makes it act more like normal gmod
			if not var or not val then
				return
			end

			var = string.Trim(var)

			if string.find(var, "Custom.Config.") then
				if var == "Custom.Config.Custom Pitch" then
					val = math.Clamp(val, -89, 89)
				else
					val = normalizeAngle(val, 360)
				end
			end

			return stuff.ogapi.var.SetVarFloat(var, val)
		end

		meth_lua_api.var.SetVarInt = function(var, val) -- Gay
			if not var or not val then
				return
			end

			var = string.Trim(var)

			return stuff.ogapi.var.SetVarInt(var, val)
		end

		meth_lua_api.var.GetVarColor = function(var) -- Convenient way to get colors from the API
			if not var then
				return
			end

			var = string.Trim(var)

			local og = stuff.ogapi.var.GetVarInt(var)
			
			local r, g, b
			
			r = og % 256
			g = ((og - r) / 256) % 256
			b = (((og - r) / 65536) - (g / 256)) + 256 
			
			local a = math.floor(math.abs(og) / 16777216) 
			
			if og < 0 then
				a = 255 - a
			end
			
			return Color(r, g, b, a)
		end
	end
end)
