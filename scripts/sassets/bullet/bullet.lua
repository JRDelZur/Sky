bulletE = {}
bulletE.__index = bulletE
local lg = love.graphics
function bulletE:new(x, y, angle, world, dirX, dirY, damage, skin, view)
    self = setmetatable({}, bulletE)
    --variables basicas de las balas
    self.x = x 
    self.y = y 
    self.xx = x
    self.yy = y
    self.w = 8
    self.h = 16
    self.damage = damage
    self.class = nil
    self.speed = 450
    self.skin = skin --1 = vampiro, 2 = espora
    self.dirX = dirX
    self.dirY = dirY
    self.angle = angle
    self.view = view

    self.time = 0
    --self.dirX = dirX
    --self.dirY = dirY
    self.world = world
    --collider
    self.collider = world:newRectangleCollider(self.x, self.y , self.h, self.w)
    self.collider:setFixedRotation(true)
    self.sprite = lg.newImage('assets/Sprites/Bullet/bullet.png')
    if self.skin == 1 then
        self.quad = love.graphics.newQuad( 0, 0, 13, 13, self.sprite )
    elseif self.skin == 2 then
        self.quad = love.graphics.newQuad( 13, 0, 13, 13, self.sprite )
    end
    if self.damage == 1 then
        if self.dirX > 0 then
            if self.skin == 1 then
                self.class = 'Danger1R'
            elseif self.skin == 2 then
                --self.class = 'SDanger1R'
            end
        elseif self.dirX < 0 then
            if self.skin == 1 then
                self.class = 'Danger1L'
            elseif self.skin == 2 then
                --self.class = 'SDanger1L'
            end
        end
        if self.skin == 2 then
            if self.view == 'right' then
                self.class = 'SDanger1R'
            elseif self.view == 'left' then
                self.class = 'SDanger1L'
            end
        end
    end
    self.collider:setCollisionClass(self.class)
    self.collider:setObject(bulletE)

   	self.sprite:setFilter('nearest')
    love.math.setRandomSeed(os.time())
    return self
end

function bulletE:update(dt)
    if self.skin == 1 then
        self.x, self.y = self.collider:getPosition()
        --movimiento balas

        self.collider:setAngle(self.angle)
        self.collider:setLinearVelocity(self.dirX, self.dirY)
        --si salen de pantalla
    elseif self.skin == 2 then
        local vx, vy = self.collider:getLinearVelocity()
        self.x, self.y = self.collider:getPosition()
        if self.time <= 0.1 then
            
            self.collider:setLinearVelocity(self.dirX, -200)

        elseif self.time <= 2 then
            if self.view == 'right' then 
                local vx = love.math.random(10, 59)
                self.collider:setLinearVelocity( self.dirX + vx, 0)
            end
            if self.view == 'left' then 
                local vx = love.math.random(10, 59)
                self.collider:setLinearVelocity( self.dirX + (vx * -1), 0)
            end
        end

    end
end


function bulletE:draw()
    lg.draw(self.sprite, self.quad, self.x , self.y, self.angle, 1, 1, 6.5, 6.5)
end