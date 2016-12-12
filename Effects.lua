local Effects = {}
Effects.List = {}
function Effects:setUp(Tileset,Quads)
    self.Tileset = Tileset
    self.Quads = Quads
end

function Effects:add(spriteNumber,x,y,vx,vy,duration)
    self.List[#self.List + 1] = {
        spriteNumber = spriteNumber,
        x = x, 
        y = y,
        vy = vy,
        vx = vx,
        duration = duration}
end

function Effects:update(dt)
    local deleteList = {}
    local n = 1
    for key,entry in pairs(self.List) do
        entry.duration = entry.duration - dt
        entry.x = entry.x + entry.vx*dt
        entry.y = entry.y + entry.vy*dt
        if entry.duration < 0 then deleteList[n] = key; n = n + 1 end
    end
    for i=1,#deleteList do
        self.List[deleteList[i]] = nil
    end
end
function Effects:draw(dt)
    for key,v in pairs(self.List) do
        love.graphics.draw(self.Tileset,self.Quads[v.spriteNumber],math.floor(v.x),math.floor(v.y))
    end
end








return Effects