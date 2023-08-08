player = {}

function player:init(x, y, world, scaleF)
    --variables basicas player
    self.x = x
    self.y = y
    self.world = world

    
    self.scaleF = scaleF
    self.w = 30 * self.scaleF
    self.h = 30 * self.scaleF
    self.impulseForce = 500
    self.speed = 500
    self.downCheckOnWall = false
    self.leftCheckOnWall = false
    --collider
    --          player    
    self.collider = world:newRectangleCollider(self.x, self.y, self.w, self.h)
    self.collider:setCollisionClass('Player')
    self.collider:setFixedRotation(true)
    --          checkdown
    self.downCheck = world:newRectangleCollider(self.x, self.y + self.h, self.w / 1.2, self.h / 5)
    self.downCheck:setCollisionClass('PDown')
    --			checkleft
    self.leftCheck = world:newRectangleCollider(self.x - (self.w / 3), self.y + (self.h - (self.h / 5)), self.w / 3, self.h / 5)
    self.leftCheck:setCollisionClass('PLeft')

    self.leftCheck:setFixedRotation(true)
end


function player:update(dt)
	self.x, self.y = self.collider:getPosition()
	local px, py = self.collider:getLinearVelocity()
	--ajuste de downcheck
	self.downCheck:setX(self.x)
	self.downCheck:setY(self.y + ((self.h / 2) + ((self.h / 5) / 2)))
	self.leftCheck:setX(self.x - (self.w / 3) - (self.w / 3))
	self.leftCheck:setY(self.y + ((self.h / 2) - ((self.h / 5) / 2)))

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
    --print(self.leftCheckOnWall)
    --movimiento
    if love.keyboard.isDown('a') and px > -300 then
    	self.collider:applyForce(self.speed * -1, 0)
    	self.collider:applyForce(self.speed * 0.2, 0)
    elseif love.keyboard.isDown('d') and px < 300 then
    	self.collider:applyForce(self.speed, 0)
    	self.collider:applyForce(-self.speed * 0.2, 0)
    end
end

function player:draw()
	--lg.rectangle('line', self.x, self.y, self.w, self.h)
end

function player:keypressed(key)
	if self.downCheckOnWall == true and key == 'space' then
        self.collider:applyLinearImpulse(0, self.impulseForce * -1)
        print('floor jump')
    end
    if self.leftCheckOnWall == true and self.downCheckOnWall == false and key == 'space' then
    	self.collider:applyLinearImpulse(300, self.impulseForce * -1)
    	print('sidewall jump')
    end
end