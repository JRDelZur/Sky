bhoox = {}
bhoox.__index = bhoox
local lg = love.graphics
function bhoox:new(x, y, world)
    lg.setDefaultFilter('nearest', 'nearest')
    self = setmetatable({}, bhoox)
    self.x = x
    self.y = y
    self.bx = self.x
    self.by = self.y + 44
    self.texture = lg.newImage('assets/Sprites/Objects/bhoox/bhooxAtlas.png')
    self.qUpBrok = love.graphics.newQuad( 79, 0, 25, 48, self.texture)
    self.qUpFix = love.graphics.newQuad( 25, 0, 25, 48, self.texture)
    self.qUp = self.qUpFix
    self.qDownFix = love.graphics.newQuad( 0, 0, 25, 48, self.texture)
    self.qDownBrok = love.graphics.newQuad( 50, 0, 29, 48, self.texture)
    self.qDown = self.qDownFix
    self.down = false
    self.boxCollider = world:newRectangleCollider(self.bx, self.by + 51, 50, 46)
    self.boxCollider:setType('static')
    self.checkCollider = world:newRectangleCollider(self.x + 28, self.y + 25, 6, 44)
    self.checkCollider:setType('static')
    self.checkCollider:setCollisionClass('Object')
    self.boxCollider:setCollisionClass('Object')
    self.world = world
    return self
end

function bhoox:update(dt)
    if self.checkCollider:enter('Bullet') then
        self.down = true
        self.checkCollider:destroy()
    end
    if self.down == true then
        self.boxCollider:setType('dynamic')
        self.qDown = self.qDownBrok
        self.qUp = self.qUpBrok
    end
    self.bx, self.by = self.boxCollider:getPosition()
    --x 928.00
    --y 1472.00
end


function bhoox:draw()
    love.graphics.draw(self.texture, self.qUp, self.x, self.y, 0, 2, 2)
    love.graphics.draw(self.texture, self.qDown, self.bx - 25, self.by - 28 - 44, 0, 2, 2)
end