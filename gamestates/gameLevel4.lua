
-- Import our libraries.
local Gamestate = require 'libs/hump/gamestate'
local Class = require 'libs/hump/class'

-- Grab our base class
local LevelBase = require 'gamestates.LevelBase'

-- Import the Entities we will build.
local Player = require 'entities.player'
local salaryman = require 'entities.salaryman'
local buffBoss = require 'entities.buffBoss'
local camera = require 'libs.camera'

-- Declare a couple immportant variables
player = nil

local gameLevel4 = Class{--town
  __includes = LevelBase
}

function gameLevel4:init()
  LevelBase.init(self, 'assets/Frozen_Forest_Tileset/VillageTownNoSlope.lua')
end

function gameLevel4:enter()
  player = Player(self.world,  45*16, 45*16-4)
  man1 = salaryman(self.world, 8*16, 8*16-4)
  man2 = salaryman(self.world, 19*16, 8*16-4)
  man3 = salaryman(self.world, 6*16, 29*16-4)
  man4 = salaryman(self.world, 15*16, 48*16-4)
  man5 = salaryman(self.world, 29*16, 31*16-4)
  boss = buffBoss(self.world, 37*16, 11*16)
  LevelBase.Entities:add(player) -- add the player to the level
  LevelBase.Entities:add(man1)
  LevelBase.Entities:add(man2)
  LevelBase.Entities:add(man3)
  LevelBase.Entities:add(man4)
  LevelBase.Entities:add(man5)
  LevelBase.Entities:add(boss)
end

function gameLevel4:update(dt)
  self.map:update(dt) -- remember, we inherited map from LevelBase
  LevelBase.Entities:update(dt) -- this executes the update function for each individual Entity

  LevelBase.positionCamera(self, player, camera)
end

function gameLevel4:draw()
  -- Attach the camera before drawing the entities
  camera:set()
  
  love.graphics.setBackgroundColor(.529,.808,.922)
  --camera:setScale(2,2)s
  self.map:draw(-camera.x, -camera.y) -- Remember that we inherited map from LevelBase
  LevelBase.Entities:draw() -- this executes the draw function for each individual Entity

  camera:unset()
  -- Be sure to detach after running to avoid weirdness
end

-- All levels will have a pause menu
function gameLevel4:keypressed(key)
  LevelBase:keypressed(key)
end

return gameLevel4