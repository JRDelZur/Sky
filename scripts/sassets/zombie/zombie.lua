zombie = {}
zombie.__index = zombie
local anim8 = require 'libraries/anim8'
local lg = love.graphics
function zombie:new(x, y, world)
    lg.setDefaultFilter('nearest', 'nearest')
    self = setmetatable({}, zombie)
    self.x = x
    self.y = y
    self.speed = 300
    self.offSetX = 0
    self.spriteSheet = lg.newImage('assets/Sprites/Enemies/zombie/zombieSS.png')
    self.collider = world:newRectangleCollider(self.x, self.y, 12, 59)
    self.world = world
    self.collider:setCollisionClass('Zombie')
    self.collider:setFixedRotation(true)
    self.animations = {}
    self.grid = anim8.newGrid( 36, 60, self.spriteSheet:getWidth(),  self.spriteSheet:getHeight() )
    self.animations.left = anim8.newAnimation( self.grid('10-1', 2), 0.1 )
    self.animations.right = anim8.newAnimation( self.grid('1-10', 1), 0.1 )
    self.view = 'right'
    self.animations.actual = self.animations.right
    self.checkColliderR = world:newRectangleCollider(self.x, self.y, 400, 220)
    self.checkColliderR:setFixedRotation(true)
    self.checkColliderR:setCollisionClass('ZombieCheck')
    self.isCheckR = false
    self.checkColliderL = world:newRectangleCollider(self.x, self.y, 400, 220)
    self.checkColliderL:setFixedRotation(true)
    self.checkColliderL:setCollisionClass('ZombieCheck')
    self.isCheckL = false
    self.isIdle = true
    return self
end

function zombie:update(dt)
    local rvx, rvy = self.collider:getLinearVelocity()
    --comprobacion de comprobadores
    if self.checkColliderR:enter('Player') then
        self.isCheckR = true
    end
    if self.checkColliderL:enter('Player') then
        self.isCheckL = true
    end
    if self.checkColliderR:exit('Player') then
        self.isCheckR = false
    end
    if self.checkColliderL:exit('Player') then
        self.isCheckL = false
    end
    if self.isCheckL == false and self.isCheckR == false then
        self.isIdle = true
    else
        self.isIdle = false
    end

    --ajuste de vista segun los comprobadores
    if self.isCheckR == true then
        self.view = 'right'
        if rvx < 100 then
           self.collider:applyForce(self.speed, 0)
        end
    elseif self.isCheckL == true then
        self.view = 'left'
        if rvx > -100 then
           self.collider:applyForce(self.speed * -1, 0)
        end
    end
    --ajuste segun vista
    if self.view == 'right' then
        self.animations.actual = self.animations.right
        self.offSetX = 0
    elseif self.view == 'left' then
        self.animations.actual = self.animations.left
        self.offSetX = -5

    end
    print(rvx)

    self.x, self.y = self.collider:getPosition()
    self.animations.actual:update(dt)

    self.checkColliderR:setPosition(self.x + 200, self.y - 110 + 30)
    self.checkColliderL:setPosition(self.x - 200, self.y - 110 + 30)
end


function zombie:draw()
    self.animations.actual:draw(self.spriteSheet, self.x - 15 + self.offSetX, self.y - 29, nil, 1, 1)
end