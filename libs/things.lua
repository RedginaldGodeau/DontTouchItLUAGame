function color(r,g,b)
    love.graphics.setColor(r/255,g/255,b/255)
end
function getcolor(r,g,b)
    return r/255,g/255,b/255
end

function math.lerp (_start, _end, _amt)
    return (1-_amt)*_start+_amt*_end
end

function math.Clamp(val, lower, upper)
    assert(val and lower and upper, "not very useful error message here")
    if lower > upper then lower, upper = upper, lower end -- swap if boundaries supplied the wrong way
    return math.max(lower, math.min(upper, val))
end
function readScore(file)
    local f = io.open(file,'r')
    local text = nil
    if(f) then
        text = f:read()
        io.close(f)
    end

    return text
end

function writeScore(file,score)
    local f = io.open(file,'w')
    local text = f:write(score)
    io.close(f)
    return text
end

