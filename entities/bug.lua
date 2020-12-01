local Class = require 'libs/hump/class'
local Entity = require 'entities/Entity'

local time = 0
local maxTime = 0.080
local frames = {}
local currentFrame = 1



local dBoss = Class{
  __includes = Entity -- Player class inherits our Entity class
}

function dBoss:init(world, x, y)
  self.img = love.graphics.newImage('/assets/spr_wasp_idle_anim.gif')
  for y = 1, 1 do
    for x = 1, 1 do
      table.insert(frames, love.graphics.newQuad(96 * x - 96, 96 * y - 96, 96, 96, self.img:getDimensions()))
    end
  end

  

  Entity.init(self, world, x, y, 16, 32)


  self.sx = 1
  self.sy = 1
  self.offset = 15

  self.world:add(self, self:getRect())
end


function dBoss:update(dt)
end

function dBoss:draw()
  love.graphics.push()
  love.graphics.scale(.5, .5) 
  love.graphics.draw(self.img, frames[currentFrame], self.x*2, self.y*2,0,self.sx, self.sy,self.offset)
  love.graphics.pop()
end


return dBoss
