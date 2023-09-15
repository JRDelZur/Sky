Scene = {}
local wf = require 'libraries/windfield'
function Scene:load()
	sti = require 'libraries/sti'
	camera = require 'libraries/camera'
	cam = camera()
	require 'scripts/collClasses'
	require 'scripts/sassets/player/player'
	require 'scripts/sassets/objects/bhoox/bhoox'
	require 'scripts/sassets/zombie/zombie'
	world = wf.newWorld()
	world:setGravity(0, 500)
	falled = false
	chargeClasses()--cargamos clases


	hooks = {}
	zombies = {}
	zombies[1] = zombie:new(982, 1472, world)

	gameMap = sti('assets/maps/tutorialMap.lua')

    --terrains
    hooks[1] = bhoox:new(928, 1472, world)
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
	for i,v in ipairs(hooks) do
		v:update(dt)
	end
	zombies[1]:update(dt)
	cam:lookAt(player.x + lg.getWidth() / 7, player.y - lg.getHeight() / 3.5)
	--print(falled)
end

function Scene:draw()
	
	
	cam:attach()
    	gameMap:drawLayer(gameMap.layers['background'])
        gameMap:drawLayer(gameMap.layers['terrain'])
        hooks[1]:draw()
    	player:draw()
    	zombies[1]:draw()
        world:draw(0.07)
	cam:detach()
end

function Scene:keypressed(key)
	player:keypressed(key)	
end

function Scene:keyreleased(key)
	player:keyreleased(key)
end

return Scene