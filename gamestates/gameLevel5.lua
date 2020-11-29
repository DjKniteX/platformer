
-- Import our libraries.
local Gamestate = require 'libs/hump/gamestate'
local Class = require 'libs/hump/class'

-- Grab our base class
local LevelBase = require 'gamestates.LevelBase'

-- Import the Entities we will build.
local Player = require 'entities.player'
local caterpillar = require 'entities.caterpillar'
local reaper = require 'entities.reaper'
local camera = require 'libs.camera'

-- Declare a couple immportant variables
player = nil

local gameLevel5 = Class{--jungle
  __includes = LevelBase
}

function gameLevel5:init()
  LevelBase.init(self, 'assets/Frozen_Forest_Tileset/DeepJungleNoSlope.lua')
end

function gameLevel5:enter()
  player = Player(self.world,  20*16, 5*16)
  LevelBase.Entities:add(player) -- add the player to the level
end

function gameLevel5:update(dt)
  self.map:update(dt) -- remember, we inherited map from LevelBase
  LevelBase.Entities:update(dt) -- this executes the update function for each individual Entity

  LevelBase.positionCamera(self, player, camera)
end

function gameLevel5:draw()
  -- Attach the camera before drawing the entities
  camera:set()
  love.graphics.setBackgroundColor(.529,.808,.922)
  --camera:setScale(2,2)
  self.map:draw(-camera.x, -camera.y) -- Remember that we inherited map from LevelBase
  LevelBase.Entities:draw() -- this executes the draw function for each individual Entity

  camera:unset()
  -- Be sure to detach after running to avoid weirdness
end

-- All levels will have a pause menu
function gameLevel5:keypressed(key)
  LevelBase:keypressed(key)
end

return gameLevel5