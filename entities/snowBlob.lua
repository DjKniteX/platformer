local Class = require 'libs/hump/class'
local Entity = require 'entities/Entity'

local time = 0
local maxTime = 0.080
local frames = {}
local currentFrame = 1



local snowBlob = Class{
  __includes = Entity -- Player class inherits our Entity class
}

function snowBlob:init(world, x, y)
  self.img = love.graphics.newImage('/assets/Monster-Snowland Ice Ball.png')
  for y = 1, 1 do
    for x = 1, 1 do
      table.insert(frames, love.graphics.newQuad(16 * x - 16, 16 * y - 16, 16, 16, self.img:getDimensions()))
    end
  end

  

  Entity.init(self, world, x-8, y-8, 16, self.img:getHeight())

  self.sx = 1
  self.sy = 1
  self.offset = 15

  self.world:add(self, self:getRect())
end

function snowBlob:update(dt)
end

function snowBlob:draw()
  love.graphics.draw(self.img, frames[currentFrame], self.x, self.y,0,self.sx, self.sy,self.offset)
end


return snowBlob
