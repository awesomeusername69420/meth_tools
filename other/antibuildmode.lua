--[[
	Adds people in build mode to meth's aimbot friends

	https://github.com/awesomeusername69420/meth_tools
]]

if meth_lua_api then
	mutil = meth_lua_api.util
end

timer.Create("bruh", 0.3, 0, function()
	if mutil then -- Auto add/remove build mode people to friends
		for _, v in ipairs(player.GetAll()) do
			if v == LocalPlayer() or not v:Alive() then
				continue
			end

			local ind = v:EntIndex()
		
			if v:GetNWBool("BuildMode", false) or v:GetNWBool("buildmode", false) or v:GetNWBool("_Kyle_Buildmode", false) then
				mutil.AddFriend(ind)
			else
				if mutil.IsFriend(ind) then
					mutil.DelFriend(ind)
				end
			end
		end
	end
end)
