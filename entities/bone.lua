World = require('../world')
Bone = {}
Bone.__index = Bone
ActiveBones = {}

function Bone.new(x,y)
   local instance = setmetatable({}, Bone)
   instance.x = x
   instance.y = y
   instance.img = love.graphics.newImage("assets/coin.png")
   instance.width = instance.img:getWidth()
   instance.height = instance.img:getHeight()
   instance.scaleX = 1
   instance.randomTimeOffset = math.random(0, 100)
   instance.toBeRemoved = false

   instance.physics = {}
   instance.physics.body = love.physics.newBody(World, instance.x, instance.y, "static")
   instance.physics.shape = love.physics.newRectangleShape(instance.width, instance.height)
   instance.physics.fixture = love.physics.newFixture(instance.physics.body, instance.physics.shape)
   instance.physics.fixture:setSensor(true)
   table.insert(ActiveBones, instance)
end

function Bone:remove()
    print("test")
   for i,instance in ipairs(ActiveBones) do
      if instance == self then
         player:incrementBones()
         print(player.Bones)
         self.physics.body:destroy()
         table.remove(ActiveBones, i)
      end
   end
end

function Bone:update(dt)
  
   self:spin(dt)
   self:checkRemove()
end

function Bone:checkRemove()
   if self.toBeRemoved then
    print("yo")
      self:remove()
   end
end

function Bone:spin(dt)
   self.scaleX = math.sin(love.timer.getTime() * 2 + self.randomTimeOffset)
end

function Bone:draw()
   love.graphics.draw(self.img, self.x, self.y, 0, self.scaleX, 1, self.width / 2, self.height / 2)
end

function Bone.updateAll(dt)
   for i,instance in ipairs(ActiveBones) do
      instance:update(dt)
   end
end

function Bone.drawAll()
   for i,instance in ipairs(ActiveBones) do
      instance:draw()
   end
end

function Bone.beginContact(a, b, collisions)
    print("function test")
   for i,instance in ipairs(ActiveBones) do
      if a == instance.physics.fixture or b == instance.physics.fixture then
         if a == player.physics.fixture or b == player.physics.fixture then
            print("fixture works")
            instance.toBeRemoved = true
            return true
         end
      end
   end
end

