if not meth_lua_api.callbacks then
	return
end

local hitboxmat = CreateMaterial("goweiggw", "UnlitGeneric", {
	["$alpha"] = 0.1,
	["$basetexture"] = "color/white",
	["$model"] = 1,
	["$translucent"] = 1,
	["$vertexalpha"] = 1,
	["$vertexcolor"] = 1
})

local function sortPly(a, b)
	if not a or not b then
		return false
	end
	
	local lpos = LocalPlayer():GetPos()
	
	return a:GetPos():Distance(lpos) > b:GetPos():Distance(lpos)
end

local function getPlayers()
	local players = {}

	for _, v in ipairs(player.GetAll()) do
		if v == LocalPlayer() or not v:Alive() or v:GetObserverMode() ~= 0 or v:Team() == TEAM_SPECTATOR or v:GetColor().a == 0 or v:IsDormant() or v:IsEffectActive(EF_NODRAW) then
			continue
		end
		
		table.insert(players, v)
	end
	
	table.sort(players, sortPly)
	
	return players
end

meth_lua_api.callbacks.Add("OnHUDPaint", "", function()
	cam.Start3D()
		render.SetMaterial(hitboxmat)
	
		for _, v in ipairs(getPlayers()) do
			local tcol = team.GetColor(v:Team() or 0) or Color(255, 255, 255, 65)
			local vpos = v:GetPos()
			
			for i = 0, v:GetHitboxSetCount() - 1 do
				for ii = 0, v:GetHitBoxCount(i) - 1 do
					local mins, maxs = v:GetHitBoxBounds(ii, i)
			
					if not mins or not maxs then
						continue
					end
					
					local bone = v:GetHitBoxBone(ii, i)
					
					if not bone then
						continue
					end	
					
					local pos, ang = v:GetBonePosition(bone)
					
					if pos == epos or (not pos or not ang) then
						local bm = v:GetBoneMatrix(bone)
						
						if not bm then
							continue
						end
						
						pos, ang = bm:GetTranslation(), bm:GetAngles()
						
						if not pos or not ang then
							continue
						end
					end
					
					render.DrawWireframeBox(pos, ang, mins, maxs, tcol)
					render.DrawBox(pos, ang, mins, maxs, tcol)
				end
			end
		end
	cam.End3D()
end)