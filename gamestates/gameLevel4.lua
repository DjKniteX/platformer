
-- Import our libraries.
local Gamestate = require 'libs/hump/gamestate'
local Class = require 'libs/hump/class'

-- Grab our base class
local LevelBase = require 'gamestates.LevelBase'
local gameLevel5 = require 'gamestates/gameLevel5'

-- Import the Entities we will build.
local Player = require 'entities.player'
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
  boss = buffBoss(self.world, 47*16, 1*16+8)
  LevelBase.Entities:add(player) -- add the player to the level
  LevelBase.Entities:add(boss)
end

function gameLevel4:update(dt)
  self.map:update(dt) -- remember, we inherited map from LevelBase
  LevelBase.Entities:update(dt) -- this executes the update function for each individual Entity

  LevelBase.positionCamera(self, player, camera)
  
  if player.x >= (46*16) and player.x < (47*16) and player.y >= (1*16) and player.y < (2*16) then 
    Gamestate.switch(gameLevel5)
  elseif player.x < 0 or player .x > 800 or player.y > 800 then
    LevelBase.Entities:remove(player)
    LevelBase.Entities:remove(boss)
    Gamestate.switch(gameLevel4)
  end
end

function gameLevel4:draw()
  -- Attach the camera before drawing the entities
  camera:set()
  
  love.graphics.setBackgroundColor(.529,.808,.922)
  --camera:setScale(2,2)s
  love.graphics.push()
  love.graphics.scale(2, 2) 
  self.map:draw(-camera.x, -camera.y) -- Remember that we inherited map from LevelBase
  love.graphics.pop()
  LevelBase.Entities:draw() -- this executes the draw function for each individual Entity

  camera:unset()
  -- Be sure to detach after running to avoid weirdness
end

-- All levels will have a pause menu
function gameLevel4:keypressed(key)
  LevelBase:keypressed(key)
end

return gameLevel4