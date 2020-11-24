
-- Import our libraries.
local Gamestate = require 'libs/hump/gamestate'
local Class = require 'libs/hump/class'

-- Grab our base class
local LevelBase = require 'gamestates.LevelBase'

-- Import the Entities we will build.
local Player = require 'entities.player'
local snowBlob = require 'entities.snowBlob'
local camera = require 'libs.camera'

-- Declare a couple immportant variables
player = nil

local gameLevel2 = Class{--frozenforest
  __includes = LevelBase
}

function gameLevel2:init()
  LevelBase.init(self, 'assets/Frozen_Forest_Tileset/FrostyForest1BG.lua')
end

function gameLevel2:enter()
  player = Player(self.world,  32, 350)
  blob1 = snowBlob(self.world, 12*16, 21*16)
  blob2 = snowBlob(self.world, 11*16, 33*16)
  blob3 = snowBlob(self.world, 20*16, 33*16)
  blob4 = snowBlob(self.world, 13*16, 40*16)
  blob5 = snowBlob(self.world, 15*16, 48*16)
  blob6 = snowBlob(self.world, 44*16, 9*16)
  blob7 = snowBlob(self.world, 33*16, 23*16)
  LevelBase.Entities:add(player) -- add the player to the level
  LevelBase.Entities:add(blob1)
  LevelBase.Entities:add(blob2)
  LevelBase.Entities:add(blob3)
  LevelBase.Entities:add(blob4)
  LevelBase.Entities:add(blob5)
  LevelBase.Entities:add(blob6)
  LevelBase.Entities:add(blob7)
end

function gameLevel2:update(dt)
  self.map:update(dt) -- remember, we inherited map from LevelBase
  LevelBase.Entities:update(dt) -- this executes the update function for each individual Entity

  LevelBase.positionCamera(self, player, camera)
end

function gameLevel2:draw()
  love.graphics.reset()
  -- Attach the camera before drawing the entities
  camera:set()
  
  --camera:setScale(2,2)
  self.map:draw(-camera.x, -camera.y) -- Remember that we inherited map from LevelBase
  LevelBase.Entities:draw() -- this executes the draw function for each individual Entity

  camera:unset()
  -- Be sure to detach after running to avoid weirdness
end

-- All levels will have a pause menu
function gameLevel2:keypressed(key)
  LevelBase:keypressed(key)
end

return gameLevel2