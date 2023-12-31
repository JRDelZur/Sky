gun = {}
gun.__index = gun
local lg = love.graphics

function gun:new(x, y, angle, view, damage, skin, world)
	require 'scripts/sassets/guns/bullet'
	self.world = world
	self = setmetatable({}, self)
	self.atlas = lg.newImage('assets/Sprites/Gun/gun_txtatlas.png')
	self.atlas:setFilter('nearest')
	self.x = x
	self.y = y
	self.world = world
	self.angle = angle
	self.damage = damage
	self.view = view
	self.skin = skin --'1' = pistola, '2' = subfusil, '3' = fusil
	self.quadR = nil
	self.quadL = nil
	self.oY = 4
	self.oX = 0
	self.mx = 0
	self.my = 0
	self.isFiring = false
	self.btime = 0
	self.generatorX = 0
	self.generatorY = 0
	self.bullets = {}
	if skin == '1' then--pistola
		self.quadR = love.graphics.newQuad( 0, 0, 29, 11, self.atlas)
		self.quadL = love.graphics.newQuad( 29, 0, 29, 11, self.atlas)
	elseif skin == '2' then--subfusil
		self.quadR = love.graphics.newQuad( 58, 0, 29, 11, self.atlas)
		self.quadL = love.graphics.newQuad( 87, 0, 29, 11, self.atlas)
		self.oX = -6
	elseif skin == '3' then--fusil
		self.quadR = love.graphics.newQuad( 116, 0, 29, 11, self.atlas)
		self.quadL = love.graphics.newQuad( 145, 0, 29, 11, self.atlas)
		self.oX = -9

	end
	self.quad = nil
	
	if self.view == 'right' then
		self.quad = self.quadR
	elseif self.view == 'left' then
		self.quad = self.quadL
	end
	return self
end

function gun:update(dt)
	self.btime = self.btime + dt
	if self.view == 'right' then
		self.quad = self.quadR
		self.oY = 8

	elseif self.view == 'left' then
		self.quad = self.quadL
		self.oY = 2
		
	end
	if skin == '1' then
		self.quadR = love.graphics.newQuad( 0, 0, 29, 11, self.atlas)
		self.quadL = love.graphics.newQuad( 29, 0, 29, 11, self.atlas)
	elseif skin == '2' then
		self.quadR = love.graphics.newQuad( 58, 0, 29, 11, self.atlas)
		self.quadL = love.graphics.newQuad( 87, 0, 29, 11, self.atlas)
		self.oX = -6
	elseif skin == '3' then
		self.quadR = love.graphics.newQuad( 116, 0, 29, 11, self.atlas)
		self.quadL = love.graphics.newQuad( 145, 0, 29, 11, self.atlas)
		self.oX = -9

	end
	if self.isFiring == true and self.btime >= 0.2 then

        local dirY = math.sin(self.angle) * (600)
        local dirX = math.cos(self.angle) * (600)

		table.insert(self.bullets, bullet:new(self.generatorX, self.generatorY, self.angle, self.world, dirX, dirY, self.damage))
		self.btime = 0
	end
	for i,bullet in ipairs(self.bullets) do


		if bullet.collider:enter('Terrain') then
			bullet.collider:destroy()
			table.remove(self.bullets, i)
			break
		elseif bullet.lifetime >= 1 then
			bullet.collider:destroy()
			table.remove(self.bullets, i)
			break
		elseif bullet.collider:enter('Object') then
			bullet.collider:destroy()
			table.remove(self.bullets, i)
			break		
		elseif bullet.collider:enter('Zombie') then	
			bullet.collider:destroy()
			table.remove(self.bullets, i)
			break		
		elseif bullet.collider:isDestroyed() then
			table.remove(self.bullets, i)
			break
		end


		bullet:update(dt)
	end
end

function gun:draw()

	lg.draw(self.atlas, self.quad, self.x, self.y, self.angle, 1, 1, self.oX, self.oY)

	--lg.rectangle('line', self.x, self.y -2, 5, 5)
	--print(self.oX)
end