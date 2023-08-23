player = {}
local anim8 = require 'libraries/anim8'
function player:init(x, y, world)
    

    --Sprites
    self.spriteSheet = love.graphics.newImage('assets/Sprites/Player/playerSS.png')
    self.spriteSheet:setFilter('nearest')
    self.grid = anim8.newGrid( 32, 65, player.spriteSheet:getWidth(),  player.spriteSheet:getHeight() )

    self.animations = {}
    self.animations.a = anim8.newAnimation( player.grid('1-8', 3), 0.1 )
    self.animations.d = anim8.newAnimation( player.grid('1-8', 2), 0.1 )
    self.animations.stayR = anim8.newAnimation( player.grid('1-2', 1), 1 )
    self.animations.stayL = anim8.newAnimation( player.grid('3-4', 1), 1 )
    self.animations.stay = self.animations.stayR
    self.animations.actual = self.animations.stay
    
    --variables basicas player
    self.x = x
    self.y = y
    self.world = world
    self.rjump = 0
    self.view = 'left'
    self.px = 0
    self.py = 0
    self.w = 15 
    self.h = 60
    self.impulseForce = 600 
    self.speed = 500
    --superjump
    self.sJump = {} --player.superjump
    self.sJump.status = false
    self.sJump.force = 600 
    --onwall or onfloor
    self.downCheckOnWall = false
    --collider
    --          player    
    self.collider = world:newRectangleCollider(self.x, self.y, self.w, self.h)
    self.collider:setCollisionClass('Player')
    self.collider:setFixedRotation(true)
    --          checkdown
    self.downCheck = world:newRectangleCollider(self.x, self.y + self.h, self.w - 1, self.h / 5)
    self.downCheck:setCollisionClass('PDown')
    self.downCheck:setFixedRotation(true)

    temporizador = 0
end


function player:update(dt)
	self.x, self.y = self.collider:getPosition()
	local px, py = self.collider:getLinearVelocity()
    if self.view == 'left' then
        self.animations.stay = self.animations.stayL
    elseif self.view == 'right' then
        self.animations.stay = self.animations.stayR
    end
    self.animations.actual = self.animations.stay
    

    self.px = px
    self.py = py
    self.rjump = self.rjump + dt
	--ajuste de downcheck
	self.downCheck:setX(self.x)
	self.downCheck:setY(self.y + ((self.h / 2) + ((self.h / 5) / 2)))
	--onfloor
	if self.downCheck:enter('Terrain') then --toca el piso
		self.downCheckOnWall = true
    end
    if self.downCheck:exit('Terrain') then --deja de tocar el piso
        self.downCheckOnWall = false
    end
    --movimiento
    if love.keyboard.isDown('a') then
        if px > -200 then
    	   self.collider:applyForce(self.speed * -1, 0)
        end
        self.view = 'left'
        self.animations.actual = self.animations.a
    elseif love.keyboard.isDown('d') then
        if px < 200 then
    	   self.collider:applyForce(self.speed, 0)
        end
        self.view = 'right'
        self.animations.actual = self.animations.d
    elseif not love.keyboard.isDown('s') and not love.keyboard.isDown('d') and self.downCheckOnWall then
        self.collider:setLinearVelocity(0, py)
    end

    --superjump
    if love.keyboard.isDown('s') and love.keyboard.isDown('space') and self.downCheckOnWall == true then
        self.sJump.status = true
        self.sJump.force = self.sJump.force + (dt * 100)
        if self.sJump.force >= 775 then
            self.sJump.force = 775
        end
    end
    print(player.x, player.y)
    self.animations.actual:update(dt)
end

function player:draw()
    self.animations.actual:draw(self.spriteSheet, self.x - 15, self.y - 36, nil, 1)
end

function player:keypressed(key)
	if self.downCheckOnWall == true and key == 'space' and not love.keyboard.isDown('s') then
        self.collider:applyLinearImpulse(0, self.impulseForce * -1)
        print('floor jump')
    end
    print(key)
end


function player:keyreleased(key)
    if key == 'escape' then
        love.event.quit()
    end

end