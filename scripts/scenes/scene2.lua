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


	
	floor = world:newRectangleCollider(0, 400, 854, 80)
	floor:setCollisionClass('Terrain')
	floor:setType('static')
	floor1 = world:newRectangleCollider(0, 0, 80, 480)
	floor1:setCollisionClass('Terrain')
	floor1:setType('static')
	floor2 = world:newRectangleCollider(774, 0, 80, 480)
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