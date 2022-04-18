--[[
	https://github.com/awesomeusername69420/meth_tools
]]

local colors = {
	[HITGROUP_HEAD] = Color(255, 120, 120),
	[HITGROUP_CHEST] = Color(120, 255, 120),
	[HITGROUP_STOMACH] = Color(255, 255, 120),
	[HITGROUP_LEFTARM] = Color(120, 120, 255),
	[HITGROUP_RIGHTARM] = Color(255, 120, 255),
	[HITGROUP_LEFTLEG] = Color(120, 255, 255),
	[HITGROUP_RIGHTLEG] = Color(255, 255, 255) -- color_white
}

local hitboxmat = CreateMaterial("goweiggw", "UnlitGeneric", {
	["$alpha"] = 0.1,
	["$basetexture"] = "color/white",
	["$model"] = 1,
	["$translucent"] = 1,
	["$vertexalpha"] = 1,
	["$vertexcolor"] = 1
})

local function ValidEntity(ent)
	if not IsValid(ent) then
		return false
	end

	if ent:GetClass() ~= "player" then
		return true
	end

	return ent ~= LocalPlayer() and ent:Alive() and ent:Team() ~= TEAM_SPECTATOR and ent:GetObserverMode() == 0 and not ent:IsDormant()
end

local function GetSortedPlayers()
	local ret = {}
	
	for _, v in ipairs(player.GetAll()) do
		if not ValidEntity(v) then
			continue
		end
		
		ret[#ret + 1] = v
	end
	
	local lpos = LocalPlayer():GetPos()
	
	table.sort(ret, function(a, b)
		return a:GetPos():DistToSqr(lpos) > b:GetPos():DistToSqr(lpos)
	end)
	
	return ret
end

meth_lua_api.callbacks.Add("OnHUDPaint", "", function()
	cam.Start3D()
		render.SetMaterial(hitboxmat)

		for _, v in ipairs(GetSortedPlayers()) do
			v:InvalidateBoneCache()
			v:SetupBones()

			for hitset = 0, v:GetHitboxSetCount() - 1 do
				for hitbox = 0, v:GetHitBoxCount(hitset) - 1 do
					local hitgroup = v:GetHitBoxHitGroup(hitbox, hitset)
		
					if not hitgroup then continue end -- Should be impossible but just in case
		
					local bone = v:GetHitBoxBone(hitbox, hitset)
					local mins, maxs = v:GetHitBoxBounds(hitbox, hitset)
		
					if not bone or not mins or not maxs then continue end
		
					local bmatrix = v:GetBoneMatrix(bone)
		
					if not bmatrix then continue end
		
					local pos, ang = bmatrix:GetTranslation(), bmatrix:GetAngles()
		
					if not pos or not ang then continue end
		
					render.DrawWireframeBox(pos, ang, mins, maxs, colors[hitgroup])
					render.DrawBox(pos, ang, mins, maxs, colors[hitgroup])
				end
			end
		end
	cam.End3D()
end)
