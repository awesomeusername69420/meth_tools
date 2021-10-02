if not meth_lua_api then
	return
end

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

local concommand = tCopy(concommand)
local CreateMaterial = CreateMaterial
local GetConVar = GetConVar
local ipairs = ipairs
local LocalPlayer = LocalPlayer
local math = tCopy(math)
local player = tCopy(player)
local render = tCopy(render)
local string = tCopy(string)
local tobool = tobool
local tostring = tostring

local meta_cv = tCopy(debug.getregistry()["ConVar"])
local meta_en = tCopy(debug.getregistry()["Entity"])
local meta_im = tCopy(debug.getregistry()["IMaterial"])
local meta_pl = tCopy(debug.getregistry()["Player"])

local bumpvar = GetConVar("mat_bumpmap")
local specvar = GetConVar("mat_specular")

local glowmat = CreateMaterial(string.char(math.random(97, 122)) .. tostring(math.random(-123456, 123456)), "VertexLitGeneric", {
	["$basetexture"] = "vgui/white_additive",
	["$bumpmap"] = "models/player/shared/shared_normal",
	["$envmap"] = "skybox/sky_dustbowl_01",
	["$envmapfresnel"] = 1,
	["$phong"] = 1,
	["$phongfresnelranges"] = "[0 0.05 0.1]",
	["$selfillum"] = 1,
	["$selfillumFresnel"] = 1,
	["$selfillumFresnelMinMaxExp"] = "[0.4999 0.5 0]",
	["$envmaptint"] = "[1 0 0]",
	["$selfillumtint"] = "[0.05 0.05 0.05]"
})

local mcall, mrend

if meth_lua_api.callbacks then
	mcall = meth_lua_api.callbacks
end

if meth_lua_api.render then
	mrend = meth_lua_api.render
end

local enabled = true
local color = "255 0 0"

local function getcolor()
	local col = string.Split(color, " ")
	
	if not col[1] then
		col[1] = 255
	else
		col[1] = col[1] % 256
	end
	
	if not col[2] then
		col[2] = 255
	else
		col[2] = col[2] % 256
	end
	
	if not col[3] then
		col[3] = 255
	else
		col[3] = col[3] % 256
	end
	
	return col
end

if mcall then
	mcall.Add("OnHUDPaint", "fcu", function()
		if enabled then
			if meta_cv.GetInt(bumpvar) == 0 or meta_cv.GetInt(specvar) == 0 then
				mrend.PushAlert("mat_bumpmap / mat_specular = 0")
			end

			local col = getcolor()

			for _, v in ipairs(player.GetAll()) do
				if v == LocalPlayer() or not meta_en.IsValid(v) or not meta_pl.Alive(v) then
					continue
				end
				
				cam.Start3D()
					render.MaterialOverride(glowmat)
					render.SetColorModulation(col[1] / 255, col[2] / 255, col[3] / 255)
					
					meta_en.DrawModel(v)
				cam.End3D()
			end
		end
	end)
end

concommand.Add("glowchams_enabled", function(p, c, args)
	local new = args[1]
	
	if not new then
		new = false
	end
	
	enabled = tobool(new)
end)

concommand.Add("glowchams_color", function(p, c, args, argstr)
	if not argstr then
		argstr = "nil"
	end
	
	color = argstr
	
	local col = getcolor()
	
	meta_im.SetVector(glowmat, "$envmaptint", Vector(col[1] / 255, col[2] / 255, col[3] / 255))
end)