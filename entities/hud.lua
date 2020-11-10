-- entities/paddle.lua 

local world = require('world')

local entity = {}
entity.body = love.physics.newBody(world, 200, 60, 'static')
entity.shape = love.physics.newRectangleShape(140, 40)
entity.fixture = love.physics.newFixture(entity.body, entity.shape)

return entity