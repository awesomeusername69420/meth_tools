--[[
	https://github.com/awesomeusername69420/meth_tools
]]

local cache = {
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
			arccw = GetConVar("arccw_enable_penetration"),
			m9k = GetConVar("M9KDisablePenetration"),
			tfa = GetConVar("sv_tfa_bullet_penetration"),
			tfa_mul = GetConVar("sv_tfa_bullet_penetration_power_mul")
		}
	},

	colors = {
		green = Color(50, 180, 90, 100),
		red = Color(255, 0, 0, 100),
	}
}

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
	if IsValid(wep) then
		local ammotype = wep:GetPrimaryAmmoType()

		if not ammotype then
			return nil
		end

		local gameammo = game.GetAmmoName(ammotype)

		if not gameammo then
			return nil
		end

		local eyetrace = LocalPlayer():GetEyeTrace()

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

			return (gafm(wep) / gpm(wep, eyetrace.MatType)) * mul
		end

		if isBase(wep, "arccw") then
			if cache.penetration.convars.arccw and not cache.penetration.convars.arccw:GetBool() then
				return nil
			end

			return math.pow(wep.Penetration or math.huge, 2)
		end
	end

	return nil
end

local function canPenetrate()
	local wep = LocalPlayer():GetActiveWeapon()

	if IsValid(wep) then
		local ammopen = getAmmoPen(wep) or -1

		if not ammopen then
			return false
		end

		local eyetrace = LocalPlayer():GetEyeTrace()
		local eyepos = eyetrace.HitPos
		local forward = LocalPlayer():EyeAngles():Forward()
		local endtrace = nil
		local endpos = nil

		for i = 1, 1000 do -- There's probably a better way of doing this but this is what I came up with so fuck you
			local cur = eyepos + (forward * i)

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
			if isBase(wep, "tfa") then
				return eyepos:Distance(endpos) / 100 <= ammopen / 2
			end

			return math.Round(eyepos:DistToSqr(endpos)) < ammopen
		end
	end

	return false
end

if meth_lua_api then
	meth_lua_api.callbacks.Add("OnHUDPaint", "", function()
		local ogrt = render.GetRenderTarget()
		render.SetRenderTarget()
	
		render.SetMaterial(cache.materials.box)
	
		local col = canPenetrate() and cache.colors.green or cache.colors.red
		local endpos = LocalPlayer():GetEyeTrace().HitPos
	
		render.DrawBox(endpos, angle_zero, cache.mins, cache.maxs, col)
		render.DrawWireframeBox(endpos, angle_zero, cache.mins, cache.maxs, col, true)
	
		render.SetRenderTarget(ogrt)
	end)
else
	hook.Add("PreDrawEffects", "", function()
		local ogrt = render.GetRenderTarget()
		render.SetRenderTarget()
	
		render.SetMaterial(cache.materials.box)
	
		local col = canPenetrate() and cache.colors.green or cache.colors.red
		local endpos = LocalPlayer():GetEyeTrace().HitPos
	
		render.DrawBox(endpos, angle_zero, cache.mins, cache.maxs, col)
		render.DrawWireframeBox(endpos, angle_zero, cache.mins, cache.maxs, col, true)
	
		render.SetRenderTarget(ogrt)
	end)
end
