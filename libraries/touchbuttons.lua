local touchbuttons = {}
touchbuttons.__index = touchbuttons

function touchbuttons:newRectangleButton(x, y, w, h, buttonType)
    local self = setmetatable({}, touchbuttons)
    self.x = x
    self.y = y
    self.w = w
    self.h = h
    self.isPressed = false
    self.type = buttonType
    self.shape = 'rectangle'
    if self.type ~= 'mouse' and self.type ~= 'touch' then error(self.type..' is not an existing type of button', 2) end
    return self
end

function touchbuttons:newCircleButton(x, y, r, buttonType)
    local self = setmetatable({}, touchbuttons)
    self.x = x
    self.y = y
    self.r = r
    self.isPressed = false
    self.type = buttonType
    self.shape = 'circle'
    if self.type ~= 'mouse' and self.type ~= 'touch' then error(self.type..' is not an existing type of button', 2) end
    return self
end

function touchbuttons:getPosition()
    return self.x, self.y
end

function touchbuttons:getX()
    return self.x
end

function touchbuttons:getY()
    return self.y
end

function touchbuttons:setPosition(x, y)
    self.y = y
    self.x = x
end

function touchbuttons:getDimensions()
    return self.w, self.h
end

function touchbuttons:getWidth()
    return self.w
end

function touchbuttons:getHeight()
    return self.h
end

function touchbuttons:setDimensions(w, h)
    self.w = w
    self.h = h
end

function touchbuttons:checkPressed(mouseButton)
    local isButtonPressed = false
    --touchButton
    if self.type == 'touch' then
        local touches = love.touch.getTouches()
        for i,v in ipairs(touches) do
            local touchX, touchY = love.touch.getPosition(v)
            --Check touch rectangle
            if self.shape == 'rectangle' then
                if touchX <= self.x + self.w and
                touchX + 2 >= self.x and
                touchY <= self.y + self.h and
                touchY + 2 >= self.y then
                    isButtonPressed = true
                    break
                else
                    isButtonPressed = false
                end
            --check touch circle
            elseif self.shape == 'circle' then
                if (self.x - touchX)^2 + (self.y - touchY)^2 <= (self.r + 2)^2 then
                    isButtonPressed = true
                    break
                else
                    isButtonPressed = false
                end
            end
        end
  --MouseClickButton
    elseif self.type == 'mouse' then
        mouseX, mouseY = love.mouse.getPosition()
      --Check mouse click rectangle
        if self.shape == 'rectangle' then
            if mouseX <= self.x + self.w and
            mouseX + 5 >= self.x and
            mouseY <= self.y + self.h and
            mouseY + 5 >= self.y and
            love.mouse.isDown(mouseButton) then
                isButtonPressed = true
            else
                isButtonPressed = false
            end 
        --Check mouse click circle
        elseif self.shape == 'circle' then
            if (self.x - mouseX)^2 + (self.y - mouseY)^2 <= (self.r + 1)^2 and
            love.mouse.isDown(mouseButton) then
                isButtonPressed = true
            else
                isButtonPressed = false
            end
        end
    end
    --isPressed
    if isButtonPressed == true then
        self.isPressed = true
    elseif isButtonPressed == false then
        self.isPressed = false
    end
    return self.isPressed
end

function touchbuttons:draw()
    --Draw Rectangle
    if self.shape == 'rectangle' then
        love.graphics.rectangle('line', self.x, self.y, self.w, self.h)
    --Draw Circle
    elseif self.shape == 'circle' then
        love.graphics.circle('line', self.x, self.y, self.r)
    end
end

return touchbuttons
