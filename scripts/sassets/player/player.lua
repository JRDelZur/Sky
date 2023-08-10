player = {}

function player:init(x, y, world)
    --variables basicas player
    self.x = x
    self.y = y
    self.world = world
    self.rjump = 0
    self.px = 0
    self.py = 0
    self.w = 64 
    self.h = 64 
    self.impulseForce = 2750 
    self.speed = 7000 
    --superjump
    self.sJump = {} --player.superjump
    self.sJump.status = false
    self.sJump.force = 2750 
    --onwall or onfloor
    self.downCheckOnWall = false
    self.leftCheckOnWall = false
    self.rightCheckOnWall = false
    --collider
    --          player    
    self.collider = world:newRectangleCollider(self.x, self.y, self.w, self.h)
    self.collider:setCollisionClass('Player')
    self.collider:setFixedRotation(true)
    --          checkdown
    self.downCheck = world:newRectangleCollider(self.x, self.y + self.h, self.w - 1, self.h / 5)
    self.downCheck:setCollisionClass('PDown')
    self.downCheck:setFixedRotation(true)
    --			checkleft
    self.leftCheck = world:newRectangleCollider(self.x - (self.w / 10), self.y + (self.h - (self.h / 5)), self.w / 10, self.h / 5)
    self.leftCheck:setCollisionClass('PLeft')
    self.leftCheck:setFixedRotation(true)
    --         checkright
    self.rightCheck = world:newRectangleCollider(self.x + (self.w / 10), self.y + (self.h - (self.h / 5)), self.w / 10, self.h / 5)
    self.rightCheck:setCollisionClass('PLeft')
    self.rightCheck:setFixedRotation(true)
    temporizador = 0
end


function player:update(dt)
	self.x, self.y = self.collider:getPosition()
	local px, py = self.collider:getLinearVelocity()
    self.px = px
    self.py = py
    self.rjump = self.rjump + dt
	--ajuste de downcheck
	self.downCheck:setX(self.x)
	self.downCheck:setY(self.y + ((self.h / 2) + ((self.h / 5) / 2)))
    --ajuste de leftcheck
	self.leftCheck:setX(self.x - ((self.w / 2) + ((self.w / 10) / 2)))
	self.leftCheck:setY((self.y + ((self.h / 2) - ((self.h / 5) / 2))) - 1)
    --ajuste de rightcheck
    self.rightCheck:setX(self.x + ((self.w / 2) + ((self.w / 10) / 2)))
    self.rightCheck:setY((self.y + ((self.h / 2) - ((self.h / 5) / 2))) - 1)

	--onfloor
	if self.downCheck:enter('Terrain') then --toca el piso
		self.downCheckOnWall = true
    end
    if self.downCheck:exit('Terrain') then --deja de tocar el piso
        self.downCheckOnWall = false
    end
    --onwallleft
    if self.leftCheck:enter('Terrain') then --toca el piso
		self.leftCheckOnWall = true
    end
    if self.leftCheck:exit('Terrain') then --deja de tocar el piso
        self.leftCheckOnWall = false
    end
        --onwallright
    if self.rightCheck:enter('Terrain') then --toca el piso
        self.rightCheckOnWall = true
    end
    if self.rightCheck:exit('Terrain') then --deja de tocar el piso
        self.rightCheckOnWall = false
    end
    --movimiento
    if love.keyboard.isDown('a') and px > -300 and not love.keyboard.isDown('s')then
    	self.collider:applyForce(self.speed * -1, 0)
        self.sJump.status = false
        self.sJump.force = 2750
    elseif love.keyboard.isDown('d') and px < 300 and not love.keyboard.isDown('s') then
    	self.collider:applyForce(self.speed, 0)
        self.sJump.status = false
        self.sJump.force = 2750
    elseif not love.keyboard.isDown('a') and not love.keyboard.isDown('d') and self.downCheckOnWall then
        self.collider:setLinearVelocity(0, py)
    end
    --superjump
    if love.keyboard.isDown('s') and love.keyboard.isDown('space') and self.downCheckOnWall == true then
        self.sJump.status = true
        self.sJump.force = self.sJump.force + (dt * 750)
        if self.sJump.force >= 4000 then
            self.sJump.force = 4000
        end
    end
    print(self.sJump.force)
end

function player:draw()

end

function player:keypressed(key)
	if self.downCheckOnWall == true and key == 'space' and not love.keyboard.isDown('s') then
        self.collider:applyLinearImpulse(0, self.impulseForce * -1)
        print('floor jump')
    elseif self.leftCheckOnWall == true and self.downCheckOnWall == false and self.rightCheckOnWall == false and key == 'space' and self.rjump >= 0.2 then
    	self.rjump = 0
        if not self.leftCheck:stay('Terrain') then
            self.leftCheckOnWall = false
        end
        self.collider:setLinearVelocity(self.px, 0)
        self.collider:applyLinearImpulse(2000 , self.impulseForce * -1)
    	print('sidewall jump')
    elseif self.leftCheckOnWall == false and self.downCheckOnWall == false and self.rightCheckOnWall == true and key == 'space' and self.rjump >= 0.2 then
        self.rjump = 0
        if not self.rightCheck:stay('Terrain') then
            self.rightCheckOnWall = false
        end
        self.collider:setLinearVelocity(self.px, 0)
        self.collider:applyLinearImpulse(2000 * -1, self.impulseForce * -1)
        print('sidewall jump')
    end
    print(key)
end


function player:keyreleased(key)


function love.keyreleased(key)
    if key == 'escape' then
        love.event.quit()
    end
    if key == 'space' and self.sJump.status == true then
        self.collider:applyLinearImpulse(0, self.sJump.force * -1)
        self.sJump.force = 2750
        self.sJump.status = false
    end
end 

end