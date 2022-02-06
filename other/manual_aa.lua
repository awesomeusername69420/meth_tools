--[[
	Arrow keys to control fake angle (real goes opposite)

	https://github.com/awesomeusername69420/meth_tools
]]

local stuff = {
	meth = {
		mvar = nil,
		mcall = nil
	},

	keyDown = false
}

if meth_lua_api then
	stuff.meth.mcall = meth_lua_api.callbacks

	if meth_lua_api.util.GetPermissions().CheatSettings then
		stuff.meth.mvar = meth_lua_api.var
	
		stuff.meth.mvar.SetVarInt("General.Options.Yaw", 1)
	end
end

hook.Add("CreateMove", "aa", function(cmd)
	if not stuff.meth.mvar then
		return
	end

	local up = input.IsKeyDown(KEY_UP)
	local down = input.IsKeyDown(KEY_DOWN)
	local left = input.IsKeyDown(KEY_LEFT)
	local right = input.IsKeyDown(KEY_RIGHT)

	if up or down or left or right then
		if not stuff.keyDown then
			if up then -- Stupid
				stuff.meth.mvar.SetVarInt("General.Options.Yaw", 4)
				stuff.meth.mvar.SetVarInt("General.Options.Fake Yaw", 1)
			end

			if down then
				stuff.meth.mvar.SetVarInt("General.Options.Yaw", 1)
				stuff.meth.mvar.SetVarInt("General.Options.Fake Yaw", 4)
			end

			if left then
				stuff.meth.mvar.SetVarInt("General.Options.Yaw", 3)
				stuff.meth.mvar.SetVarInt("General.Options.Fake Yaw", 2)
			end

			if right then
				stuff.meth.mvar.SetVarInt("General.Options.Yaw", 2)
				stuff.meth.mvar.SetVarInt("General.Options.Fake Yaw", 3)
			end

			stuff.keyDown = true
		end
	else
		if stuff.keyDown then
			stuff.keyDown = false
		end
	end
end)
