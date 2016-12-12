local Lose = {}

Lose.Buttons = clone(Buttons)

Lose.BG = nil
Lose.Buttons:add('Menu',W - 64 + 8 ,16,48,24,function() State = 'Menu'; SCORE = 0 end)

function Lose:createBG()
    self.BG = love.graphics.newCanvas(W,H)
    love.graphics.setCanvas(self.BG)
    Game['Main']:draw()
    love.graphics.setCanvas()
end

function Lose:draw()
    love.graphics.setColor(100,100,100)
    love.graphics.draw(self.BG,0,0)
    self.Buttons:draw()
    love.graphics.setFont(BigFont)
    love.graphics.setColor(255,255,255)
    love.graphics.print(formatNum(SCORE),50,50)
end
function Lose:update( ... )
    -- body
end
function Lose:keypressed( ... )
    -- body
end
function Lose:mousepressed( ... )
    self.Buttons:update()
end
return Lose