Scene = {}
local wf = require 'libraries/windfield'
function Scene:load()
	sti = require 'libraries/sti'
	camera = require 'libraries/camera'
	cam = camera()
	require 'scripts/sassets/player/player'
	gameMap = sti('assets/maps/tutorialMap.lua')
	world = wf.newWorld()
	world:setGravity(0, 500)
	falled = false
	--collision classes
	world:addCollisionClass('Terrain')--terreno
    world:addCollisionClass('Player', {ignores = {'Player'}}) --player
	world:addCollisionClass('PDown', {ignores = {'Player', 'Terrain'}})--checkdown
    world:addCollisionClass('Bullet', {ignores = {'Player', 'Terrain', 'PDown', 'Bullet'}})
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




	player:init(752, 1648, world, cam)
end

function Scene:update(dt)
	world:update(dt)
    player.cam = cam
	player:update(dt)
	cam:lookAt(player.x + lg.getWidth() / 7, player.y - lg.getHeight() / 3.5)
	--print(falled)
end

function Scene:draw()
	
	
	cam:attach()
    	gameMap:drawLayer(gameMap.layers['background'])
        gameMap:drawLayer(gameMap.layers['terrain'])

    	player:draw()
        --world:draw()
	cam:detach()
end

function Scene:keypressed(key)
	player:keypressed(key)	
end

function Scene:keyreleased(key)
	player:keyreleased(key)
end

return Scene