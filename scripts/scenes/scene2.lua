Scene = {}
local wf = require 'libraries/windfield'
function Scene:load()
	sti = require 'libraries/sti'
	camera = require 'libraries/camera'
	cam = camera()
	require 'scripts/gamepad'
	require 'scripts/collClasses'
	require 'scripts/sassets/player/player'
	require 'scripts/sassets/objects/bhoox/bhoox'
	require 'scripts/sassets/zombie/zombie'
	require 'scripts/sassets/vampie/vampie'
	require 'scripts/sassets/mushmbie/mushmbie'
	world = wf.newWorld()
	world:setGravity(0, 500)

	chargeClasses()--cargamos clases


	hooks = {}
	zombies = {}
	zombies[1] = mushmbie:new(982, 1472, world)
	--zombies[2] = vampie:new(1000, 1472, world)
	gameMap = sti('assets/maps/tutorialMap.lua')

    --terrains
    --hooks[1] = bhoox:new(928, 1472, world)
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
   
    if gameMap.layers['hooks'] then
    	for i, obj in pairs(gameMap.layers['hooks'].objects) do

    		table.insert(hooks, bhoox:new(obj.x, obj.y, world))
    	end
    end

    
    gamepad:load()



	player:init(752, 1648, world, cam)
end

function Scene:update(dt)
	world:update(dt)
    player.cam = cam
    gamepad:update(dt)
    gamepad.ui.isDamaged = player.isDamaged
    gamepad.ui.lives = player.live
    player.arm.angle = gamepad.moves.joystickAngle
    player.isFiring = gamepad.moves.joystickPressed
    player.moveDir = gamepad.moves.dir
    player.isJumping = gamepad.moves.isJumping 
	player:update(dt)
	for i,v in ipairs(hooks) do
		v:update(dt)
	end
	for i,v in ipairs(zombies) do
		v:update(dt)
		if v.dFinished == true then
			table.remove(zombies, i)

		end
	end
	

	cam:lookAt(player.x , player.y - lg.getHeight() / 3.5)
	--print(falled)
end

function Scene:draw()
	
	
	cam:attach()
    	gameMap:drawLayer(gameMap.layers['background'])
        gameMap:drawLayer(gameMap.layers['terrain'])
        for i,v in ipairs(hooks) do
			v:draw()
		end

    	player:draw()
		for i,v in ipairs(zombies) do
			v:draw()
		end
        
        --world:draw(0.07)
	cam:detach()
	gamepad:draw()
end

function Scene:keypressed(key)
	player:keypressed(key)	
end

function Scene:keyreleased(key)
	player:keyreleased(key)
end

return Scene