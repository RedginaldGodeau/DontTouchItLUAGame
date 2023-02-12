----------------------------------------
-- PLAYER  -----------------------------
----------------------------------------
instance = {}
instance.__index = instance

function instance:create(_x,_y,_w,_h,_form,_class)
    local obj = {}
    setmetatable(obj,instance)

    obj.position = {x = _x,y = _y}
    obj.size = {w = _w,h = _h}
    obj.class = _class
    obj.form = _form

    return obj
end
function instance:getObjectPosition()
    return self.position.x,self.position.y
end
function instance:setObjectPosition(_x,_y)
    self.position = {x = _x, y = _y}
    return self:getObjectPosition()
end
function instance:getObjectSize ()
    local w = self.size.w
    local h = self.size.h
    return w,h
end
function instance:setObjectSize (_w,_h)
    local w,h = self:getObjectSize()
    self.size = {_w or w, _h or h}
    return self:getObjectSize()
end

function instance:draw()
    local x,y = self:getObjectPosition()
    local w,h = self:getObjectSize()

    if(self.form == 'circle') then love.graphics.circle('fill',x,y,w/2)
    else love.graphics.rectangle('fill',x - w/2,y - h/2,w,h) end
end


function instance:hascollide (class,t)
    local obj = nil

    for i,v in pairs(t) do
        if(hitbox_getdistance (self,v)) then
            obj = v
        end
    end
    
    return obj
end

function instance:hasobjectcollide (class,t)
    local obj = nil
    if(hitbox_getdistance (self,t)) then
        obj = t
    end

    return obj
end

function hitbox_getdistance (o1,o2)
    local x,y = o1:getObjectPosition()
    local w,h = o1:getObjectSize()
    local x2,y2 = o2:getObjectPosition()
    local w2,h2 = o2:getObjectSize()

    local xdist = math.abs(x - x2)
    local ydist = math.abs(y - y2)

    local xwidth = w/2 + w2/2
    local yheight = h/2 + h2/2

    return xdist < xwidth and ydist < yheight
end

function click_object (btn,mousex,mousey)
    local x,y = btn:getObjectPosition()
    local w,h = btn:getObjectSize()

    local xdist = math.abs(x - mousex)
    local ydist = math.abs(y - mousey)

    return xdist < w/2 and ydist < h/2
end