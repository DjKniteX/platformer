local Class = require('libs/hump/class')
local Entity = require('entities/Entity')

local Ground = Class{
    _includes = Entity -- ground class inherits our Entity class
}

function Ground:init(world, x,y, w,h)
    Entity.init(self, world, x,y,w,h)
    self.world:add(self, self:getRect())
end 

function Ground:draw()
    love.graphics.rectangle('fill', self:getRect())
end 

return Ground