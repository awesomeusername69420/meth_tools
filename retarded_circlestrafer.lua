local table = table.Copy(table)

local bit = table.Copy(bit)
local concommand = table.Copy(concommand)
local debug = table.Copy(debug)
local engine = table.Copy(engine)
local hook = table.Copy(hook)
local input = table.Copy(input)
local LocalPlayer = LocalPlayer
local math = table.Copy(math)
local tobool = tobool
local tonumber = tonumber

local meta_cd = debug.getregistry()["CUserCmd"]
local meta_en = debug.getregistry()["Entity"]
local meta_pl = debug.getregistry()["Player"]
local meta_vc = debug.getregistry()["Vector"]

local IN_JUMP = 2
local IN_MOVELEFT = 512
local IN_MOVERIGHT = 1024
local KEY_SPACE = 65
local MOVETYPE_LADDER = 9
local MOVETYPE_NOCLIP = 8
local MOVETYPE_OBSERVER = 10

--

local ismeth = false

if meth_lua_api then
	ismeth = true
end

local vars = {
	["ahop"] = false,
	["astrafe"] = false,
	["csize"] = 5,
	["shouldstrafe"] = true,
}

--

local r = 1
local s = 0
local isstrafe = false

hook.Add("CreateMove", "", function(cmd)
	if meta_cd.CommandNumber(cmd) == 0 then
		return
	end

	local mvtyp = meta_en.GetMoveType(LocalPlayer()) or 0
	local v = meta_pl.GetVehicle(LocalPlayer()) or nil

	if mvtyp ~= MOVETYPE_LADDER and mvtyp ~= MOVETYPE_NOCLIP and mvtyp ~= MOVETYPE_OBSERVER and meta_en.WaterLevel(LocalPlayer()) == 0 and not meta_en.IsValid(v) then
		local j = meta_cd.KeyDown(cmd, IN_JUMP)

		if ismeth then
			j = input.IsKeyDown(KEY_SPACE)
		end
	
		local right = meta_cd.KeyDown(cmd, IN_MOVERIGHT)
		local left = meta_cd.KeyDown(cmd, IN_MOVELEFT)
	
		if right then
			r = 1
		end
	
		if left then
			r = -1
		end

		if vars["ahop"] and j and not meta_en.IsOnGround(LocalPlayer()) then
			meta_cd.SetButtons(cmd, bit.band(meta_cd.GetButtons(cmd), bit.bnot(IN_JUMP)))
		end
	
		if vars["astrafe"] and not meta_en.IsOnGround(LocalPlayer()) and not isstrafe then
			if meta_cd.GetMouseX(cmd) > 0 then
				meta_cd.SetSideMove(cmd, 10^4)
			elseif meta_cd.GetMouseX(cmd) < 0 then
				meta_cd.SetSideMove(cmd, 0 - 10^4)
			end
		end

		if vars["shouldstrafe"] and (right or left) and j then
			isstrafe = true
	
			local vel = meta_en.GetVelocity(LocalPlayer())
			local spd = meta_vc.Length2D(vel)
	
			if spd < 300 then
				spd = 300
			end
	
			local rt = 5.9 + (spd / 1500) * 5
			local del = (275 / spd) * (2 / vars["csize"]) * (128 / (1.7 / engine.TickInterval())) * rt
		
			local dela = r * math.min(del, 15)
			s = s + dela
	
			meta_cd.SetForwardMove(cmd, math.cos((s + 90 * r) * (math.pi / 180)) * 450)
			meta_cd.SetSideMove(cmd, math.sin((s + 90 * r) * (math.pi / 180)) * 450)
		else
			if isstrafe then
				s = 0
				isstrafe = false
			end
		end
	end
end)

--

concommand.Add("r_cs_size", function(p, c, args)
	if not args[1] then
		args[1] = 5
	end

	vars["csize"] = tonumber(args[1])
end)

concommand.Add("r_cs_ahop", function(p, c, args)
	if not args[1] then
		args[1] = false
	end

	vars["ahop"] = tobool(args[1])
end)

concommand.Add("r_cs_astrafe", function(p, c, args)
	if not args[1] then
		args[1] = false
	end

	vars["astrafe"] = tobool(args[1])
end)

concommand.Add("r_cs_toggle", function()
	vars["shouldstrafe"] = not vars["shouldstrafe"]
end)
