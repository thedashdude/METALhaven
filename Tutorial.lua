local Tutorial = clone(Room)
Tutorial.Texts = {
    'Welcome. Press c to advance the tutorial.',
    'This is a missile. Face the wall it is about to hit to block it.', --2
    'If you fail the wall breaks a little.', --3
    'Repair this by pressing z.',--4
    'You have to have scrap metal to repair walls.',
    'You can take scrap metal from walls by pressing z.',
    'When a wall gets hit while damaged it is destroyed.', --7
    'You cannot repair destroyed walls.',
    'If a missile hits a destroyed wall, it keeps going.', --9
    'When goes through the level it damages the floor.',
    'Your goal is to defend the floor.',
    'If only 35 (1/4) healthy floors are remaining, you lose.',
    'Also, if 70 (1/2) floors are on fire, you lose.',
    'Hold z on the terminal to stop the scattered attack.', --14
    'You must hold z for 10s out of the 45 to stop it.',
    'If you are facing a green ! when it triggers, you',
    'only stop the single !, not them all.',
    'so try and use the terminal.',
    'Blue ! indicate power ups.',--19
    'If you are under the ! when the timer runs out',
    'you pick up the power up.',
    'Power ups can be used by pressing x.',
    'Power Ups are:',
    'Stop Time for 15s,',
    'Slow Time for 30s,',
    'Put out all fires,',
    'Unlimited scrap for 30s.',
    'Fire spreads slowly but can get out of hand.', --28
    'Press z on the pipe to fill a bucket of water.',
    'Facing fire and pressing z puts out the fire, and turns it to damaged flooring.',
    'Damaged floor cannot be repaired, but you can contruct walls on it.',
    'Press z while facing damaged flooring builds a damaged wall there.',
    'Then you can repair that to get a full fledged wall.',
    'When you succesfully defuse the terminal you get full (4) scrap.',
    'Thats all. Have Fun!'
    }






Tutorial.Num = 1
Tutorial.PowerUps.next = {style = 1, t = 20, x = 10, y = 10}

stopPows = true

function Tutorial:setup()
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
    self.Layout[3][1] = 110
    self.Layout[6][1] = 110
    self.functions = {}
    for i = 1 , 100 do 
        self.functions[i] = function()  end
    end
    self.functions[2] = function() self.BadThings:addMissile(20);print('f') end
    self.functions[3] = function() self.BadThings:addMissile(0.5) end
    self.functions[4] = function() self.Effects:add(self.Names.RWARN,6*32,1*32,0,0,1) end
    self.functions[7] = function() self.BadThings:addMissile(0.5) end
    self.functions[7] = function() self.BadThings.Missiles[#self.BadThings.Missiles + 1] = {x = 3, y = 0, t = 5, d = 1} end
    self.functions[9] = function() self.BadThings.Missiles[#self.BadThings.Missiles + 1] = {x = 3, y = 0, t = 5, d = 1} end
    self.functions[14] = function() self.BadThings:enableTerminal() end
    self.functions[20] = function() stopPows = false end
end


function Tutorial:update(dt)
    dt = dt
    self:updateInfo(dt)
    self.PowerUps:update(dt, self.Player)
    if stopPows then
        self.PowerUps.next.t = 20
    end
    dt = self.PowerUps:setDt(dt)
    SCORE = SCORE + dt
    --self:FireUpdate(dt)
    self:updatePlayer(dt)
    self.Effects:update(dt)


    local triggered, list = self.BadThings:update(dt,self.Player) -- T R I G G E R E D
    self.BadThings.Timer = 10
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


    
end
function Tutorial:keypressed(key,other1,other2)
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

    if key == 'c' then
        self.Num = self.Num + 1
        self.functions[self.Num]()
        if self.Num > #self.Texts then
            State = 'Menu'
        end
    end

    self:movePlayer(dx,dy)
end
function Tutorial:draw(dt)
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
    love.graphics.printf(self.Texts[self.Num],0,4,W,'left')

    
end


return Tutorial