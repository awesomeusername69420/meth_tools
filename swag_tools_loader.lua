-- Meth stuff

local mrend, mutil

if meth_lua_api then
	mrend = meth_lua_api.render
	mutil = meth_lua_api.util
end

-- Localization

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
local http = tCopy(http)
local LocalPlayer = LocalPlayer
local math = tCopy(math)
local MsgC = MsgC
local RunString = RunString
local string = tCopy(string)
local surface = tCopy(surface)
local timer = tCopy(timer)
local tostring = tostring

local meta_en = tCopy(debug.getregistry()["Entity"])

local INIT_TIMER_NAME = string.char(math.random(97, 122)) .. tostring(math.random(-123456, 123456))

timer.Create(INIT_TIMER_NAME, 1, 0, function()
	if meta_en.IsValid(LocalPlayer()) then -- Wait until LocalPlayer is valid before loading
		http.Fetch("https://raw.githubusercontent.com/awesomeusername69420/meth_tools/main/swag_tools.lua", function(b)
			if mutil then
				mutil.RunString(b)
			else
				RunString(b)
			end
		end, function(e)
			if mrend then
				mrend.PushAlert("Failed to load Swag Tools.")
				mrend.PushAlert("Reason: " .. e)
			else
				surface.PlaySound("buttons/button10.wav")
				MsgC(Color(255, 100, 100), "[STL] ", Color(222, 222, 222), "Failed to load Swag Tools. Reason: ", Color(255, 100, 100), e .. "\n")
			end
		end)
		
		timer.Remove(INIT_TIMER_NAME)
	end
end)
