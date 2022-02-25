--[[
	https://github.com/awesomeusername69420/meth_tools

	Command(s):
		_swastika_length (number) 		-		Changes the length of the Swastika's lines
		_swastika_sspeed (number) 		-		Changes the speed of the Swastika's rotation
]]

local stuff = {
	color_red = Color(255, 0, 0),
	center = Vector(ScrW() / 2, ScrH() / 2, 0),
	convars = {
		length = CreateClientConVar("_swastika_length", 12, false, false, "Length of Swastika lines", 0),
		spin = CreateClientConVar("_swastika_sspeed", 5, false, false, "Speed of Swastika spinning", 0)
	}
}

local function canRender()
	return not vgui.CursorVisible() and not gui.IsConsoleVisible() and not gui.IsGameUIVisible() and not LocalPlayer():IsTyping()
end

if meth_lua_api then
	meth_lua_api.callbacks.Add("OnHUDPaint", "", function()
		if not canRender() then
			return
		end
	
		local length = stuff.convars.length:GetFloat()
		local center = stuff.center
		local x, y = center.x, center.y
	
		local ogrt = render.GetRenderTarget()
		render.SetRenderTarget()
	
		draw.NoTexture()
		surface.SetDrawColor(stuff.color_red)
		
		local matrix = Matrix()
		matrix:Translate(center)
		matrix:Rotate(Angle(0, math.NormalizeAngle(SysTime() * (stuff.convars.spin:GetFloat() * 10)), 0))
		matrix:Translate(-center)
	
		cam.PushModelMatrix(matrix)
			surface.DrawLine(x, y - length, x, y + length)
			surface.DrawLine(x - length, y, x + length, y)
			surface.DrawLine(x, y - length, x + length, y - length)
			surface.DrawLine(x, y + length, x - length, y + length)
			surface.DrawLine(x - length, y, x - length, y - length)
			surface.DrawLine(x + length, y, x + length, y + length)
		cam.PopModelMatrix()
	
		render.SetRenderTarget(ogrt)
	end)
else
	hook.Add("DrawOverlay", "", function()
		if not canRender() then
			return
		end
	
		local length = stuff.convars.length:GetFloat()
		local center = stuff.center
		local x, y = center.x, center.y
	
		local ogrt = render.GetRenderTarget()
		render.SetRenderTarget()
	
		draw.NoTexture()
		surface.SetDrawColor(stuff.color_red)
		
		local matrix = Matrix()
		matrix:Translate(center)
		matrix:Rotate(Angle(0, math.NormalizeAngle(SysTime() * (stuff.convars.spin:GetFloat() * 10)), 0))
		matrix:Translate(-center)
	
		cam.PushModelMatrix(matrix)
			surface.DrawLine(x, y - length, x, y + length)
			surface.DrawLine(x - length, y, x + length, y)
			surface.DrawLine(x, y - length, x + length, y - length)
			surface.DrawLine(x, y + length, x - length, y + length)
			surface.DrawLine(x - length, y, x - length, y - length)
			surface.DrawLine(x + length, y, x + length, y + length)
		cam.PopModelMatrix()
	
		render.SetRenderTarget(ogrt)
	end)
end
