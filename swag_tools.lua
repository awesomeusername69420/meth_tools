--[[
	Locales
]]

local table = table.Copy(table)

local cam = table.Copy(cam)
local Color = Color
local concommand = table.Copy(concommand)
local debug = table.Copy(debug)
local ents = table.Copy(ents)
local game = game
local GetConVar = GetConVar
local gui = table.Copy(gui)
local hook = table.Copy(hook)
local HSVToColor = HSVToColor
local ipairs = ipairs
local IsValid = IsValid
local jit = table.Copy(jit)
local LocalPlayer = LocalPlayer
local Material = Material
local math = table.Copy(math)
local MsgC = MsgC
local pairs = pairs
local player = table.Copy(player)
local render = table.Copy(render)
local RunConsoleCommand = RunConsoleCommand
local string = table.Copy(string)
local surface = table.Copy(surface)
local timer = table.Copy(timer)
local tobool = tobool
local tostring = tostring
local type = type
local UnPredictedCurTime = UnPredictedCurTime
local util = table.Copy(util)

local meta_an = debug.getregistry()["Angle"]
local meta_cd = debug.getregistry()["CUserCmd"]
local meta_cv = debug.getregistry()["ConVar"]
local meta_en = debug.getregistry()["Entity"]
local meta_pl = debug.getregistry()["Player"]
local meta_vc = debug.getregistry()["Vector"]
local meta_vm = debug.getregistry()["VMatrix"]

local MASK_SHOT = 1174421507
local MATERIAL_FOG_NONE = 0
local PLAYERANIMEVENT_ATTACK_PRIMARY = 0

math.randomseed(math.random(-123456, 123456))

-- Meth stuff

local mrend, mutil

if meth_lua_api then
	if meth_lua_api.render then
		mrend = meth_lua_api.render
	end

	if meth_lua_api.util then
		mutil = meth_lua_api.util
	end
end

--[[
	Varzzzzz
]]

local bullets = {}

local vars = {
	-- Cunt
	["hookname"] = string.char(math.random(97, 122)) .. tostring(math.random(-123456, 123456)),
	["timer_fast"] = string.char(math.random(97, 122)) .. tostring(math.random(-123456, 123456)),
	["timer_slow"] = string.char(math.random(97, 122)) .. tostring(math.random(-123456, 123456)),

	-- Render
	["antiblind"] = false,
	["beamtracers"] = false,
	["cfov"] = meta_cv.GetInt(GetConVar("fov_desired")),
	["fog"] = true,
	["fullbright"] = false,
	["maxtracers"] = 1000,
	["reddeath"] = true,
	["rgb"] = false,
	["tracerlife"] = 3,
	["tracers_local"] = false,
	["tracers_other"] = false,

	-- Tools
	["antigag"] = false,
	["gesture"] = "dance",
	["gesture_loop"] = false,
	["gopen"] = true,
	["psays"] = false,
	["psays_message"] = "message",
}

local concommands = {
	["integer"] = {
		-- Render
		["st_render_fov_set"] = "cfov",
		["st_render_tracers_life_set"] = "tracerlife",
		["st_render_tracers_max_set"] = "maxtracers",

		-- Tools
	},

	["string"] = {
		-- Render

		-- Tools
		["st_tools_gesture_set"] = "gesture",
		["st_tools_psay_spam_set"] = "psays_message"
	},

	["boolean"] = {
		-- Render
		["st_render_antiblind"] = "antiblind",
		["st_render_fog"] = "fog",
		["st_render_fullbright"] = "fullbright",
		["st_render_rgb"] = "rgb",
		["st_render_tracers_beam"] = "beamtracers",
		["st_render_tracers_local"] = "tracers_local",
		["st_render_tracers_other"] = "tracers",

		-- Tools
		["st_tools_allow_guiopenurl"] = "gopen",
		["st_tools_antigag"] = "antigag",
		["st_tools_gesture_loop"] = "gesture_loop",
		["st_tools_psay_spam"] = "psays",
	}
}

local addedCommands = {}

-- nonozone

local badCommands = {
	"+back",
	"+forward",
	"+jump",
	"+left",
	"+moveleft",
	"+right",
	"+voicerecord",
	"+zoom",
	"-back",
	"-forward",
	"-jump",
	"-left",
	"-moveleft",
	"-right",
	"-voicerecord",
	"-zoom",
	"bind",
	"bind_mac",
	"bindtoggle",
	"cl_chatfilters",
	"cl_interp",
	"cl_interp_all",
	"cl_interp_npcs",
	"cl_interp_ratio",
	"cl_yawspeed",
	"connect",
	"demos",
	"disconnect",
	"engine_no_focus_sleep",
	"exit",
	"fps_max",
	"impulse",
	"jpeg",
	"kill",
	"mat_texture_limit",
	"net_graph",
	"net_graphheight",
	"net_graphmsecs",
	"net_graphpos",
	"net_graphproportionalfont",
	"net_graphshowinterp",
	"net_graphshowlatency",
	"net_graphsolid",
	"net_graphtext",
	"open",
	"pp_bloom",
	"pp_bokeh",
	"pp_dof",
	"pp_motionblur",
	"pp_stereoscopy",
	"pp_texturize",
	"pp_texturize_scale",
	"pp_toytown",
	"quit",
	"rate",
	"record",
	"retry",
	"say",
	"screenshot",
	"startmovie",
}

local badWeapons = {
	"bomb",
	"bugbait",
	"c4",
	"camera",
	"climb",
	"crowbar",
	"fist",
	"frag",
	"gravity gun",
	"grenade",
	"hand",
	"ied",
	"knife",
	"medkit",
	"physcannon",
	"physgun",
	"physics gun",
	"slam",
	"stunstick",
	"sword",
}

--[[
	Fuccncs
]]

local alert = function(event, data)
	if not event then
		event = ""
	end

	if not data then
		data = ""
	end

	if mrend then
		mrend.PushAlert("Blocked " .. tostring(event) .. "(" .. tostring(data) .. ")")
	else
		surface.PlaySound("garrysmod/balloon_pop_cute.wav")

		MsgC(Color(255, 100, 100), "[$W467001Z] ", Color(222, 222, 222), "Blocked ", Color(255, 100, 100), tostring(event) .. "(" .. tostring(data) .. ")", Color(222, 222, 222), "\n")
	end
end

local function isBadWeapon(weapon)
	if not weapon or not meta_en.IsValid(weapon) then
		return true
	end

	local class = weapon:GetClass()
	local pname = weapon:GetPrintName()

	if not class or not pname then
		return true
	end

	for _, v in ipairs(badWeapons) do
		if string.find(class, v) or string.find(pname, v) then
			return true
		end
	end

	return false
end

--[[
	Deeztourz (funy)
]]

local safefuncs = {
	cb = meta_cd.ClearButtons,
	cm = meta_cd.ClearMovement,
	sva = meta_cd.SetViewAngles,

	msgc = MsgC,
	cremove = concommand.Remove,
	ctable = concommand.GetTable,
	gcv = GetConVar,
	gopen = gui.OpenURL,
	htable = hook.GetTable,
	pcon = meta_pl.ConCommand,
	rcon = RunConsoleCommand,
	tempty = table.Empty,
	texists = timer.Exists,
}

meta_cd.ClearButtons = function(...)
	if not ... then
		return
	end

	if string.find(string.lower(debug.getinfo(2).short_src), "taunt_camera") then
		return
	end

	return safefuncs.cb(...)
end

meta_cd.ClearMovement = function(...)
	if not ... then
		return
	end

	if string.find(string.lower(debug.getinfo(2).short_src), "taunt_camera") then
		return
	end

	return safefuncs.cm(...)
end

meta_cd.SetViewAngles = function(...)
	if not ... then
		return
	end

	if string.find(string.lower(debug.getinfo(2).short_src), "taunt_camera") then
		return
	end

	return safefuncs.sva(...)
end

_G.GetConVar = function(var)
	if not var or type(var) ~= "string" then
		return
	end

	for _, v in ipairs(addedCommands) do
		if string.find(var, v) then
			alert("GetConVar", var)

			return
		end
	end

	return safefuncs.gcv(var)
end

_G.concommand.GetTable = function(...)
	local nt, ac = safefuncs.ctable()

	for k, _ in pairs(nt) do
		if table.HasValue(addedCommands, k) then
			nt[k] = nil
		end
	end

	alert("concommand.GetTable")

	return nt, ac
end

_G.concommand.Remove = function(var)
	if not var or type(var) ~= "string" then
		return
	end

	for _, v in ipairs(addedCommands) do
		if string.find(var, v) then
			alert("concommand.Remove", var)

			return
		end
	end

	return safefuncs.cremove(var)
end

_G.hook.GetTable = function(...)
	local nt = safefuncs.htable()

	for h, ht in pairs(nt) do
		if type(ht) == "table" then
			for k, _ in pairs(ht) do
				if k == vars["hookname"] then
					ht[k] = nil
				end
			end

			if table.Count(ht) == 0 then
				nt[h] = nil
			end
		end
	end

	alert("hook.GetTable")

	return nt
end

_G.table.Empty = function(tbl)
	if not tbl or type(tbl) ~= "table" then
		return
	end

	if tbl == _G then
		alert("table.Empty", "_G")

		return
	end

	return safefuncs.tempty(tbl)
end

_G.gui.OpenURL = function(url)
	if not url or type(url) ~= "string" then
		return
	end

	if not vars["gopen"] then
		alert("gui.OpenURL", "\"" .. url .. "\"")

		return
	end

	return safefuncs.gopen(url)
end

_G.timer.Exists = function(n)
	if not n or type(n) ~= "string" then
		return false
	end

	if n == vars["timer_fast"] or n == vars["timer_slow"] then
		return false
	end

	return safefuncs.texists(n)
end

_G.RunConsoleCommand = function(cmd, ...)
	if not cmd or type(cmd) ~= "string" then
		return
	end

	local conc = ""

	if ... then
		conc = " " .. ...
	end

	for _, v in ipairs(badCommands) do
		if string.find(cmd, v) then
			alert("RunConsoleCommand", "\"" .. cmd .. conc .. "\"")

			return
		end
	end

	for _, v in ipairs(addedCommands) do
		if string.find(cmd, v) then
			alert("RunConsoleCommand", "\"" .. cmd .. conc .. "\"")

			return
		end
	end

	return safefuncs.rcon(cmd, ...)
end

meta_pl.ConCommand = function(cmd)
	if not cmd or type(cmd) ~= "string" then
		return
	end

	for _, v in ipairs(badCommands) do
		if string.find(cmd, v) then
			alert("LocalPlayer():ConCommand", "\"" .. cmd .. "\"")

			return
		end
	end

	for _, v in ipairs(addedCommands) do
		if string.find(cmd, v) then
			alert("LocalPlayer():ConCommand", "\"" .. cmd .. "\"")

			return
		end
	end

	return safefuncs.pcon(cmd)
end

--[[
	The Hooks!!
]]

hook.Add("HUDShouldDraw", vars["hookname"], function(n)
	if n == "CHudDamageIndicator" and not vars["reddeath"] then
		return false
	end
end)

hook.Add("CalcView", vars["hookname"], function(ply, pos, ang, fov, zn, zf)
	if not meta_en.IsValid(ply) then
		return
	end

	local v = meta_pl.GetVehicle(ply)
	local w = meta_pl.GetActiveWeapon(ply)

	local nfov = fov + (math.Clamp(vars["cfov"], 1, 179) - meta_cv.GetInt(GetConVar("fov_desired")))

	if meta_pl.ShouldDrawLocalPlayer(ply) then
		pos = pos + (meta_an.Forward(ang) * -150)
	end

	local nview = {
		origin = pos,
		angles = ang,
		fov = nfov,
		zneaf = zn,
		zfar = zf
	}

	if meta_en.IsValid(v) then
		return hook.Run("CalcVehicleView", v, ply, nview)
	end

	if meta_en.IsValid(w) then
		local wcv = w.CalcView

		if wcv then
			nview.origin, nview.angles, nview.fov = wcv(w, ply, pos * 1, ang * 1, fov)
		end
	end

	return nview
end)

hook.Add("HUDPaint", vars["hookname"], function()
	if vars["antiblind"] then
		hook.Remove("HUDPaint", "ulx_blind")
		hook.Remove("HUDPaintBackground", "ulx_blind")
	end
end)

hook.Add("Think", vars["hookname"], function()
	if vars["antigag"] then
		hook.Remove("PlayerCanHearPlayersVoice", "ULXGag")
		hook.Remove("PlayerBindPress", "ULXGagForce")
		timer.Remove("GagLocalPlayer")

		meta_pl.SetNWBool(LocalPlayer(), "Muted", false)

		if ulx and ulx["gagUser"] then
			ulx["gagUser"](false)
		end
	end

	if vars["rgb"] then
		local rgc = HSVToColor(UnPredictedCurTime() % 6 * 60, 1, 1)

		meta_pl.SetWeaponColor(LocalPlayer(), Vector(rgc.r / 255, rgc.g / 255, rgc.b / 255))
		meta_pl.SetPlayerColor(LocalPlayer(), Vector(rgc.r / 255, rgc.g / 255, rgc.b / 255))
	else
		local wc = string.Split(meta_cv.GetString(GetConVar("cl_weaponcolor")), " ")
		local pc = string.Split(meta_cv.GetString(GetConVar("cl_playercolor")), " ")

		meta_pl.SetWeaponColor(LocalPlayer(), Vector(wc[1], wc[2], wc[3]))
		meta_pl.SetPlayerColor(LocalPlayer(), Vector(pc[1], pc[2], pc[3]))
	end
end)

hook.Add("SetupSkyboxFog", vars["hookname"], function()
	local f = vars["fog"]

	if not f then
		render.FogMode(MATERIAL_FOG_NONE)
	end

	return not f
end)

hook.Add("SetupWorldFog", vars["hookname"], function()
	local f = vars["fog"]

	if not f then
		render.FogMode(MATERIAL_FOG_NONE)
	end

	return not f
end)

hook.Add("RenderScene", vars["hookname"], function()
	if vars["fullbright"] then
		for _, v in ipairs(meta_en.GetMaterials(game:GetWorld())) do
			Material(v):SetVector("$color", Vector(1, 1, 1))
		end

		render.SuppressEngineLighting(false)
		render.ResetModelLighting(1, 1, 1)

		render.SetLightingMode(1)
	else
		render.SetLightingMode(0)
	end
end)

hook.Add("PreDrawViewModel", vars["hookname"], function(vm)
	if not vm then
		return
	end

	render.SetLightingMode(0)
end)

hook.Add('PostDrawViewModel', vars["hookname"], function(vm)
	if not vm then
		return
	end

	render.SetLightingMode(0)

	for k, _ in ipairs(meta_en.GetMaterials(vm)) do
		render.MaterialOverrideByIndex(k - 1, nil)
	end
end)

hook.Add("PreDrawEffects", vars["hookname"], function()
	render.SetLightingMode(0)

	if not vars["tracers"] then
		return
	end

	for k, v in ipairs(bullets) do
		if not k or not v then
			continue
		end

		if vars["beamtracers"] then
			cam.Start3D()
				render.SetMaterial(Material("cable/redlaser"))
				render.DrawBeam(bullets[k].s, bullets[k].e, 4, 1, 1, Color(255, 255, 255, 255))
			cam.End3D()
		else
			render.DrawLine(bullets[k].s, bullets[k].e, bullets[k].c, true)
		end
	end
end)

hook.Add("DoAnimationEvent", vars["hookname"], function(ply, event, data)
	if not (event == PLAYERANIMEVENT_ATTACK_PRIMARY and data == PLAYERANIMEVENT_ATTACK_PRIMARY) then
		return
	end

	local en = vars["tracers_other"]
	local len = vars["tracers_local"]

	if (not en and not len) or not meta_en.IsValid(ply) or not meta_pl.Alive(ply) or isBadWeapon(meta_pl.GetActiveWeapon(ply)) then
		return
	end

	local isloc = ply == LocalPlayer()

	if isloc then
		if en and not len then
			return
		end
	else
		if len and not en then
			return
		end
	end

	if table.Count(bullets) > vars["maxtracers"] then
		table.remove(bullets, 1)
	end

	local usebones = true
	local startpos = meta_en.EyePos(ply)
	local dir = meta_an.Forward(meta_en.EyeAngles(ply))
	local col = Color(255, 100, 100, 255)

	if isloc then
		col = Color(100, 255, 100, 255)

		if not meta_pl.ShouldDrawLocalPlayer(LocalPlayer()) then
			usebones = false
		end

		if mutil then
			local at = mutil.GetAimbotTarget()

			if at ~= 0 then
				local ent = ents.GetByIndex(at)

				if meta_en.IsPlayer(ent) and meta_en.IsValid(ent) then
					dir = meta_en.LocalToWorld(ent, meta_en.OBBCenter(ent)) - startpos
				end
			end
		end
	end

	if usebones then
		for i = 0, meta_en.GetBoneCount(ply) - 1 do
			if string.find(string.lower(meta_en.GetBoneName(ply, i)), "head") then
				startpos = meta_vm.GetTranslation(meta_en.GetBoneMatrix(ply, i)) + (dir * 2)
	
				break
			end
		end
	end

	local tr = util.TraceLine({
		start = startpos,
		endpos = startpos + (dir * 32767),
		filter = ply,
		ignoreworld = false,
		mask = MASK_SHOT,
	})

	table.insert(bullets, {
		["s"] = startpos,
		["e"] = tr.HitPos,
		["c"] = col,
	})

	local ttr = bullets[table.Count(bullets)]

	timer.Simple(vars["tracerlife"], function()
		table.RemoveByValue(bullets, ttr)
	end)
end)

--[[
	The rest
]]

for j, l in pairs(concommands) do
	if not j or not l then
		continue
	end

	if not type(l) == "table" then
		continue
	end

	for k, v in pairs(l) do
		local confunc = function() return end

		if j == "integer" then
			confunc = function(p, c, args)
				if not args[1] or type(args[1]) ~= "number" then
					args[1] = 1
				end

				vars[v] = math.floor(args[1])
			end
		elseif j == "string" then
			confunc = function(p, c, args, argstr)
				if not argstr then
					argstr = "nil"
				end

				vars[v] = argstr
			end
		elseif j == "boolean" then
			confunc = function(p, c, args)
				if not args[1] then
					args[1] = false
				end

				vars[v] = tobool(args[1])
			end
		else
			continue
		end

		concommand.Add(k, confunc, nil, nil, 0)
		table.insert(addedCommands, k)
	end
end

timer.Create(vars["timer_fast"], 0.1, 0, function()
	if vars["gesture_loop"] then
		safefuncs.rcon("act", vars["gesture"])
	end
end)

timer.Create(vars["timer_slow"], 1, 0, function()
	if vars["psays"] then
		for _, v in ipairs(player.GetAll()) do
			if not meta_en.IsValid(v) or v == LocalPlayer() then
				continue
			end

			safefuncs.rcon("ulx", "psay", v:Name(), vars["psays_message"])
		end
	end
end)

if mrend then
	mrend.PushAlert("Successfully loaded Swag Tools!")
else
	surface.PlaySound("garrysmod/balloon_pop_cute.wav")

	MsgC(Color(255, 100, 100), "[$W467001Z] ", Color(222, 222, 222), "Loaded Successfully!\n")
end

jit.flush()
