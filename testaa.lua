-- Localization

local table = table.Copy(table)

local concommand = table.Copy(concommand)
local debug = table.Copy(debug)
local hook = table.Copy(hook)
local input = table.Copy(input)
local ipairs = ipairs
local istable = istable
local IsValid = IsValid
local LocalPlayer = LocalPlayer
local math = table.Copy(math)
local player = table.Copy(player)
local tobool = tobool
local tostring = tostring

local cmd = debug.getregistry()["CUserCmd"]

local methapi = meth_lua_api or nil
local mvar = nil

if methapi then
	if istable(methapi) then
		if methapi.var then
			mvar = methapi.var
		end
	end
end

if not mvar then
	return
end

-- Variables

local vars = {
	["autodir"] = false,
	["aajitter"] = true,
	["fljitter"] = true,
	["snapback"] = true,
}

-- Function things

local function sortPlayer(a, b)
	if not a or not b then
		return false
	end

	return a:GetPos():Distance(LocalPlayer():GetPos()) < b:GetPos():Distance(LocalPlayer():GetPos())
end

local function orderedPlayerList()
	local ply = {}

	for _, v in ipairs(player.GetAll()) do
		if not IsValid(v) then
			continue
		end

		table.insert(ply, v)
	end

	table.sort(ply, sortPlayer)

	return ply
end

-- Setup

mvar.SetVarInt("General.Options.Yaw", 2)
mvar.SetVarInt("General.Options.Fake Yaw", 6)

local function faa()
	local yp = "General.Options.Yaw"
	local aayaw = mvar.GetVarInt(yp)	

	if aayaw == 0 or aayaw == 1 then
		mvar.SetVarInt(yp, 4)
	elseif aayaw == 2 then
		mvar.SetVarInt(yp, 3)
	elseif aayaw == 3 then
		mvar.SetVarInt(yp, 2)
	else
		mvar.SetVarInt(yp, 1)
	end
end

hook.Add("CreateMove", "", function(ccmd)
	if cmd.CommandNumber(ccmd) == 0 then
		return
	end

	local base = 0
	local aayaw = mvar.GetVarInt("General.Options.Yaw") or 0

	if aayaw == 0 or aayaw == 1 then
		base = 0
	elseif aayaw == 2 then
		base = 90
	elseif aayaw == 3 then
		base = -90
	elseif aayaw == 4 then
		base = 180
	elseif aayaw == 6 then
		base = mvar.GetVarFloat("Custom.Config.Fake Jitter Angle 1")
	end

	if vars["autodir"] then
		for _, v in ipairs(orderedPlayerList()) do
			if v == LocalPlayer() or not (IsValid(v) and v:Alive() and not v:IsDormant()) then
				continue
			end

			local nbase = (v:GetPos() - LocalPlayer():GetPos()):Angle() - LocalPlayer():EyeAngles()

			base = nbase.yaw
			break
		end
	end

	local n = base + 180

	if vars["aajitter"] then
		n = (base + 180) + math.random(-80, 80)
	end

	if vars["snapback"] then
		if math.random(0, 100) > 90 then
			local c = 1

			if math.random(0, 10) > 5 then
				c = -1
			end

			n = base + (math.random(30, 45) * c)
		end
	end

	mvar.SetVarFloat("Custom.Config.Jitter Angle 1", n)
	mvar.SetVarFloat("Custom.Config.Jitter Angle 2", n)

	if vars["fljitter"] then
		mvar.SetVarInt("General.Options.Fake Lag", math.random(1, 8))
	end
end)

-- Cmds

concommand.Add("testaa_snapback", function(p, c, args)
	if not args[1] then
		args[1] = false
	end

	vars["snapback"] = tobool(args[1])
end)

concommand.Add("testaa_lagjitter", function(p, c, args)
	if not args[1] then
		args[1] = false
	end

	vars["fljitter"] = tobool(args[1])
end)

concommand.Add("testaa_jitter", function(p, c, args)
	if not args[1] then
		args[1] = false
	end

	vars["aajitter"] = tobool(args[1])
end)

concommand.Add("testaa_autodir", function(p, c, args)
	if not args[1] then
		args[1] = false
	end

	vars["autodir"] = tobool(args[1])
end)

concommand.Add("testaa_invert", function()
	faa()
end)
