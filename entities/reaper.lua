local Class = require 'libs/hump/class'
local Entity = require 'entities/Entity'

local time = 0
local maxTime = 0.080
local frames = {}
local currentFrame = 1



local reaper = Class{
  __includes = Entity -- Player class inherits our Entity class
}

function reaper:init(world, x, y)
  self.img = love.graphics.newImage('/assets/Undead executioner puppet/png/idle.png')
  for y = 1, 1 do
    for x = 1, 1 do
      table.insert(frames, love.graphics.newQuad(125 * x - 125, 125 * y - 125, 125, 100, self.img:getDimensions()))
    end
  end

  

  Entity.init(self, world, x, y, 16, 32)

  self.sx = 1
  self.sy = 1
  self.offset = 15

  self.world:add(self, self:getRect())
end

function reaper:update(dt)
end

function reaper:draw()
  love.graphics.push()
  love.graphics.scale(1.25, 1.25) 
  love.graphics.draw(self.img, frames[currentFrame], self.x*.8, self.y*.8,0,self.sx, self.sy,self.offset)
  love.graphics.pop()
end


return reaper
