local touchbuttons = {}
touchbuttons.__index = touchbuttons

function touchbuttons:newRectangleButton(x, y, w, h, buttonType)
    local self = setmetatable({}, touchbuttons)
    self.x = x
    self.y = y
    self.w = w
    self.h = h
    self.cat = 0
    self.isPressed = false
    self.type = buttonType
    self.Returned = false
    self.shape = 'rectangle'
    if self.type ~= 'mouse' and self.type ~= 'touch' then error(self.type..' is not an existing type of button', 2) end
    return self
end

function touchbuttons:newCircleButton(x, y, r, buttonType)
    local self = setmetatable({}, touchbuttons)
    self.x = x
    self.y = y
    self.r = r
    self.cat = 0
    self.isPressed = false
    self.type = buttonType
    self.shape = 'circle'
    if self.type ~= 'mouse' and self.type ~= 'touch' then error(self.type..' is not an existing type of button', 2) end
    return self
end

function touchbuttons:newJoystick(x, y, r, buttonType)
    local self = setmetatable({}, touchbuttons)
    self.x = x
    self.y = y
    self.radius = r
    self.isPressed = false
    self.mouseX, self.mouseY = self.x, self.y
    self.cat = 1
    self.Tid = 0
    self.angle = 0
    self.type = buttonType
    if self.type ~= 'mouse' and self.type ~= 'touch' then error(self.type..' is not an existing type of button', 2) end
    return self
end

function touchbuttons:getJoystickAngle()
    if self.cat == 1 then
        local angle = 0 
        if self.isPressed == true then
            angle = math.atan2((self.mouseY - self.y), (self.mouseX - self.x))

        end
        self.angle = angle
    end
    return self.angle
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
    if self.cat == 0 then
        local isButtonPressed = false
        --touchButton
        local mouseX, mouseY = love.mouse.getPosition()
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
    end

    return self.isPressed
end

function touchbuttons:checkPressedAR(mouseButton)
    if self.type == 'mouse' then
        local isPressed = false
        local isPressedAR = false

        local mButton = mouseButton
        local mouseX, mouseY = love.mouse.getPosition()


        if self:checkPressed(mButton) then
            isPressed = true

        else
            isPressed = false
        end
        

        function love.mousereleased(x, y, button)

            if button == mButton then

                if isPressed == true then
                    if self.shape == 'rectangle' then
                        if mouseX <= self.x + self.w and
                        mouseX + 5 >= self.x and
                        mouseY <= self.y + self.h and
                        mouseY + 5 >= self.y then
                            isPressedAR = true
            
                            
                        else
                            isPressedAR = false

                        end
                    end 
                else
                    isPressedAR = false
                    

                end
            end
            if isPressedAR == true then
                self.Returned = true

            else
                self.Returned = false
            end

        end
    elseif self.type == 'touch' then
        local isButtonPressed = false
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
        function love.touchreleased(id, x, y, dx, dy, pressure)
            local touchX, touchY = x, y
            if isButtonPressed == true and 
                touchX <= self.x + self.w and
                touchX + 2 >= self.x and
                touchY <= self.y + self.h and
                touchY + 2 >= self.y then

                self.Returned = true

            end

        end
    end
    return self.Returned
    
end

function touchbuttons:update(dt)
    if self.cat == 0 then
        self.Returned = false 
    elseif self.cat == 1 then
        function love.touchpressed( id, x, y, dx, dy, pressure )
            local distance = math.sqrt((x - self.x)^2 + (y - self.y)^2)
            if distance <= self.radius then
                self.isPressed = true
                self.mouseX = x
                self.mouseY = y
                self.Tid = id
            end
            
        end
        if self.isPressed == true then
            local touches = love.touch.getTouches()
            for i, v in ipairs(touches) do
                if touches[i] == self.Tid then
                    local touchX, touchY = love.touch.getPosition(v)
                    local distance = math.sqrt((touchX - self.x)^2 + (touchY - self.y)^2)
                    
                    -- Si la distancia es mayor que el radio del self, ajustar las coordenadas para mantenerlo dentro del círculo
                    if distance > self.radius then
                        local angle = math.atan2(touchY - self.y, touchX - self.x)
                        self.mouseX = self.x + self.radius * math.cos(angle) 
                        self.mouseY = self.y + self.radius * math.sin(angle)
                    else
                        self.mouseX = touchX
                        self.mouseY = touchY
                    end
                end
            end
        end
        function love.touchreleased( id, x, y, dx, dy, pressure )
            if id == self.Tid then
                self.isPressed = false
            end
        end
        -- Si el self no se está presionando, regresar a la posición de reposo
        if not self.isPressed then
            self.mouseX = self.x
            self.mouseY = self.y
        end
    end
end

function touchbuttons:draw()
    if self.cat == 0 then
        --Draw Rectangle
        if self.shape == 'rectangle' then
            love.graphics.rectangle('line', self.x, self.y, self.w, self.h)
        --Draw Circle
        elseif self.shape == 'circle' then
            love.graphics.circle('line', self.x, self.y, self.r)
        end
    elseif self.cat == 1 then

        love.graphics.circle("line", self.x, self.y, self.radius)
        
        -- Dibujar el punto del joystick
        love.graphics.setColor(1, 0, 0)
        
        love.graphics.circle("line", self.mouseX, self.mouseY, 10)
        love.graphics.setColor(255, 255, 255)
    end
end

return touchbuttons
