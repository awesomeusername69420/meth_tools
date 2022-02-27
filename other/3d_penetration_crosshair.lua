--[[
	https://github.com/awesomeusername69420/meth_tools
]]

local cache = {
	eyepos = vector_origin,
	eyeangles = angle_zero,
	mins = Vector(-4, -4, -4),
	maxs = Vector(4, 4, 4),

	materials = {
		box = CreateMaterial(tostring({}), "UnlitGeneric", { -- Default color material but with alpha
			["$alpha"] = 0.7,
			["$basetexture"] = "color/white",
			["$model"] = 1,
			["$translucent"] = 1,
			["$vertexalpha"] = 1,
			["$vertexcolor"] = 1
		})
	},

	penetration = {
		m9k = {
			["357"] = 144,
			AR2 = 256,
			Buckshot = 25,
			Pistol = 81,
			SMG1 = 196,
			SniperPenetratedRound = 400
		},

		convars = {
			last = {},

			arccw = GetConVar("arccw_enable_penetration"),
			m9k = GetConVar("M9KDisablePenetration"),
			tfa = GetConVar("sv_tfa_bullet_penetration"),
			tfa_mul = GetConVar("sv_tfa_bullet_penetration_power_mul")
		}
	},

	weapon = {
		class = nil,
		hitpos = nil,
		lastpen = false,
		pen = nil
	},

	colors = {
		green = Color(50, 180, 90, 100),
		red = Color(255, 0, 0, 100),
	}
}

for k, v in pairs(cache.penetration.convars) do
	if type(v) == "table" then
		continue
	end

	if v then
		cache.penetration.convars.last[k] = v:GetFloat()
	end
end

local function getEyeTrace()
	local tr = util.TraceLine({
		start = cache.eyepos,
		endpos = cache.eyepos + (cache.eyeangles:Forward() * 32768),
		mask = MASK_SHOT,
		filter = LocalPlayer()
	})

	return tr
end

local function canRender()
	return not vgui.CursorVisible() and not gui.IsConsoleVisible() and not gui.IsGameUIVisible() and not LocalPlayer():IsTyping()
end

local function isBase(wep, base)
	if IsValid(wep) then
		local wbase = wep.Base

		if wbase then
			return string.Split(string.lower(wbase), "_")[1] == base
		end
	end

	return false
end

local function getAmmoPen(wep)
	if wep:GetClass() == cache.weapon.class then
		local rcache = true

		for k, v in pairs(cache.penetration.convars.last) do -- Check cache for convar changes
			if v ~= cache.penetration.convars[k]:GetFloat() then
				rcache = false

				for k, v in pairs(cache.penetration.convars) do -- Update convars if one is different
					if type(v) == "table" then
						continue
					end
				
					if v then
						cache.penetration.convars.last[k] = v:GetFloat()
					end
				end

				break
			end
		end

		if rcache then
			return cache.weapon.pen
		end
	end

	if IsValid(wep) then
		local ammotype = wep:GetPrimaryAmmoType()

		if not ammotype then
			return nil
		end

		local gameammo = game.GetAmmoName(ammotype)

		if not gameammo then
			return nil
		end

		local eyetrace = getEyeTrace()

		if isBase(wep, "bobs") then -- M9K is bob's base
			if cache.penetration.convars.m9k and cache.penetration.convars.m9k:GetBool() then
				return nil
			end

			return cache.penetration.m9k[gameammo]
		end

		if isBase(wep, "tfa") then
			if cache.penetration.convars.tfa and not cache.penetration.convars.tfa:GetBool() then
				return nil
			end

			local gafm = wep.GetAmmoForceMultiplier
			local gpm = wep.GetPenetrationMultiplier

			if not gafm or not gpm then
				return nil
			end

			local mul = 1

			if cache.penetration.convars.tfa_mul then
				mul = cache.penetration.convars.tfa_mul:GetFloat()
			end

			return ((gafm(wep) / gpm(wep, eyetrace.MatType)) * mul) * 0.875
		end

		if isBase(wep, "arccw") then
			if cache.penetration.convars.arccw and not cache.penetration.convars.arccw:GetBool() then
				return nil
			end

			return math.pow(wep.Penetration or math.huge, 2)
		end

		if isBase(wep, "fas2") then
			if not wep.PenetrationEnabled or not wep.PenStr or eyetrace.MatType == MAT_SLOSH then
				return nil
			end

			local ent = eyetrace.Entity

			if IsValid(ent) and (ent:IsPlayer() or ent:IsNPC()) then
				return nil
			end
			
			return math.pow(wep.PenStr, 2) + (wep.PenStr * 0.25)
		end

		if isBase(wep, "cw") then
			if not wep.CanPenetrate or not wep.PenStr or eyetrace.MatType == MAT_SLOSH then
				return nil
			end

			local ent = eyetrace.Entity

			if IsValid(ent) and (ent:IsPlayer() or ent:IsNPC()) then
				return nil
			end
			
			return math.pow(wep.PenStr, 2) + (wep.PenStr * 0.25)
		end
	end

	return nil
end

local function canPenetrate()
	local wep = LocalPlayer():GetActiveWeapon()

	if IsValid(wep) then
		local eyetrace = getEyeTrace()

		if isBase(wep, "fas2") then
			local ent = eyetrace.Entity

			if IsValid(ent) and (ent:IsPlayer() or ent:IsNPC()) then
				return false
			end
		end

		local ammopen = getAmmoPen(wep) or -1

		cache.weapon.class = wep:GetClass()
		cache.weapon.pen = ammopen

		if not ammopen then
			return false
		end

		local eyepos = eyetrace.HitPos
		local forward = cache.eyeangles:Forward()
		local endtrace = nil
		local endpos = nil

		for i = 1, 75 do -- There's probably a better way of doing this but this is what I came up with so fuck you
			local cur = cache.eyepos + (forward * i)

			local tr = util.TraceLine({
				start = cur,
				endpos = cur
			})

			if not tr.HitWorld then
				endpos = cur
				endtrace = tr

				break
			end
		end

		if endpos then
			local decimals = string.Split(tostring(ammopen), ".")
			decimals = decimals[2] and #decimals[2] or 0

			if isBase(wep, "tfa") then
				return math.Round(eyepos:Distance(endpos) / 100, decimals) <= ammopen / 2
			end

			return math.Round(eyepos:DistToSqr(endpos), decimals) < ammopen
		end
	end

	return false
end

if meth_lua_api then
	meth_lua_api.callbacks.Add("OnHUDPaint", tostring({}), function()
		if not canRender() then
			return
		end

		local ogrt = render.GetRenderTarget()
		render.SetRenderTarget()
	
		render.SetMaterial(cache.materials.box)
	
		local eyetrace = getEyeTrace()
		local endpos = eyetrace.HitPos

		local penetrate = (endpos == cache.weapon.hitpos and (IsValid(LocalPlayer():GetActiveWeapon()) and LocalPlayer():GetActiveWeapon():GetClass() == cache.weapon.class)) and cache.weapon.lastpen or canPenetrate()

		cache.weapon.hitpos = endpos
		cache.weapon.lastpen = penetrate

		local col = penetrate and cache.colors.green or cache.colors.red

		cam.Start3D()
			render.DrawBox(endpos, angle_zero, cache.mins, cache.maxs, col)
			render.DrawWireframeBox(endpos, angle_zero, cache.mins, cache.maxs, col)
		cam.End3D()
	
		render.SetRenderTarget(ogrt)
	end)
else
	hook.Add("PreDrawEffects", tostring({}), function()
		local ogrt = render.GetRenderTarget()
		render.SetRenderTarget()
	
		render.SetMaterial(cache.materials.box)
	
		local eyetrace = getEyeTrace()
		local endpos = eyetrace.HitPos

		local penetrate = (endpos == cache.weapon.hitpos and (IsValid(LocalPlayer():GetActiveWeapon()) and LocalPlayer():GetActiveWeapon():GetClass() == cache.weapon.class)) and cache.weapon.lastpen or canPenetrate()

		cache.weapon.hitpos = endpos
		cache.weapon.lastpen = penetrate

		local col = penetrate and cache.colors.green or cache.colors.red
		
		render.DrawBox(endpos, angle_zero, cache.mins, cache.maxs, col)
		render.DrawWireframeBox(endpos, angle_zero, cache.mins, cache.maxs, col, true)
	
		render.SetRenderTarget(ogrt)
	end)
end

hook.Add("CalcView", tostring({}), function(ply, pos, ang)
	if not IsValid(ply) then
		return
	end

	cache.eyepos = pos
	cache.eyeangles = ang
end)
