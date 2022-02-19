--[[
	https://github.com/awesomeusername69420/meth_tools
]]

local stuff = {
	boxmat = CreateMaterial("", "UnlitGeneric", { -- Default color material but with alpha
		["$alpha"] = 0.15,
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

meth_lua_api.callbacks.Add("OnHUDPaint", tostring({}), function()
	local curtime = SysTime()
	local remove = {}

	cam.Start3D()
		render.SetMaterial(stuff.boxmat)

		for k, v in ipairs(stuff.hitboxes) do
			if curtime - v[2] > 3 then
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

hook.Add("PlayerTraceAttack", tostring({}), function(ply, dinfo, dir, tr)
	local attacker = dinfo:GetAttacker()
	local tick = engine.TickCount()

	if not IsValid(attacker) or attacker ~= LocalPlayer() or ply == LocalPlayer() or ply == attacker or (ply._ShotTick == tick) then
		if tr.HitGroup ~= 0 then
			for _, v in ipairs(stuff.hitboxes) do
				if v[3] == ply and v[4] == tick then
					for _, h in ipairs(v[1]) do
						if h.hitbox == tr.HitBox then
							h.col = stuff.colors.red
						end
					end
				end
			end
		end

		return
	end

	ply._ShotTick = tick

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
				hitbox = ii,
				col = (tr.HitGroup ~= 0 and tr.HitBox == ii) and stuff.colors.red or color_white
			}
		end
	end

	stuff.hitboxes[#stuff.hitboxes + 1] = {hitboxes, SysTime(), ply, tick}

	timer.Simple(0, function()
		if IsValid(ply) then
			ply._ShotTick = nil
		end
	end)
end)
