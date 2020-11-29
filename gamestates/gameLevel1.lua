
-- Import our libraries.
local Gamestate = require 'libs/hump/gamestate'
local Class = require 'libs/hump/class'
require("entities/bone")

-- Grab our base class
local LevelBase = require 'gamestates.LevelBase'

-- Import the Entities we will build.
local Player = require 'entities.player'
local camera = require 'libs.camera'

-- Declare a couple immportant variables
player = nil

local gameLevel1 = Class{
  __includes = LevelBase
}

function gameLevel1:init()
  love.graphics.reset()
  LevelBase.init(self, 'assets/levels/level_1.lua')
  Bone.new(300, 200)
  Bone.new(400, 200)
  Bone.new(500, 100)

end

function gameLevel1:enter()
  player = Player(self.world,  32, 64)
  LevelBase.Entities:add(player)
end

function gameLevel1:update(dt)
  self.map:update(dt) -- remember, we inherited map from LevelBase
  LevelBase.Entities:update(dt) -- this executes the update function for each individual Entity

  LevelBase.positionCamera(self, player, camera)
  Bone.updateAll(dt)
end

function gameLevel1:draw()
  love.graphics.reset()
  -- Attach the camera before drawing the entities
  camera:set()

  self.map:draw(-camera.x, -camera.y) -- Remember that we inherited map from LevelBase
  LevelBase.Entities:draw() -- this executes the draw function for each individual Entity

  Bone.drawAll()

  camera:unset()
  -- Be sure to detach after running to avoid weirdness


end

function beginContact(a, b, collision)
	if Bone.beginContact(a, b, collision) then return end
	if Spike.beginContact(a, b, collision) then return end
	Player:beginContact(a, b, collision)
end

-- All levels will have a pause menu
function gameLevel1:keypressed(key)
  LevelBase:keypressed(key)
end

return gameLevel1