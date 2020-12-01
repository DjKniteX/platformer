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

  Entity.init(self, world, x, y, 16, 24)

  -- Add our unique player values
  self.xVelocity = 0 -- current velocity on x, y axes
  self.yVelocity = 0
  self.acc = 160 -- the acceleration of our player
  self.maxSpeed = 8 -- the top speed
  self.friction = 140 -- slow our player down - we could toggle this situationally to create icy or slick platforms
  self.gravity = 150 -- we will accelerate towards the bottom

    -- These are values applying specifically to jumping
  self.isJumping = false -- are we in the process of jumping?
  self.isGrounded = false -- are we on the ground?
  self.hasReachedMax = false  -- is this as high as we can go?
  self.jumpAcc = 7 -- how fast do we accelerate towards the top
  self.jumpMaxSpeed = 11 -- our speed limit while jumping
  self.graceTime = 0
  self.graceDuration = 0.1
  self.countdown = .25

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
  --print(self.x, self.y)
  Bone.updateAll(dt)
  local prevX, prevY = self.x, self.y
  -- Apply Friction
  self.xVelocity = self.xVelocity * (1 - math.min(dt * self.friction, 1))
  self.yVelocity = self.yVelocity * (1 - math.min(dt * self.friction, 1))
 --grace time
  if not self.grounded then
    self.graceTime = self.graceTime - dt
  end
  -- Apply gravity
  --if not self.isGrounded then
    self.yVelocity = self.yVelocity + self.gravity * dt
  --end
  --move
	if love.keyboard.isDown("left", "a") and self.xVelocity > -self.maxSpeed then
    self.xVelocity = self.xVelocity - self.acc * dt
    self.sx = -1
	elseif love.keyboard.isDown("right", "d") and self.xVelocity < self.maxSpeed then
    self.xVelocity = self.xVelocity + self.acc * dt
    self.sx = 1
	end

  -- The Jump code gets a lttle bit crazy.  Bare with me.
  if love.keyboard.isDown("up", "w") then
    if self.isGrounded or self.graceTime > 0 then
      --print(self.isGrounded)
      self.yVelocity = self.yVelocity - self.jumpAcc
      self.graceTime = 0
      self.isJumping = true
      --self.isGrounded = false
    end
  end

  if self.isJumping then
    if self.countdown <= 0  or not love.keyboard.isDown("up","w") then
      self.countdown = .25
      self.isJumping = false
    elseif not (self.yVelocity < -self.jumpMaxSpeed) then
      self.yVelocity = self.yVelocity - self.jumpAcc
      self.countdown= self.countdown - dt
    end
  end

  -- these store the location the player will arrive at should
  local goalX = self.x + self.xVelocity
  local goalY = self.y + self.yVelocity

  -- Move the player while testing for collisions
  self.x, self.y, collisions, len = self.world:move(self, goalX, goalY, self.collisionFilter)
  if len == 0 then
    self.isGrounded = false
    print("air1")
  end

  -- Loop through those collisions to see if anything important is happening
  for i, coll in ipairs(collisions) do
    if coll.touch.y < goalY and coll.normal.y < 0 then
      self.hasReachedMax = false
      self.isGrounded = true
      self.graceTime = self.graceDuration
      print("ground")
    elseif coll.touch.y > goalY then
      self.isGrounded = false
      print("ceiling")
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
  love.graphics.draw(self.img, frames[currentFrame], self.x+8, self.y-8,0,self.sx, self.sy,self.offset)
  love.graphics.rectangle('line', self:getRect())
end

function beginContact(a, b, collisions)
	if self.isGrounded == true then return end
   local nx, ny = collision:getNormal()
   if a == self.physics.fixture then
      if ny > 0 then
         self:land(collision)
      elseif ny < 0 then
         self.yVel = 0
      end
   elseif b == self.physics.fixture then
      if ny < 0 then
         self:land(collision)
      elseif ny > 0 then
         self.yVel = 0
      end
   end
end

function endContact(a, b, collisions)
	if a == self.physics.fixture or b == self.physics.fixture then
    if self.currentGroundCollision == collision then
       self.grounded = false
    end
 end
end
function player:jump(key)
  if (key == "w" or key == "up" or key == "space") then
     if self.isGrounded or self.graceTime > 0 then
        self.yVelocity = -500
        self.graceTime = 0
     end
  end
end
return player