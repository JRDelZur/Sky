gamepad = {}
local tb = require 'libraries/touchbuttons'
local lg = love.graphics
function gamepad:load()
	lg.setDefaultFilter('nearest', 'nearest')
	self.moves = {}
	--JOYSTICK
	self.moves.joystickX = love.graphics.getWidth() - 125
	self.moves.joystickY = love.graphics.getHeight() - 80
	self.moves.joystickImage = lg.newImage('assets/Sprites/Ui/joystick.png')
	self.moves.joystickAreImage = lg.newImage('assets/Sprites/Ui/joyare.png')
	self.moves.joystick = tb:newJoystick( self.moves.joystickX, self.moves.joystickY, 75, 'touch')
	self.moves.joystickPressed = false 
	self.moves.joystickAngle = 0
	--UI
	self.ui = {}
	self.ui.isDamaged = false
	self.ui.live = lg.newImage('assets/Sprites/Ui/live.png')
	self.ui.lives = 0
	self.ui.icons = lg.newImage('assets/Sprites/Ui/iconsatlas.png')
	self.ui.icon = self.ui.iconH
	self.ui.iconH = love.graphics.newQuad( 0, 0, 25, 29, self.ui.icons)
	self.ui.iconT = love.graphics.newQuad( 25, 0, 25, 29, self.ui.icons)
	self.moves.atlas = lg.newImage('assets/Sprites/Ui/controlsatlas.png')
	--BOTON IZQUIERDO
	self.moves.left = {}

	self.moves.left.x = 50
	self.moves.left.y = lg.getHeight() - 140
	self.moves.left.button = tb:newRectangleButton( self.moves.left.x, self.moves.left.y, 90, 90, 'touch')
	
	self.moves.left.quadP = love.graphics.newQuad( 84, 0, 14, 14, self.moves.atlas)
	self.moves.left.quadNP = love.graphics.newQuad( 98, 0, 14, 14, self.moves.atlas)
	self.moves.left.quad = self.moves.left.quadP
	--BOTON DERECHO

	self.moves.right = {}
	self.moves.right.x = 50 + 90 + 50
	self.moves.right.y = lg.getHeight() - 140
	self.moves.right.button = tb:newRectangleButton(self.moves.right.x, self.moves.right.y, 90, 90, 'touch')
	
	self.moves.right.quadP = love.graphics.newQuad( 0, 0, 14, 14, self.moves.atlas)
	self.moves.right.quadNP = love.graphics.newQuad( 14, 0, 14, 14, self.moves.atlas)
	self.moves.right.quad = self.moves.right.quadP

	--BOTON DE SALTO
	self.moves.jump = {}
	self.moves.jump.x = lg.getWidth() - 100
	self.moves.jump.y = lg.getHeight() - 250
	self.moves.jump.button = tb:newRectangleButton(self.moves.jump.x, self.moves.jump.y , 90, 90, 'touch')
	
	self.moves.jump.quadP = love.graphics.newQuad( 112, 0, 14, 14, self.moves.atlas)
	self.moves.jump.quadNP = love.graphics.newQuad( 126, 0, 14, 14, self.moves.atlas)
	self.moves.jump.quad = self.moves.jump.quadP

	self.moves.dir = 0
	self.moves.isJumping = false
end

function gamepad:update(dt)
	self.moves.dir = 0
	self.moves.right.quad = self.moves.right.quadP
	self.moves.left.quad = self.moves.left.quadP
	self.moves.jump.quad = self.moves.jump.quadP

	if self.moves.left.button:checkPressed() then
		self.moves.dir = -1
		self.moves.left.quad = self.moves.left.quadNP
	elseif self.moves.right.button:checkPressed() then
		self.moves.dir = 1
		self.moves.right.quad = self.moves.right.quadNP
	end
	if self.moves.jump.button:checkPressed() then

		self.moves.jump.quad = self.moves.jump.quadNP
		self.moves.isJumping = true
	else
		self.moves.isJumping = false
	end

	if self.ui.isDamaged == false then
		self.ui.icon = self.ui.iconH
	else
		self.ui.icon = self.ui.iconT
	end

	self.moves.joystickPressed = self.moves.joystick:checkPressed()
	self.moves.joystickAngle = self.moves.joystick:getJoystickAngle()

	self.moves.joystick:update(dt)
end

function gamepad:draw()
	lg.draw(self.ui.icons, self.ui.icon, 50, 30, 0, 3, 3)
	lg.setColor(255, 255, 255, 0.7)
	lg.draw(self.moves.atlas, self.moves.left.quad, self.moves.left.button:getX(), self.moves.left.button:getY(), 0, 6.4, 6.4)
	lg.draw(self.moves.atlas, self.moves.right.quad, self.moves.right.button:getX(), self.moves.right.button:getY(), 0, 6.4, 6.4)
	lg.draw(self.moves.atlas, self.moves.jump.quad, self.moves.jump.button:getX(), self.moves.jump.button:getY(), 0, 6.4, 6.4)
	lg.draw(self.moves.joystickAreImage, self.moves.joystick:getX() - 75, self.moves.joystick:getY() - 75, 0, 3, 3)
	lg.draw(self.moves.joystickImage, self.moves.joystick.mouseX - 24, self.moves.joystick.mouseY - 24, 0, 3, 3)
	lg.setColor(255, 255, 255, 1)
	for i = 1, self.ui.lives do
		lg.draw(self.ui.live, 125 + i * (5 * 3) , 60, 0, 3, 3)
	end

end