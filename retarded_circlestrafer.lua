local table = table.Copy(table)

local Angle = Angle
local engine = table.Copy(engine)
local hook = table.Copy(hook)
local LocalPlayer = LocalPlayer
local math = table.Copy(math)
local util = table.Copy(util)
local Vector = Vector

local r = 1
local s = 0

hook.Add("CreateMove", "a", function(cmd)
	if cmd:CommandNumber() == 0 then
		return
	end

	local right = cmd:KeyDown(IN_MOVERIGHT)
	local left = cmd:KeyDown(IN_MOVELEFT)

	if right then
		r = 1
	end

	if left then
		r = -1
	end

	if (right or left) and cmd:KeyDown(IN_JUMP) then
		local vel = Vector(300, 300, 0)
		local spd = vel:Length2D()
		local lpos = LocalPlayer():GetPos()

		if spd < 45 then
			spd = 45
		end

		local rt = 5.9 + (spd / 1500) * 5
		local del = (275 / spd) * (2 / 5) * (128 / (1.7 / engine.TickInterval())) * rt
	
		local dela = r * math.min(del, 15)
		s = s + dela

		cmd:SetForwardMove(math.cos((s + 90 * r) * (math.pi / 180)) * 450)
		cmd:SetSideMove(math.sin((s + 90 * r) * (math.pi / 180)) * 450)
	else
		if s ~= 0 then
			s = 0
		end
	end
end)
