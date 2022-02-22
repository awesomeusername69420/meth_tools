--[[
	https://github.com/awesomeusername69420/meth_tools
]]

local cache = {
	LocalPlayer = LocalPlayer(),
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

	colors = {
		green = Color(50, 180, 90, 100)
	},

	players = {}
}

local function shouldDraw(ply)
	if not IsValid(ply) then
		return false
	end

	return ply ~= cache.LocalPlayer and ply:Alive() and not ply:IsDormant() and not ply:GetNoDraw() and ply:GetObserverMode() == OBS_MODE_NONE and ply:Team() ~= TEAM_SPECTATOR and ply:GetColor().a > 0
end

local function getHeadPos(ply)
	if not IsValid(ply) then
		return vector_origin
	end

	local hbone = ply:LookupBone("ValveBiped.Bip01_Head1")
	
	if hbone then
		return ply:GetBoneMatrix(hbone):GetTranslation()
	end

	return ply:EyePos()
end

timer.Create(tostring({}), 0.3, 0, function()
	if not IsValid(cache.LocalPlayer) then
		cache.LocalPlayer = LocalPlayer()
	end

	cache.players = {}

	for _, v in ipairs(player.GetAll()) do
		if not shouldDraw(v) then
			continue
		end

		cache.players[#cache.players + 1] = v
	end
end)

if meth_lua_api then
	meth_lua_api.callbacks.Add("OnHUDPaint", tostring({}), function()
		local ogrt = render.GetRenderTarget()
		render.SetRenderTarget()
	
		cam.Start3D()
			render.SetMaterial(cache.materials.box)
	
			for _, v in ipairs(cache.players) do
				if not shouldDraw(v) then
					continue
				end
		
				local startpos = getHeadPos(v)
				local endpos = v:GetEyeTraceNoCursor().HitPos
	
				render.DrawLine(startpos, endpos, cache.colors.green)

				render.DrawBox(endpos, angle_zero, cache.mins, cache.maxs, cache.colors.green)
				render.DrawWireframeBox(endpos, angle_zero, cache.mins, cache.maxs, cache.colors.green)
			end
		cam.End3D()
	
		render.SetRenderTarget(ogrt)
	end)
else
	hook.Add("PreDrawEffects", tostring({}), function()
		local ogrt = render.GetRenderTarget()
		render.SetRenderTarget()
	
		cam.Start3D()
			render.SetMaterial(cache.materials.box)
	
			for _, v in ipairs(cache.players) do
				if not shouldDraw(v) then
					continue
				end
		
				local startpos = getHeadPos(v)
				local endpos = v:GetEyeTraceNoCursor().HitPos
	
				render.DrawLine(startpos, endpos, cache.colors.green, true)

				render.DrawBox(endpos, angle_zero, cache.mins, cache.maxs, cache.colors.green)
				render.DrawWireframeBox(endpos, angle_zero, cache.mins, cache.maxs, cache.colors.green, true)
			end
		cam.End3D()
	
		render.SetRenderTarget(ogrt)
	end)
end
