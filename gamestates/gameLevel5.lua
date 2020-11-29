
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
  LevelBase.init(self, 'assets/Frozen_Forest_Tileset/DeepJungle.lua')
end

function gameLevel5:enter()
  player = Player(self.world,  20*16, 5*16)
  cat1 = caterpillar(self.world, 10*16, 13*16)
  cat2 = caterpillar(self.world, 12*16, 22*16)
  cat3 = caterpillar(self.world, 15*16, 32*16)
  cat4 = caterpillar(self.world, 48*16, 13*16)
  cat5 = caterpillar(self.world, 35*16, 21*16)
  cat6 = caterpillar(self.world, 35*16, 41*16)
  reaper = reaper(self.world, 10*16, 42*16)
  LevelBase.Entities:add(player) -- add the player to the level
  LevelBase.Entities:add(cat1)
  LevelBase.Entities:add(cat2)
  LevelBase.Entities:add(cat3)
  LevelBase.Entities:add(cat4)
  LevelBase.Entities:add(cat5)
  LevelBase.Entities:add(cat6)
  LevelBase.Entities:add(reaper)
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