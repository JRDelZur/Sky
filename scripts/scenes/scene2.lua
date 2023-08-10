Scene = {}
local wf = require 'libraries/windfield'
function Scene:load()
	sti = require 'libraries/sti'
	camera = require 'libraries/camera'
	cam = camera()
	require 'scripts/sassets/player/player'
	gameMap = sti('assets/maps/testMap.lua')
	world = wf.newWorld()
	world:setGravity(0, 500)
	--collision classes
	world:addCollisionClass('Terrain')--terreno
    world:addCollisionClass('Player', {ignores = {'Player'}}) --player
	world:addCollisionClass('PDown', {ignores = {'Player', 'Terrain'}})--checkdown
    world:addCollisionClass('PLeft', {ignores = {'Player', 'Terrain', 'PDown'}})--checkleft
    world:addCollisionClass('PRight', {ignores = {'Player', 'Terrain', 'PDown', 'PRight'}})--checkright
    --terrains
    walls = {}
    if gameMap.layers['walls'] then
    	for i, obj in pairs(gameMap.layers['walls'].objects) do
    		local wall = world:newRectangleCollider(obj.x, obj.y, obj.width, obj.height)
    		wall:setType('static')
    		wall:setCollisionClass('Terrain')
    		wall:setFixedRotation(true)
    		table.insert(walls, wall)
    	end
    end
	player:init(80, 80, world)
end

function Scene:update(dt)
	world:update(dt)
	player:update(dt)
	cam:lookAt(player.x, player.y)

end

function Scene:draw()
	cam:attach()
		gameMap:drawLayer(gameMap.layers['background'])
		gameMap:drawLayer(gameMap.layers['terrain'])
		
		world:draw()
	cam:detach()
end

function Scene:keypressed(key)
	player:keypressed(key)	
end

function Scene:keyreleased(key)
	player:keyreleased(key)
end

return Scene