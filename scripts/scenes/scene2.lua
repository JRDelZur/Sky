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
    world:addCollisionClass('PLeft', {ignores = {'Player', 'Terrain', 'PDown'}})--checkleft
    world:addCollisionClass('PRight', {ignores = {'Player', 'Terrain', 'PDown', 'PRight'}})--checkright
    world:addCollisionClass('Ghost', {ignores = {'Player', 'Terrain', 'PDown', 'PRight'}})
    world:addCollisionClass('GhostWall', {ignores = {'Player', 'Terrain', 'PDown', 'PRight'}})
    world:addCollisionClass('CheckEvent', {ignores = {'Player', 'Terrain', 'PDown', 'PRight'}})
    --terrains
    eventwall1 = world:newRectangleCollider(2272.00, 952.00, 32.00, 1000.00)
    eventwall2 = world:newRectangleCollider(2016.00, 960.00, 32.00, 1000.00)
    eventwall2:setType('static')

    eventwall1:setType('static')
    eventwall2:setCollisionClass('GhostWall')

    eventwall1:setCollisionClass('GhostWall')

    limitwall1 = world:newRectangleCollider(-8.00, 128.00, 1328.00, 1400.00)
    limitwall2 = world:newRectangleCollider(2872.00, 128.00, 1328.00, 1400.00)
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
    if gameMap.layers['swalls'] then
    	for i, obj in pairs(gameMap.layers['swalls'].objects) do
    		local wall = world:newRectangleCollider(obj.x, obj.y, obj.width, obj.height)
    		wall:setType('static')
    		wall:setCollisionClass('CheckEvent')
    		wall:setFixedRotation(true)
    		table.insert(walls, wall)
    	end
    end
    fwall = {}
    if gameMap.layers['fwall'] and falled == false then
    	for i, obj in pairs(gameMap.layers['fwall'].objects) do
    		local wall = world:newRectangleCollider(obj.x, obj.y, obj.width, obj.height)
    		wall:setType('static')
    		wall:setCollisionClass('Terrain')
    		wall:setFixedRotation(true)
    		table.insert(fwall, wall)
    	end
    elseif falled == true then
    	for i, v in ipairs(fwall) do
    		v:destroy()
    		table.remove(fwall, i)
    	end
    end



	player:init(2010, 1519, world)
end

function Scene:update(dt)
	world:update(dt)
	player:update(dt)
	if player.collider:enter('CheckEvent') then
		player.collider:setCollisionClass('Ghost')
		falled = true
	end
	cam:lookAt(player.x + lg.getWidth() / 7, player.y - lg.getHeight() / 3.5)
	print(falled)
end

function Scene:draw()
	
	
	cam:attach()
    	gameMap:drawLayer(gameMap.layers['sky'])
    	gameMap:drawLayer(gameMap.layers['dirtfiill'])
    	gameMap:drawLayer(gameMap.layers['dirt'])
    	gameMap:drawLayer(gameMap.layers['parkourfill'])
    	gameMap:drawLayer(gameMap.layers['parkour'])
    	gameMap:drawLayer(gameMap.layers['fall'])
    	
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