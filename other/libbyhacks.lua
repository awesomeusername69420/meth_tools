--[[
	https://github.com/awesomeusername69420/meth_tools
	
	Todo:
		Auto detect minimum and maximum enterable values
]]

if meth_lua_api then
	mutil = meth_lua_api.util
end

local stor = {
	["group"] = nil,
	["canhp"] = false,
	["maxhp"] = 500,
	["canarmor"] = false,
	["maxarmor"] = 255,
	["canammo"] = false,
	["maxammo"] = 100,
}

local function hasAccessToCommand(cmd) -- Tests if the player can run a command
	if ULib then
		if ULib.ucl then
			if ULib.ucl.query then
				local access, accessTag = ULib.ucl.query(LocalPlayer(), cmd)
				
				return access or false
			end
		end
	end
	
	return false
end

timer.Create(tostring({}), 1, 0, function()
	local lname = LocalPlayer():GetName()

	-- Godmode

	if stor.canhp then
		if LocalPlayer():Health() < stor.maxhp then
			LocalPlayer():ConCommand("ulx hp \"" .. lname .. "\" " .. stor.maxhp)
		end
	end

	if stor.canarmor then
		if LocalPlayer():Armor() < stor.maxarmor then
			LocalPlayer():ConCommand("ulx armor \"" .. lname .. "\" " .. stor.maxarmor)
		end
	end
	
	-- Infinite ammo
	
	if stor.canammo then
		local wep = LocalPlayer():GetActiveWeapon()
		
		if IsValid(wep) then
			local ammotype = wep:GetPrimaryAmmoType()
			local maxclip = wep:GetMaxClip1()
			
			if ammotype ~= -1 and maxclip ~= -1 then
				if LocalPlayer():GetAmmoCount(ammotype) < maxclip then
					for i = 1, math.floor(maxclip / stor.maxammo) do
						LocalPlayer():ConCommand("ulx giveammo \"" .. lname .. "\" " .. stor.maxammo)
					end
					
					LocalPlayer():ConCommand("ulx giveammo \"" .. lname .. "\" " .. (maxclip % stor.maxammo))
				end
			end
		end
	end
end)

hook.Add("Tick", tostring({}), function()
	if mutil then -- Auto add/remove build mode people to friends
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

	if stor.group ~= LocalPlayer():GetUserGroup() then -- Update permissions & parameters
		stor.canhp = hasAccessToCommand("ulx hp")
		stor.canarmor = hasAccessToCommand("ulx armor")
		stor.canammo = hasAccessToCommand("ulx giveammo")
	
		-- Will exist later
		--stor.maxhp = getMaxInt("ulx hp")
		--stor.maxarmor = getMaxInt("ulx armor")
		--stor.maxammo = getMaxInt("ulx giveammo")
	
		stor.group = LocalPlayer():GetUserGroup()
	end
end)
