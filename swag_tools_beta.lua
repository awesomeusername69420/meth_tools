--[[
	https://github.com/awesomeusername69420/meth_tools
	
	Command(s):
		st_menu  -  Toggles the menu
]]

--[[
	Localization
]]

local G_ = _G or "NICE _G" -- Anti _G manipulation (Swift AC)

if G_ == "NICE _G" then
	local kill = true

	if meth_lua_api then -- Attempt to restore _G from meth_lua_api
		if meth_lua_api.internal then
			if meth_lua_api.internal.Protected_G then
				G_ = meth_lua_api.internal.Protected_G
				kill = false
			end
		end
	end
	
	if kill then
		return -- Don't run the script if restore failed
	end
end

-- Meth Stuff

local ismeth, issafe = false, false
local mcall, mio, mrend, mutil, mvar, mvar_o

if meth_lua_api then
	ismeth = true
	issafe = _G == meth_lua_api.internal.Protected_G -- Fails when _G is altered (Swift AC)
	
	mcall = meth_lua_api.callbacks
	mrend = meth_lua_api.render
	mutil = meth_lua_api.util
end

-- Menu Stuff

local isbeta = true
local title = "Swag Tools" .. (isbeta and " Beta" or "")
local title_short = "ST" .. (isbeta and "B" or "")

-- Main Stuff

local table = G_.table.Copy(G_.table)

local debug = G_.table.Copy(G_.debug)
local pairs = G_.pairs
local type = G_.type

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

-- Main stuff

local Angle = G_.Angle
local bit = tCopy(G_.bit)
local cam = tCopy(G_.cam)
local Color = G_.Color
local concommand = tCopy(G_.concommand)
local CreateMaterial = G_.CreateMaterial
local cvars = tCopy(G_.cvars)
local DisableClipping = G_.DisableClipping
local draw = tCopy(G_.draw)
local engine = tCopy(G_.engine)
local ents = tCopy(G_.ents)
local EyePos = G_.EyePos
local file = tCopy(G_.file)
local game = tCopy(G_.game)
local gameevent = tCopy(G_.gameevent)
local GetConVar = G_.GetConVar
local gui = tCopy(G_.gui)
local hook = tCopy(G_.hook)
local HSVToColor = G_.HSVToColor
local http = tCopy(G_.http)
local input = tCopy(G_.input)
local ipairs = G_.ipairs
local IsConCommandBlocked = G_.IsConCommandBlocked
local Lerp = Lerp
local LocalPlayer = G_.LocalPlayer
local Material = G_.Material
local math = tCopy(G_.math)
local MsgC = G_.MsgC
local os = tCopy(G_.os)
local Player = G_.Player
local player = tCopy(G_.player)
local render = tCopy(G_.render)
local RunConsoleCommand = G_.RunConsoleCommand
local ScrH = G_.ScrH
local ScrW = G_.ScrW
local string = tCopy(G_.string)
local surface = tCopy(G_.surface)
local SysTime = SysTime
local timer = tCopy(G_.timer)
local tostring = G_.tostring
local UnPredictedCurTime = G_.UnPredictedCurTime
local util = tCopy(G_.util)
local Vector = G_.Vector
local vgui = tCopy(G_.vgui)

-- Rest of the meth stuff

if ismeth then
	if not _G then
		_G = tCopy(meth_lua_api.internal.Protected_G) -- Restore _G if it's nil (Swift AC)
	end

	if mutil then
		local mset = mutil.GetPermissions() or {} -- Check meth lua permission settings
			
		if mset.CheatSettings then
			mvar_o = meth_lua_api.var
			mvar = tCopy(meth_lua_api.var)
			
			mvar.GetVarInt = function(var) -- Custom function that fixes the lua api returning dumb numbers
				local x = mvar_o.GetVarInt(var)
				
				return x % 256
			end
			
			mvar.GetVarColor = function(var) -- Custom function to get colors from the lua api
				local x = mvar_o.GetVarInt(var)
				
				local r, g, b
				
				r = x % 256
				g = ((x - r) / 256) % 256
				b = (((x - r) / 65536) - (g / 256)) + 256 -- This math is dumb but it works
				
				local a = math.floor(math.abs(x) / 16777216) -- Alpha is gay
				
				if x < 0 then
					a = 255 - a
				end
				
				return Color(r, g, b, a)
			end
		end
		
		if mset.File then
			mio = meth_lua_api.io
		end
	end
end

-- Metatables

local meta_an = tCopy(debug.getregistry()["Angle"])
local meta_cd_g = debug.getregistry()["CUserCmd"]
local meta_cd = tCopy(meta_cd_g) -- Create a local copy for detours
local meta_cl = tCopy(debug.getregistry()["Color"])
local meta_cv = tCopy(debug.getregistry()["ConVar"])
local meta_en = tCopy(debug.getregistry()["Entity"])
local meta_fl_g = debug.getregistry()["File"]
local meta_fl = tCopy(meta_fl_g)
local meta_im = tCopy(debug.getregistry()["IMaterial"])
local meta_pl_g = debug.getregistry()["Player"]
local meta_pl = tCopy(meta_pl_g)
local meta_pn = tCopy(debug.getregistry()["Panel"])
local meta_vc = tCopy(debug.getregistry()["Vector"])
local meta_vm = tCopy(debug.getregistry()["VMatrix"])
local meta_wn = tCopy(debug.getregistry()["Weapon"])

-- Enums

local ACT_GMOD_GESTURE_AGREE = G_.ACT_GMOD_GESTURE_AGREE
local ACT_GMOD_GESTURE_BECON = G_.ACT_GMOD_GESTURE_BECON
local ACT_GMOD_GESTURE_BOW = G_.ACT_GMOD_GESTURE_BOW
local ACT_GMOD_GESTURE_DISAGREE = G_.ACT_GMOD_GESTURE_DISAGREE
local ACT_GMOD_GESTURE_TAUNT_ZOMBIE = G_.ACT_GMOD_GESTURE_TAUNT_ZOMBIE
local ACT_GMOD_GESTURE_WAVE = G_.ACT_GMOD_GESTURE_WAVE
local ACT_GMOD_TAUNT_CHEER = G_.ACT_GMOD_TAUNT_CHEER
local ACT_GMOD_TAUNT_DANCE = G_.ACT_GMOD_TAUNT_DANCE
local ACT_GMOD_TAUNT_LAUGH = G_.ACT_GMOD_TAUNT_LAUGH
local ACT_GMOD_TAUNT_MUSCLE = G_.ACT_GMOD_TAUNT_MUSCLE
local ACT_GMOD_TAUNT_PERSISTENCE = G_.ACT_GMOD_TAUNT_PERSISTENCE
local ACT_GMOD_TAUNT_ROBOT = G_.ACT_GMOD_TAUNT_ROBOT
local ACT_GMOD_TAUNT_SALUTE = G_.ACT_GMOD_TAUNT_SALUTE
local ACT_SIGNAL_FORWARD = G_.ACT_SIGNAL_FORWARD
local ACT_SIGNAL_GROUP = G_.ACT_SIGNAL_GROUP
local ACT_SIGNAL_HALT = G_.ACT_SIGNAL_HALT
local EF_NODRAW = G_.EF_NODRAW
local FILL = G_.FILL
local FSASYNC_ERR_FAILURE = G_.FSASYNC_ERR_FAILURE
local IN_BACK = G_.IN_BACK
local IN_FORWARD = G_.IN_FORWARD
local IN_JUMP = G_.IN_JUMP
local IN_MOVELEFT = G_.IN_MOVELEFT
local IN_MOVERIGHT = G_.IN_MOVERIGHT
local IN_RELOAD = G_.IN_RELOAD
local IN_SPEED = G_.IN_SPEED
local IN_USE = G_.IN_USE
local IN_WALK = G_.IN_WALK
local KEY_BACKSPACE = input.GetKeyCode("BACKSPACE")
local KEY_ENTER = input.GetKeyCode("ENTER")
local KEY_ESCAPE = input.GetKeyCode("ESCAPE")
local KEY_PERIOD = input.GetKeyCode(".")
local KEY_SPACE = input.GetKeyCode("SPACE")
local MASK_SHOT = G_.MASK_SHOT
local MATERIAL_FOG_NONE = 0
local METHFLAG_ESPONLY = 1 -- Custom flags used for canrender function
local METHFLAG_NOFREECAM = 3
local METHFLAG_NONE = 0
local METHFLAG_NOTHIRDPERSON = 2
local MOUSE_LEFT = input.GetKeyCode("MOUSE1")
local MOVETYPE_LADDER = G_.MOVETYPE_LADDER
local MOVETYPE_NOCLIP = G_.MOVETYPE_NOCLIP
local MOVETYPE_OBSERVER = G_.MOVETYPE_OBSERVER
local PLAYERANIMEVENT_ATTACK_PRIMARY = G_.PLAYERANIMEVENT_ATTACK_PRIMARY
local RENDERMODE_TRANSCOLOR = G_.RENDERMODE_TRANSCOLOR
local TEAM_SPECTATOR = G_.TEAM_SPECTATOR

-- Tables + randomString()

local function randomString()
	return string.char(math.random(97, 122)) .. tostring(math.random(-123456, 123456))
end

local glowflags = { -- Cleans up the code a little
	["$basetexture"] = "vgui/white_additive",
	["$bumpmap"] = render.GetHDREnabled() and "models/player/shared/shared_normal" or "",
	["$envmap"] = "skybox/sky_dustbowl_01",
	["$envmapfresnel"] = 1,
	["$phong"] = 1,
	["$phongfresnelranges"] = "[0 0.05 0.1]",
	["$selfillum"] = 1,
	["$selfillumFresnel"] = 1,
	["$selfillumFresnelMinMaxExp"] = "[0.5 0.5 0]",
	["$envmaptint"] = "[1 0 0]",
	["$selfillumtint"] = "[0.05 0.05 0.05]"
}

local boxflags = { -- Default color material
	["$alpha"] = 0.3,
	["$basetexture"] = "color/white",
	["$model"] = 1,
	["$translucent"] = 1,
	["$vertexalpha"] = 1,
	["$vertexcolor"] = 1
}

local materials = {
	["blur"] = Material("pp/blurscreen"),
	["beam"] = Material("cable/redlaser"), -- Bullet tracers, breadcrumb beams
	["traitor"] = Material("vgui/ttt/sprite_traitor"), -- Traitor "T" icon
	["wireframe"] = Material("models/wireframe"),
	["debugwhite"] = Material("models/debug/debugwhite"), -- Generic debug white chams material
	["devmaterial"] = Material("dev/dev_measuregeneric01b"), -- Gray Dev Material
	["devmaterial_alt"] = Material("dev/dev_measuregeneric01"), -- Orange Dev Material
	["devtexture"] = meta_im.GetTexture(Material("dev/dev_measuregeneric01b"), "$basetexture"), -- Gray Dev Texture
	["devtexture_alt"] = meta_im.GetTexture(Material("dev/dev_measuregeneric01"), "$basetexture"), -- Orange Dev Texture
	
	["boxmat_hit"] = CreateMaterial(randomString(), "UnlitGeneric", boxflags),
	["boxmat_kill"] = CreateMaterial(randomString(), "UnlitGeneric", boxflags),
	["boxmat_backtrack"] = CreateMaterial(randomString(), "UnlitGeneric", boxflags),
	["boxmat_freecam"] = CreateMaterial(randomString(), "UnlitGeneric", boxflags),
	["glow_player"] = CreateMaterial(randomString(), "VertexLitGeneric", glowflags),
	["glow_player_weapon"] = CreateMaterial(randomString(), "VertexLitGeneric", glowflags),
	["glow_player_highlight_aimbot"] = CreateMaterial(randomString(), "VertexLitGeneric", glowflags),
	["glow_player_highlight_friends"] = CreateMaterial(randomString(), "VertexLitGeneric", glowflags),
	["glow_viewmodel"] = CreateMaterial(randomString(), "VertexLitGeneric", glowflags),
}

meta_im.SetInt(materials.beam, "$flags", bit.bor(meta_im.GetInt(materials.beam, "$flags"), 32768)) -- Sets the beam material to IgnoreZ so it can be drawn in HUDPaint

local colors = {
	["accent"] = Color(255, 150, 0, 255), -- Menu accent
	["background"] = Color(255, 255, 255, 255), -- Menu background
	["background_mini"] = Color(255, 255, 255, 255),
	["rainbow"] = Color(255, 255, 255),

	["back"] = Color(45, 45, 45, 255), -- Back of menu
	["back_min_head"] = Color(55, 55, 55, 255), -- Mini menu heads
	["back_min"] = Color(55, 55, 55, 255), -- Same as above but reserved for menu
	["back_t"] = Color(24, 24, 24, 255), -- Checkboxes and other backings
	["back_t_a"] = Color(24, 24, 24, 150), -- Mini menu backings
	["black"] = Color(0, 0, 0, 255),
	["gray"] = Color(150, 150, 150, 255), -- For text boxes
	["light_red"] = Color(255, 100, 100, 255),
	["outline"] = Color(12, 12, 12, 255), -- Menu outlines
	["white"] = Color(255, 255, 255, 255),
	["red_a"] = Color(200, 0, 0, 150), -- Used for traitor detector
	["green_a"] = Color(0, 200, 0, 150),
	["blue_a"] = Color(0, 0, 200, 150),
	
	-- Actual colors
	
	["beam"] = Color(255, 255, 255, 255), -- Beam material
	["chams_color_player"] = Color(255, 0, 0, 255), -- Player chams
	["chams_color_player_weapon"] = Color(255, 0, 0, 255), -- Player weapon chams
	["chams_color_viewmodel"] = Color(255, 0, 0, 255), -- Viewmodel chams
	["meth_catpng"] = Color(255, 255, 255, 150),
	["meth_freecambox"] = Color(255, 255, 255, 75),
	["meth_highlight_aimbot"] = Color(255, 255, 255), -- Player aimbot highlight chams
	["meth_highlight_friends"] = Color(255, 255, 255), -- Player friend highlight chams
	["meth_backtrackhitbox"] = Color(255, 255, 255, 75),
	["meth_watermark"] = "RGB",
	["meth_fovcircle"] = Color(255, 255, 255),
	["traces_breadcrumbs"] = Color(255, 255, 255, 255),
	["traces_shotrecord_hit"] = Color(255, 255, 255, 75),
	["traces_shotrecord_kill"] = Color(255, 0, 0, 75),
	["world_ambient"] = Color(30, 30, 30, 255),
}

local vars = {
	["menu"] = false,
	["menu_fade"] = true,
	["menu_tab"] = "render",
	["menu_mousedown"] = false,
	["menu_mousedelay"] = false,
	["menu_dragging"] = nil,
	["menu_typing"] = nil,
	["menu_dragging_ox"] = 0,
	["menu_dragging_oy"] = 0,
	["menu_x"] = nil,
	["menu_y"] = nil,
	["menu_w"] = 0,
	["menu_h"] = 0,
	["menu_background"] = true,
	["menu_background_style"] = "blur",
	["menu_background_mini"] = false,
	["menu_background_mini_style"] = "blur",
	["menu_background_blur_updatetexture"] = true,
	["menu_background_blur_scale"] = 3,
	["menu_activedropdown"] = nil,
	["menu_colorpicker_var"] = nil,
	["hookname"] = randomString(),
	["renderpanic"] = false,
	["rendercall"] = false, -- For meth_lua_api and SetRenderTarget
	["darkrp_gestures"] = {
		["dance"] = ACT_GMOD_TAUNT_DANCE,
		["muscle"] = ACT_GMOD_TAUNT_MUSCLE,
		["wave"] = ACT_GMOD_GESTURE_WAVE,
		["robot"] = ACT_GMOD_TAUNT_ROBOT,
		["bow"] = ACT_GMOD_GESTURE_BOW,
		["cheer"] = ACT_GMOD_TAUNT_CHEER,
		["laugh"] = ACT_GMOD_TAUNT_LAUGH,
		["zombie"] = ACT_GMOD_GESTURE_TAUNT_ZOMBIE,
		["agree"] = ACT_GMOD_GESTURE_AGREE,
		["disagree"] = ACT_GMOD_GESTURE_DISAGREE,
		["forward"] = ACT_SIGNAL_FORWARD,
		["becon"] = ACT_GMOD_GESTURE_BECON,
		["salute"] = ACT_GMOD_TAUNT_SALUTE,
		["pose"] = ACT_GMOD_TAUNT_PERSISTENCE,
		["halt"] = ACT_SIGNAL_HALT,
		["group"] = ACT_SIGNAL_GROUP,
	},
	
	-- Render
	["view_fov_changer"] = false,
	["view_fov_viewmodel_changer"] = false,
	["view_fov_override"] = false,
	["view_fov_set"] = meta_cv.GetInt(GetConVar("fov_desired")),
	["view_fov_viewmodel_set"] = meta_cv.GetInt(GetConVar("viewmodel_fov")),
	["view_viewmodel_offset_changer"] = false,
	["view_viewmodel_offset_x"] = 0,
	["view_viewmodel_offset_y"] = 0,
	["view_viewmodel_offset_z"] = 0,
	["view_fix_thirdperson"] = true,
	["view_antiblind"] = false,
	["view_screengrab_test"] = false,
	["view_screengrab_test_pp"] = false,
	
	["world_ambient_lighting"] = false,
	["world_fullbright"] = false,
	["world_draw_fog"] = true,
	["world_devtextures"] = false,
	["world_devtextures_orange"] = false,
	["world_gmodhud"] = true,
	
	["chams_player"] = false,
	["chams_player_weapon"] = false,
	["chams_viewmodel"] = false,
	["chams_material_player"] = "glow",
	["chams_material_player_weapon"] = "glow",
	["chams_material_viewmodel"] = "glow",
	
	["traces_btr"] = false,
	["traces_btr_local"] = false,
	["traces_btr_other"] = false,
	["traces_btr_max"] = 1000,
	["traces_btr_life"] = 3,
	["traces_shotrecords"] = false,
	["traces_shotrecord_life"] = 3,
	["traces_breadcrumbs"] = false,
	["traces_breadcrumbs_usebeam"] = false,
	["traces_breadcrumbs_length"] = 200,
	
	["meth_render_catpng"] = false,
	["meth_render_catpng_spin"] = false,
	["meth_render_catpng_spin_amount"] = 1,
	["meth_render_catpng_spin_cur"] = 0,
	["meth_render_chams_highlight"] = false,
	["meth_render_chams_highlight_friends"] = false,
	["meth_render_chams_highlight_aimbot"] = false,
	["meth_render_watermark"] = false,
	["meth_render_redrawhud"] = false,
	["meth_render_chamsfix"] = false,
	["meth_render_mirrorfix"] = false,
	["meth_render_fovcircle"] = false,
	["meth_render_fovcircle_outline"] = false,
	["meth_render_freecambox"] = false,
	["meth_render_backtrack"] = false,
	["meth_render_backtrack_target"] = nil,
	
	-- Tools
	["tools_detectors_spectatorlist"] = false,
	["tools_detectors_spectatorlist_showall"] = false,
	["tools_detectors_spectatorlist_x"] = 395,
	["tools_detectors_spectatorlist_y"] = 10,
	["tools_detectors_spectatorlist_w"] = 500,
	["tools_detectors_traitordetector"] = false,
	["tools_detectors_traitordetector_icon"] = false,
	["tools_detectors_traitordetector_list"] = false,
	["tools_detectors_traitordetector_x"] = 10,
	["tools_detectors_traitordetector_y"] = 10,
	["tools_detectors_traitordetector_w"] = 375,
	
	["tools_movement_menuclear"] = true,
	["tools_movement_faststop"] = false,
	["tools_movement_blockbot"] = false,
	["tools_movement_circlestrafer"] = false,
	["tools_movement_circlestrafer_size"] = 5,
	["tools_movement_autobhop"] = false,
	["tools_movement_autostrafe"] = false,
	["tools_movement_antipush"] = false,
	
	["meth_tools_binds"] = false,
	["meth_tools_binds_x"] = 10,
	["meth_tools_binds_y"] = ScrH() / 2,
	["meth_tools_binds_w"] = 245,
	["meth_tools_afdelay"] = false,
	["meth_tools_afdelay_amount"] = 1,
	["meth_tools_afdelay_cur"] = 0,
	["meth_tools_clearfreecam"] = false,
	["meth_tools_aa"] = false,
	["meth_tools_aa_autodir"] = false,
	["meth_tools_aa_jitter_lag"] = false,
	["meth_tools_aa_jitter_yaw"] = false,
	["meth_tools_aa_snapback"] = false,
	["meth_tools_aa_sway"] = false,
	["meth_tools_aa_sway_tick"] = false,
	["meth_tools_aafix"] = false,
	["meth_tools_aafix_last"] = nil,
	["meth_tools_slowmotion"] = false,
	["meth_tools_slowmotion_intensity"] = 200,
	
	["tools_misc_psay"] = false,
	["tools_misc_psay_message"] = "message",
	["tools_misc_gestureloop"] = false,
	["tools_misc_gestureloop_delay"] = false,
	["tools_misc_gestureloop_act"] = "dance",
	["tools_misc_antigag"] = false,
	["tools_misc_flashlightspam"] = false,
	["tools_misc_usespam"] = false,
	["tools_misc_tickshoot"] = false,
	
	-- Detours
	["detours_cmds"] = true,
	["detours_concommand_GetTable"] = true,
	["detours_concommand_Remove"] = true,
	["detours_IsConCommandBlocked"] = true,
	
	["detours_file"] = true,
	["detours_file_Append"] = true,
	["detours_file_AsyncRead"] = true,
	["detours_file_Delete"] = true,
	["detours_file_Exists"] = true,
	["detours_file_Find"] = true,
	["detours_file_Open"] = true,
	["detours_file_Read"] = true,
	["detours_file_Rename"] = true,
	["detours_file_Size"] = true,
	["detours_file_Time"] = true,
	["detours_file_Write"] = true,
	
	["detours_hook"] = true,
	["detours_hook_Add"] = true,
	["detours_hook_GetTable"] = true,
	["detours_hook_Remove"] = true,
	
	["detours_timer"] = true,
	["detours_timer_Adjust"] = true,
	["detours_timer_Create"] = true,
	["detours_timer_Destroy"] = true,
	["detours_timer_Exists"] = true,
	["detours_timer_Pause"] = true,
	["detours_timer_Remove"] = true,
	["detours_timer_RepsLeft"] = true,
	["detours_timer_Start"] = true,
	["detours_timer_Stop"] = true,
	["detours_timer_TimeLeft"] = true,
	["detours_timer_Toggle"] = true,
	["detours_timer_UnPause"] = true,
	
	["detours_gui_MousePos"] = true,
	["detours_gui_MouseX"] = true,
	["detours_gui_MouseY"] = true,
	["detours_gui_OpenURL"] = false,
	["detours_render_DrawTextureToScreen"] = true,
	["detours_RunConsoleCommand"] = true,
	["detours_table_Empty"] = true,
	["detours_taunt_camera"] = true,
	["detours_util_ScreenShake"] = false,
	["detours_cam_ApplyShake"] = false,
	["detours_vgui_CursorVisible"] = true,
	
	-- Logs
	["logs"] = true,
	["logs_detours"] = true,
	["logs_detours_count"] = 0,
	["logs_screengrabs"] = true,
	["logs_screengrabs_count"] = 0,
	["logs_timestamps"] = true,
	["logs_savetofile"] = false,
}

local menu = {
	["Render"] = {
		{"sect", 25, 25, 525, 215, "View"},
		{"cb", 35, 40, "Custom FOV", "view_fov_changer"},
		{"cb", 60, 65, "Override", "view_fov_override"},
		{"sldr", 60, 90, 2, 179, 180, 0, "FOV", "view_fov_set"},
		{"cb", 35, 115, "Custom Viewmodel FOV", "view_fov_viewmodel_changer"},
		{"sldr", 60, 140, 2, 164, 110, 0, "Viewmodel FOV", "view_fov_viewmodel_set"},
		{"cb", 35, 165, "Viewmodel Offset", "view_viewmodel_offset_changer"},
		{"sldr", 60, 190, -30, 30, 75, 0, "X Offset", "view_viewmodel_offset_x"},
		{"sldr", 260, 190, -30, 30, 75, 0, "Y Offset", "view_viewmodel_offset_y"},
		{"sldr", 60, 215, -30, 30, 75, 0, "Z Offset", "view_viewmodel_offset_z"},
		{"cb", 355, 40, "Fix Thirdperson", "view_fix_thirdperson"},
		{"cb", 355, 65, "Anti Screengrab Test", "view_screengrab_test"},
		{"cb", 380, 90, "Do Post Process", "view_screengrab_test_pp"},
		{"cb", 355, 115, "Anti Blind", "view_antiblind"},
		
		{"sect", 25, 250, 315, 90, "World"},
		{"cb", 35, 265, "Ambient Lighting", "world_ambient_lighting"},
		{"cb", 35, 290, "Fullbright", "world_fullbright"},
		{"cb", 35, 315, "Render Fog", "world_draw_fog"},
		{"cb", 220, 265, "Dev Textures", "world_devtextures"},
		{"cb", 245, 290, "Orange", "world_devtextures_orange"},
		{"cb", 220, 315, "GMod HUD", "world_gmodhud"},
		
		{"sect", 345, 250, 205, 90, "Chams"},
		{"cb", 355, 265, "Player Chams", "chams_player"},
		{"cb", 380, 290, "Weapon Chams", "chams_player_weapon"},
		{"cb", 355, 315, "Viewmodel Chams", "chams_viewmodel"},
		
		{"sect", 25, 350, 180, 265, "Meth"},
		{"cb", 35, 365, "Cat PNG FOV", "meth_render_catpng"},
		{"cb", 60, 390, "Spin", "meth_render_catpng_spin"},
		{"sldr", 60, 415, 1, 30, 45, 0, "Speed", "meth_render_catpng_spin_amount"},
		{"cb", 35, 440, "Watermark", "meth_render_watermark"},
		{"cb", 35, 465, "Chams Highlights", "meth_render_chams_highlight"},
		{"cb", 60, 490, "Friends", "meth_render_chams_highlight_friends"},
		{"cb", 60, 515, "Aimbot Target", "meth_render_chams_highlight_aimbot"},
		{"cb", 35, 540, "Redraw Huds", "meth_render_redrawhud"},
		{"cb", 35, 565, "FOV Circle", "meth_render_fovcircle"},
		{"cb", 60, 590, "Outline", "meth_render_fovcircle_outline"},
		
		{"sect", 210, 350, 340, 190, "Traces"},
		{"cb", 220, 365, "Bullet Tracers", "traces_btr"},
		{"cb", 245, 390, "Local Player", "traces_btr_local"},
		{"cb", 245, 415, "Other Players", "traces_btr_other"},
		{"cb", 410, 365, "Shot Records", "traces_shotrecord"},
		{"cb", 410, 390, "Bread Crumbs", "traces_breadcrumbs"},
		{"cb", 435, 415, "Use Beam", "traces_breadcrumbs_usebeam"},
		{"sldr", 220, 440, 1, 60, 104, 0, "Bullet Tracers - Life", "traces_btr_life"},
		{"sldr", 220, 465, 1, 1000, 111, 0, "Bullet Tracers - Max", "traces_btr_max"},
		{"sldr", 220, 490, 1, 60, 126, 0, "Shot Record - Life", "traces_shotrecord_life"},
		{"sldr", 220, 515, 10, 1000, 125, 0, "Breadcrumbs Length", "traces_breadcrumbs_length"},
		
		{"sect", 210, 550, 340, 65, "Meth - Continued"},
		{"cb", 220, 565, "Fix Fake Angle Chams", "meth_render_chamsfix"},
		{"cb", 220, 590, "Fix Mirror Clipping", "meth_render_mirrorfix"},
		{"cb", 410, 565, "Freecam Box", "meth_render_freecambox"},
		{"cb", 410, 590, "Backtrack Hitbox", "meth_render_backtrack"},
	},
	
	["Tools"] = {
		{"sect", 25, 25, 525, 140, "Detectors"},
		{"cb", 35, 40, "Spectator List", "tools_detectors_spectatorlist"},
		{"cb", 60, 65, "Show all Spectators", "tools_detectors_spectatorlist_showall"},
		{"sldr", 252, 40, 0, ScrW() - vars.tools_detectors_spectatorlist_w, 99, 0, "Spectator List - X", "tools_detectors_spectatorlist_x"},
		{"sldr", 252, 65, 0, ScrH() - 20, 99, 0, "Spectator List - Y", "tools_detectors_spectatorlist_y"},
		{"cb", 35, 90, "Traitor Detector", "tools_detectors_traitordetector"},
		{"cb", 60, 115, "Show Icons Above Head", "tools_detectors_traitordetector_icon"},
		{"cb", 60, 140, "Show List", "tools_detectors_traitordetector_list"},
		{"sldr", 252, 90, 0, ScrW() - vars.tools_detectors_traitordetector_w, 85, 0, "Traitor Detector - X", "tools_detectors_traitordetector_x"},
		{"sldr", 252, 115, 0, ScrH() - 20, 85, 0, "Traitor Detector - Y", "tools_detectors_traitordetector_y"},
		
		{"sect", 25, 175, 525, 140, "Movement"},
		{"cb", 35, 190, "Clear in Menu", "tools_movement_menuclear"},
		{"cb", 35, 215, "Fast Stop", "tools_movement_faststop"},
		{"cb", 35, 240, "Blockbot", "tools_movement_blockbot"},
		--{"cb", 35, 265, "Circle Strafer", "tools_movement_circlestrafer"},
		--{"sldr", 365, 190, 1, 10, 50, 0, "CS - Size", "tools_movement_circlestrafer_size"},
		{"cb", 35, 265, "Auto BHop", "tools_movement_autobhop"},
		{"cb", 35, 290, "Auto Strafer", "tools_movement_autostrafe"},
		{"cb", 200, 190, "Anti Push", "tools_movement_antipush"},
		
		{"sect", 25, 325, 260, 290, "Meth"},
		{"cb", 35, 340, "Bind Indicators", "meth_tools_binds"},
		{"cb", 35, 365, "Auto Fire Delay", "meth_tools_afdelay"},
		{"sldr", 60, 390, 1, math.floor(1 / engine.TickInterval()), 65, 0, "Delay Ticks", "meth_tools_afdelay_amount"},
		{"cb", 35, 415, "Clear Movement in Freecam", "meth_tools_clearfreecam"},
		{"cb", 35, 440, "Antiaim", "meth_tools_aa"},
		{"cb", 60, 465, "Auto Direction", "meth_tools_aa_autodir"},
		{"cb", 60, 490, "Jitter Fakelag", "meth_tools_aa_jitter_lag"},
		{"cb", 60, 515, "Jitter Yaw", "meth_tools_aa_jitter_yaw"},
		{"cb", 60, 540, "Snapback", "meth_tools_aa_snapback"},
		{"cb", 60, 565, "Sway", "meth_tools_aa_sway"},
		{"cb", 35, 590, "Disable Antiaim in Water", "meth_tools_aafix"},
		
		{"sect", 295, 325, 255, 215, "Miscellaneous"},
		{"cb", 305, 340, "ULX PSay Spammer", "tools_misc_psay"},
		{"txt", 330, 365, 150, 15, "Message:", "tools_misc_psay_message"},
		{"cb", 305, 390, "Gesture Loop", "tools_misc_gestureloop"},
		{"drp", 330, 415, 100, "Gesture Loop Action", {"agree", "becon", "bow", "cheer", "dance", "disagree", "forward", "group", "halt", "laugh", "muscle", "pose", "robot", "salute", "wave", "zombie"}, "tools_misc_gestureloop_act"},
		{"cb", 305, 440, "Anti ULX Gag", "tools_misc_antigag"},
		{"cb", 305, 465, "Flashlight Spammer", "tools_misc_flashlightspam"},
		{"cb", 305, 490, "Use Key Spammer", "tools_misc_usespam"},
		{"cb", 305, 515, "Tick Shoot", "tools_misc_tickshoot"},
		
		{"sect", 295, 550, 255, 65, "Meth - Continued"},
		{"cb", 305, 565, "Slow Motion", "meth_tools_slowmotion"},
		{"sldr", 330, 590, 1, 400, 80, 0, "Intensity", "meth_tools_slowmotion_intensity"},
	},
	
	["Detours"] = {
		{"sect", 25, 25, 525, 65, "Master"},
		{"cb", 35, 40, "File Protection", "detours_file"},
		{"cb", 180, 40, "ConCommand Protection", "detours_cmds"},
		{"cb", 35, 65, "Timer Protection", "detours_timer"},
		{"cb", 180, 65, "Hook Protection", "detours_hook"},
		
		{"sect", 25, 100, 525, 90, "File Detours"},
		{"cb", 35, 115, "Append", "detours_file_Append"},
		{"cb", 180, 115, "AsyncRead", "detours_file_AsyncRead"},
		{"cb", 325, 115, "Delete", "detours_file_Delete"},
		{"cb", 450, 115, "Exists", "detours_file_Exists"},
		{"cb", 35, 140, "Find", "detours_file_Find"},
		{"cb", 180, 140, "Open", "detours_file_Open"},
		{"cb", 325, 140, "Read", "detours_file_Read"},
		{"cb", 450, 140, "Rename", "detours_file_Rename"},
		{"cb", 35, 165, "Size", "detours_file_Size"},
		{"cb", 180, 165, "Time", "detours_file_Time"},
		{"cb", 325, 165, "Write", "detours_file_Write"},
		
		{"sect", 25, 200, 525, 40, "ConCommand Detours"},
		{"cb", 35, 215, "GetTable", "detours_concommand_GetTable"},
		{"cb", 180, 215, "Remove", "detours_concommand_Remove"},
		{"cb", 325, 215, "IsConCommandBlocked", "detours_IsConCommandBlocked"},
		
		{"sect", 25, 250, 525, 90, "Timer Detours"},
		{"cb", 35, 265, "Adjust", "detours_timer_Adjust"},
		{"cb", 180, 265, "Create", "detours_timer_Create"},
		{"cb", 325, 265, "Destroy", "detours_timer_Destroy"},
		{"cb", 450, 265, "Exists", "detours_timer_Exists"},
		{"cb", 35, 290, "Pause", "detours_timer_Pause"},
		{"cb", 180, 290, "Remove", "detours_timer_Remove"},
		{"cb", 325, 290, "RepsLeft", "detours_timer_RepsLeft"},
		{"cb", 450, 290, "Start", "detours_timer_Start"},
		{"cb", 35, 315, "Stop", "detours_timer_Stop"},
		{"cb", 180, 315, "TimeLeft", "detours_timer_TimeLeft"},
		{"cb", 325, 315, "Toggle", "detours_timer_Toggle"},
		{"cb", 450, 315, "UnPause", "detours_timer_UnPause"},
		
		{"sect", 25, 350, 525, 40, "Hook Detours"},
		{"cb", 35, 365, "Add", "detours_hook_Add"},
		{"cb", 180, 365, "Remove", "detours_hook_Remove"},
		{"cb", 325, 365, "GetTable", "detours_hook_GetTable"},
		
		{"sect", 25, 400, 525, 115, "Miscellaneous Detours"},
		{"cb", 35, 415, "gui.MousePos", "detours_gui_MousePos"},
		{"cb", 180, 415, "gui.MouseX", "detours_gui_MouseX"},
		{"cb", 325, 415, "gui.MouseY", "detours_gui_MouseY"},
		{"cb", 450, 415, "gui.OpenURL", "detours_gui_OpenURL"},
		{"cb", 35, 440, "vgui.CursorVisible", "detours_vgui_CursorVisible"},
		{"cb", 180, 440, "render.DrawTextureToScreen", "detours_render_DrawTextureToScreen"},
		{"cb", 35, 465, "RunConsoleCommand", "detours_RunConsoleCommand"},
		{"cb", 180, 465, "table.Empty", "detours_table_Empty"},
		{"cb", 325, 465, "taunt_camera", "detours_taunt_camera"},
		{"cb", 35, 490, "cam.ApplyShake", "detours_cam_ApplyShake"},
		{"cb", 180, 490, "util.ScreenShake", "detours_util_ScreenShake"},
	},
	
	["Config"] = {
		{"sect", 25, 25, 525, 255, "Colors"},
		{"sect", 35, 40, 250, 110, "Chams"},
		{"clr", 45, 55, 120, 25, "Player", "chams_color_player"},
		{"clr", 45, 85, 120, 25, "Weapon", "chams_color_player_weapon"},
		{"clr", 45, 115, 120, 25, "Viewmodel", "chams_color_viewmodel"},
		{"drp", 175, 60, 100, "", {"normal", "glow", "wireframe", "wallhack"}, "chams_material_player"},
		{"drp", 175, 90, 100, "", {"normal", "glow", "wireframe", "wallhack"}, "chams_material_player_weapon"},
		{"drp", 175, 120, 100, "", {"normal", "glow", "wireframe", "wallhack"}, "chams_material_viewmodel"},
		
		{"sect", 295, 40, 245, 110, "Traces"},
		{"clr", 305, 55, 110, 25, "SR - Hit", "traces_shotrecord_hit"},
		{"clr", 305, 85, 110, 25, "SR - Kill", "traces_shotrecord_kill"},
		{"clr", 305, 115, 110, 25, "Breadcrumbs", "traces_breadcrumbs"},
		{"clr", 425, 55, 105, 25, "Beam", "beam"},
		
		{"sect", 35, 160, 250, 110, "Meth"},
		{"clr", 45, 175, 110, 25, "Cat PNG FOV", "meth_catpng"},
		{"clr", 45, 205, 110, 25, "Watermark", "meth_watermark"},
		{"clr", 45, 235, 110, 25, "FOV Circle", "meth_fovcircle"},
		{"clr", 165, 175, 110, 25, "Freecam", "meth_freecambox"},
		{"clr", 165, 205, 110, 25, "Backtrack", "meth_backtrackhitbox"},
		
		{"sect", 295, 160, 245, 110, "Misc"},
		{"clr", 305, 175, 110, 25, "Menu Accent", "accent"},
		{"clr", 305, 205, 110, 25, "Ambient Light", "world_ambient"},
		{"clr", 425, 175, 105, 25, "Menu BG", "background"},
		{"clr", 425, 205, 105, 25, "MiniMenu BG", "background_mini"},
		{"clr", 305, 235, 110, 25, "MiniMenu Head", "back_min_head"},
		
		{"sect", 25, 290, 295, 140, "Menu"},
		{"cb", 35, 305, "Menu Background", "menu_background"},
		{"drp", 209, 305, 100,  "Background Style", {"blur", "color"}, "menu_background_style"},
		{"cb", 35, 330, "MiniMenu Background", "menu_background_mini"},
		{"drp", 209, 330, 100, "Background Style", {"blur", "color"}, "menu_background_mini_style"},
		{"sldr", 60, 355, 1, 10, 100, 0, "Blur - Scale", "menu_background_blur_scale"},
		{"cb", 60, 380, "Blur Updates Screenspace", "menu_background_blur_updatetexture"},
		{"cb", 35, 405, "Menu Fade In/Out", "menu_fade"},
		
		{"sect", 330, 290, 220, 90, "Config"},
	},
	
	["Logs"] = {} -- Custom
}

local menu_order = {"Render", "Tools", "Detours", "Config", "Logs"}

local badAddons = {
	"anti cheat",
	"anti-cheat",
	"anticheat",
	"eprotect",
	"gimme that screen",
	"say no to exploits",
	"snte",
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
	"gmod_tool",
	"gravity gun",
	"grenade",
	"hand",
	"ied",
	"knife",
	"lightsaber",
	"medkit",
	"physcannon",
	"physgun",
	"physics gun",
	"slam",
	"stunstick",
	"sword",
	"tfa_csgo_bayonet",
	"tfa_csgo_bowie",
	"tfa_csgo_butfly",
	"tfa_csgo_falch",
	"tfa_csgo_flip",
	"tfa_csgo_gut",
	"tfa_csgo_karam",
	"tfa_csgo_m9",
	"tfa_csgo_pushkn",
	"tfa_csgo_stiletto",
	"tfa_csgo_tackni",
	"tfa_csgo_ursus",
	"tfa_csgo_widowmaker",
}

local tWeapons = {
	"(Disguise)",
	"spiderman's_swep",
	"weapon_awp",
	"weapon_jihadbomb",
	"weapon_ttt_awp",
	"weapon_ttt_c4",
	"weapon_ttt_death_station",
	"weapon_ttt_decoy",
	"weapon_ttt_dhook",
	"weapon_ttt_flaregun",
	"weapon_ttt_knife",
	"weapon_ttt_phammer",
	"weapon_ttt_push",
	"weapon_ttt_radio",
	"weapon_ttt_sg552",
	"weapon_ttt_silencedsniper",
	"weapon_ttt_sipistol",
	"weapon_ttt_teleport",
	"weapon_ttt_trait_defilibrator",
	"weapon_ttt_tripmine",
	"weapon_ttt_turtlenade",
	"weapon_ttt_xbow",
}

local badCommands = {
	"+back",
	"+forward",
	"+jump",
	"+left",
	"+moveleft",
	"+right",
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

local badMaterials = {
	"assault_warehouse_02",
	"glass",
	"metalfence",
	"metalfireescape",
	"metalgrate",
	"metalrail",
	"water",
	"window"
}

local specmodes = {
	"Deathcam",
	"Freezecam",
	"Fixed",
	"Firstperson",
	"Thirdperson",
	"Roaming"
}

local cache = { -- Vastly improves performance
	["blockbot_ang"] = Angle(0, 0, 0),
	["blockbot_targ"] = nil,
	["calcview_eyeangles"] = meta_en.EyeAngles(LocalPlayer()),
	["calcview_eyepos"] = meta_en.EyePos(LocalPlayer()),
	["calcview_fov"] = meta_pl.GetFOV(LocalPlayer()) or meta_cv.GetInt(GetConVar("fov_desired")) - 1,
	["calcview_fov_custom"] = meta_pl.GetFOV(LocalPlayer()) or meta_cv.GetInt(GetConVar("fov_desired")) - 1,
	["circlestrafer_active"] = false,
	["circlestrafer_delta"] = 0,
	["cp_ignore"] = true,
	["drp_ignore"] = true,
	["menu_background_step"] = 0,
	["scrh"] = 0,
	["scrw"] = 0,
	["traitors"] = {},
	["txt_ignore"] = true,
	["usespam_tick"] = 0
}

local defvar, defcol, defcache = tCopy(vars), tCopy(colors), tCopy(cache)

local meth_aa = { -- Convert meth_lua_api var into angle
	[0] = 0,
	[1] = 0,
	[2] = 90,
	[3] = -90,
	[4] = 180
}

local meth_binds_keys = {
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

local meth_binds = {
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

-- Used to store stuff

local addtologs = {}
local backtrack = {}
local breadcrumbs = {}
local bullets = {}
local hits = {}
local logs = {}
local materialbackup = {}
local spectators = {}
local traitors = {}

local files = { -- Files to keep safe
	"st3_cfg.txt",
	"st3_log.txt",
	"catpng.png",
	"methlogo.jpg"
}

local detours = { -- Clean copies of to-be-modified functions
	["cam_ApplyShake"] = cam.ApplyShake,
	["concommand_GetTable"] = concommand.GetTable,
	["concommand_Remove"] = concommand.Remove,
	["cvars_AddChangeCallback"] = cvars.AddChangeCallback,
	["cvars_Bool"] = cvars.Bool,
	["cvars_GetConVarCallbacks"] = cvars.GetConVarCallbacks,
	["cvars_Number"] = cvars.Number,
	["cvars_RemoveChangeCallback"] = cvars.RemoveChangeCallback,
	["cvars_String"] = cvars.String,
	["file_Append"] = file.Append,
	["file_AsyncRead"] = file.AsyncRead,
	["file_Delete"] = file.Delete,
	["file_Exists"] = file.Exists,
	["file_Find"] = file.Find,
	["file_Open"] = file.Open,
	["file_Read"] = file.Read,
	["file_Rename"] = file.Rename,
	["file_Size"] = file.Size,
	["file_Time"] = file.Time,
	["file_Write"] = file.Write,
	["GetConVar"] = GetConVar,
	["GetConVarNumber"] = GetConVarNumber,
	["GetConVarString"] = GetConVarString,
	["GetConVar_Internal"] = GetConVar_Internal,
	["gui_MousePos"] = gui.MousePos,
	["gui_MouseX"] = gui.MouseX,
	["gui_MouseY"] = gui.MouseY,
	["gui_OpenURL"] = gui.OpenURL,
	["hook_Add"] = hook.Add,
	["hook_GetTable"] = hook.GetTable,
	["hook_Remove"] = hook.Remove,
	["IsConCommandBlocked"] = IsConCommandBlocked,
	["meta_vc_ToScreen"] = meta_vc.ToScreen,
	["render_DrawTextureToScreen"] = render.DrawTextureToScreen,
	["RunConsoleCommand"] = RunConsoleCommand,
	["table_Empty"] = table.Empty,
	["timer_Adjust"] = timer.Adjust,
	["timer_Create"] = timer.Create,
	["timer_Destroy"] = timer.Destroy,
	["timer_Exists"] = timer.Exists,
	["timer_Pause"] = timer.Pause,
	["timer_Remove"] = timer.Remove,
	["timer_RepsLeft"] = timer.RepsLeft,
	["timer_Start"] = timer.Start,
	["timer_Stop"] = timer.Stop,
	["timer_TimeLeft"] = timer.TimeLeft,
	["timer_Toggle"] = timer.Toggle,
	["timer_UnPause"] = timer.UnPause,
	["util_ScreenShake"] = util.ScreenShake,
	["vgui_CursorVisible"] = vgui.CursorVisible,
}

-- Retarded Derma Trash (Color Picker)

local CPframe = vgui.Create("DFrame")

meta_pn.SetSize(CPframe, 190, 170)
meta_pn.SetPaintedManually(CPframe, true)
CPframe.SetTitle(CPframe, "")
CPframe.ShowCloseButton(CPframe, false)
CPframe.SetSizable(CPframe, false)
CPframe.SetDraggable(CPframe, false)

meta_pn.SetVisible(CPframe, false)

local CPpicker = vgui.Create("DColorMixer", CPframe)

meta_pn.SetSize(CPpicker, 180, 116)
meta_pn.SetPos(CPpicker, 5, 29)
CPpicker.SetPalette(CPpicker, false)
CPpicker.SetWangs(CPpicker, false)

local CPframeChildren = meta_pn.GetChildren(CPpicker)
local CPpickerBoxThing = meta_pn.GetChildren(CPframeChildren[4])[1]
local CPpickerRGB = CPframeChildren[5]
local CPpickerALPHA = CPframeChildren[6]

meta_pn.SetSize(CPpickerBoxThing, 15, 15)
meta_pn.SetCursor(CPpickerBoxThing, "arrow") -- Prevent the color picker from changing your mouse cursor

--[[
	Detours
]]

local function log(event, noind, ltype)
	noind = noind or false

	if vars.logs then
		if vars.logs_detours then
			if ltype == "d" then
				vars.logs_detours_count = vars.logs_detours_count + 1
			end
		end
		
		if vars.logs_screengrabs then
			if ltype == "s" then
				vars.logs_screengrabs_count = vars.logs_screengrabs_count + 1
			end
		end
	
		if event == 0 then
			addtologs[#addtologs + 1] = ""
		else
			event = tostring(event)

			addtologs[#addtologs + 1] = (not noind and "  " or "") .. (vars.logs_timestamps and os.date() .. "  " or "") .. event
		end
	end
end

local function alert(message, dolog, ltype)
	if ismeth and mrend then
		mrend.PushAlert(message)
	else
		surface.PlaySound("garrysmod/balloon_pop_cute.wav")
		MsgC(Color(255, 100, 100), "[" .. title_short .. "] ", Color(222, 222, 222), message .. "\n")
	end
	
	if dolog then
		log(message, false, ltype)
	end
end

-- taunt_camera detour (Move while taunting)
	
meta_cd_g.ClearButtons = function(cmd)
	if not cmd then
		return
	end
	
	if vars.detours_taunt_camera then
		if string.find(string.lower(debug.getinfo(2).short_src), "taunt_camera") then
			return
		end
	end
	
	return meta_cd.ClearButtons(cmd)
end

meta_cd_g.ClearMovement = function(cmd)
	if not cmd then
		return
	end
	
	if vars.detours_taunt_camera then
		if string.find(string.lower(debug.getinfo(2).short_src), "taunt_camera") then
			return
		end
	end
	
	return meta_cd.ClearMovement(cmd)
end

meta_cd_g.SetViewAngles = function(cmd, ang)
	if not cmd or not ang then
		return
	end
	
	if vars.detours_taunt_camera then
		if string.find(string.lower(debug.getinfo(2).short_src), "taunt_camera") then
			return
		end
	end
	
	return meta_cd.SetViewAngles(cmd, ang)
end

local function initDetours() -- Rest of the detours
	if not _G then
		alert("Global Table is nil - Detours won't work", false)
		return
	end

	-- cvars
	
	_G.concommand.GetTable = function()
		local og, at = concommand.GetTable()
		local cb = tCopy(og)
		
		if vars.detours_cmds and vars.detours_concommand_GetTable then
			for k, _ in pairs(cb) do
				if k == "st_menu" then
					cb[k] = nil
				end
			end
			
			alert("Blocked concommand.GetTable()", vars.logs_detours, "d")
		end
	
		return cb, at
	end
	
	_G.concommand.Remove = function(cmd)
		if type(cmd) ~= "string" then
			return
		end
		
		if vars.detours_cmds and vars.detours_concommand_Remove then
			if cmd == "st_menu" then
				alert("Blocked concommand.Remove()", vars.logs_detours, "d")
				return
			end
		end
	
		return detours.concommand_Remove(cmd)
	end
	
	_G.GetConVar = function(cmd)
		if type(cmd) ~= "string" then
			return nil
		end
		
		if vars.detours_cmds and vars.detours_GetConVar then
			if cmd == "st_menu" then
				alert("Blocked GetConVar()", vars.logs_detours, "d")
				return nil
			end
		end
		
		return detours.GetConVar(cmd)
	end
	
	_G.GetConVarNumber = function(cmd)
		if type(cmd) ~= "string" then
			return 0
		end
		
		if vars.detours_cmds and vars.detours_GetConVarNumber then
			if cmd == "st_menu" then
				alert("Blocked GetConVarNumber()", vars.logs_detours, "d")
				return 0
			end
		end
		
		return detours.GetConVarNumber(cmd)
	end
	
	_G.GetConVarString = function(cmd)
		if type(cmd) ~= "string" then
			return ""
		end
		
		if vars.detours_cmds and vars.detours_GetConVarString then
			if cmd == "st_menu" then
				alert("Blocked GetConVarString()", vars.logs_detours, "d")
				return ""
			end
		end
		
		return detours.GetConVarString(cmd)
	end
	
	_G.GetConVar_Internal = function(cmd)
		if type(cmd) ~= "string" then
			return
		end
		
		if vars.detours_cmds and vars.detours_GetConVar_Internal then
			if cmd == "st_menu" then
				alert("Blocked GetConVar_Internal()", vars.logs_detours, "d")
				return
			end
		end
		
		return detours.GetConVar_Internal(cmd)
	end
	
	_G.cvars.GetConVarCallbacks = function(cmd, cinf)
		cinf = cinf or false
	
		if type(cmd) ~= "string" then
			return
		end
		
		if vars.detours_cmds and vars.detours_cmds_GetConVarCallbacks then
			if cmd == "st_menu" then
				alert("Blocked cvars.GetConVarCallbacks()", vars.logs_detours, "d")
				return nil
			end
		end
		
		return detours.cvars_GetConVarCallbacks(cmd, cinf)
	end
	
	_G.cvars.AddChangeCallback = function(cmd, cb, id)
		if not cb then
			return
		end
		
		if type(cmd) ~= "string" then
			return
		end
		
		if vars.detours_cmds and vars.detours_cmds_AddChangeCallback then
			if cmd == "st_menu" then
				alert("Blocked cvars.AddChangeCallback()", vars.logs_detours, "d")
				return
			end
		end
		
		return detours.cvars_AddChangeCallback(cmd, cb, id)
	end
	
	_G.cvars.RemoveChangeCallback = function(cmd, id)
		if not id then
			return
		end
		
		if type(cmd) ~= "string" then
			return
		end
		
		if vars.detours_cmds and vars.detours_cmds_RemoveChangeCallback then
			if cmd == "st_menu" then
				alert("Blocked cvars.RemoveChangeCallback()", vars.logs_detours, "d")
				return
			end
		end
		
		return  detours.cvars_RemoveChangeCallback(cmd, id)
	end
	
	_G.cvars.Bool = function(cmd, def)
		def = def or false
	
		if type(cmd) ~= "string" then
			return def
		end
		
		if vars.detours_cmds and vars.detours_cmds_Bool then
			if cmd == "st_menu" then
				alert("Blocked cvars.Bool()", vars.logs_detours, "d")
				return def
			end
		end
		
		return detours.cvars_Bool(cmd, def)
	end
	
	_G.cvars.Number = function(cmd, def)
		def = def or nil
		
		if type(cmd) ~= "string" then
			return def
		end
		
		if vars.detours_cmds and vars.detours_cmds_Number then
			if cmd == "st_menu" then
				alert("Blocked cvars.Number()", vars.logs_detours, "d")
				return def
			end
		end
		
		return detours.cvars_Number(cmd, def)
	end
	
	_G.cvars.String = function(cmd, def)
		def = def or nil
		
		if type(cmd) ~= "string" then
			return def
		end
		
		if vars.detours_cmds and vars.detours_cmds_String then
			if cmd == "st_menu" then
				alert("Blocked cvars.String()", vars.logs_detours, "d")
				return def
			end
		end
		
		return detours.cvars_String(cmd, def)
	end
	
	-- file
	
	_G.file.Append = function(file, cont)
		if type(file) ~= "string" or type(cont) ~= "string" then
			return
		end
		
		if vars.detours_file and vars.detours_file_Append then
			for _, f in ipairs(files) do
				if string.find(file, f) then
					alert("Blocked file.Append()", vars.logs_detours, "d")
					return
				end
			end
		end
		
		return detours.file_Append(file, cont)
	end
	
	_G.file.AsyncRead = function(file, path, cb, sync)
		sync = sync or false
		
		if type(file) ~= "string" or type(path) ~= "string" or not cb then
			return FSASYNC_ERR_FAILURE
		end
		
		if vars.detours_file and vars.detours_file_AsyncRead then
			for _, f in ipairs(files) do
				if string.find(file, f) then
					alert("Blocked file.AsyncRead()", vars.logs_detours, "d")
					return FSASYNC_ERR_FAILURE
				end
			end
		end
		
		return detours.file_AsyncRead(file, path, cb, sync)
	end
	
	_G.file.Delete = function(file)
		if type(file) ~= "string" then
			return
		end
		
		if vars.detours_file and vars.detours_file_Delete then
			for _, f in ipairs(files) do
				if string.find(file, f) then
					alert("Blocked file.Delete()", vars.logs_detours, "d")
					return
				end
			end
		end
		
		return detours.file_Delete(file)
	end
	
	_G.file.Exists = function(file, path)
		if type(file) ~= "string" or type(path) ~= "string" then
			return false
		end
		
		if vars.detours_file and vars.detours_file_Exists then
			for _, f in ipairs(files) do
				if string.find(file, f) then
					alert("Blocked file.Exists()", vars.logs_detours, "d")
					return false
				end
			end
		end
		
		return detours.file_Exists(file, path)
	end
	
	_G.file.Find = function(file, path, sorting)
		sorting = sorting or "nameasc"
		
		if type(file) ~= "string" or type(path) ~= "string" then
			return nil, nil
		end
		
		if vars.detours_file and vars.detours_file_Find then
			local x, y = detours.file_Find(file, path, sorting)
			
			for k, v in ipairs(x) do
				for _, f in ipairs(files) do
					if v == f then
						x[k] = nil
					end
				end
			end
			
			alert("Blocked file.Find()", vars.logs_detours, "d")
			
			return x, y
		end
		
		return detours.file_Find(file, path, sorting)
	end
	
	_G.file.Open = function(file, mode, path)
		if type(file) ~= "string" or type(mode) ~= "string" or type(path) ~= "string" then
			return nil
		end

		if vars.detours_file and vars.detours_file_Open then
			for _, f in ipairs(files) do
				if string.find(file, f) then
					alert("Blocked file.Open()", vars.logs_detours, "d")
					return nil
				end
			end
		end
		
		return detours.file_Open(file, mode, path)
	end
	
	_G.file.Read = function(file, path)
		if path == true then
			path = "GAME"
		end
		
		path = path or "DATA"
		
		if type(file) ~= "string" then
			return nil
		end
		
		if vars.detours_file and vars.detours_file_Read then
			for _, f in ipairs(files) do
				if string.find(file, f) then
					alert("Blocked file.Read()", vars.logs_detours, "d")
					return nil
				end
			end
		end
		
		return detours.file_Read(file, path)
	end
	
	_G.file.Rename = function(oname, nname)
		if type(oname) ~= "string" or type(nname) ~= "string" then
			return false
		end
		
		if vars.detours_file and vars.detours_file_Rename then
			for _, f in ipairs(files) do
				if string.find(oname, f) or string.find(nname, f) then
					alert("Blocked file.Rename()", vars.logs_detours, "d")
					return false
				end
			end
		end
		
		return detours.file_Rename(oname, nname)
	end
	
	_G.file.Size = function(file, path)
		if type(file) ~= "string" or type(path) ~= "string" then
			return -1
		end
		
		if vars.detours_file and vars.detours_file_Size then
			for _, f in ipairs(files) do
				if string.find(file, f) then
					alert("Blocked file.Size()", vars.logs_detours, "d")
					return -1
				end
			end
		end
		
		return detours.file_Size(file, path)
	end
	
	_G.file.Time = function(file, path)
		if type(file) ~= "string" or type(path) ~= "string" then
			return 0
		end
		
		if vars.detours_file and vars.detours_file_Time then
			for _, f in ipairs(files) do
				if string.find(file, f) then
					alert("Blocked file.Time()", vars.logs_detours, "d")
					return 0
				end
			end
		end
		
		return detours.file_Time(file, path)
	end
	
	_G.file.Write = function(file, cont)
		if type(file) ~= "string" or type(cont) ~= "string" then
			return
		end
		
		if vars.detours_file and vars.detours_file_Write then
			for _, f in ipairs(files) do
				if string.find(file, f) then
					alert("Blocked file.Write()", vars.logs_detours, "d")
					return
				end
			end
		end
		
		return detours.file_Write(file, cont)
	end
	
	-- timers
	
	_G.timer.Adjust = function(name, delay, reps, func)
		if type(name) ~= "string" or type(delay) ~= "number" or type(reps) ~= "number" or type(func) ~= "function" then
			return
		end
		
		if vars.detours_timer and vars.detours_timer_Adjust then
			if name == vars.hookname then
				alert("Blocked timer.Adjust()", vars.logs_detours, "d")
				return
			end
		end
		
		return detours.timer_Adjust(name, delay, reps, func)
	end
	
	_G.timer.Create = function(name, delay, reps, func)
		if type(name) ~= "string" or type(delay) ~= "number" or type(reps) ~= "number" or type(func) ~= "function" then
			return
		end
		
		if vars.detours_timer and vars.detours_timer_Create then
			if name == vars.hookname then
				alert("Blocked timer.Create()", vars.logs_detours, "d")
				return
			end
		end
		
		return detours.timer_Create(name, delay, reps, func)
	end
	
	_G.timer.Destroy = function(name)
		if type(name) ~= "string" then
			return
		end
		
		if vars.detours_timer and vars.detours_timer_Destroy then
			if name == vars.hookname then
				alert("Blocked timer.Destroy()", vars.logs_detours, "d")
				return
			end
		end
		
		return detours.timer_Destroy(name)
	end
	
	_G.timer.Exists = function(name)
		if type(name) ~= "string" then
			return false
		end
		
		if vars.detours_timer and vars.detours_timer_Exists then
			if name == vars.hookname then
				alert("Blocked timer.Exists()", vars.logs_detours, "d")
				return false
			end
		end
		
		return detours.timer_Exists(name)
	end
	
	_G.timer.Pause = function(name)
		if type(name) ~= "string" then
			return false
		end
		
		if vars.detours_timer and vars.detours_timer_Pause then
			if name == vars.hookname then
				alert("Blocked timer.Pause()", vars.logs_detours, "d")
				return false
			end
		end
		
		return detours.timer_Pause(name)
	end
	
	_G.timer.UnPause = function(name)
		if type(name) ~= "string" then
			return false
		end
		
		if vars.detours_timer and vars.detours_timer_UnPause then
			if name == vars.hookname then
				alert("Blocked timer.UnPause()", vars.logs_detours, "d")
				return false
			end
		end
		
		return detours.timer_UnPause(name)
	end
	
	_G.timer.Remove = function(name)
		if type(name) ~= "string" then
			return
		end
		
		if vars.detours_timer and vars.detours_timer_Remove then
			if name == vars.hookname then
				alert("Blocked timer.Remove()", vars.logs_detours, "d")
				return
			end
		end
		
		return detours.timer_Remove(name)
	end
	
	_G.timer.RepsLeft = function(name)
		if type(name) ~= "string" then
			return
		end
		
		if vars.detours_timer and vars.detours_timer_RepsLeft then
			if name == vars.hookname then
				alert("Blocked timer.RepsLeft()", vars.logs_detours, "d")
				return
			end
		end
		
		return detours.timer_RepsLeft(name)
	end
	
	_G.timer.Start = function(name)
		if type(name) ~= "string" then
			return false
		end
		
		if vars.detours_timer and vars.detours_timer_Start then
			if name == vars.hookname then
				alert("Blocked timer.Start()", vars.logs_detours, "d")
				return false
			end
		end
		
		return detours.timer_Start(name)
	end
	
	_G.timer.Stop = function(name)
		if type(name) ~= "string" then
			return false
		end
		
		if vars.detours_timer and vars.detours_timer_Stop then
			if name == vars.hookname then
				alert("Blocked timer.Stop()", vars.logs_detours, "d")
				return false
			end
		end
		
		return detours.timer_Stop(name)
	end
	
	_G.timer.TimeLeft = function(name)
		if type(name) ~= "string" then
			return
		end
		
		if vars.detours_timer and vars.detours_timer_TimeLeft then
			if name == vars.hookname then
				alert("Blocked timer.TimeLeft()", vars.logs_detours, "d")
				return
			end
		end
		
		return detours.timer_TimeLeft(name)
	end
	
	_G.timer.Toggle = function(name)
		if type(name) ~= "string" then
			return false
		end
		
		if vars.detours_timer and vars.detours_timer_Toggle then
			if name == vars.hookname then
				alert("Blocked timer.Toggle()", vars.logs_detours, "d")
				return false
			end
		end
		
		return detours.timer_Toggle(name)
	end
	
	-- hook
	
	_G.hook.Add = function(event, name, func)
		if type(event) ~= "string" or type(name) ~= "string" or type(func) ~= "function" then
			return
		end
		
		if vars.detours_hook and vars.detours_hook_Add then
			if vars.view_antiblind then
				if event == "HUDPaint" and name == "ulx_blind" then
					return
				end
			end
			
			if name == vars.hookname then
				alert("Blocked hook.Add()", vars.logs_detours, "d")
				return
			end
		end
		
		return detours.hook_Add(event, name, func)
	end
	
	_G.hook.Remove = function(event, name)
		if type(event) ~= "string" or type(name) ~= "string" then
			return
		end
		
		if vars.detours_hook and vars.detours_hook_Remove then
			if name == vars.hookname then
				alert("Blocked hook.Remove()", vars.logs_detours, "d")
				return
			end
		end
		
		return detours.hook_Remove(event, name)
	end
	
	_G.hook.GetTable = function()
		local og = detours.hook_GetTable()
		
		if vars.detours_hook and vars.detours_hook_GetTable then
			for event, subs in pairs(og) do
				if type(subs) == "table" then
					for k, _ in pairs(subs) do
						if k == vars.hookname then
							subs[k] = nil
						end
					end
					
					if table.Count(subs) == 0 then
						og[event] = nil
					end
				end
			end
			
			alert("Blocked hook.GetTable()", vars.logs_detours, "d")
		end
		
		return og
	end
	
	-- miscellaneous
	
	_G.gui.MousePos = function()
		if vars.detours_gui_MousePos then
			if vars.menu then
				alert("Blocked gui.MousePos()", vars.logs_detours, "d")
				return 0, 0
			end
		end
		
		return detours.gui_MouseX(), detours.gui_MouseY()
	end
	
	_G.gui.MouseX = function()
		if vars.detours_gui_MouseX then
			if vars.menu then
				alert("Blocked gui.MouseX()", vars.logs_detours, "d")
				return 0
			end
		end
		
		return detours.gui_MouseX()
	end
	
	_G.gui.MouseY = function()
		if vars.detours_gui_MouseY then
			if vars.menu then
				alert("Blocked gui.MouseY()", vars.logs_detours, "d")
				return 0
			end
		end
		
		return detours.gui_MouseY()
	end
	
	_G.gui.OpenURL = function(url)
		if type(url) ~= "string" then
			return
		end
	
		if vars.detours_gui_OpenURL then
			alert("Blocked gui.OpenURL()", vars.logs_detours, "d")
			return
		end
		
		return detours.gui_OpenURL(url)
	end
	
	_G.vgui.CursorVisible = function()
		if vars.detours_vgui_CursorVisible then
			if vars.menu then
				alert("Blocked vgui.CursorVisible()", vars.logs_detours, "d")
				return false
			end
		end
		
		return detours.vgui_CursorVisible()
	end
	
	_G.render.DrawTextureToScreen = function(texture)
		if type(texture) ~= "ITexture" then
			return
		end
		
		if vars.detours_render_DrawTextureToScreen or vars.view_antiblind then
			alert("Blocked render.DrawTextureToScreen()", vars.logs_detours, "d")
			return
		end
		
		return detours.render_DrawTextureToScreen(texture)
	end
	
	_G.RunConsoleCommand = function(cmd, ...)
		if type(cmd) ~= "string" then
			return
		end
		
		local rest = {...}
		
		if vars.detours_RunConsoleCommand then
			for _, v in ipairs(badCommands) do
				if string.find(cmd, v) then
					alert("Block RunConsoleCommand()", vars.logs_detours, "d")
					return
				end
				
				for _, r in ipairs(rest) do
					if string.find(r, v) then
						alert("Block RunConsoleCommand()", vars.logs_detours, "d")
						return
					end
				end
			end
		end
		
		return detours.RunConsoleCommand(cmd, ...)
	end
	
	_G.table.Empty = function(tbl)
		if type(tbl) ~= "table" then
			return
		end
		
		if vars.detours_table_Empty then
			if tbl == _G then
				alert("Blocked table.Empty()", vars.logs_detours, "d")
				return
			end
		end
		
		return detours.table_Empty(tbl)
	end
	
	_G.cam.ApplyShake = function(pos, ang, factor)
		if not pos or not ang or not factor then
			return
		end
		
		if vars.detours_cam_ApplyShake then
			return
		end
		
		return detours.cam_ApplyShake(pos, ang, factor)
	end
	
	_G.util.ScreenShake = function(pos, amp, freq, dur, rad)
		if not pos or not amp or not freq or not dur or not rad then
			return
		end
		
		if vars.detours_util_ScreenShake then
			return
		end
		
		return detours.util_ScreenShake(pos, amp, freq, dur, rad)
	end
end

-- Fix functions

-- Patch file functions to allow us to access our own files

detours.file_Append = function(file, cont)
	if type(file) ~= "string" or type(cont) ~= "string" then
		return
	end
	
	local fs = detours.file_Open(file, "ab", "DATA")
	
	if fs then
		meta_fl.Write(fs, cont)
		meta_fl.Close(fs)
	end
end

detours.file_Write = function(file, cont)
	if type(file) ~= "string" or type(cont) ~= "string" then
		return
	end
	
	local fs = detours.file_Open(file, "wb", "DATA")
	
	if fs then
		meta_fl.Write(fs, cont)
		meta_fl.Close(fs)
	end
end

detours.file_Read = function(file, path)
	if path == true then
		path = "GAME"
	end
	
	path = path or "DATA"

	if type(file) ~= "string" then
		return
	end
	
	local fs = detours.file_Open(file, "rb", path)
	local str = ""
	
	if fs then
		str = meta_fl.Read(fs, meta_fl.Size(fs)) or ""
		
		meta_fl.Close(fs)
	end
	
	return str
end

-- Fix Vector:ToScreen()

meta_vc.ToScreen = function(vec)
	local ret = {
		["x"] = -1,
		["y"] = -1,
		["visible"] = false
	}

	if not vec then
		return ret
	end
	
	cam.Start3D()
		ret = detours.meta_vc_ToScreen(vec)
	cam.End3D()
	
	return ret
end

--[[
	Functions
]]

local function saveconfig()
	local ogmenu = vars.menu
	
	vars.menu = false
	vars.colors_backup = tCopy(colors) -- Save colors to config
	
	local tabletojson = util.TableToJSON(vars)
	
	if ismeth and mio then
		local mdata = mio.Write("C:/MTHRW/LUA/data/st3_cfg.txt", tabletojson)

		if not mdata.status then
			detours.file_Write("st3_cfg.txt", tabletojson) -- Fallback to default gmod stuff when things go wrong
		end
	else
		detours.file_Write("st3_cfg.txt", tabletojson)
	end
	
	log("Saved config")
	alert("Saved config", false)
	
	vars.menu = ogmenu
end

local function loadconfig(suppress)
	local oghook = vars.hookname -- Backup important stuff
	local ogmenu = vars.menu
	local ogtab = vars.menu_tab
	local ogmenupos = {
		["x"] = vars.menu_x,
		["y"] = vars.menu_y,
		["w"] = vars.menu_w,
		["h"] = vars.menu_h
	}
	
	local jsontotable = nil
	local data = nil

	if ismeth and mio then
		local mdata = mio.Read("C:/MTHRW/LUA/data/st3_cfg.txt")
		
		if mdata.content ~= "" then
			data = mdata.content
		end
	end
	
	if not data then
		data = file.Read("st3_cfg.txt", "DATA") -- Fallback to default gmod stuff when things go wrong
	end
	
	if data then
		jsontotable = util.JSONToTable(data)
	end
	
	if jsontotable then
		for k, v in pairs(jsontotable) do -- Restore vars from config
			vars[k] = v
		end
		
		for k, v in pairs(vars.colors_backup) do -- Restore colors
			colors[k] = v
		end
		
		vars.colors_backup = nil
		
		if not suppress then
			log("Loaded config")
		end
		
		alert("Loaded config", false)
	else
		if not suppress then
			log("Failed to load config")
			alert("Failed to load config", false)
		end
	end
	
	vars.hookname = oghook -- Restore important stuff
	vars.menu = ogmenu
	vars.menu_tab = ogtab
	vars.menu_x = ogmenupos.x
	vars.menu_y = ogmenupos.y
	vars.menu_w = ogmenupos.w
	vars.menu_h = ogmenupos.h
end

local function mousein(a, b, c, d)
	local mx, my = detours.gui_MouseX(), detours.gui_MouseY()
	
	return mx >= a and my >= b and mx <= c and my <= d
end

local function canclick(a, b, c, d, igdly)
	if not vars.menu then
		return false
	end

	local extra = true

	if not igdly then
		extra = not vars.menu_mousedelay
	end
	
	return mousein(a, b, c, d) and input.IsMouseDown(MOUSE_LEFT) and extra and not meta_pn.IsVisible(CPframe)
end

local function canrender(flags)
	if not flags then
		flags = 0
	end

	local mesp = true
	local mfree = true
	
	if ismeth then
		if not vars.menu then
			if mvar then
				mesp = mvar.GetVarInt("ESP..Enabled") == 1
				mfree = mvar.GetVarInt("Player.Free Cam.Free Cam") == 1
			end
		end
	end
	
	local guicheck = not detours.vgui_CursorVisible() and not gui.IsConsoleVisible() and not gui.IsGameUIVisible() and not meta_pl.IsTyping(LocalPlayer())
	
	if flags == 1 then
		return mesp
	end
	
	if flags == 2 then
		return not meta_pl.ShouldDrawLocalPlayer(LocalPlayer())
	end
	
	if flags == 3 then
		return not mfree
	end	
	
	return mesp and guicheck
end

local function getChamsMatNorm(mat)
	if mat == "normal" then
		return materials.debugwhite
	elseif mat == "wireframe" then
		return materials.wireframe
	elseif mat == "wallhack" then
		return nil
	end
end

local function getChamsMat(use)
	if use == "PLAYER" then
		local mat = vars.chams_material_player
		
		if mat == "glow" then
			return materials.glow_player
		else
			return getChamsMatNorm(mat)
		end
	end
	
	if use == "HIGHLIGHT_P_F" then
		local mat = vars.chams_material_player
	
		if mat == "glow" then
			return materials.glow_player_highlight_friends
		else
			return getChamsMatNorm(mat)
		end
	end
	
	if use == "HIGHLIGHT_P_A" then
		local mat = vars.chams_material_player
	
		if mat == "glow" then
			return materials.glow_player_highlight_aimbot
		else
			return getChamsMatNorm(mat)
		end
	end
	
	if use == "HIGHLIGHT_W_F" then
		local mat = vars.chams_material_player_weapon
	
		if mat == "glow" then
			return materials.glow_player_highlight_friends
		else
			return getChamsMatNorm(mat)
		end
	end
	
	if use == "HIGHLIGHT_W_A" then
		local mat = vars.chams_material_player_weapon
	
		if mat == "glow" then
			return materials.glow_player_highlight_aimbot
		else
			return getChamsMatNorm(mat)
		end
	end
	
	if use == "WEAPON" then
		local mat = vars.chams_material_player_weapon
	
		if mat == "glow" then
			return materials.glow_player_weapon
		else
			return getChamsMatNorm(mat)
		end
	end
	
	if use == "VM" then
		local mat = vars.chams_material_viewmodel
	
		if mat == "glow" then
			return materials.glow_viewmodel
		else
			return getChamsMatNorm(mat)
		end
	end

	return nil
end

local function validMaterial(mat)
	if not mat then
		return false
	end
	
	for _, v in ipairs(badMaterials) do
		if string.find(mat, v) then
			return false
		end
	end
	
	return true
end

local function validEntity(ent)
	if not meta_en.IsValid(ent) then
		return false
	end
	
	if meta_en.GetClass(ent) == "player" then
		if not meta_pl.Alive(ent) or meta_pl.GetObserverMode(ent) ~= 0 or meta_pl.Team(ent) == TEAM_SPECTATOR or meta_en.GetColor(ent).a == 0 or meta_en.IsDormant(ent) or meta_en.IsEffectActive(ent, EF_NODRAW) then
			return false
		else
			return true
		end
	end
	
	return not meta_en.IsDormant(ent)
end

local function validMoveType()
	local movetype = meta_en.GetMoveType(LocalPlayer())
	
	if not movetype then
		return false
	end
	
	return movetype ~= MOVETYPE_LADDER and movetype ~= MOVETYPE_NOCLIP and movetype ~= MOVETYPE_OBSERVER and not validEntity(meta_pl.GetVehicle(LocalPlayer()))
end

local function isMoving(cmd)
	if not cmd then
		return false
	end
	
	return meta_cd.KeyDown(cmd, IN_MOVELEFT) or meta_cd.KeyDown(cmd, IN_MOVERIGHT) or meta_cd.KeyDown(cmd, IN_FORWARD) or meta_cd.KeyDown(cmd, IN_BACK) and not meta_cd.KeyDown(cmd, IN_JUMP)
end

local function getMethAimbotTarget()
	if not ismeth or not mutil then
		return nil
	end

	local at = mutil.GetAimbotTarget()
	
	if at ~= 0 then
		local ent = ents.GetByIndex(at)

		if validEntity(ent) then
			return ent
		end
	end
	
	return nil
end

local function getKey(key)
	if key < 1 then
		return nil
	end
	
	if key > 47 and key < 91 then
		return input.GetKeyCode(string.char(key))
	end
	
	return meth_binds_keys[key] or 0
end

local function getKeyStatus(option, toggle, tvar)
	toggle = toggle or false
	
	local status = mvar.GetVarInt(option)
	
	status = status > 0 and status or 0
	
	local key = getKey(status) or 0
	local keystatus = false
	
	if toggle then
		if tvar then
			if mvar.GetVarInt(tvar) == 1 then
				keystatus = true
			end
		end
	else
		if key > 0 then
			if input.IsButtonDown(key) then
				keystatus = true
			end
		end
	end
	
	return key, keystatus
end

local function getBinds()
	local binds = {}
	
	for k, v in pairs(meth_binds) do
		if k ~= "*" then
			if mvar.GetVarInt(k) ~= 1 then
				continue
			end
		end
		
		for option, data in pairs(v.toggle) do
			local key, stat = getKeyStatus(option, true, data[1])
			
			if key == 0 then
				stat = true
			end
			
			local keyname = input.GetKeyName(key) or "ALWAYS"
			
			binds[#binds + 1] = {
				["name"] = data[2],
				["type"] = "Toggle",
				["key"] = string.upper(keyname),
				["status"] = stat
			}
		end
		
		for option, name in pairs(v.hold) do
			local key, stat = getKeyStatus(option, false)
			
			if key == 0 then
				stat = true
			end
			
			local keyname = input.GetKeyName(key) or "ALWAYS"
			
			binds[#binds + 1] = {
				["name"] = name,
				["type"] = "Hold",
				["key"] = string.upper(keyname),
				["status"] = stat
			}
		end
	end
	
	return binds
end

local function getEntityHitboxes(ent, doOVR)
	local hitboxes = {}
	
	if not validEntity(ent) then
		return hitboxes
	end
	
	local epos = meta_en.GetPos(ent)
	
	for i = 0, meta_en.GetHitboxSetCount(ent) - 1 do
		for ii = 0, meta_en.GetHitBoxCount(ent, i) - 1 do
			local mins, maxs = meta_en.GetHitBoxBounds(ent, ii, i)
			
			if not mins or not maxs then
				continue
			end
			
			local bone = meta_en.GetHitBoxBone(ent, ii, i)
			
			if not bone then
				continue
			end	
			
			local pos, ang = meta_en.GetBonePosition(ent, bone)
			
			if pos == epos or (not pos or not ang) then
				local bm = meta_en.GetBoneMatrix(ent, bone)
				
				if not bm then
					continue
				end
				
				pos, ang = meta_vm.GetTranslation(bm), meta_vm.GetAngles(bm)
				
				if not pos or not ang then
					continue
				end
			end
			
			local new = {
				["pos"] = pos,
				["ang"] = ang,
				["mins"] = mins,
				["maxs"] = maxs
			}
			
			if doOVR ~= nil then
				new.ovr = doOVR
			end
			
			hitboxes[#hitboxes + 1] = new
		end
	end
	
	return hitboxes
end

local function isVisible(thing)
	if not thing then
		return false
	end

	if type(thing) == "Vector" then
		local vpos = meta_vc.ToScreen(thing)
		
		return vpos.visible
	else
		if not validEntity(thing) then
			return false
		end
		
		local cpos = meta_en.GetPos(thing) - cache.calcview_eyepos
		local len = meta_vc.Length(cpos)
		local rad = meta_en.BoundingRadius(thing)
		local max = math.abs(math.cos(math.acos(len / math.sqrt((len * len) + (rad * rad))) + 60 * (math.pi /180)))
		
		meta_vc.Normalize(cpos)
		
		return meta_vc.Dot(cpos, meta_an.Forward(cache.calcview_eyeangles)) > max
	end
end

local function isBadWeapon(wep)
	if not validEntity(wep) then
		return true
	end
	
	local class = string.lower(meta_en.GetClass(wep) or "")
	
	for _, v in ipairs(badWeapons) do
		if string.find(class, v) then
			return true
		end
	end
	
	return false
end

local function getHeadPos(ent)
	if not validEntity(ent) then
		return Vector(0, 0, 0)
	end
	
	local entpos = meta_en.GetPos(ent)
	local headpos = meta_en.EyePos(ent)
	
	for i = 0, meta_en.GetBoneCount(ent) - 1 do
		if string.find(string.lower(meta_en.GetBoneName(ent, i)), "head") then
			headpos = meta_en.GetBonePosition(ent, i)
			
			if headpos == entpos then
				headpos = meta_vm.GetTranslation(meta_en.GetBoneMatrix(ent, i))
			end

			break
		end
	end
	
	return headpos
end

local function getColor(color, ent)
	if colors[color] == "RGB" then
		return colors.rainbow
	else
		if colors[color] == "HP" then
			if meta_en.IsValid(ent) then
				local ehp = meta_en.Health(ent) * (meta_en.Health(ent) / meta_en.GetMaxHealth(ent))
				
				return Color(255 - (ehp * 2.55), ehp * 2.55, 0, 255)
			else
				return colors.white
			end
		else
			return colors[color]
		end
	end
end

local function compareColor(a, b)
	if not a or not b then
		return false
	end
	
	return a.r == b.r and a.g == b.g and a.b == b.b and a.a == b.a
end

local function copyColor(a)
	if not a then
		return Color(255, 255, 255, 255)
	end
	
	return Color(a.r, a.g, a.b, a.a)
end

local function updateGlowColor(material, color)
	if not material then
		return
	end
	
	meta_im.SetVector(material, "$envmaptint", meta_cl.ToVector(color))
end

local function getClosest(smart)
	smart = smart or false

	local mx, my = ScrW() / 2, ScrH() / 2
	local best = math.huge
	local curply = nil
	
	local lpos = meta_en.GetPos(LocalPlayer())
	
	for _, v in ipairs(player.GetAll()) do
		if not validEntity(v) or v == LocalPlayer() then
			continue
		end
		
		local cur
		
		if smart then
			local spos = meta_vc.ToScreen(meta_en.GetPos(v))
			cur = math.Dist(spos.x, spos.y, mx, my)
		else
			cur = meta_vc.DistToSqr(meta_en.GetPos(v), lpos)
		end

		if cur < best then
			best = cur
			curply = v
		end
	end
	
	return curply
end

local function invokeColorPicker(x, y)
	local w, h = meta_pn.GetWide(CPframe), meta_pn.GetTall(CPframe)

	if x + w > vars.menu_x + vars.menu_w then
		x = (vars.menu_x + vars.menu_w) - w
	end
	
	if y + h > vars.menu_y + vars.menu_h then
		y = (vars.menu_y + vars.menu_h) - h
	end
	
	if colors[vars.menu_colorpicker_var] ~= "RGB" and colors[vars.menu_colorpicker_var] ~= "HP" then
		CPpicker.SetColor(CPpicker, colors[vars.menu_colorpicker_var])
	else
		CPpicker.SetColor(CPpicker, Color(255, 255, 255, 255))
	end
	
	cache.cp_ignore = true

	meta_pn.SetEnabled(CPframe, true)

	meta_pn.SetPos(CPframe, x, y)
	
	meta_pn.SetEnabled(CPpickerRGB, true)
	meta_pn.SetEnabled(CPpickerALPHA, true)
	meta_pn.SetEnabled(CPpickerBoxThing, true)
	
	meta_pn.SetVisible(CPpickerRGB, true)
	meta_pn.SetVisible(CPpickerALPHA, true)
	meta_pn.SetVisible(CPpickerBoxThing, true)
	
	meta_pn.SetVisible(CPframe, true)
end

local function shrinkText(text, w)
	surface.SetFont("BudgetLabel")
	
	text = text or ""
	local newtext = text
	
	local tw, th = surface.GetTextSize(newtext)
	
	while tw + 5 > w do
		newtext = string.sub(newtext, 1, string.len(newtext) - 1)
		tw, th = surface.GetTextSize(newtext .. "...")
	end
	
	if newtext ~= text then
		newtext = newtext .. "..."
	end
	
	return newtext
end

-- Menu Functions

local swag = {
	["AddTab"] = function(label, page, id)
		local x = vars.menu_x + 12 + (75 * id)
		local y = vars.menu_y + 20
		local w, h = 75, 20
	
		if canclick(x + 1, y + 1, x + w, y + h) then
			vars.menu_tab = page
		end
		
		local active = page == vars.menu_tab
		
		draw.NoTexture()
		
		if active then
			surface.SetDrawColor(colors.back)
			surface.DrawLine(x, y + h, x + w, y + h)
		else
			surface.SetDrawColor(colors.back_t)
		end
		
		surface.DrawRect(x, y + 1, w, h - 1)
		
		x = x - 1
		
		if active then
			surface.SetDrawColor(colors.outline)
			surface.DrawLine(x, y, x, y + h)
			surface.DrawLine(x + w, y, x + w, y + h)
		
			if id ~= 0 then
				surface.DrawLine(x, y, vars.menu_x + 11, y)
				surface.DrawLine(x, y + h, vars.menu_x + 11, y + h)
			end
			
			surface.DrawLine(x + w, y + h, (vars.menu_x + vars.menu_w) - 12, y + h)
			surface.DrawLine(x + w, y, (vars.menu_x + vars.menu_w) - 12, y)
		
			surface.SetDrawColor(getColor("accent"))
			surface.DrawLine(x + 1, y, x + w, y)
			surface.DrawLine(x + 1, y + 1, x + w, y + 1)
		end
		
		surface.SetFont("BudgetLabel")
		surface.SetTextColor(colors.white)
		
		local tw, th = surface.GetTextSize(label)
		
		surface.SetTextPos(x + ((w / 2) - (tw / 2)), y + 4)
		surface.DrawText(label)
	end,

	["AddCheckbox"] = function(x, y, label, var)	
		x = (x + vars.menu_x) + 12
		y = (y + vars.menu_y) + 40
		
		if canclick(x, y, x + 15, y + 15) then
			vars[var] = not vars[var]
		end
	
		draw.NoTexture()
		
		surface.SetDrawColor(colors.back_t)
		surface.DrawRect(x, y, 15, 15)
		
		if vars[var] then
			surface.SetDrawColor(getColor("accent"))
			surface.DrawRect(x + 2, y + 2, 11, 11)
		end
		
		surface.SetDrawColor(colors.outline)
		surface.DrawOutlinedRect(x, y, 15, 15)
		
		surface.SetFont("BudgetLabel")
		surface.SetTextColor(colors.white)
		
		local tw, th = surface.GetTextSize(label)
		
		surface.SetTextPos(x + 20, y + math.abs(7.5 - (th / 2)))
		
		surface.DrawText(label)
	end,
	
	["AddSlider"] = function(x, y, min, max, length, decimals, label, var)
		local tw, th = surface.GetTextSize(label)
		local tx = (x + vars.menu_x) + 12
	
		x = (x + vars.menu_x) + 25 + tw
		y = (y + vars.menu_y) + 40
		
		local cx = math.Round(((vars[var] - min) * (((x + length) - x) / (max - min))) + x, decimals)
		
		draw.NoTexture()
		
		surface.SetDrawColor(colors.outline)
		surface.DrawLine(x, y + 7, x + length, y + 7)
		
		surface.SetDrawColor(colors.back_min)
		surface.DrawRect(cx - 6, y - 1, 12, 15)
		
		surface.SetFont("BudgetLabel")
		surface.SetTextColor(colors.white)
		
		surface.SetTextPos(tx, y)
		surface.DrawText(label)
		
		tw, th = surface.GetTextSize(tostring(vars[var]))
		local bw = tw + 15
		
		surface.SetDrawColor(colors.back_t)
		surface.DrawRect(x + length + 15, y - 1, bw, 17)
		
		surface.SetDrawColor(colors.outline)
		surface.DrawOutlinedRect(cx - 6, y - 1, 12, 15)
		surface.DrawOutlinedRect(x + length + 15, y - 1, bw, 17)
		
		surface.SetTextPos(x + length + 22, y)
		surface.DrawText(tostring(vars[var]))
		
		if canclick(cx - 6, y - 4, cx + 6, y + 11) then
			if not vars.menu_dragging then
				vars.menu_dragging = "Slider_" .. var
				
				vars.menu_dragging_ox = detours.gui_MouseX() - cx
				vars.menu_dragging_oy = detours.gui_MouseY() - (y - 4)
			end
		end
		
		if vars.menu_dragging == "Slider_" .. var then
			local nx = math.Round(math.Clamp(min + ((detours.gui_MouseX() - x) / (((x + length) - x) / (max - min))), min, max), decimals)
			
			if nx == -0 then -- Stupid
				nx = 0
			end
			
			vars[var] = nx
		end
	end,
	
	["AddDropdown"] = function(x, y, w, label, options, var) -- Label is unused
		x = (x + vars.menu_x) + 12
		y = (y + vars.menu_y) + 37 -- Dropdowns are a little off somehow
		
		surface.SetFont("BudgetLabel")
		
		local h = 20
		local optionh = 20 * #options
		
		render.SetScissorRect(x, y, x + w, y + h + optionh)
		
		if meta_pn.IsVisible(CPframe) then
			cache.drp_ignore = true
		end
		
		local isclick = input.IsMouseDown(MOUSE_LEFT)

		if not cache.drp_ignore then
			if isclick then
				if not mousein(x, y, x + w, y + h) then
					if vars.menu_activedropdown == var then
						if not mousein(x, y, x + w, y + h + optionh) then
							cache.drp_ignore = true
							
							vars.menu_mousedelay = true
							vars.menu_activedropdown = nil
						end
					end
				else
					vars.menu_mousedelay = true
					cache.drp_ignore = true
				
					if vars.menu_activedropdown == var then
						vars.menu_activedropdown = nil
					elseif not vars.menu_activedropdown then
						vars.menu_activedropdown = var
					end
				end
			end
		else
			if not isclick then
				cache.drp_ignore = false
			end
		end
		
		draw.NoTexture()
		
		surface.SetDrawColor(colors.back_t)
		surface.DrawRect(x, y, w - 20, h)
		
		surface.SetDrawColor(colors.back)
		surface.DrawRect((x + w) - 20, y, 20, h)
		
		surface.SetDrawColor(colors.outline)
		surface.DrawOutlinedRect(x, y, w, h)
		surface.DrawLine((x + w) - 20, y, (x + w) - 20, y + h)
		
		surface.SetTextColor(colors.white)
		surface.SetTextPos(x + 5, y + 3)
		
		local sel = vars[var]
		
		sel = string.upper(string.sub(sel, 1, 1)) .. string.sub(sel, 2)
		
		surface.DrawText(sel)
		
		if vars.menu_activedropdown == var then
			surface.DrawLine((x + w) - 15, y + (h / 2), (x + w) - 6, y + (h / 2))
		
			local optiony = y + 19
		
			surface.SetDrawColor(colors.back_t)
			surface.DrawRect(x, optiony, w, optionh)

			surface.SetDrawColor(colors.outline)

			local ofy = 0
			
			for k, v in ipairs(options) do
				local oy = (y + (20 * k)) - 1
			
				if mousein(x, oy, x + w, oy + h - 1) then
					local oc = getColor("accent")
					local bc = Color(oc.r, oc.g, oc.b, 100)
					
					surface.SetDrawColor(bc)
					
					surface.DrawRect(x, oy + 1, w, h - 1)
					
					surface.SetDrawColor(colors.outline)
				end
			
				surface.SetTextPos(x + 5, oy + 3)
				surface.DrawText(string.upper(string.sub(v, 1, 1)) .. string.sub(v, 2))
				
				if k ~= #options then
					surface.DrawLine(x, oy + h, x + w, oy + h)
				end
				
				if canclick(x, oy, x + w, oy + h) then
					vars[var] = v
					
					cache.drp_ignore = true
					vars.menu_activedropdown = nil
				end
			end
			
			surface.DrawOutlinedRect(x, optiony, w, optionh)
		else
			surface.DrawLine((x + w) - 11, y + 5, (x + w) - 11, y + (h - 4))
			surface.DrawLine((x + w) - 15, y + (h / 2), (x + w) - 6, y + (h / 2))
		end
	end,
	
	["AddColor"] = function(x, y, w, h, label, var)
		x = (x + vars.menu_x) + 12
		y = (y + vars.menu_y) + 40
		
		surface.SetFont("BudgetLabel")
		
		local tw, th = surface.GetTextSize(label)
		
		if w == -1 then
			local nw, nh = 60, 25
			
			if tw + 12 > nw then
				nw = nw + tw
			end
			
			w, h = nw, nh
		end
		
		if canclick(x, y, x + w, y + h) and not cache.drp_ignore then
			vars.menu_colorpicker_var = var
			invokeColorPicker(detours.gui_MouseX() + 4, detours.gui_MouseY() - 20)
		end
		
		draw.NoTexture()

		local step = 55 / h
		local grad = math.floor(55 / step) - 1
		local c = 55
		
		for i = 1, grad do
			c = c - step
			
			surface.SetDrawColor(c, c, c, 255)
			surface.DrawLine(x, y + i, x + w, y + i)
		end
		
		surface.SetTextPos(x + ((w / 2) - (tw / 2)), y + 2)
		surface.DrawText(label)
		
		if colors[var] == "RGB" then
			surface.SetDrawColor(colors.rainbow)
		elseif colors[var] == "HP" then
			local mod = math.sin(UnPredictedCurTime()) * 100
		
			surface.SetDrawColor(255 - (mod * 2.55), mod * 2.55, 0, 255)
		else
			surface.SetDrawColor(getColor(var))
		end
		
		surface.DrawRect(x + 5, y + (h - 7), w - 10, 2)
		
		surface.SetDrawColor(colors.outline)
		surface.DrawOutlinedRect(x, y, w, h)
	end,
	
	["AddButton"] = function(x, y, w, h, label, func)
		x = (x + vars.menu_x) + 12
		y = (y + vars.menu_y) + 40
		
		draw.NoTexture()
		
		local step = 55 / h
		local grad = math.floor(55 / step) - 1
		local c = 55
		
		for i = 1, grad do
			c = c - step
			
			surface.SetDrawColor(c, c, c, 255)
			surface.DrawLine(x, y + i, x + w, y + i)
		end
		
		if canclick(x, y, x + w, y + h) then
			func()
		end
		
		surface.SetFont("BudgetLabel")
		surface.SetTextColor(colors.white)
		
		local tw, th = surface.GetTextSize(label)
		
		surface.SetTextPos(x + ((w / 2) - (tw / 2)), y + ((h / 2) - (th / 2)))
		surface.DrawText(label)
		
		surface.SetDrawColor(colors.outline)
		surface.DrawOutlinedRect(x, y, w, h)
	end,
	
	["AddTextBox"] = function(x, y, w, h, label, var)
		x = (x + vars.menu_x) + 12
		y = (y + vars.menu_y) + 40
	
		draw.NoTexture()
		
		surface.SetFont("BudgetLabel")
		surface.SetTextColor(colors.white)
		
		local tw, th = surface.GetTextSize(label)
		local ty = y + math.abs((h / 2) - (th / 2))
		
		surface.SetTextPos(x, ty)
		surface.DrawText(label)
		
		local ox = x + tw + 2
		local isclick = input.IsMouseDown(MOUSE_LEFT)
		
		if not cache.txt_ignore then
			if isclick then
				if mousein(ox, y, ox + w, y + h) then
					if not vars.menu_typing then
						vars.menu_typing = var
					end
				else
					input.CheckKeyTrapping()
					
					vars.menu_typing = nil
				end
				
				cache.txt_ignore = true
			end
		else
			if not isclick then
				cache.txt_ignore = false
			end
		end
		
		if vars.menu_typing == var then
			if not input.IsKeyTrapping() then
				input.StartKeyTrapping()
			end
		end
		
		if input.IsKeyTrapping() then
			if vars.menu_typing == var then
				local new = input.CheckKeyTrapping() or -1
				
				if new == KEY_ESCAPE or new == KEY_ENTER then
					vars.menu_typing = nil
				else
					if new == KEY_BACKSPACE then
						vars[var] = string.sub(vars[var], 1, string.len(vars[var]) - 1)
					else
						local nadd = input.GetKeyName(new) or ""
					
						if new == KEY_SPACE then
							nadd = " "
						end
					
						if string.find(string.lower(nadd), "mouse") then
							if not mousein(ox, y, ox + w, y + h) then
								vars.menu_typing = nil
							end
						else
							if (new > 0 and new < 37) or new == KEY_SPACE or new == KEY_PERIOD then
								vars[var] = vars[var] .. nadd
							end
						end
					end
				end
			end
		end
		
		surface.SetDrawColor(colors.gray)
		surface.DrawRect(ox, y, w, h)
		
		render.SetScissorRect(ox, y, ox + w, y + h, true)
		
		surface.SetTextPos(ox + 2, ty)
		surface.DrawText(vars[var])
		
		if vars.menu_typing == var then
			tw, th = surface.GetTextSize(vars[var])
			
			surface.SetDrawColor(colors.outline)
			surface.DrawLine(ox + tw + 4, y + 2, ox + tw + 4, (y + h) - 2)
		end
	end,
	
	["AddSection"] = function(x, y, w, h, label)
		x = (x + vars.menu_x) + 12
		y = (y + vars.menu_y) + 40
		
		draw.NoTexture()

		surface.SetDrawColor(colors.outline)
		
		surface.DrawLine(x, y, x, y + h)
		surface.DrawLine(x, y + h, x + w, y + h)
		surface.DrawLine(x + w, y + h, x + w, y - 1)
		surface.DrawLine(x, y, x + 8, y)
		
		local tw, th = surface.GetTextSize(label)
		
		surface.DrawLine(x + 10 + tw, y, x + w, y)
		
		surface.SetTextPos(x + 10, y - 7)
		surface.DrawText(label)
	end,
	
	["DrawMenuBackground"] = function(x, y, w, h, style)
		if vars.renderpanic then
			return
		end
		
		local ismain = x == nil
		
		if ismain and vars.menu_fade then
			if not cache.menu_background_start or vars.menu ~= cache.menu_background_lerp_last then
				cache.menu_background_start = SysTime()
			end
			
			local lerptime = (SysTime() - cache.menu_background_start) / 0.3
			
			if vars.menu then
				cache.menu_background_step = Lerp(lerptime, 0, 255)
			else
				cache.menu_background_step = Lerp(lerptime, 255, 0)
			end
			
			cache.menu_background_step = math.Clamp(cache.menu_background_step, 0, 255)
			
			if not vars.menu and cache.menu_background_step == 0 then
				cache.menu_background_start = nil
			end
		end
		
		cache.menu_background_lerp_last = vars.menu
		
		if not vars.menu_background then -- DrawMenuBackground updates the fade so if there isn't any background just return
			return
		end
		
		x = x or 0
		y = y or 0
		w = w or ScrW()
		h = h or ScrH()
		
		style = style or "m"
		
		local dostyle = style == "m" and vars.menu_background_style or vars.menu_background_mini_style
		local bgcolor = style == "m" and copyColor(getColor("background")) or copyColor(getColor("background_mini"))
		
		if ismain and vars.menu_fade then
			bgcolor.a = math.Clamp((bgcolor.a + cache.menu_background_step) - 255, 0, 255)
		end
		
		surface.SetDrawColor(bgcolor)
		
		if dostyle == "blur" then
			render.SetScissorRect(x, y, x + w, y + h, true)
		
			surface.SetMaterial(materials.blur)
			
			local update = vars.menu_background_blur_updatetexture
			
			for i = 1, vars.menu_background_blur_scale do
				meta_im.SetFloat(materials.blur, "$blur", i)
				meta_im.Recompute(materials.blur)
			
				if update then
					render.UpdateScreenEffectTexture()
				end
				
				surface.DrawTexturedRect(0, 0, ScrW(), ScrH())
			end
			
			render.SetScissorRect(0, 0, 0, 0, false)
		else
			surface.DrawRect(x, y, w, h)
		end
	end,
}

local function drawMenu()
	if vars.renderpanic then
		return
	end

	local x, y, w, h = vars.menu_x, vars.menu_y, vars.menu_w, vars.menu_h
	local mx, my = detours.gui_MouseX(), detours.gui_MouseY()
	
	if x ~= nil and y ~= nil then
		if vars.menu_mousedown then
			if not vars.menu_mousedelay then
				if mousein(x, y, x + w, y + 20) then
					if not vars.menu_dragging then
						vars.menu_dragging = "main"
						
						vars.menu_dragging_ox = mx - x
						vars.menu_dragging_oy = my - y
					end
				end
			end
			
			if vars.menu_dragging == "main" then
				local nx = mx - vars.menu_dragging_ox
				local ny = my - vars.menu_dragging_oy
				
				if x ~= nx then
					vars.menu_x = nx
					x = nx
				end
				
				if y ~= ny then
					vars.menu_y = ny
					y = ny
				end
			end
		end
		
		draw.NoTexture()
		
		surface.SetAlphaMultiplier(cache.menu_background_step / 255)
		render.SetScissorRect(x, y, x + w, y + h, true)
		
		surface.SetDrawColor(colors.black)
		surface.DrawRect(x, y, w, h)
		
		local grad = 55
		
		for i = 1, grad do
			local c = grad - i
			
			surface.SetDrawColor(c, c, c, cache.menu_background_step)
			surface.DrawLine(x, y + i, x + w, y + i)
		end
		
		local lx, ty, rx, by = x + 12, y + 40, (x + w) - 12, (y + h) - 12
		local bty = (y + h) - 32
		local btya = (y + h) - 29
	
		surface.SetDrawColor(colors.back)
		surface.DrawRect(lx, ty, w - 24, h - 72)
		
		surface.SetDrawColor(colors.back_min)
		surface.DrawRect(lx, y + 20, w - 24, 20)
		surface.DrawRect(lx, (y + h) - 32, w - 24, 20)
		
		surface.SetDrawColor(colors.outline)
		surface.DrawOutlinedRect(x, y, w, h)
		surface.DrawLine(lx, bty, (x + w) - 10, bty)
		
		lx, ty = lx - 1, ty - 1
		
		surface.DrawLine(lx, ty, lx, by)
		surface.DrawLine(lx, by, rx, by)
		surface.DrawLine(rx, by, rx, ty - 20)
		
		surface.SetFont("BudgetLabel")
		surface.SetTextColor(colors.white)
		
		local starter = (ismeth and "Running with Meth" or "Running without Meth")
		local tw, th = surface.GetTextSize(starter)
		
		surface.DrawLine(lx + tw + 10, bty, lx + tw + 10, (y + h) - 10)
		
		surface.SetTextPos(lx + 5, btya)
		surface.DrawText(starter)
		
		if issafe then
			surface.SetTextPos(lx + tw + 15, btya)
			surface.DrawText("Safe Mode is enabled, detours won't work ")
		end
		
		tw, th = surface.GetTextSize(title)
		
		surface.SetTextPos(x + ((w / 2) - (tw / 2)), y + 3)
		surface.DrawText(title)
		
		for k, t in ipairs(menu_order) do -- Draw the menu items
			local tlwr = string.lower(t)
			
			swag.AddTab(t, tlwr, k - 1)
			
			if tlwr ~= vars.menu_tab then
				continue
			end
			
			if vars.menu_tab == "logs" then
				continue
			end
		
			for _, v in pairs(menu[t]) do
				if vars.renderpanic then
					return
				end
				
				local eltype = v[1]
				
				if eltype == "cb" then
					swag.AddCheckbox(v[2], v[3], v[4], v[5])
				elseif eltype == "sldr" then
					swag.AddSlider(v[2], v[3], v[4], v[5], v[6], v[7], v[8], v[9])
				elseif eltype == "sect" then
					swag.AddSection(v[2], v[3], v[4], v[5], v[6])
				elseif eltype == "drp" then
					swag.AddDropdown(v[2], v[3], v[4], v[5], v[6], v[7])
				elseif eltype == "btn" then
					swag.AddButton(v[2], v[3], v[4], v[5], v[6], v[7])
				elseif eltype == "txt" then
					swag.AddTextBox(v[2], v[3], v[4], v[5], v[6], v[7])
				elseif eltype == "clr" then
					swag.AddColor(v[2], v[3], v[4], v[5], v[6], v[7])
				end
				
				render.SetScissorRect(x, y, x + w, y + h, true) -- Restore the scrisor rect in case anything messed it up
			end
		end
	
		if vars.menu_tab ~= "logs" then
			for k, t in ipairs(menu_order) do -- Draw active dropdown last so it renders on top
				if string.lower(t) ~= vars.menu_tab then
					continue
				end
				
				local last = nil
				
				for _, v in pairs(menu[t]) do
					if v[1] ~= "drp" then
						continue
					else
						if vars.menu_activedropdown == v[7] then
							last = v
							
							break
						end
					end
				end
				
				if last then
					swag.AddDropdown(last[2], last[3], last[4], last[5], last[6], last[7])
					render.SetScissorRect(x, y, x + w, y + h, true) -- Restore the scrisor rect
					
					break
				end
			end
		end
		
		if vars.menu_tab == "logs" then
			local ox, oy = x + 12, y + 40
			local lw, lh = 525, 490
			
			render.SetScissorRect(ox + 25, oy + 25, ox + lw + 25, oy + lh + 25, true)

			surface.SetDrawColor(colors.back_t)
			surface.DrawRect(ox + 25, oy + 25, lw, lh)
			
			local rlog = table.Reverse(logs)
			
			for k, v in ipairs(rlog) do
				local o = k - 1
				local ty = (oy + lh) - (o * 15)
				
				if ty < oy then
					table.RemoveByValue(logs, v)
					continue
				end
			
				surface.SetTextPos(ox + 5, ty)
				surface.DrawText("    " .. v)
			end
			
			render.SetScissorRect(x, y, x + w, y + h, true)
		
			swag.AddSection(25, 25, lw, lh, "Logs")
			
			swag.AddSection(25, 525, 525, 90, "Settings")
			swag.AddCheckbox(35, 540, "Enable Logs", "logs")
			swag.AddCheckbox(60, 565, "Log Detours", "logs_detours")
			swag.AddCheckbox(60, 590, "Log Screengrabs", "logs_screengrabs")
			swag.AddCheckbox(200, 565, "Log Timestamps", "logs_timestamps")
			swag.AddCheckbox(200, 590, "Save to File", "logs_savetofile")
			
			surface.SetTextPos(ox + 375, oy + 535)
			surface.DrawText("Detours: " .. tostring(vars.logs_detours_count))
			
			surface.SetTextPos(ox + 375, oy + 550)
			surface.DrawText("Screengrabs: " .. tostring(vars.logs_screengrabs_count))
			
			surface.SetTextPos(ox + 375, oy + 565)
			surface.DrawText("Total: " .. tostring(vars.logs_detours_count + vars.logs_screengrabs_count))
			
			swag.AddButton(375, 581, 100, 20, "Clear Logs", function()
				table.Empty(logs)
				
				vars.logs_detours_count = 0
				vars.logs_screengrabs_count = 0
			end)
		end
		
		if meta_pn.IsVisible(CPframe) then
			meta_pn.PaintManual(CPframe)
		end
	end
	
	surface.SetAlphaMultiplier(1)
	render.SetScissorRect(0, 0, 0, 0, false)
	
	if not vars.menu_mousedown then
		if vars.menu_dragging ~= nil then
			vars.menu_dragging = nil
			
			vars.menu_dragging_ox = 0
			vars.menu_dragging_oy = 0
		end
		
		vars.menu_mousedelay = false
	else
		vars.menu_mousedelay = true
	end
	
	if vars.menu then
		if not detours.vgui_CursorVisible() then
			gui.EnableScreenClicker(true)
		end
	end
end

-- Derma Functions

CPframe.Think = function() end
CPframe.OnMousePressed = function() end

CPframe.Paint = function(self, w, h)
	if not vars.menu_colorpicker_var then
		meta_pn.SetVisible(self, false)
		meta_pn.SetEnabled(CPpickerBoxThing, false)
		
		return
	end
	
	local x, y = meta_pn.GetPos(self)

	if not cache.cp_ignore then
		if input.IsMouseDown(MOUSE_LEFT) then
			if not mousein(x, y + 24, x + w, y + h) then
				meta_pn.SetVisible(self, false)
				meta_pn.SetEnabled(CPpickerBoxThing, false)
				
				return
			else
				cache.cp_ignore = true
			end
		end
	else
		if not input.IsMouseDown(MOUSE_LEFT) then
			cache.cp_ignore = false
		end
	end
	
	local var = vars.menu_colorpicker_var
	local dohealth = var == "chams_color_player" or var == "chams_color_player_weapon" or var == "chams_color_viewmodel"

	draw.NoTexture()
	
	surface.SetDrawColor(colors.back)
	surface.DrawRect(0, 24, w, h - 24)
	
	surface.SetDrawColor(colors.back_t)
	surface.DrawRect(5, 149, 15, 15)
	
	if dohealth then
		surface.DrawRect(80, 149, 15, 15)
		
		if mousein(x + 80, y + 149, x + 95, y + 164) and input.IsMouseDown(MOUSE_LEFT) and not vars.menu_mousedelay then
			if colors[var] == "HP" then
				colors[var] = CPpicker.GetColor(CPpicker)
			else
				colors[var] = "HP"
			end
		
			vars.menu_mousedelay = true
		end
	end
	
	if mousein(x + 5, y + 149, x + 20, y + 164) and input.IsMouseDown(MOUSE_LEFT) and not vars.menu_mousedelay then
		if colors[var] == "RGB" then
			colors[var] = CPpicker.GetColor(CPpicker)
		else
			colors[var] = "RGB"
		end
		
		vars.menu_mousedelay = true
	end
	
	if colors[var] == "RGB" then
		surface.SetDrawColor(getColor("accent"))
		surface.DrawRect(7, 151, 11, 11)
	end
	
	surface.SetFont("BudgetLabel")
	surface.SetTextColor(colors.white)
	
	local tw, th = surface.GetTextSize("Rainbow")
	
	surface.SetTextPos(25, 149 + math.abs(7.5 - (th / 2)))
	surface.DrawText("Rainbow")
	
	surface.SetDrawColor(colors.outline)
	surface.DrawOutlinedRect(0, 24, w, h - 24)
	surface.DrawOutlinedRect(5, 149, 15, 15)
	
	if dohealth then
		surface.DrawOutlinedRect(80, 149, 15, 15)
		
		if colors[var] == "HP" then
			surface.SetDrawColor(getColor("accent"))
			surface.DrawRect(82, 151, 11, 11)
		end
		
		tw, th = surface.GetTextSize("Health Based")
		
		surface.SetTextPos(100, 149 + math.abs(7.5 - (th / 2)))
		surface.DrawText("Health Based")
	end
end

CPpicker.ValueChanged = function(self, new)
	if not vars.menu_colorpicker_var then
		return
	end
	
	if colors[vars.menu_colorpicker_var] ~= "RGB" and colors[vars.menu_colorpicker_var] ~= "HP" then
		colors[vars.menu_colorpicker_var] = new
	end
end	

CPpickerBoxThing.Paint = function(self, w, h)
	draw.NoTexture()
	
	surface.DrawCircle((w / 2), (h / 2), 5, 255, 255, 255, 255)
	surface.DrawCircle((w / 2), (h / 2), 4, 0, 0, 0, 255)
	surface.DrawCircle((w / 2), (h / 2), 6, 0, 0, 0, 255)
end

local function doSpectatorList()
	if vars.renderpanic then
		return
	end
	
	local x, y, w, h = vars.tools_detectors_spectatorlist_x, vars.tools_detectors_spectatorlist_y, vars.tools_detectors_spectatorlist_w, 20
	
	if vars.menu then
		if canclick(x, y, x + w, y + h, true) then
			if not vars.menu_dragging then
				vars.menu_dragging = "SpectatorList"
				
				vars.menu_dragging_ox = detours.gui_MouseX() - x
				vars.menu_dragging_oy = detours.gui_MouseY() - y
			end
		end
	end

	if vars.menu_dragging == "SpectatorList" then
		x = math.Clamp(detours.gui_MouseX() - vars.menu_dragging_ox, 0, ScrW() - w)
		y = math.Clamp(detours.gui_MouseY() - vars.menu_dragging_oy, 0, ScrH() - h)
		
		vars.tools_detectors_spectatorlist_x = x
		vars.tools_detectors_spectatorlist_y = y
	end
	
	if vars.menu_background_mini then
		local totalh = (#spectators + 1) * h

		swag.DrawMenuBackground(x, y, w, totalh, "mm")
	end
	
	draw.NoTexture()
	surface.SetFont("BudgetLabel")
	
	local ofs, aw, bw, cw = 1, w - (w / 8), w / 2, w - (w / 4)
	
	surface.SetDrawColor(getColor("back_min_head"))
	surface.DrawRect(x, y, w, h)
	
	surface.SetTextColor(colors.white)
	
	local tw, th = surface.GetTextSize("Spectator")
	
	surface.SetTextPos(x + (w - cw) - (tw / 2), y + 3)
	surface.DrawText("Spectator")
	
	tw, th = surface.GetTextSize("Target")
	
	surface.SetTextPos(x + (w - (cw / 2)) - (tw / 2), y + 3)
	surface.DrawText("Target")
	
	tw, th = surface.GetTextSize("OBS-Mode")
	
	surface.SetTextPos(x + aw - (tw / 2), y + 3)
	surface.DrawText("OBS-Mode")
	
	local doall = vars.tools_detectors_spectatorlist_showall
	
	for _, v in ipairs(spectators) do
		if vars.renderpanic then
			return
		end
		
		local y_ofs = y + (ofs * h)
		
		if y_ofs > ScrH() then
			break
		end
		
		local sname = shrinkText(v.name, bw)
		local tname = shrinkText(v.targ, w - cw)
		local smode = v.mode
		
		surface.SetDrawColor(colors.back_t_a)	
		
		if doall then
			if v.realtarg == LocalPlayer() then
				local targcolor = copyColor(getColor("accent"))
				targcolor.a = 75
			
				surface.SetDrawColor(targcolor)
			end
		end
		
		surface.DrawRect(x, y_ofs, w, h)
		
		tw, th = surface.GetTextSize(sname)
		
		surface.SetTextPos(x + (w - cw) - (tw / 2), y_ofs + 3)
		surface.DrawText(sname)
		
		tw, th = surface.GetTextSize(tname)
	
		surface.SetTextPos(x + (w - (cw / 2)) - (tw / 2), y_ofs + 3)
		surface.DrawText(tname)
		
		tw, th = surface.GetTextSize(smode)
	
		surface.SetTextPos(x + aw - (tw / 2), y_ofs + 3)
		surface.DrawText(smode)
		
		surface.SetDrawColor(colors.outline)
		surface.DrawLine(x, y_ofs, x + w, y_ofs)
		
		ofs = ofs + 1
	end
	
	surface.SetDrawColor(colors.outline)
	surface.DrawOutlinedRect(x, y, w, h + ((ofs - 1) * h))
	surface.DrawLine(x + bw, y, x + bw, y + (ofs * h))
	surface.DrawLine(x + cw, y, x + cw, y + (ofs * h))
end

local function doTraitorDetector()
	if vars.renderpanic then
		return
	end
	
	local x, y, w, h = vars.tools_detectors_traitordetector_x, vars.tools_detectors_traitordetector_y, vars.tools_detectors_traitordetector_w, 20
	local ofs, aw, bw = 1, w - (w / 3), w - (w / 6)
	
	if vars.tools_detectors_traitordetector_list then
		if vars.menu then
			if canclick(x, y, x + w, y + h, true) then
				if not vars.menu_dragging then
					vars.menu_dragging = "TraitorList"
					
					vars.menu_dragging_ox = detours.gui_MouseX() - x
					vars.menu_dragging_oy = detours.gui_MouseY() - y
				end
			end
		end
		
		if vars.menu_dragging == "TraitorList" then
			x = math.Clamp(detours.gui_MouseX() - vars.menu_dragging_ox, 0, ScrW() - w)
			y = math.Clamp(detours.gui_MouseY() - vars.menu_dragging_oy, 0, ScrH() - h)
			
			vars.tools_detectors_traitordetector_x = x
			vars.tools_detectors_traitordetector_y = y
		end
		
		if vars.menu_background_mini then
			local totalh = (#traitors + 1) * h
		
			swag.DrawMenuBackground(x, y, w, totalh, "mm")
		end
		
		draw.NoTexture()
		
		surface.SetFont("BudgetLabel")
		surface.SetTextColor(colors.white)
		
		surface.SetDrawColor(getColor("back_min_head"))
		surface.DrawRect(x, y, w, h)
		
		local tw, th = surface.GetTextSize("Player")
		
		surface.SetTextPos(x + (w - aw) - (tw / 2), y + 3)
		surface.DrawText("Player")
		
		tw, th = surface.GetTextSize("Role")
		
		surface.SetTextPos(x + bw - (tw / 2), y + 3)
		surface.DrawText("Role")
	end
	
	if engine.ActiveGamemode() ~= "terrortown" then
		if vars.tools_detectors_traitordetector_list then
			surface.SetDrawColor(colors.outline)
			
			surface.DrawOutlinedRect(x, y, w, h + ((ofs - 1) * h))
			surface.DrawLine(x + aw, y, x + aw, y + (ofs * h))
		end
		
		return
	end
	
	for _, v in ipairs(traitors) do
		if vars.renderpanic then
			return
		end
		
		local ply = v[1]
		
		if not meta_en.IsValid(ply) then
			continue
		end
		
		local cached = table.HasValue(cache.traitors, ply)
		
		if vars.tools_detectors_traitordetector_list then
			local y_ofs = y + (ofs * h)
			
			if y_ofs < ScrH() then
				local mode = v[2]
				local role = "Unknown"
				
				if not cached then
					if mode == -1 then
						if meta_pl.IsTraitor and meta_pl.IsTraitor(LocalPlayer()) then
							role = "Innocent"
							surface.SetDrawColor(colors.green_a)
						else
							surface.SetDrawColor(colors.back_t_a)
						end
					elseif mode == 1 then
						role = "Detective"
						surface.SetDrawColor(colors.blue_a)
					elseif mode == 2 then
						role = "Traitor"
						surface.SetDrawColor(colors.red_a)
					end
				else
					role = "Traitor"
					surface.SetDrawColor(colors.red_a)
				end
				
				surface.DrawRect(x, y_ofs, w, h)
				
				role = shrinkText(role, w - aw)
				local name = shrinkText(meta_pl.GetName(ply), aw)
				
				tw, th = surface.GetTextSize(name)
				
				surface.SetTextPos(x + (w - aw) - (tw / 2), y_ofs + 3)
				surface.DrawText(name)
				
				tw, th = surface.GetTextSize(role)
				
				surface.SetTextPos(x + bw - (tw / 2), y_ofs + 3)
				surface.DrawText(role)
				
				surface.SetDrawColor(colors.outline)
				surface.DrawLine(x, y_ofs, x + w, y_ofs)
			end
		end
		
		ofs = ofs + 1
		
		if (meta_pl.IsTraitor and meta_pl.IsTraitor(LocalPlayer())) or not validEntity(ply) then
			continue
		end
		
		if vars.tools_detectors_traitordetector_icon and cached then
			local dir = meta_en.GetForward(LocalPlayer()) * -1
			local rpos = meta_en.LocalToWorld(ply, (meta_en.OBBCenter(ply) * 2) + Vector(0, 0, 2))
		
			cam.Start3D()
				render.SetMaterial(materials.traitor)
				
				render.DrawQuadEasy(rpos, dir, 8, 8, Color(255, 255, 255, 130), 180)
			cam.End3D()
		end
	end
	
	if vars.tools_detectors_traitordetector_list then
		surface.SetDrawColor(colors.outline)
		surface.DrawOutlinedRect(x, y, w, h + ((ofs - 1) * h))
		surface.DrawLine(x + aw, y, x + aw, y + (ofs * h))
	end
end

local function doHUDPaint()
	if vars.renderpanic then
		return
	end
	
	vars.menu_mousedown = input.IsMouseDown(MOUSE_LEFT)

	draw.NoTexture()
	
	if canrender(METHFLAG_NONE) then
		if vars.traces_breadcrumbs then
			while #breadcrumbs > vars.traces_breadcrumbs_length do
				table.remove(breadcrumbs, 1)
			end
		
			cam.Start3D()
				render.SuppressEngineLighting(true)
				
				if vars.traces_breadcrumbs_usebeam then
					render.SetMaterial(materials.beam)
				end
			
				for i = 1, #breadcrumbs do
					if vars.renderpanic then
						render.SuppressEngineLighting(false)
					
						cam.End3D()
						return
					end
					
					if #breadcrumbs > i + 1 then
						if vars.traces_breadcrumbs_usebeam then
							render.DrawBeam(breadcrumbs[i], breadcrumbs[i + 1], 8, 1, 1, getColor("beam"))
						else
							render.DrawLine(breadcrumbs[i], breadcrumbs[i + 1], getColor("traces_breadcrumbs"), false)
						end
					end
				end
				
				render.SuppressEngineLighting(false)
			cam.End3D()
			
			cache.traces_breadcrumbs_empty = false
		else
			if not cache.traces_breadcrumbs_empty then
				table.Empty(breadcrumbs)
				cache.traces_breadcrumbs_empty = true
			end
		end
	
		if vars.traces_btr then
			if vars.traces_btr_local or vars.traces_btr_other then
				cam.Start3D()
					render.SuppressEngineLighting(true)
				
					render.SetMaterial(materials.beam)
				
					local maxtime = UnPredictedCurTime() - vars.traces_btr_life
					
					for i = #bullets, 1, -1 do
						local v = bullets[i]
						
						if vars.renderpanic then
							render.SuppressEngineLighting(false)
						
							cam.End3D()
							return
						end
						
						if v.timestamp < maxtime then
							table.remove(bullets, i)
							
							continue
						end
						
						if not isVisible(v.src) and not isVisible(v.endpos) then
							continue
						end
						
						render.DrawBeam(v.src, v.endpos, 8, 1, 1, getColor("beam"))	
					end
					
					render.SuppressEngineLighting(false)
				cam.End3D()

				cache.traces_btr_empty = false
			end
		else
			if not cache.traces_btr_empty then
				table.Empty(bullets)
				cache.traces_btr_empty = true
			end
		end
	
		if vars.chams_player then
			local blend = render.GetBlend()
		
			cam.Start3D()
				for _, v in ipairs(player.GetAll()) do
					if vars.renderpanic then
						render.SetBlend(blend)
						
						cam.End3D()
						return
					end
				
					if not isVisible(v) or v == LocalPlayer() then -- IsVisible function has an isvalid check
						continue
					end
					
					local friend = false
					local aimbottarg = false
					
					render.MaterialOverride(getChamsMat("PLAYER"))
					
					if ismeth then
						if vars.meth_render_chams_highlight then
							if vars.meth_render_chams_highlight_friends then
								if mutil.IsFriend(meta_en.EntIndex(v)) then
									friend = true
								end
							end
							
							if vars.meth_render_chams_highlight_aimbot then
								if getMethAimbotTarget() == v then
									aimbottarg = true
								end
							end
						end
					end
					
					local color = (friend and colors.meth_highlight_friends) or (aimbottarg and colors.meth_highlight_aimbot) or getColor("chams_color_player", v)
					
					if colors.chams_color_player == "HP" then
						updateGlowColor(materials.glow_player, color)
					end
					
					render.SetColorModulation(color.r / 255, color.g / 255, color.b / 255)
					
					if friend then
						render.MaterialOverride(getChamsMat("HIGHLIGHT_P_F"))
					elseif aimbottarg then
						render.MaterialOverride(getChamsMat("HIGHLIGHT_P_A"))
					else
						render.MaterialOverride(getChamsMat("PLAYER"))
					end
					
					render.SetBlend(color.a / 255)
					
					meta_en.DrawModel(v)
					
					if vars.chams_player_weapon then
						local wep = meta_pl.GetActiveWeapon(v)
						
						if validEntity(wep) then
							render.MaterialOverride(getChamsMat("WEAPON"))
						
							if not friend and not aimbottarg then
								color = getColor("chams_color_player_weapon", v)
								
								if colors.chams_color_player_weapon == "HP" then
									updateGlowColor(materials.glow_player_weapon, color)
								end
								
								render.SetBlend(color.a / 255)
								render.SetColorModulation(color.r / 255, color.g / 255, color.b / 255)
							else
								if friend then
									render.MaterialOverride(getChamsMat("HIGHLIGHT_W_F"))
								else
									render.MaterialOverride(getChamsMat("HIGHLIGHT_W_A"))
								end
							end
							
							meta_en.DrawModel(wep)
						end
					end
					
					render.MaterialOverride(nil)
					render.SetColorModulation(1, 1, 1)
				end
				
				render.SetBlend(blend)
			cam.End3D()
		end
		
		if vars.traces_shotrecord then
			local killcolor = getColor("traces_shotrecord_kill")
			local hitcolor = getColor("traces_shotrecord_hit")
			
			local killcolor_noa = copyColor(getColor("traces_shotrecord_kill"))
			killcolor_noa.a = 255
			
			local hitcolor_noa = copyColor(getColor("traces_shotrecord_hit"))
			hitcolor_noa.a = 255
		
			local maxtime = UnPredictedCurTime() - vars.traces_shotrecord_life

			cam.Start3D()
				for i = #hits, 1, -1 do
					local g = hits[i]
					
					if g.timestamp < maxtime then
						table.remove(hits, i)
						
						continue
					end
					
					for _, v in ipairs(g.data) do
						if vars.renderpanic then
							cam.End3D()
							
							return
						end
						
						render.SetMaterial(v.ovr and materials.boxmat_kill or materials.boxmat_hit)
						
						render.DrawWireframeBox(v.pos, v.ang, v.mins, v.maxs, v.ovr and killcolor or hitcolor)
						render.DrawBox(v.pos, v.ang, v.mins, v.maxs, v.ovr and killcolor or hitcolor)
					end
				end
			cam.End3D()
			
			cache.traces_shotrecord_empty = false
		else
			if not cache.traces_shotrecord_empty then
				table.Empty(hits)
				cache.traces_shotrecord_empty = true
			end
		end
		
		if vars.tools_movement_blockbot then
			if cache.blockbot_active then
				if validEntity(cache.blockbot_targ) then
					local tent = cache.blockbot_targ
					
					surface.SetFont("BudgetLabel")
					surface.SetTextColor(255, 255, 255, 255)
					
					local tpos = meta_vc.ToScreen(meta_en.LocalToWorld(tent, meta_en.OBBCenter(tent)))
					
					surface.SetTextPos(tpos.x, tpos.y)
					surface.DrawText("X")
				end
			end
		end
	end
end

--[[
	Hooks
]]

if ismeth then
	hook.Add("PreRender", vars.hookname, function()
		render.PopCustomClipPlane() -- Prevent clip planes stacking
	end)
	
	hook.Add("ShutDown", vars.hookname, function()
		render.PopCustomClipPlane() -- Prevent clip planes from persistening through a retry/server restart/etc
	end)

	if mcall then
		mcall.Add("OnHUDPaint", vars.hookname, function()
			-- Fixes rendering with SetRenderTarget
		
			if vars.rendercall then
				return
			end
			
			vars.rendercall = true
			
			local ogrt = render.GetRenderTarget()
			render.SetRenderTarget()
		
			vars.renderpanic = false -- Reset renderpanic

			-- Actual stuff

			local canrendernone = canrender(METHFLAG_NONE)
			
			if canrendernone then
				if vars.view_screengrab_test then
					local fov = cache.calcview_fov_custom
					
					if vars.view_fov_changer then
						if vars.view_fov_override then
							fov = vars.view_fov_set - 1
						else
							fov = fov + (vars.view_fov_set - meta_cv.GetInt(GetConVar("fov_desired")))
						end
					end
					
					fov = math.Clamp(fov + 15.72, 2, 179)
					
					render.RenderView({
						origin = meta_en.EyePos(LocalPlayer()),
						angles = meta_en.EyeAngles(LocalPlayer()),
						x = 0,
						y = 0,
						w = ScrW(),
						h = ScrH(),
						drawhud = true,
						drawviewmodel = false,
						dopostprocess = vars.view_screengrab_test_pp,
						bloomtone = vars.view_screengrab_test_pp,
						fov = fov
					})
				end
			end
		
			doHUDPaint()

			if canrendernone then
				if mvar then
					if vars.meth_render_freecambox then
						if mvar.GetVarInt("Player.Free Cam.Free Cam") == 1 then
							cam.Start3D()
								render.SetMaterial(materials.boxmat_freecam)
								
								local hitboxes = getEntityHitboxes(LocalPlayer())
							
								if #hitboxes > 0 then
									for _, v in ipairs(hitboxes) do
										render.DrawWireframeBox(v.pos, v.ang, v.mins, v.maxs, getColor("meth_freecambox"))
										render.DrawBox(v.pos, v.ang, v.mins, v.maxs, getColor("meth_freecambox"))
									end
								end
							cam.End3D()
						end
					end
				
					if vars.meth_render_backtrack then
						if mvar.GetVarInt("Aimbot.Position Adjustment.Enabled") == 1 then
							local btarg = nil
							vars.meth_render_backtrack_target = nil
							
							local bdis = math.huge
							local mx, my = ScrW() / 2, ScrH() / 2
							local lpos = meta_en.GetPos(LocalPlayer())
							
							for _, v in ipairs(player.GetAll()) do -- Get the best backtrack target base off cursor and distance
								if not validEntity(v) or v == LocalPlayer() then
									continue
								end
								
								local vpos = meta_en.LocalToWorld(v, meta_en.OBBCenter(v))
								local spos = meta_vc.ToScreen(vpos)
								
								local cdis = math.Dist(spos.x, spos.y, mx, my)
								
								if cdis < bdis then
									bdis = cdis
									btarg = v
								end
							end
							
							if validEntity(btarg) then
								vars.meth_render_backtrack_target = btarg
							end

							local flamount = (mvar_o.GetVarInt("Aimbot.Position Adjustment.Fake Latency") or meta_pl.Ping(LocalPlayer())) / 1000 -- Get fake latency setting in seconds
							local ctime = UnPredictedCurTime()
							
							cam.Start3D()
								render.SetMaterial(materials.boxmat_backtrack)

								for i = #backtrack, 1, -1 do
									local v = backtrack[i]
									
									if ctime - v.timestamp < flamount - 0.25 then
										continue
									end
									
									if ctime - v.timestamp > flamount then
										table.remove(backtrack, i)
										
										continue
									end
									
									for _, h in ipairs(v.data) do
										render.DrawWireframeBox(h.pos, h.ang, h.mins, h.maxs, getColor("meth_backtrackhitbox"))
										render.DrawBox(h.pos, h.ang, h.mins, h.maxs, getColor("meth_backtrackhitbox"))
									end
								end
							cam.End3D()
						end
					end
				end
			
				if (canrender(METHFLAG_NOTHIRDPERSON) and canrender(METHFLAG_NOFREECAM)) and not meta_pl.ShouldDrawLocalPlayer(LocalPlayer()) then
					if (vars.chams_viewmodel or vars.view_screengrab_test) and validEntity(LocalPlayer()) then
						local VM = meta_pl.GetViewModel(LocalPlayer())
						
						if validEntity(VM) then
							local VMFOV = 0
			
							if not vars.view_fov_viewmodel_changer then
								local VMFOV_BASE = meta_pl.GetActiveWeapon(LocalPlayer()).ViewModelFOV or meta_cv.GetInt(GetConVar("viewmodel_fov")) or 54
								
								local plyfov = cache.calcview_fov_custom
								
								if vars.view_screengrab_test then
									if vars.view_fov_changer then
										if vars.view_fov_override then
											plyfov = vars.view_fov_set - 1
										else
											plyfov = cache.calcview_fov_custom + (vars.view_fov_set - meta_cv.GetInt(GetConVar("fov_desired")))
										end
									end
								end
								
								local retardedofs = (plyfov + 1) / 100
								
								VMFOV = VMFOV_BASE + (((plyfov + 1) - VMFOV_BASE) - ((0 - VMFOV_BASE) + 83)) - (retardedofs + (retardedofs % 1) + 0.15) -- Stupid ass math to get the viewmodel fov (probably overcomplicated)
							else
								VMFOV = vars.view_fov_viewmodel_set + 15.75
							end

							local EYEANGLES = meta_en.EyeAngles(LocalPlayer())
							local EYEPOS = cache.calcview_eyepos or EyePos() * 1
							
							if vars.view_viewmodel_offset_changer then
								local VMOFFSET = Vector(0 - vars.view_viewmodel_offset_x, 0 - vars.view_viewmodel_offset_y, 0 - vars.view_viewmodel_offset_z)
								
								local right, up, forward = meta_an.Right(EYEANGLES), meta_an.Up(EYEANGLES), meta_an.Forward(EYEANGLES)
				
								EYEPOS = EYEPOS + VMOFFSET.x * right
								EYEPOS = EYEPOS + VMOFFSET.y * forward
								EYEPOS = EYEPOS + VMOFFSET.z * up -- Fix offsets
							end
							
							local ogc = meta_en.GetColor(VM) or copyColor(colors.white)
							local ogrm = meta_en.GetRenderMode(VM) or 0
							
							cam.Start3D(EYEPOS, EYEANGLES, VMFOV, 0, 0, ScrW(), ScrH(), 1, 30000)
								cam.IgnoreZ(true)
							
								if canrender(METHFLAG_ESPONLY) then
									local vmc = getColor("chams_color_viewmodel", LocalPlayer())
									
									if colors.chams_color_viewmodel == "HP" then
										updateGlowColor(materials.glow_viewmodel, vmc)
									end
								
									meta_en.SetColor(VM, vmc) -- You have to set the color of viewmodels
									meta_en.SetRenderMode(VM, RENDERMODE_TRANSCOLOR) -- Change rendermode to prevent issues with color change
									
									render.SetColorModulation(vmc.r / 255, vmc.g / 255, vmc.b / 255) -- This doesn't do much but why not
									render.MaterialOverride(getChamsMat("VM"))
								end
								
								meta_en.DrawModel(VM)
								
								meta_en.SetColor(VM, ogc) -- Restore original viewmodel color
								meta_en.SetRenderMode(VM, ogrm) -- Restore original viewmodel rendermode
								
								render.MaterialOverride(nil)
								render.SetColorModulation(1, 1, 1)
								
								cam.IgnoreZ(false)
							cam.End3D()
						end
					end
				end
			
				if mvar then
					if vars.meth_render_catpng then
						if not meta_im.IsError(materials.catpng) then
							local fov = mvar.GetVarInt("Aimbot.Target.FoV")
							
							if fov > 0 and fov < 57 then
								local retardednumber = 2.59
								
								if meta_pl.ShouldDrawLocalPlayer(LocalPlayer()) then
									if vars.meth_render_fovcircle then
										local add = (meta_vc.Distance(cache.calcview_eyepos, meta_en.GetPos(LocalPlayer())))
							
										if mvar.GetVarInt("Player.Third Person.Third Person") == 1 then
											add = mvar.GetVarInt("Player.Third Person.Third Person Distance") - 1
										end
										
										retardednumber = retardednumber + ((add / 100) * 1.5) + 1 -- Make the fov circle change based off camera position relative to LocalPlayer's EyePos
									else
										if mvar.GetVarInt("Player.Third Person.Third Person") == 1 then
											retardednumber = 3.49
										end
									end
								end

								local rad = (math.tan(math.rad(fov)) / math.tan(math.rad(cache.calcview_fov_custom / 2)) * ScrW()) / retardednumber
								local size = (rad * 1.955) + retardednumber
								
								surface.SetDrawColor(getColor("meth_catpng"))
								surface.SetMaterial(materials.catpng)
								
								surface.DrawTexturedRectRotated((ScrW() / 2), (ScrH() / 2), size, size, vars.meth_render_catpng_spin and vars.meth_render_catpng_spin_cur or 0)
								
								if vars.meth_render_catpng_spin  then
									vars.meth_render_catpng_spin_cur = (vars.meth_render_catpng_spin_cur - vars.meth_render_catpng_spin_amount) % 360
									
									if cache.meth_catpng_reset then
										cache.meth_catpng_reset = false
									end
								else
									if not cache.meth_catpng_reset then
										vars.meth_render_catpng_spin_cur = 0
										cache.meth_catpng_reset = true
									end
								end
							end
						end
					end
					
					if vars.meth_render_fovcircle then
						if cache.meth_fovcircle_reset then
							local ogcros = mvar_o.GetVarInt("Player.Misc Players.Crosshair") -- WTF WOLFIE
							local ogtarg = mvar_o.GetVarInt("Player.Misc Players.Target Text")
						
							mvar.SetVarInt("Player.Misc Players.FOV Circle", 0)
							
							mvar.SetVarInt("Player.Misc Players.Crosshair", ogcros) -- WTF DID YOU DO
							mvar.SetVarInt("Player.Misc Players.Target Text", ogtarg)
						end
					
						local fov = mvar.GetVarInt("Aimbot.Target.FoV")
						
						if fov > 0 and fov < 57 then
							local fovcol = mvar.GetVarColor("Player.Misc Players.FOV Circle_Color")
							
							if colors.meth_fovcircle == "RGB" then
								fovcol = colors.rainbow
							end
							
							local retardednumber = 2.63
							
							if meta_pl.ShouldDrawLocalPlayer(LocalPlayer()) then
								local add = (meta_vc.Distance(cache.calcview_eyepos, meta_en.GetPos(LocalPlayer())))
								
								if mvar.GetVarInt("Player.Third Person.Third Person") == 1 then
									add = mvar.GetVarInt("Player.Third Person.Third Person Distance") - 1
								end
								
								retardednumber = retardednumber + ((add / 100) * 1.5) + 1
							end
							
							local rad = (math.tan(math.rad(fov)) / math.tan(math.rad(cache.calcview_fov_custom / 2)) * ScrW()) / retardednumber
							
							local x, y = ScrW() / 2, ScrH() / 2
							
							surface.DrawCircle(x, y, rad, fovcol.r, fovcol.g, fovcol.b, fovcol.a)
							
							if vars.meth_render_fovcircle_outline then
								surface.DrawCircle(x, y, rad - 1, 0, 0, 0, fovcol.a)
								surface.DrawCircle(x, y, rad + 1, 0, 0, 0, fovcol.a)
							end
						end
						
						cache.meth_fovcircle_reset = false
					else
						if not cache.meth_fovcircle_reset then
							if not cache.meth_fovcircle_og then
								cache.meth_fovcircle_og = mvar_o.GetVarInt("Player.Misc Players.FOV Circle")
							else
								local ogcros = mvar_o.GetVarInt("Player.Misc Players.Crosshair") -- WTF WOLFIE
								local ogtarg = mvar_o.GetVarInt("Player.Misc Players.Target Text")
							
								mvar.SetVarInt("Player.Misc Players.FOV Circle", cache.meth_fovcircle_og)
								
								mvar.SetVarInt("Player.Misc Players.Crosshair", ogcros) -- WTF DID YOU DO
								mvar.SetVarInt("Player.Misc Players.Target Text", ogtarg)
							end
							
							cache.meth_fovcircle_reset = true
						end
					end
				end
				
				if vars.meth_render_watermark then
					if not meta_im.IsError(materials.methlogo) then
						surface.SetFont("BudgetLabel")
					
						surface.SetDrawColor(colors.white)
						surface.SetMaterial(materials.methlogo)
						
						local x = 70
						
						surface.DrawTexturedRect(10, 10, x, x)
						
						surface.SetDrawColor(colors.outline)
						surface.DrawOutlinedRect(10, 10, x, x)
						
						surface.SetTextColor(getColor("meth_watermark"))
						
						surface.SetTextPos(x + 20, 15) -- This
						surface.DrawText("methamphetamine.solutions")
						
						surface.SetTextPos(x + 20, 30) -- Is
						surface.DrawText("Garry's Mod Hack")
						
						surface.SetTextPos(x + 20, 45) -- Fucking
						surface.DrawText("V3")
						
						surface.SetTextPos(x + 20, 60) -- Stupid
						
						local username = mutil.GetUsername() or meta_pl.GetName(LocalPlayer())
						
						surface.DrawText("Welcome back, addict " ..  username)
					end
				end
			end
			
			if vars.meth_render_redrawhud and not vars.view_screengrab_test then
				hook.Run("HUDPaint", true)
			end
			
			-- Render menu above everything
			
			if (vars.menu and vars.menu_background) or (vars.menu_fade and (cache.menu_background_step > 0 or vars.menu)) then
				swag.DrawMenuBackground()
			end
			
			if vars.tools_detectors_spectatorlist then
				doSpectatorList()
			end
			
			if vars.tools_detectors_traitordetector then
				doTraitorDetector()
			end
			
			if vars.meth_tools_binds then
				draw.NoTexture()
				surface.SetFont("BudgetLabel")
				surface.SetTextColor(colors.white)
			
				local binds = getBinds()
			
				local x, y = vars.meth_tools_binds_x, vars.meth_tools_binds_y
				local w, h = vars.meth_tools_binds_w, 47 + (15 * #binds)
				local tw, th
				
				for _, v in ipairs(binds) do -- Size the menu depending on the text size
					tw, th = surface.GetTextSize(v.key)
					
					if 190 + tw > w then
						w = 190 + tw
					end
				end

				if vars.menu then
					if canclick(x, y, x + w, y + 20) then
						if not vars.menu_dragging then
							vars.menu_dragging = "BindList"
							
							vars.menu_dragging_ox = detours.gui_MouseX() - x
							vars.menu_dragging_oy = detours.gui_MouseY() - y
						end
					end
				end
				
				if vars.menu_dragging == "BindList" then
					x = math.Clamp(detours.gui_MouseX() - vars.menu_dragging_ox, 0, ScrW() - w)
					y = math.Clamp(detours.gui_MouseY() - vars.menu_dragging_oy, 0, ScrH() - h)
					
					vars.meth_tools_binds_x = x
					vars.meth_tools_binds_y = y
				end

				surface.SetDrawColor(colors.black)
				surface.DrawRect(x, y, w, h)
				
				local grad = 55
		
				for i = 1, grad do
					local c = grad - i
					
					surface.SetDrawColor(c, c, c, 255)
					surface.DrawLine(x, y + i, x + w, y + i)
				end
				
				tw, th = surface.GetTextSize("Binds")
				
				surface.SetTextPos(x + ((w / 2) - (tw / 2)), y + 3)
				surface.DrawText("Binds")
				
				surface.SetDrawColor(colors.back)
				surface.DrawRect(x + 10, y + 20, w - 20, h - 30)
				
				for k, v in ipairs(binds) do
					local ofy = (y + 32) + (15 * (k - 1))
					
					if v.status then
						surface.SetTextColor(colors.white)
					else
						surface.SetTextColor(colors.gray)
					end
					
					surface.SetTextPos(x + 75, ofy)
					surface.DrawText(v.name)
					
					if v.status then
						surface.SetTextColor(getColor("accent"))
					else
						surface.SetTextColor(colors.gray)
					end
					
					surface.SetTextPos(x + 20, ofy)
					surface.DrawText(v.type)
		
					surface.SetTextPos(x + 180, ofy)
					surface.DrawText(v.key)
				end
				
				surface.SetDrawColor(colors.outline)
				surface.DrawOutlinedRect(x + 10, y + 20, w - 20, h - 30)
				surface.DrawOutlinedRect(x, y, w, h)
				
				surface.SetDrawColor(getColor("accent"))
				surface.DrawLine(x + 10, y + 20, (x + w) - 10, y + 20)
				surface.DrawLine(x + 10, y + 21, (x + w) - 10, y + 21)
			end
			
			if vars.menu or (vars.menu_fade and cache.menu_background_step > 0) then
				drawMenu()
			end
			
			render.SetRenderTarget(ogrt)
			vars.rendercall = false
		end)
	end
end

hook.Add("HUDPaint", vars.hookname, function(ignoreUpdate)
	if not ismeth then
		doHUDPaint()
	else
		if not ignoreUpdate then
			vars.renderpanic = true
		end
	end
end)

if not ismeth then
	hook.Add("DrawOverlay", vars.hookname, function()
		if (vars.menu and vars.menu_background) or (vars.menu_fade and (cache.menu_background_step > 0 or vars.menu)) then
			swag.DrawMenuBackground()
		end
		
		if vars.tools_detectors_spectatorlist then
			doSpectatorList()
		end
		
		if vars.tools_detectors_traitordetector then
			doTraitorDetector()
		end
		
		if vars.menu or (vars.menu_fade and cache.menu_background_step > 0) then
			drawMenu()
		else
			vars.menu_dragging = nil
			vars.menu_mousedelay = false
		end
	end)
end

hook.Add("PreDrawHUD", vars.hookname, function() -- Antiblind
	render.SetLightingMode(0)

	if vars.view_antiblind then
		hook.Remove("HUDPaint", "ulx_blind")
		hook.Remove("HUDPaint", "Blind")
		hook.Remove("HUDPaintBackground", "ulx_blind")
		hook.Remove("RenderScreenspaceEffects", "CSGOSmokeBlind")
		hook.Remove("RenderScreenspaceEffects", "TFA_CSGO_FLASHBANG")
		hook.Remove("RenderScreenspaceEffects", "TFA_CSO2_FLASHBANG")
		hook.Remove("RenderScreenspaceEffects", "CW20_RenderScreenspaceEffects")
	end
end)

hook.Add("HUDShouldDraw", vars.hookname, function(name)
	if not vars.world_gmodhud then
		if name == "CHudDamageIndicator" or name == "CHudZoom" or name == "CHudGMod" then
			return false
		end
	end
end)

hook.Add("CreateMove", vars.hookname, function(cmd)
	-- Use Spammer
	
	if vars.tools_misc_usespam then
		if input.IsKeyDown(input.GetKeyCode(input.LookupBinding("+use"))) then
			if cache.usespam_tick > 0 then -- Slow it down because it was WAY too fast
				meta_cd.SetButtons(cmd, bit.band(meta_cd.GetButtons(cmd), bit.bnot(IN_USE)))
				cache.usespam_tick = 0
			else
				cache.usespam_tick = cache.usespam_tick + 1
			end
		else
			cache.usespam_tick = 0
		end
	end
	
	-- Flashlight Spammer
	
	if vars.tools_misc_flashlightspam then
		local key = input.LookupBinding("impulse 100")
		
		if key then
			if not vars.menu and not detours.vgui_CursorVisible() and not gui.IsConsoleVisible() and not gui.IsGameUIVisible() and not meta_pl.IsTyping(LocalPlayer()) and not vgui.GetKeyboardFocus() then
				if input.IsKeyDown(input.GetKeyCode(key)) then
					meta_cd.SetImpulse(cmd, 100)
				end
			end
		end
	end

	local moving = isMoving(cmd)

	-- Breadcrumbs
	
	if vars.traces_breadcrumbs then	
		local lpos = meta_en.GetPos(LocalPlayer())
	
		if cache.traces_breadcrumbs_last ~= nil then
			if meta_vc.DistToSqr(cache.traces_breadcrumbs_last, lpos) >= 50 then
				breadcrumbs[#breadcrumbs + 1] = lpos
				cache.traces_breadcrumbs_last = lpos
			end
		else
			cache.traces_breadcrumbs_last = lpos
		end
		
		cache.traces_breadcrumbs_empty = false
	end

	if validMoveType() then
		local grounded = meta_en.OnGround(LocalPlayer())
	
		-- Anti push

		if vars.tools_movement_antipush then -- Basically "Walk towards point on map"
			if not cache.tools_movement_antipush_pos and not moving and validEntity(LocalPlayer()) and grounded then
				cache.tools_movement_antipush_pos = meta_en.GetPos(LocalPlayer())
			elseif moving or not grounded then
				cache.tools_movement_antipush_pos = nil
			end
			
			if not moving and validEntity(LocalPlayer()) and cache.tools_movement_antipush_pos ~= nil and grounded then
				local lpos = meta_en.GetPos(LocalPlayer())
				local lang = meta_cd.GetViewAngles(cmd) or cache.calcview_eyeangles
				local dir = cache.tools_movement_antipush_pos - lpos
				
				local movementAngle = meta_vc.Angle(Vector(dir.x, dir.y, dir.z))
				local movementYaw = math.rad(movementAngle.yaw - lang.yaw)
				
				local dist = meta_vc.DistToSqr(lpos, cache.tools_movement_antipush_pos)
				
				if dist > 4 then
					local maxSpeed = meta_pl.GetRunSpeed(LocalPlayer()) * 1000
					
					meta_cd.SetForwardMove(cmd, (math.cos(movementYaw) * maxSpeed) /dist)
					meta_cd.SetSideMove(cmd, ((0 - math.sin(movementYaw)) * maxSpeed) / dist)
				end
			end
		end
	
		-- Fast stop

		if vars.tools_movement_faststop then
			if not moving and grounded then
				if vars.tools_movement_faststop then
					local vel = meta_en.GetVelocity(LocalPlayer())
					local dir = meta_vc.Angle(vel)
					
					dir.yaw = meta_cd.GetViewAngles(cmd).yaw - dir.yaw
					
					local newmove = meta_an.Forward(dir) * meta_vc.Length2D(vel)
			
					meta_cd.SetForwardMove(cmd, 0 - newmove.x)
					meta_cd.SetSideMove(cmd, 0 - newmove.y)
				end
			end
		end

		-- Auto bhop
		
		if vars.tools_movement_autobhop then
			local ishopping = ismeth and input.IsKeyDown(KEY_SPACE) or meta_cd.KeyDown(cmd, IN_JUMP)
			
			if ishopping and not grounded then
				meta_cd.SetButtons(cmd, bit.band(meta_cd.GetButtons(cmd), bit.bnot(IN_JUMP))) -- memeware moment
			end
		end
		
		-- Auto strafe
		
		if vars.tools_movement_autostrafe then
			if not grounded then
				local mx = meta_cd.GetMouseX(cmd)
				
				if mx > 0 then
					meta_cd.SetSideMove(cmd, 10^4)
				elseif mx < 0 then
					meta_cd.SetSideMove(cmd, 0 - 10^4)
				end
			end
		end
		
		-- Blockbot
		
		if vars.tools_movement_blockbot then
			if meta_cd.KeyDown(cmd, IN_RELOAD) and grounded then
				local followee = cache.blockbot_targ
				
				if not validEntity(followee) then
					cache.blockbot_targ = getClosest(false)
				else
					if not moving then
						cache.blockbot_active = true
					
						local ontop = meta_en.GetGroundEntity(LocalPlayer()) == followee
						
						local lang = meta_cd.GetViewAngles(cmd)
						local fwd = meta_en.GetPos(followee) - meta_en.GetPos(LocalPlayer())
						local fwdang = meta_vc.Angle(fwd)
						
						local maxfwd = meta_cv.GetInt(GetConVar("cl_forwardspeed"))
						local maxsid = meta_cv.GetInt(GetConVar("cl_sidespeed"))
						
						if not meta_cd.KeyDown(cmd, IN_SPEED) then
							meta_cd.AddKey(cmd, IN_SPEED)
						end
						
						if ontop then
							local lpos = meta_en.GetPos(LocalPlayer())
							local fpos = meta_en.GetPos(followee)
							local lposz = Vector(lpos.x, lpos.y, 0)
							local fposz = Vector(fpos.x, fpos.y, 0)
							
							local zdis = meta_vc.DistToSqr(lposz, fposz)
							
							maxfwd = zdis
							maxsid = zdis
							
							local moveyaw = math.rad(meta_vc.Angle(fwd).yaw - lang.yaw)

							meta_cd.SetForwardMove(cmd, math.Clamp(math.cos(moveyaw) * maxfwd, 0 - maxfwd, maxfwd))
							meta_cd.SetSideMove(cmd, math.Clamp((0 - math.sin(moveyaw)) * maxsid, 0 - maxsid, maxsid))
						else
							local fvel = meta_vc.Length(meta_en.GetVelocity(followee))
							local dyaw = fwdang.yaw - lang.yaw
							
							if dyaw > 180 then
								dyaw = dyaw - 360
							elseif dyaw < -180 then
								dyaw = dyaw + 360
							end
							
							if fvel > 285 then
								meta_cd.SetForwardMove(cmd, 0 - math.abs(fvel))
							end
							
							if dyaw > 0.25 then
								meta_cd.SetSideMove(cmd, 0 - maxsid)
							elseif dyaw < -0.25 then
								meta_cd.SetSideMove(cmd, maxsid)
							end
						end
					else
						cache.blockbot_active = false
					end
				end
			else
				if cache.blockbot_active then
					cache.blockbot_targ = nil
					cache.blockbot_ang = Angle(0, 0, 0)
					cache.blockbot_active = false
				end
			end
		end
		
		-- Circle strafer at some point
		
		if vars.tools_movement_circlestrafer then
			local ishopping = ismeth and input.IsKeyDown(KEY_SPACE) or meta_cd.KeyDown(cmd, IN_JUMP)
			local left, right = meta_cd.KeyDown(cmd, IN_MOVELEFT) or input.IsKeyDown(input.GetKeyCode(input.LookupBinding("+moveleft"))), meta_cd.KeyDown(cmd, IN_MOVERIGHT) or input.IsKeyDown(input.GetKeyCode(input.LookupBinding("+moveright")))
			
			if (left or right) and ishopping then
				cache.circlestrafer_active = true
			else			
				if cache.circlestrafer_active then
					cache.circlestrafer_delta = 0
					cache.circlestrafer_active = false
				end
			end
		end
	end
	
	-- Meth Stuff
	
	if ismeth then
		if mvar then
			-- Slow motion
	
			if vars.meth_tools_slowmotion then
				if cache.meth_slowmotion_reset then
					mvar.SetVarInt("General.Exploits.Toos Freeze", 1)
					mvar.SetVarInt("General.Exploits.Freeze Key", 0)
				end
			
				if cache.meth_slowmotion_wait then
					mvar.SetVarInt("General.Exploits.Freeze Power", 0)
					cache.meth_slowmotion_wait = false
				else
					mvar.SetVarInt("General.Exploits.Freeze Power", vars.meth_tools_slowmotion_intensity)
					cache.meth_slowmotion_wait = true
				end
				
				cache.meth_slowmotion_reset = false
			else
				if not cache.meth_slowmotion_reset then
					if not cache.meth_slowmotion_backupkey then
						cache.meth_slowmotion_backup = mvar_o.GetVarInt("General.Exploits.Freeze Power")
						cache.meth_slowmotion_backupkey = mvar_o.GetVarInt("General.Exploits.Freeze Key")
					else
						mvar.SetVarInt("General.Exploits.Freeze Power", cache.meth_slowmotion_backup)
						mvar.SetVarInt("General.Exploits.Freeze Key", cache.meth_slowmotion_backupkey)
					end
					
					mvar.SetVarInt("General.Exploits.Toos Freeze", 0)
				
					cache.meth_slowmotion_reset = true
				end
			end
		
			-- AA
			
			if vars.meth_tools_aa then
				local ryaw = 0
				local yaw = mvar.GetVarInt("General.Options.Yaw")
				
				if yaw < 6 then
					ryaw = meth_aa[yaw] -- Based off left, right, forward, back, disabled settings in meth aa
				else
					ryaw = mvar_o.GetVarFloat("Custom.Config.Fake Jitter Angle 1") -- Go to jitter angle
				end
				
				if vars.meth_tools_aa_autodir then
					local closest = getClosest(true)
					
					if validEntity(closest) then
						ryaw = (meta_vc.Angle((meta_en.GetPos(closest) - meta_en.GetPos(LocalPlayer()))) - meta_en.EyeAngles(LocalPlayer())).yaw
					end
				end
				
				local new = ryaw + 180
				
				if vars.meth_tools_aa_jitter_yaw then
					new = (ryaw + 180) + math.random(-80, 80)
				end
				
				if vars.meth_tools_aa_sway then
					new = ryaw + (math.sin(UnPredictedCurTime()) * 60)
				end
				
				if vars.meth_tools_aa_snapback then
					local tick = math.Round((UnPredictedCurTime() % math.Round((1 / engine.TickInterval()))), 1) -- Snapback according to tickrate
					
					if tick % 1 == 0 then
						new = ryaw + (math.random(30, 45) * (math.random(0, 10) > 5 and -1 or 1)) -- Snap either -30 to -45 or 30 to 45
					end
				end
				
				mvar.SetVarFloat("Custom.Config.Jitter Angle 1", new)
				mvar.SetVarFloat("Custom.Config.Jitter Angle 2", new)
				
				if vars.meth_tools_aa_jitter_lag then
					mvar.SetVarInt("General.Options.Fake Lag", math.random(1, 14))
				end
			end
		
			-- AA Fix
		
			if vars.meth_tools_aafix then
				if not vars.meth_tools_aafix_last then
					vars.meth_tools_aafix_last = mvar.GetVarInt("General.Options.Enabled") -- Get user set aa state
				end
				
				if meta_en.WaterLevel(LocalPlayer()) > 1 then
					mvar.SetVarInt("General.Options.Enabled", 0) -- Set to 0 before swimming animation starts
				else
					mvar.SetVarInt("General.Options.Enabled", vars.meth_tools_aafix_last) -- Restore
					vars.meth_tools_aafix_last = nil -- Clear backup
				end
				
				if cache.meth_tools_aafix_reset then
					cache.meth_tools_aafix_reset = false
				end
			else
				if not cache.meth_tools_aafix_reset then
					if vars.meth_tools_aafix_last ~= nil then
						if vars.meth_tools_aafix_last ~= mvar.GetVarInt("General.Options.Enabled") then
							mvar.SetVarInt("General.Options.Enabled", vars.meth_tools_aafix_last) -- Reset to user aa state if option is disabled
						end
					end
					
					cache.meth_tools_aafix_reset = true
				end
			end
			
			-- Freecam movement clear
			
			if vars.meth_tools_clearfreecam then
				if mvar.GetVarInt("Player.Free Cam.Free Cam") == 1 then
					meta_cd.ClearButtons(cmd)
					meta_cd.ClearMovement(cmd)
				end
			end
		end
	end
	
	-- Movement clear
	
	if vars.tools_movement_menuclear then
		if vars.menu then
			meta_cd.ClearButtons(cmd)
			meta_cd.ClearMovement(cmd)
		end
	end
end)

hook.Add("CalcView", vars.hookname, function(ply, pos, ang, fov, zn, zf)
	if not validEntity(ply) then
		return
	end
	
	cache.calcview_eyepos = pos
	cache.calcview_eyeangles = ang
	cache.calcview_fov = fov
	
	local v = meta_pl.GetVehicle(ply)
	local w = meta_pl.GetActiveWeapon(ply)
	
	local nfov = fov
	local cfov = fov + (vars.view_fov_set - meta_cv.GetInt(GetConVar("fov_desired")))
	local override = vars.view_fov_changer and vars.view_fov_override
	
	if not vars.view_screengrab_test then
		if vars.view_fov_changer then
			if override then
				nfov = vars.view_fov_set - 1
			else
				nfov = cfov
			end
		end
	end
	
	nfov = math.Clamp(nfov, 2, 179)
	
	if vars.view_fix_thirdperson then
		if meta_pl.ShouldDrawLocalPlayer(ply) then
			if mvar then
				if mvar.GetVarInt("Player.Third Person.Third Person") ~= 1 then
					local tr = util.TraceLine({
						start = pos,
						endpos = pos - (meta_an.Forward(ang) * 150),
						mask = MASK_SHOT,
						filter = ply,
						ignoreworld = false
					})
					
					pos = tr.HitPos + tr.HitNormal
				end
			end
		end
	end
	
	local view = {
		origin = pos,
		angles = ang,
		fov = nfov,
		znear = zn,
		zfar = zf
	}
	
	cache.calcview_fov_custom = view.fov
	
	if validEntity(v) then
		return hook.Run("CalcVehicleView", v, ply, view)
	end
	
	if not override then
		if validEntity(w) then
			local wCV = w.CalcView
			
			if wCV then
				view.origin, view.angles, view.fov = wCV(w, ply, pos * 1, ang * 1, nfov)
				
				cache.calcview_fov_custom = view.fov
			end
		end
	end
	
	return view
end)

hook.Add("AdjustMouseSensitivity", vars.hookname, function()
	if vars.view_fov_changer and vars.view_fov_override then
		return 0
	end
end)

hook.Add("Think", vars.hookname, function()
	if vars.logs then
		if vars.logs_screengrabs then
			if not vars.view_screengrab_test then
				if vars.renderpanic then
					log("Blocked a Screengrab", false, "s")
				end
			end
		end
	end
end)

hook.Add("Tick", vars.hookname, function()
	colors.rainbow = HSVToColor((UnPredictedCurTime() % 6) * 60, 1, 1) -- Exploit city moment
	colors.rainbow.a = 255

	-- Tick shoot
	
	if vars.tools_misc_tickshoot then
		if cache.tools_misc_tickshoot_swap then
			local defwep = meta_cv.GetString(GetConVar("cl_defaultweapon"))
		
			if defwep then
				input.SelectWeapon(meta_pl.GetWeapon(LocalPlayer(), defwep))
			else
				meta_pl.ConCommand(LocalPlayer(), "lastinv")
			end
			
			cache.tools_misc_tickshoot_swap = false
		end
	end
	
	-- Antigag
	
	if vars.tools_misc_antigag then
		hook.Remove("PlayerCanHearPlayersVoice", "ULXGag")
		hook.Remove("PlayerBindPress", "ULXGagForce")
		hook.Remove("PlayerAuthed", "ULXCC_SetPGagData")
		timer.Remove("GagLocalPlayer")
		
		meta_en.SetNWBool(LocalPlayer(), "Muted", false)
		
		if ulx and ulx.gagUser then
			ulx.gagUser(LocalPlayer(), false)
		end
	end
	
	-- Gesture loop
	
	if vars.tools_misc_gestureloop then
		local dance = vars.tools_misc_gestureloop_act
		
		if engine.ActiveGamemode() == "darkrp" then
			if not vars.tools_misc_gestureloop_delay then
				local id = vars.darkrp_gestures.dance or -1
				
				if id ~= -1 then
					meta_pl.ConCommand(LocalPlayer(), "_DarkRP_DoAnimation " .. id)
					
					local sid, slen = meta_en.LookupSequence(LocalPlayer(), meta_en.GetSequenceName(LocalPlayer(), meta_en.SelectWeightedSequence(LocalPlayer(), id)))
					
					if sid and slen then
						vars.tools_misc_gestureloop_delay = true
						
						timer.Simple(slen, function()
							vars.tools_misc_gestureloop_delay = false
						end)
					end
				end
			end
		else
			if not meta_pl.IsPlayingTaunt(LocalPlayer()) then
				meta_pl.ConCommand(LocalPlayer(), "act ".. dance)
			end
		end
	end
	
	if ismeth then
		if mvar then
			-- Fake angle chams fix
	
			if vars.meth_render_chamsfix then
				mvar.SetVarInt("Player.Misc Players.Fake Angle Chams", mvar.GetVarInt("Player.Third Person.Third Person"))
			end
		
			-- Autofire delay
		
			if vars.meth_tools_afdelay then
				local cur = vars.meth_tools_afdelay_cur
				
				if validEntity(getMethAimbotTarget()) then
					if cur >= vars.meth_tools_afdelay_amount then
						mvar.SetVarInt("Aimbot.Options.Auto Fire", 1)
						cache.meth_af_set = false
					else
						if not cache.meth_af_set then
							mvar.SetVarInt("Aimbot.Options.Auto Fire", 0)
							cache.meth_af_set = true
						end
						
						cur = cur + 1
					end
				else
					if not cache.meth_af_set then
						mvar.SetVarInt("Aimbot.Options.Auto Fire", 0)
						cache.meth_af_set = true
					end
				
					cur = 0
				end
				
				vars.meth_tools_afdelay_cur = cur
				cache.meth_afdelay_reset = false
			else
				if not cache.meth_afdelay_reset then
					if not cache.meth_afdelay_og then
						cache.meth_afdelay_og = mvar_o.GetVarInt("Aimbot.Options.Auto Fire")
					else
						mvar.SetVarInt("Aimbot.Options.Auto Fire", cache.meth_afdelay_og)
					end
					
					cache.meth_afdelay_reset = true
				end
			end
		
			if vars.meth_render_chams_highlight then -- Updates meth highlight colors
				if vars.meth_render_chams_highlight_friends then
					if mvar.GetVarInt("Player.Friends.Rainbow") == 1 then
						colors.meth_highlight_friends = colors.rainbow
					else
						colors.meth_highlight_friends = mvar.GetVarColor("Player.Friends.Friends_Color")
					end
				end
	
				if vars.meth_render_chams_highlight_aimbot then
					if mvar.GetVarInt("Player.Aimbot Target.Rainbow") == 1 then
						colors.meth_highlight_aimbot = colors.rainbow
					else
						colors.meth_highlight_aimbot = mvar.GetVarColor("Player.Aimbot Target.Aimbot Target_Color")
					end
				end
			end
		end
	end
	
	-- Color updates
	-- Update the colors of the glow chams materials
	
	if vars.menu then
		if ismeth and mvar then
			if colors.meth_fovcircle ~= "RGB" then
				colors.meth_fovcircle = mvar.GetVarColor("Player.Misc Players.FOV Circle_Color") -- Make FOV Circle color display in config
			end
		end
	end
	
	if not compareColor(cache.beam_color, getColor("beam")) then
		local c = getColor("beam")
		local nvec = meta_cl.ToVector(c)
		
		meta_im.SetVector(materials.beam, "$color", nvec)
	
		cache.beam_color = copyColor(c)
	end
	
	if vars.chams_material_player == "glow" then
		if vars.chams_player then
			if not compareColor(meta_im.GetVector(materials.glow_player, "$color") * 255, getColor("chams_color_player")) then
				local c = getColor("chams_color_player")
			
				if c ~= "HP" then
					updateGlowColor(materials.glow_player, c)
				end
			end
		end
		
		if vars.chams_player_weapon then
			if not compareColor(meta_im.GetVector(materials.glow_player_weapon, "$color") * 255, getColor("chams_color_player_weapon")) then
				local c = getColor("chams_color_player_weapon")
				
				if c ~= "HP" then
					updateGlowColor(materials.glow_player_weapon, c)
				end
			end
		end
	end
	
	if vars.chams_material_player_weapon == "glow" then
		if vars.meth_render_chams_highlight then
			if vars.meth_render_chams_highlight_friends then
				if not compareColor(cache.chams_glow_player_highlight_friends_last, colors.meth_highlight_friends) then
					local c = colors.meth_highlight_friends
					local nvec = meta_cl.ToVector(c)
					
					meta_im.SetVector(materials.glow_player_highlight_friends, "$envmaptint", nvec)
					
					cache.chams_glow_player_highlight_friends_last = copyColor(c)
				end
			end
			
			if vars.meth_render_chams_highlight_aimbot then
				if not compareColor(cache.chams_glow_player_highlight_aimbot_last, colors.meth_highlight_aimbot) then
					local c = colors.meth_highlight_aimbot
					local nvec = meta_cl.ToVector(c)
					
					meta_im.SetVector(materials.glow_player_highlight_aimbot, "$envmaptint", nvec)
					
					cache.chams_glow_player_highlight_aimbot_last = copyColor(c)
				end
			end
		end
	end
	
	if vars.chams_material_viewmodel == "glow" then
		if vars.chams_viewmodel then
			if not compareColor(meta_im.GetVector(materials.glow_viewmodel, "$color") * 255, getColor("chams_color_viewmodel")) then
				local c = getColor("chams_color_viewmodel")
				
				if c ~= "HP" then
					updateGlowColor(materials.glow_viewmodel, c)
				end
			end
		end
	end
	
	if vars.world_ambient_lighting then
		if not compareColor(cache.world_ambient, getColor("world_ambient")) then
			cache.world_ambient_set = false
			
			cache.world_ambient = copyColor(getColor("world_ambient"))
		end
	end
	
	if vars.traces_shotrecord then
		if not compareColor(cache.traces_shotrecord_hit, getColor("traces_shotrecord_hit")) then
			local c = getColor("traces_shotrecord_hit")
			
			meta_im.SetInt(materials.boxmat_hit, "$alpha", c.a / 255)
			
			cache.traces_shotrecord_hit = copyColor(c)
		end
		
		if not compareColor(cache.traces_shotrecord_kill, getColor("traces_shotrecord_kill")) then
			local c = getColor("traces_shotrecord_kill")
			
			meta_im.SetInt(materials.boxmat_kill, "$alpha", c.a / 255)
			
			cache.traces_shotrecord_kill = copyColor(c)
		end
	end
	
	if ismeth then
		if vars.meth_render_backtrack then
			if not compareColor(cache.meth_backtrackhitbox, getColor("meth_backtrackhitbox")) then
				local c = getColor("meth_backtrackhitbox")
			
				meta_im.SetInt(materials.boxmat_backtrack, "$alpha", c.a / 255)
			
				cache.meth_backtrackhitbox = copyColor(c)
			end
		end
		
		if vars.meth_render_freecambox then
			if not compareColor(cache.meth_freecambox, getColor("meth_freecambox")) then
				local c = getColor("meth_freecambox")
			
				meta_im.SetInt(materials.boxmat_freecam, "$alpha", c.a / 255)
			
				cache.meth_freecambox = copyColor(c)
			end
		end
	end
	
	-- Spectator list and Traitor detector
	
	local alive = 0
	local forced = false
	local isttt = engine.ActiveGamemode() == "terrortown"

	if isttt then -- Get alive players to force last player to be traitor in TTT
		if vars.tools_detectors_traitordetector then
			for _, v in ipairs(player.GetAll()) do
				if not meta_en.IsValid(v) or not meta_pl.Alive(v) then
					continue
				end
				
				alive = alive + 1
			end
		end
	end

	if vars.tools_detectors_spectatorlist or (isttt and vars.tools_detectors_traitordetector) then -- Update spectator list and traitor detector
		table.Empty(traitors)
		table.Empty(spectators)
	
		for _, v in ipairs(player.GetAll()) do
			if not meta_en.IsValid(v) or v == LocalPlayer() then
				continue
			end
			
			local skip = false
			
			if isttt then
				if vars.tools_detectors_traitordetector then
					if GAMEMODE.round_state == ROUND_ACTIVE then
						if cache.traitors_empty then
							cache.traitors_empty = false
						end
					
						if not meta_pl.Alive(v) then
							skip = true
						end
						
						if meta_pl.IsTerror and not meta_pl.IsTerror(v) then
							skip = true
						end
						
						local added = false
						local add = {v, -1}
						
						skip = forced and true or skip
						
						if not skip then
							if not forced then
								if alive <= 2 then
									add[2] = 2
									
									traitors[#traitors + 1] = add
									
									if not table.HasValue(cache.traitors, v) then
										cache.traitors[#cache.traitors + 1] = v
									end
									
									forced = true
									added = true
								end
								
								if not added then
									if meta_pl.IsDetective and meta_pl.IsDetective(v) then -- Quick checks using built in functions
										add[2] = 1
									end
									
									if meta_pl.IsTraitor and meta_pl.IsTraitor(v) then
										add[2] = 2
									end
									
									if add[2] == -1 then
										for _, wep in ipairs(meta_pl.GetWeapons(v)) do
											if not meta_en.IsValid(wep) then
												continue
											end
											
											if table.HasValue(tWeapons, meta_en.GetClass(wep)) then -- Loop through traitor weapons
												add[2] = 2
												break
											end
										end
									end
									
									traitors[#traitors + 1] = add
									
									if add[2] == 2 then
										if not table.HasValue(cache.traitors, v) then
											cache.traitors[#cache.traitors + 1] = v
										end
									end
								end
							end
						end
					else
						if not cache.traitors_empty then
							table.Empty(cache.traitors)
							
							cache.traitors_empty = true
						end
					end
				else
					if not cache.traitors_empty then
						table.Empty(cache.traitors)
						
						cache.traitors_empty = true
					end
				end
			end
			
			if vars.tools_detectors_spectatorlist then
				skip = false

				local doall = vars.tools_detectors_spectatorlist_showall
				local starg, mode = meta_pl.GetObserverTarget(v), meta_pl.GetObserverMode(v) or -1
				
				if mode == 0 then
					skip = true
				end
				
				local new = {}
				
				if meta_en.IsValid(starg) then
					if not doall and starg ~= LocalPlayer() then
						skip = true
					end
				else
					if not doall then
						skip = true
					end
				end
				
				if not skip then
					new.name = meta_pl.GetName(v) or "UNKNOWN"
					new.targ = (meta_en.GetClass(starg) == "player" and meta_pl.GetName(starg)) or "UNKNOWN"
					new.realtarg = starg
					new.mode = specmodes[mode] or "UNKNOWN"
				
					spectators[#spectators + 1] = new
				end
			end
		end
	end
	
	-- Backtrack Hitboxes
	
	if vars.meth_render_backtrack then
		local player = vars.meth_render_backtrack_target
	
		if validEntity(player) then
			local ins = getEntityHitboxes(player)
			
			if #ins > 0 then
				backtrack[#backtrack + 1] = {
					["data"] = ins, 
					["timestamp"] = UnPredictedCurTime()
				}
			end
			
			cache.backtrack_empty = false
		else
			if not cache.backtrack_empty then
				table.Empty(backtrack)
			
				cache.backtrack_empty = true
			end
		end
	end
end)

hook.Add("SetupSkyboxFog", vars.hookname, function()
	local ret = not vars.world_draw_fog
	
	if ret then
		render.FogMode(MATERIAL_FOG_NONE) -- Prevent skybox fog from rendering
		render.FogStart(0)
		render.FogEnd(1)
		render.FogMaxDensity(0)

		if meta_en.WaterLevel(LocalPlayer()) == 3 then
			render.SetLightingMode(1)
		else
			if not vars.world_fullbright then
				render.SetLightingMode(0)
			end
		end
	end
	
	return ret
end)

hook.Add("SetupWorldFog", vars.hookname, function()
	local ret = not vars.world_draw_fog
	
	if ret then
		render.FogMode(MATERIAL_FOG_NONE) -- Prevent world fog from rendering
		render.FogStart(0)
		render.FogEnd(1)
		render.FogMaxDensity(0)

		if meta_en.WaterLevel(LocalPlayer()) == 3 then
			render.SetLightingMode(1)
		else
			if not vars.world_fullbright then
				render.SetLightingMode(0)
			end
		end
	end
	
	return ret
end)

hook.Add("RenderScene", vars.hookname, function()
	if vars.world_draw_fog then
		if not cache.world_fog_reset then
			MATERIAL_FOG_LINEAR = 1
			MATERIAL_FOG_LINEAR_BELOW_FOG_Z	= 2
			
			cache.world_fog_reset = true
			cache.world_fog_removed = false
		end
	else
		if not cache.world_fog_removed then
			MATERIAL_FOG_LINEAR = 0 -- Prevent other kinds of fog from rendering (Except water fog for some reason)
			MATERIAL_FOG_LINEAR_BELOW_FOG_Z	= 0
			
			cache.world_fog_reset = false
			cache.world_fog_removed = true
		end
	end

	local DOAMBIENT = vars.world_ambient_lighting
	local DODEV = vars.world_devtextures
	local DODEV_O = vars.world_devtextures_orange

	if (DOAMBIENT and not cache.world_ambient_set) or (DODEV and not cache.world_devtextures_set) or (not DOAMBIENT and cache.world_ambient_set) or (not DODEV and cache.world_devtextures_set) or (DODEV and (cache.world_devtextures_last ~= DODEV_O)) then
		local ambient_color = getColor("world_ambient") -- Put these up here for performance
		local ambient_vector = meta_cl.ToVector(ambient_color)
	
		for _, v in ipairs(meta_en.GetMaterials(game.GetWorld())) do
			local WORLDMAT = Material(v) -- Laggy as shit
			local WORLDMAT_NAME = string.lower(meta_im.GetName(WORLDMAT))
		
			if validMaterial(WORLDMAT_NAME) then
				if DODEV then
					if not materialbackup[WORLDMAT_NAME] then
						materialbackup[WORLDMAT_NAME] = meta_im.GetTexture(WORLDMAT, "$basetexture") -- Create a backup of world materials
					end
					
					if DODEV_O then
						meta_im.SetTexture(WORLDMAT, "$basetexture", materials.devtexture_alt)
					else
						meta_im.SetTexture(WORLDMAT, "$basetexture", materials.devtexture)
					end
				elseif cache.world_devd then
					meta_im.SetTexture(WORLDMAT, "$basetexture", materialbackup[WORLDMAT_NAME] or "") -- Attempt to restore from backup or replace with missing texture
				end
			end
		
			if DOAMBIENT then
				if not cache.world_ambient_set then
					meta_im.SetVector(WORLDMAT, "$color", ambient_vector)
					meta_im.SetFloat(WORLDMAT, "$alpha", ambient_color.a / 255)
				end
			else
				if not cache.world_ambient_reset then
					meta_im.SetVector(WORLDMAT, "$color", Vector(1, 1, 1)) -- Restore world colors
					meta_im.SetFloat(WORLDMAT, "$alpha", 1)
				end
			end
		end
	end

	-- Update cache

	cache.world_devd = DODEV
	
	if DODEV then
		if not cache.world_devtextures_set then
			cache.world_devtextures_set = true
		end
		
		if DODEV_O then
			render.MaterialOverride(materials.devmaterial_alt)
		else
			render.MaterialOverride(materials.devmaterial)
		end
	else
		if cache.world_devtextures_set then
			cache.world_devtextures_set = false
		end
		
		render.MaterialOverride(nil)
	end
	
	if DOAMBIENT then
		if not cache.world_ambient_set then
			cache.world_ambient_set = true
		end
	else
		if cache.world_ambient_set then
			cache.world_ambient_set = false
		end
	end
	
	-- Fullbright
	
	if vars.world_fullbright then
		render.SuppressEngineLighting(false)
		render.ResetModelLighting(1, 1, 1)

		render.SetLightingMode(1)
	else
		render.SetLightingMode(0)
	end
	
	cache.world_devtextures_last = DODEV_O -- Keep track of this to test when orange is toggled to run loop again
end)

hook.Add("PreDrawEffects", vars.hookname, function()
	render.SetLightingMode(0) -- Prevent fullbright fucking up menus / huds / whatever
	render.MaterialOverride(nil)
	
	if ismeth then
		if vars.meth_render_mirrorfix then
			render.PushCustomClipPlane(Vector(0, 0, 0), 0)
		end
	end
end)

hook.Add("PreDrawSkyBox", vars.hookname, function() -- Prevent things getting messed up by devtextures
	render.MaterialOverride(nil)
end)

hook.Add("PreDrawOpaqueRenderables", vars.hookname, function()
	render.MaterialOverride(nil)
end)

hook.Add("PreDrawTranslucentRenderables", vars.hookname, function()
	render.MaterialOverride(nil)
end)

hook.Add("PreDrawViewModels", vars.hookname, function() -- Render a viewmodel that will show up on screengrabs and in screenspace
	local VM = meta_pl.GetViewModel(LocalPlayer())
	
	if not validEntity(VM) then
		return
	end

	local set = not meta_en.IsEffectActive(VM, EF_NODRAW)

	for i = 0, 2 do
		meta_pl.DrawViewModel(LocalPlayer(), set, i)
	end
	
	if not set then
		return
	end

	local extra = true
	
	if ismeth and vars.view_screengrab_test then
		extra = false
	end
	
	if ((canrender(METHFLAG_NONE) and canrender(METHFLAG_NOTHIRDPERSON) and canrender(METHFLAG_NOFREECAM)) or (vars.view_viewmodel_offset_changer and vars.menu)) and not meta_pl.ShouldDrawLocalPlayer(LocalPlayer()) then
		if (((ismeth and vars.chams_viewmodel) or vars.view_fov_viewmodel_changer) or vars.view_viewmodel_offset_changer) and extra then
			for i = 0, 2 do
				meta_pl.DrawViewModel(LocalPlayer(), false, i) -- Hide original viewmodel
			end
			
			local VMFOV = 0
			
			if not vars.view_fov_viewmodel_changer then
				local VMFOV_BASE = meta_pl.GetActiveWeapon(LocalPlayer()).ViewModelFOV or meta_cv.GetInt(GetConVar("viewmodel_fov")) or 54
				
				local plyfov = cache.calcview_fov_custom
				
				if vars.view_screengrab_test then
					if vars.view_fov_override then
						plyfov = vars.view_fov_set - 1
					else
						plyfov = plyfov + (vars.view_fov_set - meta_cv.GetInt(GetConVar("fov_desired")))
					end
				end
				
				local retardedofs = (plyfov + 1) / 100
				
				VMFOV = VMFOV_BASE + (((plyfov + 1) - VMFOV_BASE) - ((0 - VMFOV_BASE) + 83)) - (retardedofs + (retardedofs % 1) + 0.15)
			else
				VMFOV = vars.view_fov_viewmodel_set + 15.75
			end
			
			local EYEANGLES = meta_en.EyeAngles(LocalPlayer())
			local EYEPOS = cache.calcview_eyepos or EyePos() * 1
			
			if vars.view_viewmodel_offset_changer then
				local VMOFFSET = Vector(0 - vars.view_viewmodel_offset_x, 0 - vars.view_viewmodel_offset_y, 0 - vars.view_viewmodel_offset_z)
				
				local right, up, forward = meta_an.Right(EYEANGLES), meta_an.Up(EYEANGLES), meta_an.Forward(EYEANGLES)
	
				EYEPOS = EYEPOS + VMOFFSET.x * right
				EYEPOS = EYEPOS + VMOFFSET.y * forward
				EYEPOS = EYEPOS + VMOFFSET.z * up
			end

			cam.Start3D(EYEPOS, EYEANGLES, VMFOV, 0, 0, ScrW(), ScrH(), 1, 30000)
				cam.IgnoreZ(true)
			
				meta_en.DrawModel(VM)
				
				cam.IgnoreZ(false)
			cam.End3D()
		end
	end
end)

hook.Add("PreDrawViewModel", vars.hookname, function(vm)
	if not validEntity(vm) then
		return
	end
	
	render.SetLightingMode(0)
	
	if not vars.chams_viewmodel or not canrender(METHFLAG_NONE) or not canrender(METHFLAG_NOTHIRDPERSON) then
		render.MaterialOverride(nil)
		render.SetColorModulation(1, 1, 1)
	else
		if not ismeth then -- Viewmodel chams for non meth users
			local color = getColor("chams_color_viewmodel", LocalPlayer())
			render.SetColorModulation(color.r / 255, color.g / 255, color.b / 255)
			
			if vars.chams_material_viewmodel == "glow" then
				updateGlowColor(materials.glow_viewmodel, color)
			end
			
			render.MaterialOverride(getChamsMat("VM"))
		end
	end
	
	if vars.world_fullbright then
		render.SuppressEngineLighting(true) -- Viewmodel fullbright
	else
		render.SuppressEngineLighting(false)
	end
end)

hook.Add("PrePlayerDraw", vars.hookname, function(ply)
	if not validEntity(ply) then
		return
	end
	
	if vars.world_fullbright then
		render.SuppressEngineLighting(true) -- Player fullbright
	else
		render.SuppressEngineLighting(false)
	end
end)

hook.Add("EntityFireBullets", vars.hookname, function(ent, data)
	if not validEntity(ent) or not data then
		return
	end
	
	if ent ~= LocalPlayer() then
		return
	end
	
	if vars.tools_misc_tickshoot then
		if not cache.tools_misc_tickshoot_swap then
			cache.tools_misc_tickshoot_swap = true
		end
	end
	
	if vars.traces_btr and vars.traces_btr_local then
		if #bullets >= vars.traces_btr_max then
			table.remove(bullets, 1)
		end
		
		local tr = util.TraceLine({
			start = data.Src,
			endpos = data.Src + (data.Dir * data.Distance),
			filter = ent,
			ignoreworld = false,
			mask = MASK_SHOT,
		})
		
		bullets[#bullets + 1] = {
			["src"] = data.Src,
			["endpos"] = tr.HitPos,
			["timestamp"] = UnPredictedCurTime()
		}
	end
end)

hook.Add("DoAnimationEvent", vars.hookname, function(ply, event, data)
	if (event ~= PLAYERANIMEVENT_ATTACK_PRIMARY and data ~= PLAYERANIMEVENT_ATTACK_PRIMARY) or not (vars.traces_btr and vars.traces_btr_other) or not validEntity or ply == LocalPlayer() then
		return
	end
	
	if isBadWeapon(meta_pl.GetActiveWeapon(ply)) then
		return
	end
	
	if #bullets >= vars.traces_btr_max then
		table.remove(bullets, 1)
	end
	
	local src = getHeadPos(ply)
	local dir = meta_an.Forward(meta_en.EyeAngles(ply))
	
	local tr = util.TraceLine({
		start = src,
		endpos = src + (dir * 32767),
		filter = player.GetAll(),
		ignoreworld = false,
		mask = MASK_SHOT,
	})
	
	bullets[#bullets + 1] = {
		["src"] = src,
		["endpos"] = tr.HitPos,
		["timestamp"] = UnPredictedCurTime()
	}
end)

gameevent.Listen("player_hurt") -- This is stupid

hook.Add("player_hurt", vars.hookname, function(data) -- Shot Records
	if not vars.traces_shotrecord or not data then
		return
	end
	
	local attacker = Player(data.attacker)
	local victim = Player(data.userid)
	
	if attacker ~= LocalPlayer() or not meta_en.IsValid(victim) then
		return
	end
	
	if victim == LocalPlayer() then
		return
	end
	
	local ins = getEntityHitboxes(victim, data.health < 1) -- Sometimes data.health will be 0 when it shouldn't be because gmod
	
	if #ins > 0 then
		hits[#hits + 1] = {
			["data"] = ins,
			["timestamp"] = UnPredictedCurTime()
		}
	end
end)

timer.Create(vars.hookname, 1, 0, function() -- Funny timer
	-- Log handling
	
	if vars.logs then
		local oglength = #addtologs
		local datatowrite = ""
		
		for k, v in ipairs(addtologs) do
			logs[#logs + 1] = v
			
			if vars.logs_savetofile then
				datatowrite = datatowrite .. v .. "\n"
			end
		end
		
		table.Empty(addtologs)
		
		if oglength > 0 then
			if vars.logs_savetofile then
				local written = false
				
				if ismeth and mio then
					local read = mio.Read("C:/MTHRW/LUA/data/st3_log.txt")
					
					if read.content then
						datatowrite = read.content .. datatowrite
					end
					
					local write = mio.Write("C:/MTHRW/LUA/data/st3_log.txt", datatowrite .. "\n")
					
					written = write.status or false
				end
				
				if not written then
					detours.file_Append("st3_log.txt", datatowrite)
				end
			end
		end
	end
	
	-- PSay Spammer
	
	if vars.tools_misc_psay then
		local cd, ac = detours.concommand_GetTable()
	
		if cd.ulx then
			for _, v in ipairs(player.GetAll()) do
				if not meta_en.IsValid(v) or v == LocalPlayer() then
					continue
				end
				
				meta_pl.ConCommand(LocalPlayer(), "ulx psay \"" .. meta_pl.GetName(v) .. "\" " .. vars.tools_misc_psay_message)
			end
		end
	end
end)

--[[
	The Rest
]]

concommand.Add("st_menu", function(p, c, args)
	if not args[1] then
		args[1] = not vars["menu"]
	end
	
	vars.menu_activedropdown = nil
	vars.menu_colorpicker_var = nil
	
	-- Setup color picker to prevent stupid errors
	
	meta_pn.SetVisible(CPpickerRGB, false)
	meta_pn.SetVisible(CPpickerALPHA, false)
	meta_pn.SetVisible(CPpickerBoxThing, false)
	meta_pn.SetVisible(CPframe, false)
	
	meta_pn.SetEnabled(CPpickerRGB, false)
	meta_pn.SetEnabled(CPpickerALPHA, false)
	meta_pn.SetEnabled(CPpickerBoxThing, false)
	meta_pn.SetEnabled(CPframe, false)
	
	-- Center menu to screen (For init and resolution changes)
	
	if cache.scrw ~= ScrW() then
		vars.menu_w = 600
		vars.menu_x = (ScrW() / 2) - (300)
		
		cache.scrw = ScrW()
	end
	
	if cache.scrh ~= ScrH() then
		vars.menu_h = 700
		vars.menu_y = (ScrH() / 2) - (350)
		
		cache.scrh = ScrH()
	end
	
	-- Show menu and cursor
	
	vars["menu"] = args[1]
	gui.EnableScreenClicker(args[1])
end)

-- :DDD

alert("Loaded " .. title)

if ismeth and issafe then
	alert("Loaded with Safe Mode - Detours won't work")
end

loadconfig(true) -- Try to autoload config but suppress "Failed to load config" alert

if vars.logs then
	local iend = ""
	
	if ismeth then
		iend = "  Safe Mode: " .. tostring(issafe)
	end
	
	log(0)
	log(game.GetIPAddress() .. "  " .. meta_pl.SteamID(LocalPlayer()) .. "  Meth: " .. tostring(ismeth) .. iend, true) -- Initial log
end

-- Create Images

local cata, loga = false, false

http.Fetch("https://raw.githubusercontent.com/awesomeusername69420/meth_tools/main/imgs/catpng.png", function(body)
	cata = true

	if body == "404: Not Found" then
		alert("Failed to download catpng")
		return
	end
	
	detours.file_Write("catpng.png", body)
	materials.catpng = Material("../data/catpng.png")
end, function(e)
	cata = true
	
	alert("Failed to download catpng")
end)

http.Fetch("https://raw.githubusercontent.com/awesomeusername69420/meth_tools/main/imgs/methlogo.jpg", function(body)
	loga = true
	
	if body == "404: Not Found" then
		alert("Failed to download Meth Logo")
		return
	end
	
	detours.file_Write("methlogo.jpg", body)
	materials.methlogo = Material("../data/methlogo.jpg")
end, function(e)
	loga = true

	alert("Failed to download Meth Logo")
end)

-- Final Init

table.insert(menu.Config, 0, {"btn", 340, 305, 95, 25, "Save Config", function() -- Put these in here so I don't have to reorder anything
	saveconfig()
end})

table.insert(menu.Config, 1, {"btn", 445, 305, 95, 25, "Load Config", function()
	loadconfig(false)
end})

table.insert(menu.Config, 1, {"btn", 340, 335, 200, 35, "Reset Settings", function()
	local ogmenu = vars.menu -- Backup
	local ogtab = vars.menu_tab
	local ogmenupos = {
		["x"] = vars.menu_x,
		["y"] = vars.menu_y,
		["w"] = vars.menu_w,
		["h"] = vars.menu_h
	}

	colors = tCopy(defcol)
	cache = tCopy(defcache)

	if vars.world_ambient_lighting then
		cache.world_ambient_set = true
	end
	
	if vars.world_devtextures then
		cache.world_devtextures_set = true
		cache.world_devd = true
	end

	vars = tCopy(defvar)

	vars.menu = ogmenu -- Restore
	vars.menu_tab = ogtab
	vars.menu_x = ogmenupos.x
	vars.menu_y = ogmenupos.y
	vars.menu_w = ogmenupos.w
	vars.menu_h = ogmenupos.h
	
	alert("Settings reset")
end})

timer.Create(vars.hookname .. "_INITTIMER", 1, 0, function()
	if cata and loga then -- Waits until images are created
		-- Setup Images
	
		if materials.catpng then
			meta_im.SetInt(materials.catpng, "$flags", bit.bor(meta_im.GetInt(materials.catpng, "$flags"), 32768))
		else
			materials.catpng = Material(randomString())
		end
		
		if materials.methlogo then
			meta_im.SetInt(materials.methlogo, "$flags", bit.bor(meta_im.GetInt(materials.methlogo, "$flags"), 32768))
		else
			materials.methlogo = Material(randomString())
		end
		
		-- Setup Detours
		
		if not issafe then
			initDetours()
		end
		
		-- Find Anti Cheats
		
		for _, v in ipairs(engine.GetAddons()) do
			local title = string.lower(v.title) or ""
			
			if title ~= "" then
				for _, a in ipairs(badAddons) do
					if string.find(title, a) or string.find(title, a, 1, true) then
						log("Detected " .. v.title)
	
						break
					end
				end
			end
		end
		
		local testsrc = debug.getinfo(debug.getinfo) -- Very good Swift AC detection
		
		if testsrc.short_src then
			if string.find(testsrc.short_src, "swiftac") then
				log("Detected Swift AC")
			end
		end
		
		timer.Remove(vars.hookname .. "_INITTIMER")
	end
end)
