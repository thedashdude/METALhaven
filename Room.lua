local Room = {}
Room.BadThings = require 'BadThings'
Room.Effects = require 'Effects'
Room.PowerUps = require 'PowerUps'

Room.WIDTH = 16
Room.HEIGHT = 12

Room.BadThings:setUp(Room.WIDTH,Room.HEIGHT)
Room.PowerUps:setUp(Room.WIDTH,Room.HEIGHT)


Room.BadThings.Difficulty = Room.BadThings.MaxDif

Room.MaxBurn = 70
Room.MinFloor = 35


--Room.PowerUps:make()
--Room.BadThings:addMissile()
--Room.BadThings:enableTerminal()

Room.NextPowerUp = 25


Room.FireInfo = {t = 3, c = 5, tMax = 12}

Room.Tiles = 'tiles2.png'
Room.Tileset = love.graphics.newImage(Room.Tiles)
Room.Quads = {}
    Room.Quads[0] = love.graphics.newQuad(32,0,32,32,256,256) -- Floor[HP]
    Room.Quads[1] = love.graphics.newQuad(64,0,32,32,256,256) -- Floor[Damaged]
    Room.Quads[100] = love.graphics.newQuad(0,32,32,32,256,256) -- Wall
    Room.Quads[101] = love.graphics.newQuad(96,0,32,32,256,256) -- Flaming Floor
    Room.Quads[110] = love.graphics.newQuad(32,32,32,32,256,256) -- Damaged Wall
    Room.Quads[120] = love.graphics.newQuad(64,32,32,32,256,256) -- Destroyed Wall
    Room.Quads[-1] = love.graphics.newQuad(0,0,32,32,256,256) -- Player
    Room.Quads[-2] = love.graphics.newQuad(128,0,32,32,256,256) -- Scrap
    Room.Quads[-3] = love.graphics.newQuad(128+32,0,32,32,256,256) -- Water
    Room.Quads[2] = love.graphics.newQuad(128+64,0,32,32,256,256) -- PIPE
    Room.Quads[-4] = love.graphics.newQuad(96,32,32,32,256,256) -- RWarning
    Room.Quads[-5] = love.graphics.newQuad(96+32,32,32,32,256,256) -- GWarning
    Room.Quads[-6] = love.graphics.newQuad(96+64,32,32,32,256,256) -- BWarning
    Room.Quads[3] = love.graphics.newQuad(7*32,0,32,32,256,256) -- Terminal
    Room.Quads[-7] = love.graphics.newQuad(6*32,32,32,32,256,256) -- Hburn
    Room.Quads[-8] = love.graphics.newQuad(7*32,32,32,32,256,256) -- Vburn
    Room.Quads[-9] = love.graphics.newQuad(0,64,32,32,256,256) -- Burn
    Room.Quads[-10] = love.graphics.newQuad(32,64,32,32,256,256) -- P1
    Room.Quads[-11] = love.graphics.newQuad(64,64,32,32,256,256) -- P2
    Room.Quads[-12] = love.graphics.newQuad(96,64,32,32,256,256) -- P3
    Room.Quads[-13] = love.graphics.newQuad(128,64,32,32,256,256) -- P4

    Room.Quads[-100] = love.graphics.newQuad(0,128,32,32,256,256) -- PlayerDOWN
    Room.Quads[-101] = love.graphics.newQuad(32,128,32,32,256,256) -- PlayerUP
    Room.Quads[-102] = love.graphics.newQuad(64,128,32,32,256,256) -- PlayerRIGHT
    Room.Quads[-103] = love.graphics.newQuad(96,128,32,32,256,256) -- PlayerLEFT

Room.Effects:setUp(Room.Tileset,Room.Quads)

Room.Names = {
    FLOOR = 0, 
    DFLOOR = 1, 
    WALL = 100, 
    FFLOOR = 101, 
    DWALL = 110, 
    PLAYER = -100, 
    SCRAP = -2, 
    WATER = -3, 
    PIPE = 2,
    RWARN = -4, 
    GWARN = -5, 
    BWARN = -6, 
    XWALL = 120,
    TERMINAL = 3,
    HBURN = -7,
    VBURN = -8,
    BURN = -9,
    P1 = -10,
    P2 = -11,
    P3 = -12,
    P4 = -13
}

Room.Player = {x = 2, y = 2, dx = 1, dy = 0, water = false, scrap = 4}
Room.Layout = {}
Room.Controls = {UP = 'up', DOWN = 'down',RIGHT = 'right',LEFT = 'left', INTERACT = 'z', POWERUP = 'x'}

--[[
0 - Floor [With HP]
1 - Floor [Damaged]

100 - Wall
101 - Flaming Floor
110 - Wall [Damaged]


]]
function Room:setup()
    local function randInt(max)
        return math.floor(math.random()*max+1)
    end
    for i=1,self.WIDTH do
        self.Layout[i] = {}
        for j=1,self.HEIGHT do
            self.Layout[i][j] = 0
            if i == 1 or j == 1 or i == self.WIDTH or j == self.HEIGHT then
                self.Layout[i][j] = 100
            end
        end
    end
    self.Player.x = randInt(self.WIDTH-2) + 1
    self.Player.y = randInt(self.HEIGHT-2) + 1
    self.Player.dx = 0
    self.Player.dy = 1
    self.Player.water = false
    self.Player.scrap = 4
    self.Pipe = {x = randInt(self.WIDTH-2) + 1, y = randInt(self.HEIGHT-2) + 1}
    self.BadThings.Terminal.x = randInt(self.WIDTH-2) + 1
    self.BadThings.Terminal.y = randInt(self.HEIGHT-2) + 1
    self.Layout[self.BadThings.Terminal.x][self.BadThings.Terminal.y] = 3
    self.Layout[self.Pipe.x][self.Pipe.y] = 2
end



function Room:draw(dt)
    love.graphics.setColor(100,100,100)
    love.graphics.rectangle('fill',0,0,32*self.WIDTH+64,32*self.HEIGHT+64+32)
    love.graphics.setColor(255,255,255)
    self:drawLayout()
    
    
    self:drawMissiles()
    self:drawTerminal()

    if self.PowerUps.next then
        local str = formatNum(self.PowerUps.next.t)
        love.graphics.setColor(0,0,255)
        love.graphics.printf(str,32*self.PowerUps.next.x,32*self.PowerUps.next.y+32,32,'center')
        love.graphics.setColor(255,255,255)
        love.graphics.draw(self.Tileset,self.Quads[self.Names.BWARN],self.PowerUps.next.x*32,self.PowerUps.next.y*32)
    end

    self:drawPlayer()
    self.Effects:draw()
    self:drawHUD()
    self:drawInfo()
    
end
function Room:update(dt)
    dt = dt
    self:updateInfo(dt)
    self.PowerUps:update(dt, self.Player)

    dt = self.PowerUps:setDt(dt)
    SCORE = SCORE + dt
    self:FireUpdate(dt)
    self:updatePlayer(dt)
    self.Effects:update(dt)


    local triggered, list = self.BadThings:update(dt,self.Player) -- T R I G G E R E D
    if #triggered>=1 then
        for i=1, #triggered do
            self:triggerMissile(triggered[i])
        end
    end
    if list ~= nil then
        for i=1, #list do
            self:hitLayout(list[i].x,list[i].y)
            self.Effects:add(self.Names.BURN,list[i].x*32,list[i].y*32,0,0,0.1)
        end
    end


    self.NextPowerUp = self.NextPowerUp - dt
    if self.NextPowerUp < 0 then
        self.PowerUps:make()
        self.NextPowerUp = 25
    end
end

function Room:mousepressed(x,y,button)

end



function Room:keypressed(key,other1,other2)
    local dx, dy = 0,0
    if key == self.Controls.UP then
        dy = -1
    elseif key == self.Controls.DOWN then
        dy = 1
    elseif key == self.Controls.LEFT then
        dx = -1
    elseif key == self.Controls.RIGHT then
        dx = 1
    elseif key == self.Controls.INTERACT then
        self:interact()
    elseif key == self.Controls.POWERUP then
        if self.PowerUps:turnOn() == 3 then
            for i=1,self.WIDTH do for j=1,self.HEIGHT do if self.Layout[i][j] == self.Names.FFLOOR then self.Layout[i][j] = self.Names.DFLOOR end end end 
        end
    end
    if key == 'j' then
        --C:\Users\theda_000\AppData\Roaming\LOVE\screenshotsMF
        local name = string.format("screenshot-%s.png", os.date("%Y%m%d-%H%M%S"))
        local shot = love.graphics.newScreenshot()
        shot:encode("png",name)
        print(name)
    end

    self:movePlayer(dx,dy)
end






function Room:updatePlayer(dt)
    local P = Room.Player
    
end
function Room:interact()
    local P = self.Player
    if self.Layout[P.x][P.y] == self.Names.PIPE then
        P.water = true
    end
    if self.Layout[P.x+P.dx][P.y+P.dy] == self.Names.WALL and P.scrap < 4 then --Take Scrap From Wall
        self.Player.scrap = 1 + self.Player.scrap
        self.Layout[P.x+P.dx][P.y+P.dy] = self.Names.DWALL
    elseif self.Layout[P.x+P.dx][P.y+P.dy] == self.Names.DWALL and P.scrap > 0  then --Repair Wall
        self.Player.scrap = self.Player.scrap - 1
        self.Layout[P.x+P.dx][P.y+P.dy] = self.Names.WALL
    end
    if self.Layout[P.x+P.dx][P.y+P.dy] == self.Names.FFLOOR and P.water then --Douse Flames
        self.Player.water = false
        self.Layout[P.x+P.dx][P.y+P.dy] = self.Names.DFLOOR
        SCORE = SCORE + 2
    elseif self.Layout[P.x+P.dx][P.y+P.dy] == self.Names.DFLOOR and P.scrap > 0 then --MAGA
        self.Player.scrap = self.Player.scrap - 1
        self.Layout[P.x+P.dx][P.y+P.dy] = self.Names.DWALL
    end
    if self.Layout[P.x][P.y] == self.Names.FFLOOR then
        P.x = self.Pipe.x
        P.y = self.Pipe.y
    end
end
function Room:movePlayer(dx,dy)
    if self.Layout[self.Player.x+dx][self.Player.y+dy] < 100 then 
        self.Player.x = self.Player.x+dx
        self.Player.y = self.Player.y+dy
    end
    if not (dx == 0 and dy == 0) then
        self.Player.dx = dx
        self.Player.dy = dy
    end
end










function Room:getPlayerQuad( ... )
    if self.Player.dx == 1 then
        return self.Quads[-102]
    elseif  self.Player.dx == -1 then
        return self.Quads[-103]
    elseif  self.Player.dy == 1 then
        return self.Quads[-100]
    elseif  self.Player.dy == -1 then
        return self.Quads[-101]
    end
    return self.Quads[-1]
end


function Room:drawPlayer()
    love.graphics.setColor(255,255,255)
    love.graphics.draw(self.Tileset,self:getPlayerQuad(),self.Player.x*32,self.Player.y*32)
    --love.graphics.line(self.Player.x*32+16,self.Player.y*32+16,self.Player.x*32+16+16*self.Player.dx,self.Player.y*32+16+16*self.Player.dy)
end
function Room:drawMissiles()
    for k,v in pairs(self.BadThings.Missiles) do
        love.graphics.draw(self.Tileset,self.Quads[self.Names.RWARN],v.x*32,v.y*32)
        love.graphics.setColor(255,0,0)
        local str = formatNum(v.t)
        love.graphics.printf(str,32*v.x,32*v.y+32,32,'center')
        love.graphics.setColor(255,255,255)
    end
end
function Room:drawTerminal()
    if self.BadThings.Terminal.enabled then
        for k,v in pairs(self.BadThings.Terminal.list) do
            love.graphics.setColor(255,255,255)
            love.graphics.draw(self.Tileset,self.Quads[self.Names.GWARN],v.x*32,v.y*32)
            love.graphics.setColor(0,255,0)
            local str = formatNum(self.BadThings.Terminal.t)
            love.graphics.printf(str,32*v.x-16,32*v.y+32,64,'center')
        end
        love.graphics.setColor(0,255,0)
        local str = formatNum(self.BadThings.Terminal.goal)
        love.graphics.printf(str,32*self.BadThings.Terminal.x-16,32*self.BadThings.Terminal.y+32,64,'center')
        love.graphics.setColor(255,255,255)
    end
end


function Room:drawHUD()
    local HUDORIGIN = {x = 0, y = self.HEIGHT*32+64+32}
    local P = self.Player
    love.graphics.setColor(150,150,150)
    love.graphics.rectangle('fill',HUDORIGIN.x,HUDORIGIN.y,32*7,32)
    love.graphics.setColor(255,255,255)
    love.graphics.rectangle('line',HUDORIGIN.x+0.5,HUDORIGIN.y+0.5,32*7,31)
    love.graphics.rectangle('line',32*7+0.5,HUDORIGIN.y+0.5,32*11-1,31)
    love.graphics.setColor(255,255,255)
    if P.scrap > 0 then
        for i = 1, P.scrap do
            love.graphics.draw(self.Tileset,self.Quads[self.Names.SCRAP],32*i+HUDORIGIN.x+64,HUDORIGIN.y)
        end
    end
    if P.water then
        love.graphics.draw(self.Tileset,self.Quads[self.Names.WATER],HUDORIGIN.x,HUDORIGIN.y)
    end
    if self.PowerUps.current then
        love.graphics.draw(self.Tileset,self.Quads[self.Names['P' .. self.PowerUps.current]],HUDORIGIN.x+32+16,HUDORIGIN.y)
    end
end
function Room:drawLayout()
    for i=1,self.WIDTH do
        for j=1,self.HEIGHT do
            self:drawNum(self.Layout[i][j],i*32,j*32)
        end
    end
end
function Room:drawNum(k,x,y)
    love.graphics.draw(self.Tileset,self.Quads[k],x,y)
end

function Room:triggerMissile(k)
    local function randInt(max)
        return math.floor(math.random()*max + 1)
    end
    SCORE = SCORE + 5; print('5')
    local P = self.Player
    local M = self.BadThings.Missiles[k]
    if M.d == 1 then
        for y=-1,self.HEIGHT+3 do
            
            if self:hitLayout(M.x,y) then
                break
            end
            self.Effects:add(self.Names.VBURN,M.x*32,y*32,0,0,0.1)
        end
    end
    if M.d == 2 then
        for x=0,self.WIDTH+2 do
            
            if self:hitLayout(x,M.y) then
                break
            end
            self.Effects:add(self.Names.HBURN,x*32,M.y*32,0,0,0.1)
        end
    end
    if M.d == 3 then
        for y=-1,self.HEIGHT+3 do
            
            if self:hitLayout(M.x,self.HEIGHT-y+1) then
                break
            end
            self.Effects:add(self.Names.VBURN,M.x*32,(self.HEIGHT-y+1)*32,0,0,0.1)
        end
    end
    if M.d == 4 then
        for x=0,self.WIDTH+2 do
            
            if self:hitLayout(self.WIDTH-x+1,M.y) then
                break
            end
            self.Effects:add(self.Names.HBURN,(self.WIDTH-x+1)*32,M.y*32,0,0,0.1)
        end
    end

    self.BadThings.Missiles[k] = nil
    --self.BadThings:addMissile()
end

function Room:hitLayout(x,y)
    if x < 1 or y < 1 or x > self.WIDTH or y > self.HEIGHT then return false end
    local P = self.Player
    local function randInt(max)
        return math.floor(math.random()*max + 1)
    end
    if (P.x + P.dx == x and P.y+P.dy == y) and (self.Layout[x][y] == self.Names.WALL or self.Layout[x][y] == self.Names.DWALL) then
        return true
    end

    if self.Layout[x][y] == self.Names.WALL then
        self.Layout[x][y] = self.Names.DWALL
        return true
    elseif self.Layout[x][y] == self.Names.DWALL and not (P.x + P.dx == x and P.y+P.dy == y) then
        self.Layout[x][y] = self.Names.XWALL
        return true
    elseif self.Layout[x][y] == self.Names.FLOOR then
        local c = randInt(100)
        if c <= 80 then
            self.Layout[x][y] = self.Names.DFLOOR
        elseif c <= 101 then
            self.Layout[x][y] = self.Names.FFLOOR
        end
    elseif self.Layout[x][y] == self.Names.DFLOOR then
        local c = randInt(100)
        if c <= 40 then
            self.Layout[x][y] = self.Names.FFLOOR
        end
    end 
end


function Room:drawInfo()
    local x = 224 + 8
    local y = self.HEIGHT*32 + 96+2
    love.graphics.print("Next Wave In "..formatNum(self.BadThings.Timer),x,y + 15)
    --love.graphics.print("Dif "..formatNum(self.BadThings.Difficulty),x,20 + 15)
    if self.PowerUps.on then
        love.graphics.print("Power Up Ends In " .. formatNum(self.PowerUps.duration),0,14)
    end
    love.graphics.print("Floor ".. self:getNumberOfType(self.Names.FLOOR)  .. "/35",x,y)
    love.graphics.print("Fire " .. self:getNumberOfType(self.Names.FFLOOR) .. "/70",x+96+64+16+8+8,y)
    love.graphics.print("SCORE " .. formatNum(SCORE),x+96+64+16+8+8,y+15)
    self:getNumberOfType(self.Names.FLOOR)
end
function Room:updateInfo(dt)
    if self:getNumberOfType(self.Names.FFLOOR) >= self.MaxBurn or self:getNumberOfType(self.Names.FLOOR) <= self.MinFloor then
        gameover()
    end
end


function Room:getNumberOfType(k)
    local s = 0
    for i=1,self.WIDTH do
        for j=1,self.HEIGHT do 
            if self.Layout[i][j] == k then 
                s = s + 1
            end 
        end 
    end 
    return s
end

function Room:FireUpdate(dt)
    
    self.FireInfo.t = self.FireInfo.t - dt
    if self.FireInfo.t < 0 then
        self.FireInfo.t = self.FireInfo.tMax

        for i=1,self.WIDTH do 
            for j=1,self.HEIGHT do 
                if self.Layout[i][j] == self.Names.FFLOOR then 
                    self:ignite(i+1,j)
                    self:ignite(i-1,j)
                    self:ignite(i,j+1)
                    self:ignite(i,j-1)
                end 
            end 
        end
        for i=1,self.WIDTH do 
            for j=1,self.HEIGHT do 
                if self.Layout[i][j] == -999 then 
                    self.Layout[i][j] = self.Names.FFLOOR
                end 
            end 
        end

    end
end

function Room:ignite(x,y)
    local function randInt(max)
        return math.floor(math.random()*max + 1)
    end
    if (self.Layout[x][y] == self.Names.FLOOR or self.Layout[x][y] == self.Names.DFLOOR) and randInt(self.FireInfo.c) == 1 then
        self.Layout[x][y] = -999
    end
end


return Room