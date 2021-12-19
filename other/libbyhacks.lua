--[[
	https://github.com/awesomeusername69420/meth_tools
]]

if meth_lua_api then
	mutil = meth_lua_api.util
end

local stor = {
	["group"] = nil,
	["maxhp"] = 100,
	["maxarmor"] = 100,
	["maxammo"] = 100,
}

local function getMaxInt(cmd) -- Get maximum value from ULX command
	if ULib then
		if ULib.cmds then
			if ULib.cmds.translatedCmds then
				for k, v in pairs(ULib.cmds.translatedCmds) do
					if k == cmd then
						if v.args then
							if v.args[3] then
								return v.args[3].max or 100
							end
						end
					end
				end
			end
		end
	end
	
	return 100
end

timer.Create(tostring({}), 1, 0, function()
	local lname = LocalPlayer():GetName()

	-- Godmode

	if LocalPlayer():Health() < stor.maxhp then
		LocalPlayer():ConCommand("ulx hp \"" .. lname .. "\" " .. stor.maxhp)
	end

	if LocalPlayer():Armor() < stor.maxarmor then
		LocalPlayer():ConCommand("ulx armor \"" .. lname .. "\" " .. stor.maxarmor)
	end
	
	-- Infinite ammo
	
	local wep = LocalPlayer():GetActiveWeapon()
	
	if IsValid(wep) then
		local ammotype = wep:GetPrimaryAmmoType()
		
		if ammotype ~= -1 then
			if  LocalPlayer():GetAmmoCount(ammotype) < stor.maxammo then
				LocalPlayer():ConCommand("ulx giveammo \"" .. lname .. "\" " .. stor.maxammo)
			end
		end
	end
end)

-- Auto add/remove build mode people to friends

hook.Add("Tick", tostring({}), function()
	if mutil then
		for _, v in ipairs(player.GetAll()) do
			local ind = v:EntIndex()
		
			if v:GetNWBool("buildmode") then
				mutil.AddFriend(ind)
			else
				if mutil.IsFriend(ind) then
					mutil.DelFriend(ind)
				end
			end
		end
	end
	
	if stor.group ~= LocalPlayer():GetUserGroup() then
		stor.maxhp = getMaxInt("ulx hp")
		stor.maxarmor = getMaxInt("ulx armor")
		stor.maxammo = getMaxInt("ulx giveammo")
	
		stor.group = LocalPlayer():GetUserGroup()
	end
end)
