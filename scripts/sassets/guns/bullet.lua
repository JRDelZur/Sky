bullet = {}
bullet.__index = bullet
local lg = love.graphics
function bullet:new(x, y, angle, world)
    self = setmetatable({}, bullet)
    --variables basicas de las balas
    self.x = x 
    self.y = y 
    self.xx = x
    self.yy = y
    self.w = 4
    self.h = 8
    self.speed = 450
    self.angle = angle
    self.atlas = lg.newImage('assets/Sprites/Gun/gun_txtatlas.png')
   	self.quadR = love.graphics.newQuad( 116, 0, 29, 11, self.atlas)
	self.quadL = love.graphics.newQuad( 145, 0, 29, 11, self.atlas)
    self.lifetime = 0
    --self.dirX = dirX
    --self.dirY = dirY
    self.world = world
    --collider
    self.collider = world:newRectangleCollider(self.x, self.y , self.h, self.w)
    self.collider:setFixedRotation(true)
    self.collider:setCollisionClass('Bullet')
    self.collider:setObject(self)
    --self.sprite = lg.newImage('assets/player/bullet/bullet.png')
    --self.sprite:setFilter('nearest')
    return self
end

function bullet:update(dt)
    self.x, self.y = self.collider:getPosition()
    --movimiento balas
    self.lifetime = self.lifetime + dt
    local vy = math.sin(self.angle) * (self.speed)
	local vx = math.cos(self.angle) * (self.speed)
    self.collider:setAngle(self.angle)
    self.collider:setLinearVelocity(vx, vy)
    --si salen de pantalla
end


function bullet:draw()
    --lg.draw(self.sprite, self.x, self.y, self.angle, 2, 2, 5, 2)
end