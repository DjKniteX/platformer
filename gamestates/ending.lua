local ending = {}

-- Pull in Gamestate from the HUMP library
Gamestate = require 'libs/hump/gamestate'

function ending:init()
    video = love.graphics.newVideo('assets/ending.ogv')
    video:play()
end

function ending:update(dt)

end

function ending:draw()
    love.graphics.reset()
    --love.graphics.scale(1.5,1.1)
    love.graphics.draw(video,100,0)
end

function ending:keypressed(key)
    if key == 'return' then
      love.event.quit()
    end
  end

return ending