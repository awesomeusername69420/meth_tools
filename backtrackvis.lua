local pos = {}

hook.Add("HUDPaint", "", function()
	local flv = meth_lua_api.var.GetVarInt("Aimbot.Position Adjustment.Fake Latency") / 1000

	cam.Start3D()
		for j, p in pairs(pos) do
			if not j:IsValid() or not j:Alive() or j:GetObserverMode() ~= 0 or j:Team() == 1002 or j:GetColor().a == 0 then
				j = nil
				continue
			end
		
			for k, v in ipairs(p) do
				local ct = CurTime()
			
				if ct - v[2] < flv - 0.2 then
					continue
				end
			
				if ct - v[2] > flv then
					table.remove(p, k)
					continue
				end
				
				for _, h in ipairs(v[1]) do
					render.DrawWireframeBox(h.pos, h.ang, h.mins, h.maxs, Color(255, 255, 255, 255))
				end
			end
		end
	cam.End3D()
end)

hook.Add("Tick", "", function()
	for _, v in ipairs(player.GetAll()) do
		if v == LocalPlayer() then continue end
		
		if not pos[v] then
			pos[v] = {}
		end
		
		local ins = {}
		
		for i = 0, v:GetHitboxSetCount() - 1 do
			for ii = 0, v:GetHitBoxCount(i) - 1 do
				local bone = v:GetHitBoxBone(ii, i)
				
				if not bone then continue end
				
				local mins, maxs = v:GetHitBoxBounds(ii, i)
				
				if not mins or not maxs then continue end
				
				local bm = v:GetBoneMatrix(bone)
				
				if not bm then continue end
				
				local pos, ang = bm:GetTranslation(), bm:GetAngles()
				
				if not pos or not ang then continue end
				
				table.insert(ins, {
					["pos"] = pos,
					["ang"] = ang,
					["mins"] = mins,
					["maxs"] = maxs,
				})
			end
		end
		
		table.insert(pos[v], {ins, CurTime()})
	end
end)