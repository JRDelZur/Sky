lg = love.graphics
wf = require 'libraries/windfield'
function love.load()
	scaleFW = lg.getWidth() / 854
	scaleFH = lg.getHeight() / 480
	scaleF = (scaleFW + scaleFH) / 2

	manageScene("scene2")

end
 
function love.update(dt)
	if Scene.update then Scene:update(dt) end
end

function love.draw()
	if Scene.draw then Scene:draw() end

end

function love.keypressed(key)
	if Scene.keypressed then Scene:keypressed(key) end
end 

function love.keyreleased(key)
	if Scene.keyreleased then Scene:keyreleased(key) end
end

function manageScene(SelectedScene)
	Scene = require("scripts/scenes/"..SelectedScene)
	if Scene.load then Scene:load(scaleF) end
end
