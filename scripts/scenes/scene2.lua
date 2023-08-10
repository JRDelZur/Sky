Scene = {}
local wf = require 'libraries/windfield'
function Scene:load(scaleF)
	self.scaleF = scaleF
	require 'scripts/sassets/player/player'
	world = wf.newWorld()
	world:setGravity(0, 500)
	--collision classes
	world:addCollisionClass('Terrain')--terreno
    world:addCollisionClass('Player', {ignores = {'Player'}}) --player
	world:addCollisionClass('PDown', {ignores = {'Player', 'Terrain'}})--checkdown
    world:addCollisionClass('PLeft', {ignores = {'Player', 'Terrain', 'PDown'}})--checkleft
    world:addCollisionClass('PRight', {ignores = {'Player', 'Terrain', 'PDown', 'PRight'}})--checkright


	
	floor = world:newRectangleCollider(0, love.graphics.getHeight() - (80 * self.scaleF), 854 * self.scaleF, 80 * self.scaleF)
	floor:setCollisionClass('Terrain')
	floor:setType('static')
	floor1 = world:newRectangleCollider(0, 0, 80 * self.scaleF, love.graphics.getHeight())
	floor1:setCollisionClass('Terrain')
	floor1:setType('static')
	floor2 = world:newRectangleCollider(love.graphics.getWidth() - (80 * self.scaleF), 0, 80 * self.scaleF, love.graphics.getHeight()) 
	floor2:setCollisionClass('Terrain')
	floor2:setType('static')
	player:init(80, 80, world, self.scaleF)
end

function Scene:update(dt)
	world:update(dt)
	player:update(dt)


end

function Scene:draw()
	world:draw()
end

function Scene:keypressed(key)
	player:keypressed(key)	
end

function Scene:keyreleased(key)
	player:keyreleased(key)
end

return Scene