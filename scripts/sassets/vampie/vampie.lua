vampie = {}
vampie.__index = vampie
local anim8 = require 'libraries/anim8'
local lg = love.graphics
function vampie:new(x, y, world)
    require 'scripts/sassets/bullet/bullet'
    lg.setDefaultFilter('nearest', 'nearest')
    self = setmetatable({}, vampie)
    self.x = x
    self.y = y

    self.speed = 375
    self.offSetX = 0
    self.live = 5
    self.living = true
    self.ltimer = 0
    self.uFinished = false
    self.dFinished = false
    self.dAlpha = 1
    self.isAttack = false
    self.isATMove = true
    self.isAttackAnim = false
    self.isWalking = false
    self.spriteSheet = lg.newImage('assets/Sprites/Enemies/vampie/vampieSS.png')
    self.collider = world:newRectangleCollider(self.x, self.y, 12, 59)
    self.world = world
    self.collider:setCollisionClass('Zombie')
    self.collider:setFixedRotation(true)
    self.animations = {}
    self.grid = anim8.newGrid( 41, 61, self.spriteSheet:getWidth(),  self.spriteSheet:getHeight() )
    self.animations.left = anim8.newAnimation( self.grid('12-1', 2), 0.07 )
    self.animations.right = anim8.newAnimation( self.grid('1-12', 1), 0.07 )
    self.animations.dieR = anim8.newAnimation( self.grid('1-1', 3), 0.07 )
    self.animations.dieL = anim8.newAnimation( self.grid('2-2', 3), 0.07 )
    self.animations.actual = self.animations.right


    self.view = 'right'

    self.checkColliderR = world:newRectangleCollider(self.x, self.y, 550, 280)

   

    self.checkColliderR:setFixedRotation(true)
    self.checkColliderR:setCollisionClass('ZombieCheck')
    self.isCheckR = false
    self.checkColliderL = world:newRectangleCollider(self.x - 59, self.y, 550, 280)
   
    self.checkColliderL:setFixedRotation(true)
  

    self.checkColliderL:setCollisionClass('ZombieCheck')
    self.isCheckL = false

    self.isIdle = true

    self.aTimer = 0
    self.cooldown = 1.15
    self.dangers = {}
    return self
end

function vampie:update(dt)
    if not self.collider:isDestroyed() then
        self.x, self.y = self.collider:getPosition()
        self.aTimer = self.aTimer + dt
        self.cooldown = self.cooldown + dt
        local rvx, rvy = self.collider:getLinearVelocity()

        --comprobacion de comprobadores

        if self.checkColliderR:enter('Player') then

        end

        if self.checkColliderR:stay('Player') then
            self.isCheckR = true
            if self.isCheckR == true and self.cooldown >= 0.85 then
                self.cooldown = 0
                local player = self.checkColliderR:getEnterCollisionData('Player')
                local px, py = player.collider:getPosition()

                local angle = math.atan2((py - self.y), (px - self.x))
                local angle = math.atan2((py - self.y), (px - self.x))
                local dirY = math.sin(angle) * (350)
                local dirX = math.cos(angle) * (350)
                
                table.insert(self.dangers, bulletE:new(self.x - 6, self.y - 20, angle, self.world, dirX, dirY, 1, 1, self.view))
            end

        else
            self.isCheckR = false
        end

        if self.checkColliderR:exit('Player') then

        end

        if self.checkColliderL:enter('Player') then

        end        

        if self.checkColliderL:stay('Player') then
            self.isCheckL = true
            if self.isCheckL == true and self.cooldown >= 1 then
                self.cooldown = 0
                local player = self.checkColliderL:getEnterCollisionData('Player')
                local px, py = player.collider:getPosition()

                local angle = math.atan2((py - self.y), (px - self.x))
                local dirY = math.sin(angle) * (350)
                local dirX = math.cos(angle) * (350)

                table.insert(self.dangers, bulletE:new(self.x - 6, self.y - 20, angle, self.world, dirX, dirY, 1, 1, self.view))
            end
        else
            self.isCheckL = false
        end        

        if self.checkColliderL:exit('Player') then
 
        end

        if self.isCheckL == false and self.isCheckR == false then
            self.isIdle = true
        else
            self.isIdle = false
        end

      
        if rvy >= 0 and self.living == true then 
            if self.isCheckL == true or self.isCheckR == true then
                self.collider:setLinearVelocity(rvx, 0)
                self.collider:applyForce(0 , -3750)
            end
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
            self.offSetX = -5
        elseif self.view == 'left' then
            self.animations.actual = self.animations.left
            self.offSetX = -5

        end



        
        

        self.checkColliderR:setPosition(self.x + 275, self.y - 110 + 30)
        self.checkColliderL:setPosition(self.x - 275, self.y - 110 + 30)

        if self.collider:enter('Bullet1') and self.live > 0 then
            
     
            local bullet = self.collider:getEnterCollisionData('Bullet1')

            if self.view == 'right' then 
                self.collider:setLinearVelocity(0, 0)
                self.collider:applyForce(-10000, 0)

            end
            if self.view == 'left' then 
                self.collider:setLinearVelocity(0, 0)
                self.collider:applyForce(10000, 0)

            end
            self.live = self.live - 1

        end
       

        if self.isAttack == true and self.aTimer >= 0.4 then

            self.isAttack = false
            self.isATMove = false

        end


        for i,v in ipairs(self.dangers) do
            v.time = v.time + dt
            v:update(dt)
            if v.time >= 1 then
                v.collider:destroy()
                table.remove(self.dangers, i)
                break
            elseif v.collider:enter('Player') then
                v.collider:destroy()
                table.remove(self.dangers, i)
                break
            elseif v.collider:enter('Terrain') then
                v.collider:destroy()
                table.remove(self.dangers, i)
                break
            end

        end
       
        if self.live <= 0 then
            self.living = false
        end

        if self.living == false then
            self.ltimer = self.ltimer + dt
            if self.view == 'right' then
                self.animations.actual = self.animations.dieR
            elseif self.view == 'left' then
                self.animations.actual = self.animations.dieL
            end
        end
        if self.ltimer >= 0.50 then
            self.uFinished = true

        end
        if self.uFinished == true then
            self.checkColliderL:destroy()
            self.checkColliderR:destroy()


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


function vampie:draw()
    lg.setColor(255, 255, 255, self.dAlpha)
    for i,v in ipairs(self.dangers) do
        v:draw()
    end
    self.animations.actual:draw(self.spriteSheet, self.x - 15 + self.offSetX, self.y - 29, 0, 1, 1)
    lg.setColor(255, 255, 255, 1)
end