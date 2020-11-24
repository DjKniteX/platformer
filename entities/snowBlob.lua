local Class = require 'libs/hump/class'
local Entity = require 'entities/Entity'

local time = 0
local maxTime = 0.080
local frames = {}
local currentFrame = 1
local jump = love.audio.newSource("assets/jump.mp3", "static")



local snowBlob = Class{
  __includes = Entity -- Player class inherits our Entity class
}

function snowBlob:init(world, x, y)
  self.img = love.graphics.newImage('/assets/Monster-Snowland Ice Ball.png')
  for y = 1, 1 do
    for x = 1, 6 do
      table.insert(frames, love.graphics.newQuad(16 * x - 16, 16 * y - 16, 16, 16, self.img:getDimensions()))
    end
  end

  

  Entity.init(self, world, x, y, self.img:getWidth(), self.img:getHeight())

  -- Add our unique player values
  self.xVelocity = 0 -- current velocity on x, y axes
  self.yVelocity = 0
  self.acc = 100 -- the acceleration of our player
  self.maxSpeed = 600 -- the top speed
  self.friction = 50 -- slow our player down - we could toggle this situationally to create icy or slick platforms
  self.gravity = 80 -- we will accelerate towards the bottom

    -- These are values applying specifically to jumping
  self.isJumping = false -- are we in the process of jumping?
  self.isGrounded = false -- are we on the ground?
  self.hasReachedMax = false  -- is this as high as we can go?
  self.jumpAcc = 250 -- how fast do we accelerate towards the top
  self.jumpMaxSpeed = 9 -- our speed limit while jumping

  self.sx = 1
  self.sy = 1
  self.offset = 15

  self.world:add(self, self:getRect())
end

function snowBlob:collisionFilter(other)
  local x, y, w, h = self.world:getRect(other)
  local playerBottom = self.y + self.h
  local otherBottom = y + h

  if playerBottom <= y then -- bottom of player collides with top of platform.
    return 'slide'
  end
end

function snowBlob:update(dt)
  local prevX, prevY = self.x, self.y
  local width = 32
  local height =32 
end

function snowBlob:draw()
  love.graphics.draw(self.img, frames[currentFrame], self.x, self.y,0,self.sx, self.sy,self.offset)
end


return snowBlob
