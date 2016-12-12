local BadThings = {}
BadThings.Missiles = {}
BadThings.Terminal = {x = 4, y = 4, t = 30, goal = -1,list = nil, enabled = false}
BadThings.WIDTH = 1
BadThings.HEIGHT = 1
BadThings.Timer = 10
BadThings.Difficulty = 0
BadThings.MaxDif = 20
function BadThings:setUp(w,h)
    self.WIDTH = w
    self.HEIGHT = h
end
function BadThings:addMissile(t)
    local function randInt(max)
        return math.floor(math.random()*max+1)
    end
    --[[
         11
        2  4
        2  4
         33
    ]]
    local side = randInt(4)
    local tNext = t or (8+randInt(4))
    if side == 1 then
        self.Missiles[#self.Missiles + 1] = {x = randInt(self.WIDTH), y = 0, t = tNext, d = side}
    elseif side == 2 then
        self.Missiles[#self.Missiles + 1] = {x = 0, y = randInt(self.HEIGHT), t = tNext, d = side}
    elseif side == 3 then
        self.Missiles[#self.Missiles + 1] = {x = randInt(self.HEIGHT), y = self.HEIGHT+1, t = tNext, d = side}
    elseif side == 4 then
        self.Missiles[#self.Missiles + 1] = {x = self.WIDTH+1, y = randInt(self.HEIGHT), t = tNext, d = side}
    end
end
function BadThings:enableTerminal()
    local function randInt(max)
        return math.floor(math.random()*max+1)
    end

    --self.Terminal = {t = 30, goal = 5, list = {},enabled = true}
    self.Terminal.t = 45
    self.Terminal.goal = 10
    self.Terminal.list = {}
    self.Terminal.enabled = true


    for i = 1, 9 do
        self.Terminal.list[i] = {x = randInt(self.WIDTH), y= randInt(self.HEIGHT)}
    end

end
function BadThings:update(dt, P)
    --Reminder that difficulty starts at max.
    local function randInt(max)
        return math.floor(math.random()*max+1)
    end

    
    self.Timer = self.Timer - dt
    if self.Timer < 0 then
        --self.Difficulty = math.min(self.Difficulty + 0.5,self.MaxDif)
        local c = randInt( math.ceil( (self.Difficulty+1)/10 ) )
        self.Timer = (self.MaxDif/2 + 6 + c - math.floor(self.Difficulty/2))/2 + 2
        for i=1,c do
            if randInt(math.max(4,8 - self.Difficulty) ) == 1 and not self.Terminal.enabled then
                self:enableTerminal()
            else
                self:addMissile()
            end
        end
    end



    local marks = {}
    local num = 1
    for k,v in pairs(self.Missiles) do
        v.t = v.t - dt
        if v.t < 0 then
            marks[num] = k
            num = num + 1
        end
    end

    local termHits = nil
    self.Terminal.t = self.Terminal.t - dt
    if self.Terminal.t < 0 and self.Terminal.enabled then
        self.Terminal.enabled = false
        termHits = self.Terminal.list
    end
    if P.x == self.Terminal.x and P.y == self.Terminal.y and love.keyboard.isDown('z') then
        self.Terminal.goal = self.Terminal.goal - dt
        SCORE = SCORE + dt
        if self.Terminal.goal < 0 then
            P.scrap = 4
        end
    end

    if self.Terminal.goal < 0 then
        termHits = nil
        self.Terminal.enabled = false
    end


    --returns all missiles that triggered.
    return marks, termHits
end





return BadThings