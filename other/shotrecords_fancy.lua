local stuff = {
	boxmat = CreateMaterial("", "UnlitGeneric", { -- Default color material but with alpha
		["$alpha"] = 0.3,
		["$basetexture"] = "color/white",
		["$model"] = 1,
		["$translucent"] = 1,
		["$vertexalpha"] = 1,
		["$vertexcolor"] = 1
	}),

	hitboxes = {},
	colors = {
		red = Color(255, 0, 0)
	}
}

meth_lua_api.callbacks.Add("OnHUDPaint", "", function()
	local curtime = SysTime()
	local remove = {}

	cam.Start3D()
		render.SetMaterial(stuff.boxmat)

		for k, v in ipairs(stuff.hitboxes) do
			local spawn = v[2]

			if curtime - spawn > 3 then
				remove[#remove + 1] = k
				continue
			end

			for _, h in ipairs(v[1]) do
				render.DrawWireframeBox(h.pos, h.ang, h.mins, h.maxs, h.col)
				render.DrawBox(h.pos, h.ang, h.mins, h.maxs, h.col)
			end
		end
	cam.End3D()

	for _, v in ipairs(remove) do
		table.remove(stuff.hitboxes, v)
	end
end)

hook.Add("PlayerTraceAttack", "", function(ply, dinfo, dir, tr)
	local attacker = dinfo:GetAttacker()

	if not IsValid(attacker) or attacker ~= LocalPlayer() or ply == LocalPlayer() or ply == attacker then
		return
	end

	local hitboxes = {}

	for i = 0, ply:GetHitboxSetCount() - 1 do
		for ii = 0, ply:GetHitBoxCount(i) - 1 do
			local mins, maxs = ply:GetHitBoxBounds(ii, i)
			
			if not mins or not maxs then
				continue
			end
			
			local bone = ply:GetHitBoxBone(ii, i)
			
			if not bone then
				continue
			end

			local bm = ply:GetBoneMatrix(bone)

			if not bm then
				continue
			end

			local pos, ang = bm:GetTranslation(bm), bm:GetAngles()
			
			if not pos or not ang then
				continue
			end
			
			hitboxes[#hitboxes + 1] = {
				pos = pos,
				ang = ang,
				mins = mins,
				maxs = maxs,
				col = tr.HitGroup == ply:GetHitBoxHitGroup(ii, i) and stuff.colors.red or color_white
			}
		end
	end

	stuff.hitboxes[#stuff.hitboxes + 1] = {hitboxes, SysTime()}
end)
