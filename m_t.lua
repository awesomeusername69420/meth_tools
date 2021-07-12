--[[
	Commands:

	m_render_fov_set (int)			|		Sets FOV
	m_render_tracedelay_set (int)		|		Sets bullet tracer lifespan (in seconds)
	m_render_maxtraces_set (int)		|		Sets maximum amount of bullet tracers allowed
	m_render_toggle_antiblind		|		Toggles anti ULX blind
	m_render_toggle_antialert		|		Toggles anti on screen alerts
	m_render_toggle_fullbright		|		Toggles fullbright
	m_render_toggle_tracers_beam		|		Toggles bullet tracer beam effect
	m_render_toggle_tracers_other		|		Toggles bullet tracers for other people
	m_render_toggle_tracers_local		|		Toggles bullet tracers for LocalPlayer
	m_render_toggle_bounce			|		Toggles the attack animation of players
	m_render_toggle_rgb			|		Toggles rainbow physgun and player
	
	m_tools_gestureloop_set (str)		|		Sets action for gestureloop (ex: "dance")
	m_tools_psay_message_set (str)		|		Sets message used for ULX psay spammer
	m_tools_os_set (str)			|		Sets the OS that will be spoofed (Windows, Linux, OSX, BSD, POSIX, Other)
	m_tools_toggle_gestureloop		|		Toggles gestureloop
	m_tools_toggle_psay			|		Toggles ULX psay spammer
	m_tools_toggle_guiopenurl		|		Toggles gui.OpenURL detour
	m_tools_toggle_antigag			|		Toggles anti ULX gag
]]

--[[
	Localization
]]

local tbc = table.Copy

local Angle = Angle
local cmd = tbc(concommand)
local Color = Color
local dbug = tbc(debug)
local FindMetaTable = FindMetaTable
local game = tbc(game)
local GetConVar = GetConVar
local grab = tbc(hook)
local graphicaluserinterface = tbc(gui)
local ipairs = ipairs
local isfunction = isfunction
local isstring = isstring
local istable = istable
local IsValid = IsValid
local jt = tbc(jit)
local LocalPlayer = LocalPlayer
local Material = Material
local math = tbc(math)
local MsgC = MsgC
local pairs = pairs
local render = tbc(render)
local ScrH = ScrH
local ScrW = ScrW
local string = tbc(string)
local surface = tbc(surface)
local sys = tbc(system)
local tbl = tbc(table)
local timer = tbc(timer)
local tostring = tostring
local util = tbc(util)
local Vector = Vector

local methapi = meth_lua_api or nil
local methrend = nil
local methutil = nil

if methapi then
	if istable(methapi) then
		if methapi.render then
			methrend = methapi.render	
		end

		if methapi.util then
			methutil = methapi.util
		end
	end
end

local pt = FindMetaTable("Player")
local ccmd = FindMetaTable("CUserCmd")

--[[
	Variables
]]

local annoyingtable = {["whats the max tabs you can have open on a vpn"] = {nil}, ["how many vpns does it take to stop a ddos"] = {nil}, ["whats better analog or garrys mod"] = {nil}, ["whats the time"] = {nil}, ["is it possible to make a clock in binary"] = {nil}, ["how many cars can you drive at once"] = {nil}, ["did you know there's more planes on the ground than there is submarines in the air"] = {nil}, ["how many busses can you fit on 1 bus"] = {nil}, ["how many tables does it take to support a chair"] = {nil}, ["how many doors does it take to screw a screw"] = {nil}, ["how long can you hold your eyes closed in bed"] = {nil}, ["how long can you hold your breath for under spagetti"] = {nil}, ["whats the fastest time to deliver the mail as mail man"] = {nil}, ["how many bees does it take to make a wasp make honey"] = {nil}, ["If I paint the sun blue will it turn blue"] = {nil}, ["how many beavers does it take to build a dam"] = {nil}, ["how much wood does it take to build a computer"] = {nil}, ["can i have ur credit card number"] = {nil}, ["is it possible to blink and jump at the same time"] = {nil}, ["did you know that dinosaurs were,  on average,  large"] = {nil}, ["how many thursdays does it take to paint an elephant purple"] = {nil}, ["if cars could talk how fast would they go"] = {nil}, ["did you know theres no oxygen in space"] = {nil}, ["do toilets flush the other way in australia"] = {nil}, ["if i finger paint will i get a splinter"] = {nil}, ["can you build me an ant farm"] = {nil}, ["did you know australia hosts 4 out of 6 of the deadliest spiders in the world"] = {nil}, ["is it possible to ride a bike in space"] = {nil}, ["can i make a movie based around your life"] = {nil}, ["how many pants can you put on while wearing pants"] = {nil}, ["if I paint a car red can it wear pants"] = {nil}, ["how come no matter what colour the liquid is the froth is always white"] = {nil}, ["can a hearse driver drive a corpse in the car pool lane"] = {nil}, ["how come the sun is cold at night"] = {nil}, ["why is it called a TV set when there is only one"] = {nil}, ["if i blend strawberries can i have ur number"] = {nil}, ["if I touch the moon will it be as hot as the sun"] = {nil}, ["did u know ur dad is always older than u"] = {nil}, ["did u know the burger king logo spells burger king"] = {nil}, ["did uknow if u chew on broken glass for a few mins,  it starts to taste like blood"] = {nil}, ["did u know running is faster than walking"] = {nil}, ["did u kno the colur blue is called blue because its blue"] = {nil}, ["did you know a shooting star isnt a star"] = {nil}, ["did u know shooting stars dont actually have guns"] = {nil}, ["did u kno the great wall of china is in china"] = {nil}, ["statistictal fact: 100% of non smokers die"] = {nil}, ["did you kmow if you eat you poop it out"] = {nil}, ["did u know rain clouds r called rain clouds cus they are clouds that rain"] = {nil}, ["if cows drink milk is that cow a cannibal"] = {nil}, ["did u know you cant win a staring contest with a stuffed animal"] = {nil}, ["did u know if a race car is at peak speed and hits someone they'll die"] = {nil}, ["did u know the distance between the sun and earth is the same distance as the distance between the earth and the sun"] = {nil}, ["did u kno flat screen tvs arent flat"] = {nil}, ["did u know aeroplane mode on ur phone doesnt make ur phone fly"] = {nil}, ["did u kno too many britdhays can kill you"] = {nil}, ["did u know rock music isnt for rocks"] = {nil}, ["did u know if you eat enough ice you can stop global warming"] = {nil}, ["if ww2 happened before vietnam would that make vietnam world war 2"] = {nil}, ["did you know 3.14 isn't a real pie"] = {nil}, ["did u know 100% of stair accidents happen on stairs"] = {nil}, ["can vampires get AIDS"] = {nil}, ["what type of bird was a dodo"] = {nil}, ["did u know dog backwards is god"] = {nil}, ["did you know on average a dog barks more than a cat"] = {nil}}

local bullets = {}

local vars = {
	-- Timers

	["fasttimer"] = tostring(math.random(-2147483648, 2147483647)),
	["slowtimer"] = tostring(math.random(-2147483648, 2147483647)),

	-- Render

	["fov"] = GetConVar("fov_desired"):GetInt(),
	["fullbright"] = false,
	["tracedelay"] = 3,
	["beamtracers"] = false,
	["othertracers"] = false,
	["localtracers"] = false,
	["maxtraces"] = 1000,
	["bounce"] = true,
	["rgb"] = false,

	-- Tools

	["antiblind"] = false,
	["antigag"] = false,
	["antialert"] = false,
	["gesture"] = "dance",
	["gestureloop"] = false,
	["psay"] = false,
	["psay_msg"] = "message",
	["noguiopenurl"] = true,
	["os"] = jt.os,
}

local concmds = {
	["int"] = {
		["m_render_fov_set"] = "fov",
		["m_render_tracedelay_set"] = "tracedelay",
		["m_render_maxtraces_set"] = "maxtraces",
	},

	["str"] = {
		["m_tools_gestureloop_set"] = "gesture",
		["m_tools_psay_message_set"] = "psay_msg",
		["m_tools_os_set"] = "os",
	},

	["toggle"] = {
		--render
		["m_render_toggle_antiblind"] = "antiblind",
		["m_render_toggle_antialert"] = "antialert",
		["m_render_toggle_fullbright"] = "fullbright",
		["m_render_toggle_tracers_beam"] = "beamtracers",
		["m_render_toggle_tracers_other"] = "othertracers",
		["m_render_toggle_tracers_local"] = "localtracers",
		["m_render_toggle_bounce"] = "bounce",
		["m_render_toggle_rgb"] = "rgb",

		--tools
		["m_tools_toggle_gestureloop"] = "gestureloop",
		["m_tools_toggle_psay"] = "psay",
		["m_tools_toggle_guiopenurl"] = "noguiopenurl",
		["m_tools_toggle_antigag"] = "antigag",
	}
}

--[[
	Detours
]]

local alertDetour = function(evt, data)
	if not evt then
		evt = "UNKNOWN_EVENT"
	end

	if methrend then
		methrend.PushAlert("Blocked " .. tostring(evt) .. "(" .. tostring(data) .. ")")
	else
		surface.PlaySound("garrysmod/balloon_pop_cute.wav")
	
		if not data then
			MsgC(Color(255, 100, 100), "Blocked ", Color(100, 255, 255), tostring(evt), Color(255, 100, 100), ".\n")
		else
			MsgC(Color(255, 100, 100), "Blocked ", Color(100, 255, 255), tostring(evt) .. "(" .. tostring(data) .. ")", Color(255, 100, 100), ".\n")
		end
	end
end

local badcmds = {
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

local detours = {
	clearbuttons = ccmd.ClearButtons,
	clearmovement = ccmd.ClearMovement,
	setviewangles = ccmd.SetViewAngles,

	dregcon = dbug.getregistry().Player.ConCommand,
	openurl = graphicaluserinterface.OpenURL,
	ptconcommand = pt.ConCommand,
	runconsolecommand = RunConsoleCommand,
	syslin = sys.IsLinux,
	sysosx = sys.IsOSX,
	syswin = sys.IsWindows,
	tableempty = tbl.Empty,
}

ccmd.SetViewAngles = function(...)
	if not ... then
		return true
	end

	local s = string.lower(dbug.getinfo(2).short_src)

	if string.find(s, "taunt_camera") then
		return true
	end

	return detours.setviewangles(...)
end

ccmd.ClearButtons = function(...)
	if not ... then
		return true
	end

	local s = string.lower(dbug.getinfo(2).short_src)

	if string.find(s, "taunt_camera") then
		return true
	end

	return detours.ClearButtons(...)
end

ccmd.ClearMovement = function(...)
	if not ... then
		return true
	end

	local s = string.lower(dbug.getinfo(2).short_src)

	if string.find(s, "taunt_camera") then
		return true
	end

	return detours.ClearMovement(...)
end

_G.concommand.GetTable = function()
	alertDetour("concommand.GetTable()")

	return annoyingtable
end

_G.hook.GetTable = function()
	alertDetour("hook.GetTable()")

	return annoyingtable
end

_G.RunConsoleCommand = function(command, ...)
	if not command then
		return true
	end

	for _, v in pairs(badcmds) do
		if not v then
			continue
		end
		
		if string.find(command, v) then
			if ... then
				alertDetour("RunConsoleCommand", command .. " " .. tostring(...))
			else
				alertDetour("RunConsoleCommand", command)
			end

			return true
		end
	end

	return detours.runconsolecommand(command, ...)
end

pt.ConCommand = function(command)
	if not command then
		return true
	end

	for _, v in pairs(badcmds) do
		if not v then
			continue
		end
		
		if string.find(tostring(command), v) then
			alertDetour("ConCommand", command)

			return true
		end
	end

	return detours.ptconcommand(command)
end

dbug.getregistry().Player.ConCommand = function(command)
	if not command then
		return true
	end

	for _, v in pairs(badcmds) do
		if not v then
			continue
		end
		
		if string.find(tostring(command), v) then
			alertDetour("ConCommand", command)

			return true
		end
	end

	return detours.dregcon(command)
end

_G.table.Empty = function(targ)
	if not targ then
		return {}
	end

	if string.find(tostring(targ), "_G") then
		alertDetour("table.Empty", targ)

		return {}
	end

	return detours.tableempty(targ)
end

_G.gui.OpenURL = function(...)
	if not ... then
		return true
	end

	if vars["noguiopenurl"] then
		alertDetour("gui.OpenURL", tostring(...))

		return true
	end
	
	return detours.openurl(...)
end

--[[
	Things
]]

local function spoofOS(set)
	if not set then
		return
	end

	set = tostring(set)

	local win = string.StartWith(string.lower(set), "windows") or false
	local bsd = string.StartWith(string.lower(set), "bsd") or false
	local lin = string.StartWith(string.lower(set), "linux") or false
	local osx = string.StartWith(string.lower(set), "osx") or false
	local psx = string.StartWith(string.lower(set), "posix") or false

	if win then
		jit.os = "Windows"
	elseif lin then
		jit.os = "Linux"
	elseif osx then
		jit.os = "OSX"
	elseif bsd then
		jit.os = "BSD"
	elseif psx then
		jit.os = "POSIX"
	else
		jit.os = "Other"
	end

	_G.system.IsLinux = function()
		return lin or bsd
	end
	
	_G.system.IsOSX = function()
		return osx
	end
	
	_G.system.IsWindows = function()
		return win
	end
end

local function animReturn()
	if vars["bounce"] then
		return
	else
		return ACT_INVALID
	end
end

--[[
	Hooks
]]

grab.Add("HUDShouldDraw", tostring({}), function(n) 
	if n == "CHudGMod" then
		return not vars["antialert"]
	end

    if n == "CHudDamageIndicator" then
       return false 
    end
end)

grab.Add("CalcView", tostring({}), function(ply, pos, angles, fov, zn, zf)
	if not IsValid(ply) then 
		return
	end

	local v = ply:GetVehicle()
	local w = ply:GetActiveWeapon()

	fov = fov + (vars["fov"] - GetConVar("fov_desired"):GetInt())

	local view = {
		origin = pos,
		angles = angles,
		fov = fov,
		znear = zn,
		zfar = zf
	}

	if IsValid(v) then
		return grab.Run("CalcVehicleView", v, ply, view)
	end

	if IsValid(w) then
		local wf = w.CalcView
	
		if wf then
			view.origin, view.angles, view.fov = wf(w, ply, pos * 1, angles * 1, fov)
		end
	end

	return view
end)

grab.Add("Think", tostring({}), function()
	if vars["antiblind"] then
		grab.Remove("HUDPaint", "ulx_blind")
	end

	if vars["antigag"] then
		grab.Remove("PlayerCanHearPlayersVoice", "ULXGag") -- For new ULX

		grab.Remove("PlayerBindPress", "ULXGagForce") -- For old ULX

		if timer.Exists("GagLocalPlayer") then
			timer.Remove("GagLocalPlayer")
		end
			
		if LocalPlayer():GetNWBool("Muted", false) then
			LocalPlayer():SetNWBool("Muted", false)
		end

		if ulx then
			if ulx["gagUser"] then
				ulx["gagUser"](false)
			end
		end
	end

	if vars["rgb"] then
		local rgc = HSVToColor(CurTime() % 6 * 60, 1, 1)

		LocalPlayer():SetWeaponColor(Vector(rgc.r / 255, rgc.g / 255, rgc.b / 255))
		LocalPlayer():SetPlayerColor(Vector(rgc.r / 255, rgc.g / 255, rgc.b / 255))
	else
		local wt = string.Split(GetConVar("cl_weaponcolor"):GetString(), " ")
		local pt = string.Split(GetConVar("cl_playercolor"):GetString(), " ")

		LocalPlayer():SetWeaponColor(Vector(wt[1], wt[2], wt[3]))
		LocalPlayer():SetPlayerColor(Vector(pt[1], pt[2], pt[3]))
	end
end)

grab.Add("RenderScene", tostring({}), function()
	if vars["fullbright"] then
		for _, v in ipairs(game.GetWorld():GetMaterials()) do
			Material(v):SetVector("$color", Vector(1, 1, 1))
		end

		render.SuppressEngineLighting(false)
		render.ResetModelLighting(1, 1, 1)

		render.SetLightingMode(1)
	else
		render.SetLightingMode(0)
	end
end)

grab.Add("PostDrawViewModel", tostring({}), function(viewmodel)
	if not viewmodel then
		return
	end

	render.SetLightingMode(0)

	for k, _ in ipairs(viewmodel:GetMaterials()) do
		render.MaterialOverrideByIndex(k - 1, nil)
	end
end)

grab.Add("PreDrawEffects", tostring({}), function()
	render.SetLightingMode(0)

	if not vars["othertracers"] and not vars["localtracers"] then
		return
	end

	for k, v in pairs(bullets) do
		if not k or not v then
			continue
		end
		
		if vars["beamtracers"] then
			cam.Start3D()
				render.SetMaterial(Material("cable/redlaser"))
        		render.DrawBeam(bullets[k]["src"], bullets[k]["end"], 4, 1, 1, bullets[k]["col"])
        	cam.End3D()
		else
        	render.DrawLine(bullets[k]["src"], bullets[k]["end"], bullets[k]["col"], true)
		end
	end
end)

grab.Add("DoAnimationEvent", tostring({}), function(ply, evt, data)
	-- 0 = PLAYERANIMEVENT_ATTACK_PRIMARY

	if not (data == 0 and evt == 0) then
		return
	end

	local ot = vars["othertracers"]
	local lt = vars["localtracers"]

	if not ot and not lt then
		return animReturn()
	end

	if not IsValid(ply) or not ply:Alive() then
		return
	end

	if ply == LocalPlayer() then
    	if ot and not lt then
    		return
    	end
	else
		if lt and not ot then
    		return
    	end
	end

	if #bullets >= vars["maxtraces"] then
		table.remove(bullets, 1)
	end

	local col = Color(255, 100, 100, 255)

	if ply == LocalPlayer() then
    	col = Color(100, 255, 100, 255)
   end

	local bend = Vector(0, 0, 0)
	local start = nil
	local dir = ply:EyeAngles():Forward()
	local sc = true

	if ply == LocalPlayer() and not LocalPlayer():ShouldDrawLocalPlayer() then
		sc = false
	end

	if sc then
		for i = 0, ply:GetBoneCount() - 1 do
			if string.find(string.lower(ply:GetBoneName(i)), "head") then
				start = ply:GetBoneMatrix(i):GetTranslation() + (ply:EyeAngles():Forward() * 2)
				break
			end
		end
	end

	if not start then
		start = ply:EyePos()
	end

	if ply == LocalPlayer() then
		if methutil then
			if methutil.GetAimbotTarget() ~= 0 then
				local target = methutil.GetAimbotTarget()
				local ent = nil
	
				ent = ents.GetByIndex(target)
	
				if IsValid(ent) and ent:IsPlayer() then
					dir = ent:LocalToWorld(ent:OBBCenter()) - LocalPlayer():GetShootPos()
				end
			end
		end
	end

	local tr = util.TraceLine({
        start = start,
        endpos = start + (dir * 32767),
        mask = MASK_SHOT,
        filter = player.GetAll(),
        ignoreworld = false,
    })

    table.insert(bullets, {
        ["src"] = start,
        ["dir"] = dir,
        ["dis"] = 32767,
        ["col"] = col,
        ["end"] = tr.HitPos
    })

    local thingtoremove = bullets[#bullets]
		
    timer.Simple(vars["tracedelay"], function()
        for k, v in ipairs(bullets) do
				if v == thingtoremove then
					table.remove(bullets, k)
				end
        end
    end)

    return animReturn()
end)

--[[
	Commands
]]

for j, l in pairs(concmds) do
	if not j or not l then
		continue
	end

	if not istable(l) then
		continue
	end

	for k, v in pairs(l) do
		local confunc = function() return end

		if j == "int" then
			confunc = function(p, c, args)
				if not args[1] then
					args[1] = 1
				end

				vars[v] = math.floor(args[1])
			end
		elseif j == "str" then
			confunc = function(p, c, args, argstr)
				if not argstr then
					argstr = "nil"
				end

				vars[v] = argstr
			end
		elseif j == "toggle" then
			confunc = function()
				vars[v] = not vars[v]
			end
		else
			continue
		end

		if isfunction(confunc) then
			cmd.Add(k, confunc)
		end
	end
end

-----------------------

timer.Create(vars["fasttimer"], 0.1, 0, function()
	if not vars["gestureloop"] then
		return
	end

	detours.runconsolecommand("act", vars["gesture"])
end)

timer.Create(vars["slowtimer"], 1, 0, function()
	spoofOS(vars["os"])

	if not vars["psay"] then
		return
	end

	for _, v in ipairs(player.GetAll()) do
		if v == LocalPlayer() or not IsValid(v) then
			continue
		end

		detours.runconsolecommand("ulx", "psay", v:Name(), vars["psay_msg"])
	end
end)

if methrend then
	methrend.PushAlert("Successfully loaded Swag Tools!!")
else
	surface.PlaySound("garrysmod/balloon_pop_cute.wav")
	MsgC(Color(255, 100, 100), "Successfully loaded ", Color(100, 255, 255), "Swag Tools", Color(255, 100, 100), "!!\n")
end

jt.flush()
