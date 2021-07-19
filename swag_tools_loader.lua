local tbc = table.Copy

local Color = Color
local http = tbc(http)
local istable = istable
local jit = tbc(jit)
local MsgC = MsgC
local pairs = pairs
local RunString = RunString
local surface = tbc(surface)

local methapi = meth_lua_api or nil
local methutil = nil
local methrend = nil

if methapi then
	if istable(methapi) then
		if methapi.util then
			methutil = methapi.util
		end

		if methapi.render then
			methrend = methapi.render
		end
	end
end

http.Fetch("https://raw.githubusercontent.com/ts03GCZqIsTZtu4/swag_tools/main/swag_tools.lua",
	function(b)
		if methutil then
			methutil.RunString(b)
		else
			RunString(b)
		end
	end,

	function(e)
		if methrend then
			methrend.PushAlert("Failed to load Swag Tools")
			methrend.PushAlert("Error: " .. e)
		else
			surface.PlaySound("buttons/button10.wav")
			MsgC(Color(255, 100, 100), "Failed to load ", Color(100, 255, 255), "Swag Tools", Color(255, 100, 100), "\nError: ", Color(100, 255, 255), e)
		end
	end
)

jit.flush()
