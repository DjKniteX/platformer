
-- Import our libraries.
local Gamestate = require 'libs/hump/gamestate'
local Class = require 'libs/hump/class'

-- Grab our base class
local LevelBase = require 'gamestates.LevelBase'

-- Import the Entities we will build.
local Player = require 'entities.player'
local dBoss = require 'entities.desertBoss'
local camera = require 'libs.camera'

local sun = love.graphics.newImage('assets/Wasteland_Sky.png')
local mountain1 = love.graphics.newImage('assets/Wasteland_Mountains_1.png')
local mountain2 = love.graphics.newImage('assets/Wasteland_Mountains_2.png')

-- Declare a couple immportant variables
player = nil

local gameLevel3 = Class{--desert
  __includes = LevelBase
}

function gameLevel3:init()
  LevelBase.init(self, 'assets/Frozen_Forest_Tileset/DesertLand.lua')
end

function gameLevel3:enter()
  player = Player(self.world,  432,528)
  LevelBase.Entities:add(player) -- add the player to the level
end

function gameLevel3:update(dt)
  self.map:update(dt) -- remember, we inherited map from LevelBase
  LevelBase.Entities:update(dt) -- this executes the update function for each individual Entity

  LevelBase.positionCamera(self, player, camera)
end

function gameLevel3:draw()
  -- Attach the camera before drawing the entities
  camera:set()
  love.graphics.push()
  love.graphics.scale(2, 2) 
  love.graphics.draw(sun, -camera.x, -camera.y)
  love.graphics.draw(mountain2, -camera.x, -camera.y+25)
  love.graphics.draw(mountain1, -camera.x, -camera.y+50)
  love.graphics.pop()
  --camera:setScale(2,2)
  self.map:draw(-camera.x, -camera.y) -- Remember that we inherited map from LevelBase
  LevelBase.Entities:draw() -- this executes the draw function for each individual Entity

  camera:unset()
  -- Be sure to detach after running to avoid weirdness
end

-- All levels will have a pause menu
function gameLevel3:keypressed(key)
  LevelBase:keypressed(key)
end

return gameLevel3