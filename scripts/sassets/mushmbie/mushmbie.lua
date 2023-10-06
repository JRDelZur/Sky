mushmbie = {}
mushmbie.__index = mushmbie
local anim8 = require 'libraries/anim8'
local lg = love.graphics
function mushmbie:new(x, y, world)
    require 'scripts/sassets/bullet/bullet'
    lg.setDefaultFilter('nearest', 'nearest')
    self = setmetatable({}, mushmbie)
    self.x = x
    self.y = y
    self.speed = 425
    self.offSetX = 0
    self.live = 10
    self.living = true
    self.ltimer = 0
    self.uFinished = false
    self.dFinished = false
    self.dAlpha = 1
    self.isAttack = false
    self.isATMove = true
    self.isAttackAnim = false
    self.isWalking = false
    self.spriteSheet = lg.newImage('assets/Sprites/Enemies/mushmbie/mushmbieSS.png')
    self.collider = world:newRectangleCollider(self.x, self.y, 12, 59)
    self.world = world
    self.collider:setCollisionClass('Zombie')
    self.collider:setFixedRotation(true)
    self.animations = {}
    self.grid = anim8.newGrid( 30, 63, self.spriteSheet:getWidth(),  self.spriteSheet:getHeight() )
    self.animations.left = anim8.newAnimation( self.grid('8-1', 2), 0.075 )
    self.animations.right = anim8.newAnimation( self.grid('1-8', 1), 0.075 )
    self.animations.idleL = anim8.newAnimation( self.grid('3-4', 3), 0.7 )
    self.animations.idleR = anim8.newAnimation( self.grid('1-2', 3), 0.7 )

    self.view = 'right'
    self.animations.actual = self.animations.right
    self.checkColliderR = world:newRectangleCollider(self.x, self.y, 400, 220)
    self.checkColliderHead = world:newRectangleCollider(self.x, self.y - 5, 12, 5)
    self.checkDangerColliderR = world:newRectangleCollider(self.x + (59 * 2), self.y, 100, 60)
    

    self.checkColliderR:setFixedRotation(true)
    self.checkColliderR:setCollisionClass('ZombieCheck')
    self.isCheckR = false
    self.checkColliderL = world:newRectangleCollider(self.x - 59, self.y, 400, 220)
    self.checkDangerColliderL = world:newRectangleCollider(self.x, self.y, 100, 60)
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

function mushmbie:update(dt)
    if not self.collider:isDestroyed() then
        self.aTimer = self.aTimer + dt
        self.cooldown = self.cooldown + dt
        self.isWalking = false
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
            self.animations.actual = self.animations.right
            if rvx < 240 and self.isATMove == true then
               self.collider:applyForce(self.speed, 0)
               self.isWalking = true
            end
        elseif self.isCheckL == true then
            self.view = 'left'
            self.animations.actual = self.animations.left
            if rvx > -240 and self.isATMove == true then
               self.collider:applyForce(self.speed * -1, 0)
               self.isWalking = true
            end
        end
        print(self.isWalking)

        --ajuste segun vista
        if self.view == 'right' then
            
            self.offSetX = 0
        elseif self.view == 'left' then
            
            self.offSetX = 0

        end


        self.x, self.y = self.collider:getPosition()
        

        self.checkColliderR:setPosition(self.x + 200, self.y - 110 + 30)
        self.checkColliderL:setPosition(self.x - 200, self.y - 110 + 30)
        self.checkDangerColliderR:setPosition(self.x + (100 / 2) + 8, self.y )
        self.checkDangerColliderL:setPosition(self.x - (100 / 2) - 8, self.y )
        self.checkColliderHead:setPosition(self.x , self.y - (59/2) - 2)
        if self.collider:enter('Bullet1') and self.live > 0 then
            
     
            local bullet = self.collider:getEnterCollisionData('Bullet1')

            if self.view == 'right' then 
                self.collider:setLinearVelocity(rvx, 0)
                self.collider:applyForce(-6000, -5000)

            end
            if self.view == 'left' then 
                self.collider:setLinearVelocity(rvx, 0)
                self.collider:applyForce(6000, -5000)

            end
            self.live = self.live - 1

        end
        if self.checkDangerColliderR:enter('Player') then


        end

        if self.checkDangerColliderR:stay('Player') then
            if self.live > 0 and self.cooldown >= 1.5 then
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
            if self.live > 0 and self.cooldown >= 1.5 then
                self.isAttack = true
                self.isAttackAnim = true
                

                self.isCheckDL = true
                
            end
        else
            self.isCheckDL = false
        end

        if self.checkDangerColliderL:exit('Player') then

        end

        if self.isAttackAnim == true then
            if self.view == 'right' then

            end
            if self.view == 'left' then

            end
        end
        if self.isAttack == true then
            self.aTimer = 0
            self.cooldown = 0
            if self.isCheckDR == true then
                local player = self.checkColliderR:getEnterCollisionData('Player')
                local px, py = player.collider:getPosition()

                local angle = math.atan2((py - self.y), (px - self.x))
                local dirY = math.sin(angle) * (350)
                local dirX = math.cos(angle) * (350)
                
                table.insert(self.dangers, bulletE:new(self.x - 6, self.y - 20, angle, self.world, rvx, dirY, 1, 2, 'right'))  
                table.insert(self.dangers, bulletE:new(self.x - 6, self.y - 20, angle, self.world, rvx, dirY, 1, 2, 'left'))   
                table.insert(self.dangers, bulletE:new(self.x - 6, self.y - 20, angle, self.world, rvx, dirY, 1, 2, 'right'))  
                table.insert(self.dangers, bulletE:new(self.x - 6, self.y - 20, angle, self.world, rvx, dirY, 1, 2, 'left'))                       
            end
            if self.isCheckDL == true then
                local player = self.checkColliderL:getEnterCollisionData('Player')
                local px, py = player.collider:getPosition()

                local angle = math.atan2((py - self.y), (px - self.x))
                local dirY = math.sin(angle) * (350)
                local dirX = math.cos(angle) * (350)

                table.insert(self.dangers, bulletE:new(self.x - 6, self.y - 20, angle, self.world, rvx, dirY, 1, 2, 'left'))
                table.insert(self.dangers, bulletE:new(self.x - 6, self.y - 20, angle, self.world, rvx, dirY, 1, 2, 'right'))
                table.insert(self.dangers, bulletE:new(self.x - 6, self.y - 20, angle, self.world, rvx, dirY, 1, 2, 'right'))  
                table.insert(self.dangers, bulletE:new(self.x - 6, self.y - 20, angle, self.world, rvx, dirY, 1, 2, 'left'))    

            end
            self.isAttack = false


        end


        for i,v in ipairs(self.dangers) do
            v:update(dt)
            v.time = v.time + dt
            --if v.time >= 0.1 then
              --  v.dirX = rvx
            --end
            if v.time >= 1.5 then
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
                
            elseif self.view == 'left' then

            end
        end
        if self.ltimer >= 0.50 then
            self.uFinished = true

        end
        if self.isIdle == true then
            if self.view == 'right' then
                self.animations.actual = self.animations.idleR
            elseif self.view == 'left' then
                self.animations.actual = self.animations.idleL
            end
        end
        if self.uFinished == true then
            
            for i,v in ipairs(self.dangers) do
                v.collider:destroy()
                table.remove(self.dangers, i)
                
            end
            if #self.dangers <= 0 then
                self.checkColliderL:destroy()
                self.checkColliderR:destroy()
                self.checkColliderHead:destroy()
                self.checkDangerColliderR:destroy()
                self.checkDangerColliderL:destroy()
                self.collider:destroy()
            end
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


function mushmbie:draw()
    lg.setColor(255, 255, 255, self.dAlpha)
    for i,v in ipairs(self.dangers) do
        v:draw()
    end
    self.animations.actual:draw(self.spriteSheet, self.x - 15 + self.offSetX, self.y - 29, nil, 1, 1)

    lg.setColor(255, 255, 255, 1)
end