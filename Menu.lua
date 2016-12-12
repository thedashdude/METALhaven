local Menu = {}

Menu.Buttons = clone(Buttons)

Menu.Tiles = 'tiles2.png'
Menu.Tileset = love.graphics.newImage(Room.Tiles)

Menu.Buttons:add('Play',W - 64 + 8 ,16,48,24,function() State = 'Main';love.graphics.setFont(Font) end)
Menu.Buttons:add('Easy',W - 64 + 8 ,16+24+16,48,24,function() State = 'Main';Game[State].BadThings.Difficulty = 10 end)
Menu.Buttons:add('Help',W - 64 + 8 ,16+24+16+16+24+16+24,48,24,function() State = 'Tut'; Game[State]:setup() end)
Menu.Buttons:add('Quit',W - 64 + 8 ,16+24+16+16+24,48,24,function() love.event.quit( ) end)

Menu.Quads = {}
    Menu.Quads[1] = love.graphics.newQuad(32*6,64,32,32,256,256)
    Menu.Quads[2] = love.graphics.newQuad(32*7,64,32,32,256,256)
    Menu.Quads[3] = love.graphics.newQuad(0,96,32,32,256,256)
    Menu.Quads[4] = love.graphics.newQuad(32,96,32,32,256,256)
    Menu.Quads[5] = love.graphics.newQuad(32*2,96,32,32,256,256)
    Menu.Quads[6] = love.graphics.newQuad(32*3,96,32,32,256,256)
    Menu.Quads[7] = love.graphics.newQuad(32*4,96,32,32,256,256)
    Menu.Quads[8] = love.graphics.newQuad(32*5,96,32,32,256,256)
    Menu.Quads[9] = love.graphics.newQuad(32*6,96,32,32,256,256)
    Menu.Quads[10] = love.graphics.newQuad(32*7,96,32,32,256,256)

    Menu.Quads[0] = love.graphics.newQuad(32,0,32,32,256,256) -- Floor[HP]

Menu.Names = {
    M = 1,
    E = 2,
    T = 3,
    A = 4,
    L = 5,
    h = 6,
    a = 7,
    v = 8,
    e = 9,
    n = 10,
    FLOOR = 0
}




function Menu:draw()
    love.graphics.setColor(100,100,100)
    love.graphics.rectangle('fill',0,0,512+64,384+64+32+32)
    for i=1,18 do
        for j=1,20 do
            love.graphics.draw(self.Tileset,self.Quads[self.Names.FLOOR],i*32 - 32,j*32 - 32)
        end
    end
    
    love.graphics.setFont(Font)
    love.graphics.setColor(0,0,0)
    love.graphics.rectangle('fill',W-64,0,64,H)
    love.graphics.setColor(100,100,100)
    local size = 48
    local slope = 0.8858131487889273356401384083045
    love.graphics.polygon('fill', 0, 0, 0, size, W-64-size, H, W-64,H, W-64,H-size, size, 0)
    self.Buttons:draw()
    love.graphics.setColor(255,255,255)
    Menu:type('METALhaven',-32,-32)
    
end

function Menu:type(str,x,y)
    local slope = -0.8858131487889273356401384083045
    local dx = 32 + 17
    local dy = 32 + 17
    for i=1,#str do
        love.graphics.draw(self.Tileset,self.Quads[self.Names[str:sub(i,i)]],math.floor(x+(i)*dx),math.floor(y + (i)*dy))
    end
end

function Menu:update( ... )
    -- body
end
function Menu:keypressed( ... )
    -- body
end
function Menu:mousepressed( ... )
    self.Buttons:update()
end




return Menu