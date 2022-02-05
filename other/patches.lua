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
	called = false,
	ogdebug = _reg[1],
	ogapi = table.Copy(meth_lua_api),
	apiperms = meth_lua_api.util.GetPermissions() or {}
}

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

		if stuff.apiperms.CheatSettings then -- Prevent fake angle chams rendering in mirrors, cameras, etc
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

	if stuff.apiperms.CheatSettings then-- API fixes
		meth_lua_api.var.GetVarInt = function(var) -- Stop API returning retarded numbers sometimes
			local og = stuff.ogapi.var.GetVarInt(var)

			if string.find(string.lower(var), "color") then -- Fix color calls
				return og
			end

			return og % 256
		end

		meth_lua_api.var.GetVarColor = function(var) -- Convenient way to get colors from the API
			local x = stuff.ogapi.var.GetVarInt(var)
			
			local r, g, b
			
			r = x % 256
			g = ((x - r) / 256) % 256
			b = (((x - r) / 65536) - (g / 256)) + 256 
			
			local a = math.floor(math.abs(x) / 16777216) 
			
			if x < 0 then
				a = 255 - a
			end
			
			return Color(r, g, b, a)
		end
	end

	if meth_lua_api.callbacks then
		meth_lua_api.callbacks.Add("OnHUDPaint", stuff.name, function() -- Fix API rendering with SetRenderTarget
			if stuff.called then
				return
			end
	
			stuff.called = true
	
			local ogrt = render.GetRenderTarget()
			render.SetRenderTarget()
	
			meth_lua_api.callbacks.OnHUDPaint()
	
			render.SetRenderTarget(ogrt)
			stuff.called = false
		end)
	end
end)
