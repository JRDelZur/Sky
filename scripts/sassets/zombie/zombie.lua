zombie = {}
zombie.__index = zombie
local anim8 = require 'libraries/anim8'
local lg = love.graphics
function zombie:new(x, y, world)
    lg.setDefaultFilter('nearest', 'nearest')
    self = setmetatable({}, zombie)
    self.x = x
    self.y = y
    self.speed = 375
    self.offSetX = 0
    self.live = 3
    self.living = true
    self.ltimer = 0
    self.uFinished = false
    self.dFinished = false
    self.dAlpha = 1
    self.isAttack = false
    self.isATMove = true
    self.isAttackAnim = false
    self.isWalking = false
    self.spriteSheet = lg.newImage('assets/Sprites/Enemies/zombie/zombieSS.png')
    self.collider = world:newRectangleCollider(self.x, self.y, 12, 59)
    self.world = world
    self.collider:setCollisionClass('Zombie')
    self.collider:setFixedRotation(true)
    self.animations = {}
    self.grid = anim8.newGrid( 36, 60, self.spriteSheet:getWidth(),  self.spriteSheet:getHeight() )
    self.animations.left = anim8.newAnimation( self.grid('10-1', 3), 0.075 )
    self.animations.right = anim8.newAnimation( self.grid('1-10', 2), 0.075 )
    self.animations.deadR = anim8.newAnimation( self.grid('1-6', 4), 0.085 )
    self.animations.deadL = anim8.newAnimation( self.grid('6-1', 5), 0.085 )
    self.animations.idleL = anim8.newAnimation( self.grid('4-3', 1), 1 )
    self.animations.idleR = anim8.newAnimation( self.grid('1-2', 1), 1 )
    self.animations.attackL = anim8.newAnimation( self.grid('8-1', 7), 0.1 )
    self.animations.attackR = anim8.newAnimation( self.grid('1-8', 6), 0.1 )
    self.view = 'right'
    self.animations.actual = self.animations.right
    self.checkColliderR = world:newRectangleCollider(self.x, self.y, 400, 220)
    self.checkColliderHead = world:newRectangleCollider(self.x, self.y - 5, 12, 5)
    self.checkDangerColliderR = world:newRectangleCollider(self.x + (59 * 2), self.y, 20, 50)
    

    self.checkColliderR:setFixedRotation(true)
    self.checkColliderR:setCollisionClass('ZombieCheck')
    self.isCheckR = false
    self.checkColliderL = world:newRectangleCollider(self.x - 59, self.y, 400, 220)
    self.checkDangerColliderL = world:newRectangleCollider(self.x, self.y, 20, 50)
    self.checkColliderL:setFixedRotation(true)
    self.checkDangerColliderR:setCollisionClass('ZombieCheck')
    self.checkDangerColliderL:setCollisionClass('ZombieCheck')
    self.checkDangerColliderL:setFixedRotation(true)
    self.checkDangerColliderR:setFixedRotation(true)
    self.checkColliderHead:setFixedRotation(true)
    self.checkColliderHead:setCollisionClass('ZombieCheck')
    self.checkColliderL:setCollisionClass('ZombieCheck')
    self.isCheckL = false
    self.isCheckDL = false
    self.isCheckDR = false
    self.isIdle = true

    self.aTimer = 0
    self.cooldown = 1.15
    self.dangers = {}
    return self
end

function zombie:update(dt)
    if not self.collider:isDestroyed() then
        self.aTimer = self.aTimer + dt
        self.cooldown = self.cooldown + dt
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
            if rvx < 125 and self.isAttack == false and self.isATMove == true then
               self.collider:applyForce(self.speed, 0)
               self.isWalking = true
            end
        elseif self.isCheckL == true then
            self.view = 'left'
            if rvx > -125 and self.isAttack == false and self.isATMove == true then
               self.collider:applyForce(self.speed * -1, 0)
               self.isWalking = true
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

        if self.isWalking == false then
            if self.view == 'right' then
                self.animations.actual = self.animations.idleR
            elseif self.view == 'left' then
                self.animations.actual = self.animations.idleL
            end
        end

        self.x, self.y = self.collider:getPosition()
        

        self.checkColliderR:setPosition(self.x + 200, self.y - 110 + 30)
        self.checkColliderL:setPosition(self.x - 200, self.y - 110 + 30)
        self.checkDangerColliderR:setPosition(self.x + (20 / 2) + 8, self.y )
        self.checkDangerColliderL:setPosition(self.x - (20 / 2) - 8, self.y )
        self.checkColliderHead:setPosition(self.x , self.y - (59/2) - 2)
        if self.collider:enter('Bullet1') and self.live > 0 then
            
     
            local bullet = self.collider:getEnterCollisionData('Bullet1')

            if self.view == 'right' then 
                self.collider:setLinearVelocity(0, 0)
                self.collider:applyForce(-10000, -5000)

            end
            if self.view == 'left' then 
                self.collider:setLinearVelocity(0, 0)
                self.collider:applyForce(10000, -5000)

            end
            self.live = self.live - 1

        end
        if self.checkDangerColliderR:enter('Player') then


        end

        if self.checkDangerColliderR:stay('Player') then
            if self.live > 0 and self.cooldown >= 1.15 then
                self.isAttack = true
                self.isAttackAnim = true
                self.aTimer = 0

                self.isCheckDR = true
                self.cooldown = 0
            end
        else
            self.isCheckDR = false
        end

        if self.checkDangerColliderR:exit('Player') then

        end
        if self.checkDangerColliderL:enter('Player') then

        end

        if self.checkDangerColliderL:stay('Player') then
            if self.live > 0 and self.cooldown >= 1.15 then
                self.isAttack = true
                self.isAttackAnim = true
                self.aTimer = 0

                self.isCheckDL = true
                self.cooldown = 0
            end
        else
            self.isCheckDL = false
        end

        if self.checkDangerColliderL:exit('Player') then

        end

        if self.isAttackAnim == true then
            if self.view == 'right' then
                self.animations.attackR:resume()
                self.animations.actual = self.animations.attackR
            end
            if self.view == 'left' then
                self.animations.attackL:resume()
                self.animations.actual = self.animations.attackL
            end
        end
        if self.isAttack == true and self.aTimer >= 0.4 then
            if self.isCheckDR == true then
                local dangerArea = {}
                dangerArea.collider = self.world:newRectangleCollider(self.x + 6, self.y - 20, 30, 50)
                dangerArea.collider:setCollisionClass('Danger1R')
                dangerArea.collider:setType('static')
                dangerArea.time = 0
                dangerArea.view = self.view
                table.insert(self.dangers, dangerArea)

            end
            if self.isCheckDL == true then
                local dangerArea = {}
                dangerArea.collider = self.world:newRectangleCollider(self.x - 6 - 30, self.y - 20, 30, 50)
                dangerArea.collider:setCollisionClass('Danger1L')
                dangerArea.collider:setType('static')
                dangerArea.time = 0
                dangerArea.view = self.view
                table.insert(self.dangers, dangerArea)

            end
            self.isAttack = false
            self.isATMove = false

        end
        if self.isAttackAnim == true and self.aTimer >= 0.8 then
            self.isAttackAnim = false
            self.isATMove = true
            self.animations.attackR:pause()
            self.animations.attackR:gotoFrame(1)
            self.animations.attackL:pause()
            self.animations.attackL:gotoFrame(1)
        end

        for i,v in ipairs(self.dangers) do
            v.time = v.time + dt
            if v.view == 'right' then
               v.collider:setPosition(self.x + 6 + 15, self.y )
            end
            if v.view == 'left' then
               v.collider:setPosition(self.x - 6 - 15, self.y )
            end
            if v.time >= 0.8 then
                v.collider:destroy()
                table.remove(self.dangers, i)
                break
            end
            if v.collider:enter('Player') then
                v.collider:destroy()
                table.remove(self.dangers, i)
                break
            end

        end
        if self.checkColliderHead:enter('Object') and self.live > 0 then
            self.live = 0
        end
        if self.live <= 0 then
            self.living = false
        end

        if self.living == false then
            self.ltimer = self.ltimer + dt
            if self.view == 'right' then
                self.animations.actual = self.animations.deadR
            elseif self.view == 'left' then
                self.animations.actual = self.animations.deadL
            end
        end
        if self.ltimer >= 0.50 then
            self.uFinished = true
            self.animations.actual:gotoFrame(6)
            self.animations.actual:pause()
        end
        if self.uFinished == true then
            self.checkColliderL:destroy()
            self.checkColliderR:destroy()
            self.checkColliderHead:destroy()
            self.checkDangerColliderR:destroy()
            self.checkDangerColliderL:destroy()
            for i,v in ipairs(self.dangers) do
                v.collider:destroy()
                table.remove(self.dangers, i)
            end
            self.collider:destroy()
        end
        self.animations.actual:update(dt)
    end
    if self.uFinished == true and self.dFinished == false then
        self.dAlpha = self.dAlpha - (4 * dt)
    end
    if self.dAlpha <= 0 then
        self.dFinished = true
    end
    --self.collider:applyForce(1000, -1000)

    --print('left:', self.CheckL, 'right:', self.CheckR)
end


function zombie:draw()
    lg.setColor(255, 255, 255, self.dAlpha)
    self.animations.actual:draw(self.spriteSheet, self.x - 15 + self.offSetX, self.y - 29, nil, 1, 1)
    lg.setColor(255, 255, 255, 1)
end