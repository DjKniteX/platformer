-- Pull in Gamestate from the HUMP library
Gamestate = require 'libs/hump/gamestate'

-- Pull in each of our game states
local mainMenu = require 'gamestates/mainmenu'
local gameLevel1 = require 'gamestates/gameLevel1'
local pause = require 'gamestates/pause'

function love.load()
  Gamestate.registerEvents()
  Gamestate.switch(mainMenu)
end
