local table = table.Copy(table)

local Color = Color
local http = table.Copy(http)
local jit = table.Copy(jit)
local MsgC = MsgC
local RunString = RunString
local surface = table.Copy(surface)

local mrend, mutil

if meth_lua_api then
	if meth_lua_api.render then
		mrend = meth_lua_api.render
	end

	if meth_lua_api.util then
		mutil = meth_lua_api.util
	end
end

http.Fetch("https://raw.githubusercontent.com/awesomeusername69420/meth_tools/main/swag_tools.lua",
	function(b)
		if mutil then
			mutil.RunString(b)
		else
			RunString(b)
		end
	end,

	function(e)
		if mrend then
			mrend.PushAlert("Failed to load Swag Tools.")
			mrend.PushAlert("Reason: " .. e)
		else
			surface.PlaySound("buttons/button10.wav")

			MsgC(Color(255, 100, 100), "[$W467001Z] ", Color(222, 222, 222), "Failed to load Swag Tools. Reason: ", Color(255, 100, 100), e .. "\n")
		end
	end
)

jit.flush()
