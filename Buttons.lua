local Buttons = {}
Buttons.font = love.graphics.newFont( "saxmono.ttf", 14)

function Buttons:add(text,x,y,w,h,func)
    self[#self + 1] = {text,x,y,w,h,func}
end
function Buttons:update()
    mx, my = love.mouse.getPosition()
    for i = 1, #self do
        if mx >= self[i][2] and mx <= self[i][2]+self[i][4] and my >= self[i][3] and my <= self[i][3]+self[i][5] then
            self[i][6]()
        end  
    end
end
function Buttons:draw()
    love.graphics.setFont(self.font)
    for i = 1, #self do
        x = self[i][2]
        y = self[i][3]
        text = self[i][1]
        h = self[i][5]
        w = self[i][4]
        love.graphics.setColor(150,150,150)
        love.graphics.rectangle('fill',x,y,w,h)
        love.graphics.setColor(0,0,0)
        love.graphics.rectangle('line',x,y,w,h)
        love.graphics.setColor(0,0,0)
        love.graphics.printf(text,x,y+5,w,'center')
    end
end
function Buttons.width(text)
    return 6 + 8*text:len()
end
return Buttons