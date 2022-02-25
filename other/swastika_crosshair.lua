--[[
	https://github.com/awesomeusername69420/meth_tools
]]

local stuff = {
	color_red = Color(255, 0, 0),
	center = Vector(ScrW() / 2, ScrH() / 2, 0)
}

local function canRender()
	return not vgui.CursorVisible() and not gui.IsConsoleVisible() and not gui.IsGameUIVisible() and not LocalPlayer():IsTyping()
end

meth_lua_api.callbacks.Add("OnHUDPaint", "", function()
	if not canRender() then
		return
	end

	local center = stuff.center
	local x, y = center.x, center.y

	local ogrt = render.GetRenderTarget()
	render.SetRenderTarget()

	draw.NoTexture()
	surface.SetDrawColor(stuff.color_red)
	
	local matrix = Matrix()
	matrix:Translate(center)
	matrix:Rotate(Angle(0, math.NormalizeAngle(SysTime() * 50), 0))
	matrix:Translate(-center)

	cam.PushModelMatrix(matrix)
		surface.DrawLine(x, y - 12, x, y + 12)
		surface.DrawLine(x - 12, y, x + 12, y)
		surface.DrawLine(x, y - 12, x + 12, y - 12)
		surface.DrawLine(x, y + 12, x - 12, y + 12)
		surface.DrawLine(x - 12, y, x - 12, y - 12)
		surface.DrawLine(x + 12, y, x + 12, y + 12)
	cam.PopModelMatrix()

	render.SetRenderTarget(ogrt)
end)
