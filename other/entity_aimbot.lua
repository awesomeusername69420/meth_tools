--[[
	https://github.com/awesomeusername69420/meth_tools
	
	Command(s):
		_ents_add (class) 		-		Adds an entity class to the aimbot list
		_ents_remove (class)	-		Remove an entity class from the aimbot list
		_ents_removeall			-		Removes all entities from the aimbot list
		_ents_print				-		Prints the aimbot entity table
		_ents_eyetrace			-		Prints the class of the entity you're looking at
]]

--[[
	Meth setup
]]

local mvar, mutil

if meth_lua_api then
	mutil = meth_lua_api.util

	local perms = mutil.GetPermissions()

	if perms.CheatSettings then
		mvar = meth_lua_api.var
	end
else
	return
end

--[[
	Locals
]]

local stuff = {
	meth = {
		aimbot = {
			target = nil,
			shotlast = false,
			shooting = false,

			enabled = false,
			bodyaim = false,
			autofire = false,
			actualfov = 0,
			fov = 0,
			key = 0
		}
	},

	badents = {
		player = true,
		worldspawn = true
	},
	aiments = {}
}

local meth_bind_keys = { -- Hardcoded because I don't know how meth's keybinds work
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

--[[
	Functions
]]

local function fixAngle(ang)
	ang = ang or angle_zero

	return Angle(math.Remap(math.NormalizeAngle(ang.pitch), -180, 180, -89, 89), math.NormalizeAngle(ang.yaw), math.NormalizeAngle(ang.roll))
end

local function getKey(key)
	if key < 1 then
		return nil
	end
	
	if key > 47 and key < 91 then
		return input.GetKeyCode(string.char(key))
	end
	
	return meth_bind_keys[key] or 0
end

local function shouldAimbot()
	return stuff.meth.aimbot.key ~= 0 and ((stuff.meth.aimbot.key and input.IsButtonDown(stuff.meth.aimbot.key)) or not stuff.meth.aimbot.key) -- Is key unset, held, or always
end

local function getAimbotTarget() -- Helper function to get aimbot entity from meth api
	if not mutil then
		return nil
	end

	local aimtarg = mutil.GetAimbotTarget()

	if aimtarg ~= 0 then
		local ent = ents.GetByIndex(aimtarg)

		if IsValid(ent) then
			return ent
		end
	end

	return nil
end

local function getBestTarget()
	local best, cur = math.huge, nil
	local mx, my = ScrW() / 2, ScrH() / 2

	for _, v in ipairs(ents.GetAll()) do
		if v:IsPlayer() or v:IsWorld() or v:IsDormant() or not stuff.aiments[v:GetClass()] or v:Health() < 1 then -- Don't waste time on bad entities
			continue
		end

		local spos = v:LocalToWorld(v:OBBCenter()):ToScreen()
		local mdis = math.abs(math.Dist(mx, my, spos.x, spos.y))

		if mdis > stuff.meth.aimbot.fov and stuff.meth.aimbot.actualfov > 0 and stuff.meth.aimbot.actualfov < 180 then -- Check if target is in aimbot fov
			continue
		end

		if mdis < best then -- Update current entity to closest
			best = mdis
			cur = v
		end
	end

	return cur
end

local function isVisible(pos, ent)
	pos = pos or vector_origin

	local tr = util.TraceLine({
		start = LocalPlayer():EyePos(),
		endpos = pos,
		filter = LocalPlayer(),
		mask = MASK_SHOT
	})

	return tr.Entity == ent
end

--[[
	Hooks + Timers
]]

timer.Create(tostring({}), 0.3, 0, function() -- Updates meth parameters
	if not mvar then
		return
	end

	stuff.meth.aimbot.enabled = tobool(mvar.GetVarInt("Aimbot..Enabled") % 256)
	stuff.meth.aimbot.autofire = tobool(mvar.GetVarInt("Aimbot.Options.Auto Fire") % 256)

	local sethitbox = mvar.GetVarInt("Aimbot.Accuracy.Hitbox") % 256

	stuff.meth.aimbot.bodyaim = sethitbox == 2

	local setfov = mvar.GetVarInt("Aimbot.Target.FoV") % 256
	local retardednumber = LocalPlayer():ShouldDrawLocalPlayer() and 3.49 or 2.6

	local rad = (math.tan(math.rad(setfov)) / math.tan(math.rad(LocalPlayer():GetFOV() / 2)) * ScrW()) / retardednumber -- Turns the meth fov setting into distance from screen center

	stuff.meth.aimbot.actualfov = setfov
	stuff.meth.aimbot.fov = rad
	stuff.meth.aimbot.key = getKey(mvar.GetVarInt("Aimbot.Options.Key") % 256)
end)

hook.Add("CreateMove", tostring({}), function(cmd)
	if cmd:CommandNumber() == 0 or (not stuff.meth.aimbot.enabled and not stuff.meth.aimbot.shooting) then -- Don't shoot if aimbot is disabled
		return
	end

	if stuff.meth.aimbot.shooting then -- Aimbot entities
		local targ = stuff.meth.aimbot.target

		if not shouldAimbot() or not IsValid(targ) or targ:Health() < 1 then -- If stopped aimbotting or target goes away, stop
			stuff.meth.aimbot.target = nil
			stuff.meth.aimbot.shooting = false

			mvar.SetVarInt("Aimbot..Enabled", 1)

			return
		end

		local targAimPos = targ:LocalToWorld(targ:OBBCenter())

		if not stuff.meth.aimbot.bodyaim then
			local targHeadBone = targ:LookupBone("ValveBiped.Bip01_Head1")
	
			if targHeadBone then
				targAimPos = targ:GetBoneMatrix(targHeadBone):GetTranslation()
			end
		end

		if not isVisible(targAimPos, targ) then -- Target not visible, give up
			stuff.meth.aimbot.target = nil
			stuff.meth.aimbot.shooting = false

			mvar.SetVarInt("Aimbot..Enabled", 1)

			return
		end

		local targAimAng = fixAngle((targAimPos - LocalPlayer():EyePos()):Angle())

		cmd:SetViewAngles(targAimAng)

		if stuff.meth.aimbot.autofire then -- Tap fire
			if stuff.meth.aimbot.shotlast then
				if cmd:KeyDown(IN_ATTACK) then
					cmd:RemoveKey(IN_ATTACK)
				end
			else
				if not cmd:KeyDown(IN_ATTACK) then
					cmd:AddKey(IN_ATTACK)
				end
			end

			stuff.meth.aimbot.shotlast = not stuff.meth.aimbot.shotlast
		end

		return
	end

	if shouldAimbot() then -- Find entity to aimbot
		if IsValid(getAimbotTarget()) then
			return
		end

		local targ = getBestTarget()

		if IsValid(targ) then
			stuff.meth.aimbot.target = targ
			stuff.meth.aimbot.shooting = true

			mvar.SetVarInt("Aimbot..Enabled", 0) -- Make sure meth doesn't switch to shooting players
		end
	end
end)

--[[
	ConCommands
]]

concommand.Add("_ents_add", function(p, c, args)
	if not args[1] or stuff.badents[args[1]] then
		MsgC(Color(255, 100, 100), "Entity class invalid\n")
		surface.PlaySound("buttons/button10.wav")
		return
	end

	if stuff.aiments[args[1]] then
		MsgC(Color(255, 100, 100), "Entity class already in list\n")
		surface.PlaySound("buttons/button10.wav")
	else
		stuff.aiments[args[1]] = true

		MsgC(Color(100, 255, 100), "Entity class added to list\n")
		surface.PlaySound("buttons/button14.wav")
	end
end)

concommand.Add("_ents_remove", function(p, c, args)
	if not args[1] then
		MsgC(Color(255, 100, 100), "Entity class invalid\n")
		surface.PlaySound("buttons/button10.wav")
		return
	end

	if stuff.aiments[args[1]] then
		stuff.aiments[args[1]] = nil

		MsgC(Color(100, 255, 100), "Entity class removed to list\n")
		surface.PlaySound("buttons/button14.wav")
	else
		MsgC(Color(255, 100, 100), "Entity class not in list\n")
		surface.PlaySound("buttons/button10.wav")
	end
end)

concommand.Add("_ents_removeall", function()
	stuff.aiments = {}

	MsgC(Color(100, 255, 100), "Entity table wiped\n")
	surface.PlaySound("buttons/button14.wav")
end)

concommand.Add("_ents_print", function()
	if table.Count(stuff.aiments) > 0 then
		PrintTable(stuff.aiments)
	
		MsgC(Color(100, 255, 100), "Entity table printed\n")
		surface.PlaySound("buttons/button14.wav")
	else
		MsgC(Color(255, 100, 100), "Entity table is empty\n")
		surface.PlaySound("buttons/button10.wav")
	end
end)

concommand.Add("_ents_eyetrace", function()
	local ent = LocalPlayer():GetEyeTrace().Entity

	if IsValid(ent) then
		MsgC(Color(100, 255, 100), ent:GetClass() .. "\n")
		surface.PlaySound("buttons/button14.wav")
	else
		MsgC(Color(255, 100, 100), "No entity found\n")
		surface.PlaySound("buttons/button10.wav")
	end
end)
