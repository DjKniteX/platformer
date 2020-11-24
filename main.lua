-- Pull in Gamestate from the HUMP library
Gamestate = require 'libs/hump/gamestate'

-- Pull in each of our game states
local mainMenu = require 'gamestates/mainmenu'
local gameLevel1 = require 'gamestates/gameLevel1'
local gameLevel2 = require 'gamestates/gameLevel2'
local gameLevel3 = require 'gamestates/gameLevel3'
local gameLevel4 = require 'gamestates/gameLevel4'
local gameLevel5 = require 'gamestates/gameLevel5'
local pause = require 'gamestates/pause'

function love.load()
  Gamestate.registerEvents()
  Gamestate.switch(gameLevel3)
end
