function love.load()
    love.window.setTitle("METALhaven - by thedashdude for Ludum Dare 37")
    love.filesystem.setIdentity('screenshotsMF')
    Font = love.graphics.newFont("saxmono.ttf", 14)
    BigFont = love.graphics.newFont("saxmono.ttf", 40)
    love.graphics.setFont(Font)
    W,H = 512+64, 384+64+32+32
    love.window.setMode(W, H)
    Buttons = require 'Buttons'
    Game = require 'Game'
    State = "Menu"
    Game['Main']:setup()
    SCORE = 0
end

function love.update(dt)
    Game[State]:update(dt)
end
function love.draw()
    Game[State]:draw()
    --print(Menu.Buttons,Lose.Buttons)
end
function love.keypressed( key, scancode, isrepeat )
    Game[State]:keypressed(key,scancode,isrepeat)

    if key == 'f' then
        local name = string.format("screenshot-%s.png", os.date("%Y%m%d-%H%M%S"))
        local shot = love.graphics.newScreenshot()
        shot:encode("png",name)
        print(name)
    end

end

function formatNum(k)
    local str = math.floor(k*10)/10 .. ''
    if not str:find('%.') then
        str = str .. '.0'
    end
    return str
end

function clone(tab)
    local metatable = getmetatable(tab)
    local new = {}
    for k, v in pairs(tab) do
        if type(v) == 'table' then
            new[k] = clone(v)
        else
            new[k] = v
        end
    end
    setmetatable(new, metatable)
    return new
end
function gameover()
    Game['Lose']:createBG()
    Room:setup()
    Game['Main'] = clone(Room)
    State = 'Lose'
end
function love.mousepressed( x, y, button )
    Game[State]:mousepressed(x,y,button)
end
function love.quit( )

end