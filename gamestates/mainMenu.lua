local mainMenu = {}

-- Pull in Gamestate from the HUMP library
Gamestate = require 'libs/hump/gamestate'

local gameLevel1 = require 'gamestates/gameLevel1'
local gameLevel2 = require 'gamestates/gameLevel2'

local function newButton(text, fn)
    return {
        text = text,
        fn = fn,

        now = false, 
        last = false
    }
end

local buttons = {}


function mainMenu:init()
    table.insert(buttons, newButton(
        "Start Game",
        function()
            Gamestate.switch(gameLevel2)
            print(state)
        end
    ))table.insert(buttons, newButton(
        "Exit",
        function()
           love.event.quit(0)
        end
    ))
end

function mainMenu:update(dt)
end

function mainMenu:draw()

    local ww = love.graphics.getWidth()
    local wh = love.graphics.getHeight()
    local button_width = ww * (1/3)
    local margin = 16
    local cursor_y = 0
    local button_height = 45
    local total_height = (25 + margin) * #buttons

    if state == true then
    end
    for i, button in ipairs(buttons) do
        button.last = button.now
        local color = {0,4, 0.4, 0.5, 1}
        local bx = (ww * 0.5) - (button_width * 0.5)
        local by = (wh * 0.5) -  (total_height * 0.5) + cursor_y
        local mx, my = love.mouse.getPosition()
        local hot = mx > bx and mx < bx + button_width and my > by and my < by + button_height

        if hot then 
            color = {0.8, 0.8, 0.9, 1.0}
        end

        button.now = love.mouse.isDown(1)
        if button.now and not button.last and hot then 
            button.fn()
        end

        love.graphics.setColor(unpack(color))
        love.graphics.rectangle("fill", bx, by, button_width, button_height )
        love.graphics.setColor(0,0,0,1)
        love.graphics.print(button.text, bx + 80, by + 15)


        cursor_y = cursor_y + (button_height + margin)
    end
    love.graphics.setColor(0,1,0,1)
    love.graphics.print("Game-Off 2020 // teamskynite.net // Miottos",100,500)
end

return mainMenu