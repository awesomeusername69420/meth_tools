--[[
	https://github.com/awesomeusername69420/meth_tools

	Plays a sound when someone starts spectating you
]]

local people = {}

timer.Create(tostring({}), 0.1, 0, function()
	local lp = LocalPlayer()

	if not IsValid(lp) then return end

	for _, v in ipairs(player.GetAll()) do
		local id = v:SteamID64()

		if v == lp or v:GetObserverMode() == OBS_MODE_NONE then
			if people[id] then
				people[id] = false -- Old ones gtfo
			end

			continue
		end

		if v:GetObserverTarget() == lp then
			if not people[id] then
				surface.PlaySound("vo/k_lab/ba_careful01.wav") -- New spectator has arrived
				people[id] = true
			end
		end
	end
end)
