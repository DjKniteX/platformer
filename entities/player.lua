local Class = require 'libs.hump.class'
local Entity = require 'entities.Entity'

local player = Class{
  __includes = Entity -- Player class inherits our Entity class
}


local time = 0
local maxTime = 0.080
local frames = {}
local currentFrame = 1

require("entities/bone")

function player:init(world, x, y)
  self.img = love.graphics.newImage('/assets/linus.png')
  for y = 1, 1 do
    for x = 1, 6 do
      table.insert(frames, love.graphics.newQuad(32 * x - 32, 32 * y - 32, 32, 32, self.img:getDimensions()))
    end
  end

  Entity.init(self, world, x, y, 8, self.img:getHeight())

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
  self.jumpAcc = 500 -- how fast do we accelerate towards the top
  self.jumpMaxSpeed = 11 -- our speed limit while jumping

  self.world:add(self, self:getRect())

  self.sx = 1
  self.sy = 1
  self.offset = 15

  -- physics system
  self.width = 20
  self.height = 60
  self.physics = {}
  self.physics.body = love.physics.newBody(World, self.x, self.y, "dynamic")
  self.physics.body:setFixedRotation(true)
  self.physics.shape = love.physics.newRectangleShape(self.width, self.height)
  self.physics.fixture = love.physics.newFixture(self.physics.body, self.physics.shape)

    -- eventually scoring system
  self.score = 0
end


function player:collisionFilter(other)
  local x, y, w, h = self.world:getRect(other)
  local playerBottom = self.y + self.h
  local otherBottom = y + h

  --if playerBottom <= y then -- bottom of player collides with top of platform.
    return 'slide'
  --end
end


--[[
player.filter = function(item, other)
  local x, y, w, h = world:getRect(other)
  local px, py, pw, ph = world:getRect(item)
  local playerBottom = py + ph
  local otherBottom = y + h
  if playerBottom <= y then -- collide with top
    return 'slide'
  --[[elseif py >= otherBottom then
    return nil -- no collision. We pass through the bottom of this platform
  elseif math.max(playerBottom, otherBottom) - math.min(py, y) <= ph + h then
    -- http://stackoverflow.com/questions/3269434/whats-the-most-efficient-way-to-test-two-integer-ranges-for-overlap
    return 'bounce'
  end
end
]]

function player:incrementBones()
  self.score = self.score  + 1
end

function player:update(dt)
  print(self.x, self.y)
  Bone.updateAll(dt)
  local prevX, prevY = self.x, self.y

  -- Apply Friction
  self.xVelocity = self.xVelocity * (1 - math.min(dt * self.friction, 1))
  self.yVelocity = self.yVelocity * (1 - math.min(dt * self.friction, 1))

  -- Apply gravity
  self.yVelocity = self.yVelocity + self.gravity * dt

	if love.keyboard.isDown("left", "a") and self.xVelocity > -self.maxSpeed then
    self.xVelocity = self.xVelocity - self.acc * dt
    self.sx = -1
	elseif love.keyboard.isDown("right", "d") and self.xVelocity < self.maxSpeed then
    self.xVelocity = self.xVelocity + self.acc * dt
    self.sx = 1
	end

  -- The Jump code gets a lttle bit crazy.  Bare with me.
  if love.keyboard.isDown("up", "w") then
    if -self.yVelocity < self.jumpMaxSpeed and not self.hasReachedMax then
      self.yVelocity = self.yVelocity - self.jumpAcc * dt
    elseif math.abs(self.yVelocity) > self.jumpMaxSpeed then
      self.hasReachedMax = true
    end

    self.isGrounded = false -- we are no longer in contact with the ground
  end

  -- these store the location the player will arrive at should
  local goalX = self.x + self.xVelocity
  local goalY = self.y + self.yVelocity

  -- Move the player while testing for collisions
  self.x, self.y, collisions, len = self.world:move(self, goalX, goalY, self.collisionFilter)

  -- Loop through those collisions to see if anything important is happening
  for i, coll in ipairs(collisions) do
    if coll.touch.y > goalY then  -- We touched below (remember that higher locations have lower y values) our intended target.
      self.hasReachedMax = true -- this scenario does not occur in this demo
      self.isGrounded = false
    elseif coll.normal.y < 0 then
      self.hasReachedMax = false
      self.isGrounded = true
    end
  end


  	--update our time event each frame.
	time = time + dt

	--when time becomes equal or bigger than maximum time;
	if time >= maxTime then
		--reset it
		time = 0

		--and update our current frame.
		currentFrame = currentFrame + 1

		--if current frame becomes bigger than length of the frames,
		if currentFrame > #frames then

			--reset it to first frame, and loop restarts.
			currentFrame = 1
		end
	end
end

function player:draw()
  love.graphics.draw(self.img, frames[currentFrame], self.x, self.y,0,self.sx, self.sy,self.offset)
  love.graphics.rectangle('line', self:getRect())
end

function beginContact(a, b, collisions)
	if Bone.beginContact(a, b, collisions) then return end
	player:beginContact(a, b, collisions)
end

function endContact(a, b, collisions)
	player:endContact(a, b, collisions)
end

return player