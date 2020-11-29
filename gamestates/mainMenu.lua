local mainMenu = {}

-- Pull in Gamestate from the HUMP library
Gamestate = require 'libs/hump/gamestate'

local gameLevel1 = require 'gamestates/gameLevel1'
local gameLevel2 = require 'gamestates/gameLevel2'
mainMenu1 = love.graphics.newImage('/assets/main1.png')



function mainMenu:init()

end

function mainMenu:update(dt)
end

function mainMenu:draw()
    love.graphics.reset()
    love.graphics.scale(2.7, 2.0)   -- reduce everything by 50% in both X and Y coordinates
    love.graphics.draw(mainMenu1)
    love.graphics.reset()
    love.graphics.setColor(0,1,0,1)
    love.graphics.print("Game-Off 2020 // teamskynite.net",30,580)
end

function mainMenu:keypressed(key)
    if key == 'return' then
      Gamestate.switch(gameLevel1)
    end
  end

return mainMenu