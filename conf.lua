--conf.lua 
-- LOVE configuration file

love.conf = function(t)
    t.console = true -- enable the debug console for windows
    t.window.title = "Moonward Bound - Mockingbird Summit"  
    t.window.width = 800 -- game's screen width (num of pixels)
    t.window.height = 600 -- game's screen height (num of pixels)
end 
