local PowerUps = {}

PowerUps.current = nil

PowerUps.on = false
PowerUps.duration = -1

PowerUps.next = nil

function PowerUps:setUp(w,h)
    self.WIDTH = w
    self.HEIGHT = h
end

function PowerUps:make()
    local function randInt(max)
        return math.floor(math.random()*max+1)
    end
    self.next = {style = randInt(4), t = 20, x = randInt(self.WIDTH-2)+1, y = randInt(self.HEIGHT-2)+1}
end

function PowerUps:update(dt, P)
    if self.next then
        self.next.t = self.next.t - dt
        if self.next.t < 0 and self.next and P.x == self.next.x and P.y == self.next.y then
            self.current = self.next.style
            self.on = false
            self.next = nil
        elseif self.next.t < 0 then
            self.next = nil
            --self.current = nil
        end

    end
    if self.on then
        self.duration = self.duration - dt
        if self.duration < 0 then
            self.on = false
            self.current = nil
        end
    end

    if self.on and self.current == 4 then
        P.scrap = 4
    end
end
function PowerUps:draw()      
    --Too simple. Just put it in Room ._.
end


function PowerUps:turnOn()
    if self.on == false and self.current then
        self.on = true

        if self.current == 1 then
            self.duration = 15
        elseif self.current == 2 then
            self.duration = 30
        elseif self.current == 3 then
            self.duration = 0.1
            return 3
        elseif self.current == 4 then
            self.duration = 30
        end
    end
end

function PowerUps:setDt(dt)
    if self.on then
        if self.current == 1 then
            return 0
        elseif self.current == 2 then
            return dt / 2
        elseif self.current == 3 then
            return dt
        elseif self.current == 4 then
            return dt
        end
    end
    return dt
end





return PowerUps