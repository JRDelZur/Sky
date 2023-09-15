player = {}
local anim8 = require 'libraries/anim8'
local lg = love.graphics
function player:init(x, y, world, cam)
    
    require 'scripts/sassets/guns/gun'
    --Sprites
    self.spriteSheet = love.graphics.newImage('assets/Sprites/Player/playerSS.png')
    self.arm = {}
    self.arm.sprite = love.graphics.newImage('assets/Sprites/Player/armR.png')
    self.arm.spriteL = love.graphics.newImage('assets/Sprites/Player/armL.png')
    --self.arm.sprite = self.arm.spriteL
    self.arm.x = 0
    self.arm.y = 0
    self.arm.angle = 0
    self.spriteSheet:setFilter('nearest')
    self.arm.sprite:setFilter('nearest')
    --self.arm.spriteL:setFilter('nearest')
    self.grid = anim8.newGrid( 32, 65, player.spriteSheet:getWidth(),  player.spriteSheet:getHeight() )

    self.animations = {}
    self.animations.a = anim8.newAnimation( player.grid('1-8', 3), 0.1 )
    self.animations.d = anim8.newAnimation( player.grid('1-8', 2), 0.1 )
    self.animations.aR = anim8.newAnimation( player.grid('8-1', 3), 0.1 )
    self.animations.dR = anim8.newAnimation( player.grid('8-1', 2), 0.1 )
    self.animations.stayR = anim8.newAnimation( player.grid('1-2', 1), 2.5 )
    self.animations.stayL = anim8.newAnimation( player.grid('3-4', 1), 2.5 )
    self.animations.fallR = anim8.newAnimation( player.grid('5-5', 1), 0.1)
    self.animations.fallL = anim8.newAnimation( player.grid('6-6', 1), 0.1)
    self.animations.stay = self.animations.stayR
    self.animations.actual = self.animations.stay

    --variables basicas player
    self.x = x
    self.y = y
    self.gun = gun:new()
    self.world = world
    self.cam = cam
    self.rjump = 0
    self.view = 'left'
    self.px = 0
    self.py = 0
    self.w = 15 
    self.h = 60
    self.impulseForce = 450 
    self.speed = 500
        --
    self.generator = {}
    self.generator.view = self.view
    self.generator.x = 0
    self.generator.y = 0
    --pistola arma
    self.gun = gun:new(self.arm.x, self.arm.y, self.arm.angle, self.view, 5, '3', self.world)
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
    local mx, my = love.mouse.getPosition()
    local fmx, fmy = cam:worldCoords(mx, my)
	local px, py = self.collider:getLinearVelocity()
    --ajustes segun donde voltea

    if self.view == 'left' then
        self.generator.view = 'left'
        self.arm.x = self.x 
        self.arm.y = self.y - 15
        self.animations.stay = self.animations.stayL
        if self.downCheckOnWall == false and py > 0 then
            self.animations.stay = self.animations.fallL
        end
    elseif self.view == 'right' then
        self.generator.view = 'right'
        self.arm.x = self.x + 2
        self.arm.y = self.y - 15
        self.animations.stay = self.animations.stayR
        if self.downCheckOnWall == false and py > 0 then
            self.animations.stay = self.animations.fallR
        end
    end
    local sangle = self.arm.angle * (180 / math.pi)
    local gangle = math.abs(self.arm.angle * (180 / math.pi))
    --generadorvoltea
    if self.generator.view == 'left' then
        if sangle < -90 and sangle > -180 then
            self.generator.x = self.x - 5
            self.generator.y = self.y - 20
        elseif sangle < 180 and sangle > 156.98163914709 then
            self.generator.x = self.x - 4
            self.generator.y = self.y - 22
        elseif sangle < 156.98163914709 and sangle > 139.34745690756 then
            self.generator.x = self.x - 5
            self.generator.y = self.y - 24
        elseif sangle < 139.34745690756 and sangle > 90 then
            self.generator.x = self.x - 7
            self.generator.y = self.y - 26
        end
    elseif self.generator.view == 'right' then
        if sangle > -90 and sangle < -25.758121721976 then
            self.generator.x = self.x - 3
            self.generator.y = self.y - 27
        elseif sangle > -25.758121721976 and sangle < -29.647769899234 then
            self.generator.x = self.x - 2
            self.generator.y = self.y - 24
        elseif sangle > -29.647769899234 and sangle < 5.9132140118629 then
            self.generator.x = self.x - 2
            self.generator.y = self.y - 20
        elseif sangle > 5.9132140118629 and sangle < 18.434948822922 then
            self.generator.x = self.x - 2
            self.generator.y = self.y - 18
        elseif sangle > 18.434948822922 and sangle < 40.368257078255 then
            self.generator.x = self.x - 2
            self.generator.y = self.y - 16
        elseif sangle > 40.368257078255 and sangle < 54.261676329554 then
            self.generator.x = self.x - 2
            self.generator.y = self.y - 14
        elseif sangle > 54.261676329554 and sangle < 65.628900849089 then
            self.generator.x = self.x - 2
            self.generator.y = self.y - 12
        elseif sangle > 65.628900849089 and sangle < 90 then
            self.generator.x = self.x - 2
            self.generator.y = self.y - 8
        end
    end
    


    self.animations.actual = self.animations.stay
    self.arm.angle = math.atan2((fmy - self.arm.y), (fmx - self.arm.x))--angulo relacion mouse y el brazo
 

    --ajuste de mira depende el brazo
    if gangle >= 90 and gangle <= 180 then--si el brazo voltea a la izquierda self.view es left
        self.view = 'left'
    elseif gangle >= 0 and gangle <= 89 then--si el brazo voltea a la derecha self.view es right
        self.view = 'right'
    end
    self.px = px
    self.py = py
    self.rjump = self.rjump + dt
	--ajuste de downcheck
	self.downCheck:setX(self.x)
	self.downCheck:setY(self.y + ((self.h / 2) + ((self.h / 5) / 2)))
	--onfloor
	if self.downCheck:enter('Terrain') or self.downCheck:enter('Object') then --toca el piso
	
    end
    if self.downCheck:stay('Terrain') or self.downCheck:stay('Object') then
        self.downCheckOnWall = true
    else
        self.downCheckOnWall = false
    end
    if self.downCheck:exit('Terrain') or self.downCheck:exit('Object') then --deja de tocar el piso
        
    end

    --movimiento
    if love.keyboard.isDown('a') then
        if px > -200 then
            self.collider:applyForce(self.speed * -1, 0)
        end
        --seleccion de animacion
        if self.downCheckOnWall == true and self.view == 'left' then
            self.animations.actual = self.animations.a
        elseif self.downCheckOnWall == true and self.view == 'right' then
            self.animations.actual = self.animations.dR
        end
    elseif love.keyboard.isDown('d') then
        if px < 200 then
    	   self.collider:applyForce(self.speed, 0)
        end
        --seleccion de animacion
        if self.downCheckOnWall == true and self.view == 'right' then
            self.animations.actual = self.animations.d

        elseif self.downCheckOnWall == true and self.view == 'left' then 
            self.animations.actual = self.animations.aR
        end
    elseif not love.keyboard.isDown('d') and not love.keyboard.isDown('a') and self.downCheckOnWall then
        self.collider:setLinearVelocity(0, py)
    end

    --PISTOLA
    self.gun:update(dt)
    self.gun.x = self.arm.x
    self.gun.y = self.arm.y
    self.gun.angle = self.arm.angle
    self.gun.view = self.view
    self.gun.mx = fmx
    self.gun.my = fmy
    self.gun.generatorX = self.generator.x
    self.gun.generatorY = self.generator.y
    self.animations.actual:update(dt)
    ---180
    --print('x', fmx - self.x, 'y', fmy - self.y)
    print(sangle)
end

function player:draw()
    for i,bullet in ipairs(self.gun.bullets) do
        bullet:draw()

    end
    lg.draw(self.arm.sprite, self.arm.x, self.arm.y, self.arm.angle, 1, 1, 0, 4)
    self.gun:draw()
    self.animations.actual:draw(self.spriteSheet, self.x - 15, self.y - 35, nil, 1, 1)
    --lg.rectangle('fill', self.generator.x, self.generator.y , 5, 5)
end

function player:keypressed(key)
	if self.downCheckOnWall == true and key == 'space' and not love.keyboard.isDown('s') then
        self.collider:applyLinearImpulse(0, self.impulseForce * -1)
    end
end


function player:keyreleased(key)
    if key == 'escape' then
        love.event.quit()
    end

end
