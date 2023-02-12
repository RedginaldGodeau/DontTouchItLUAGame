-------------------------------------
-- CONSTANTS  -----------------------
-------------------------------------

-------------------------------------
-- VARIABLES  -----------------------
-------------------------------------
local score = 0
local plr = nil

local countdown = {
    obstacle = 0,
}

local obs_speed = 250
local obs_spawning = 3

local vcolor = {r=255,g=255,b=255}
local vccolor = {r=255,g=255,b=255}

local dead = false

-------------------------------------
-- FUNCTIONS  -----------------------
-------------------------------------
function cursor_move (speed)
    local x,y = plr:getObjectPosition()
    local cx,cy = love.mouse.getPosition()
    return math.lerp(x,cx,speed),math.lerp(y,cy,speed)
end
function make_obstacle()
    local w = math.random(win.width * .30,win.width * .50)
    local h = math.random(win.height * .10,win.height * .75)
    local x = win.width + w
    local y = math.random(0,win.height)
    table.insert(inst_obstacle,instance:create(x,y,w,h,'rectangle','obstacle'))
end
function draw_obstacle()
    for i,v in pairs(inst_obstacle) do v:draw() end
end


-------------------------------------
-- LOAD  ----------------------------
-------------------------------------
function love.load ()
    -- LOVE  ----------------------------
    love.window.setTitle("Don't Touch It")
    -- FONTS ----------------------------
    fonttext = love.graphics.newFont('fonts/Roboto-Black.ttf', imagefilename )

    -- REQUIRE  -------------------------
    require('libs/things')
    require('object')
    -- INITIALIZE  ----------------------
    bestscore = readScore('config/score.txt') or 0
    win = {height = love.graphics.getHeight(),width = love.graphics.getWidth()}
    math.randomseed(os.time())
    math.random() math.random() math.random()

    -- OBJECT  --------------------------
    inst_obstacle = {}
    plr = instance:create(win.width/2,win.height/2,50,50,'circle',nil)
    killer = instance:create(-win.width,win.height/2,50,win.height,'rectangle','clear')

    score_cadre = instance:create(win.width/2,win.height/2,400,600,'rectangle',nil)
    restart_button = instance:create(win.width/2,win.height/2 + 60,150,70,'rectangle',nil)
end
-------------------------------------
-- UPDATE  --------------------------
-------------------------------------
function love.update (dt)
    if(dead) then return end
    plr:setObjectPosition(cursor_move(.1))

    score = score + dt
    obs_speed = math.Clamp(250 + score * 7,250,1200)
    obs_spawning = math.Clamp(3 - .03 * score,.3,5)

    for i,v in pairs(inst_obstacle) do
        local x,y = v:getObjectPosition()
        v:setObjectPosition(x - dt * obs_speed, y)

        if(v:hasobjectcollide('clear',killer)) then
            table.remove(inst_obstacle,i)
        end
    end

    if(plr:hascollide('obstacle',inst_obstacle)) then
        if(tonumber(readScore('config/score.txt')) < score) then
            writeScore('config/score.txt',score) 
            bestscore = score
        end
        dead = true
    end

    if(countdown.obstacle <= 0) then
        make_obstacle()
        countdown.obstacle = obs_spawning
    else countdown.obstacle = countdown.obstacle - dt end
end
-------------------------------------
-- DRAW  ----------------------------
-------------------------------------
function love.draw ()
    love.graphics.setBackgroundColor(getcolor(255 - vcolor.r,255 - vcolor.g,255 - vcolor.b))

    if(vccolor.r ~= vcolor.r and vccolor.g ~= vcolor.g and vccolor.b ~= vcolor.b) then
        vcolor = {r = math.lerp(vcolor.r,vccolor.r,.2),g = math.lerp(vcolor.g,vccolor.g,.2),b = math.lerp(vcolor.b,vccolor.b,.2)}
    else 
        vccolor = {r = math.random(1,255),g = math.random(1,255),b = math.random(1,255)}
        print('Change')
    end
    color(vcolor.r,vcolor.g,vcolor.b)
    killer:draw()
    plr:draw()
    draw_obstacle()

    love.graphics.setFont(fonttext)
    love.graphics.print('Score :' .. math.floor(score))
    love.graphics.print('Best :' .. math.floor(bestscore),0,12)

    if(dead) then
        color(vcolor.r -20,vcolor.g - 20,vcolor.b - 20)
        score_cadre:draw()
        color(255 - vcolor.r,255 - vcolor.g,255 - vcolor.b)
        love.graphics.print('Score :' .. math.floor(score),win.width/2 - 90,win.height/2 - 50)
        love.graphics.print('Best :' .. math.floor(bestscore),win.width/2 - 90,win.height/2 - 38)
        restart_button:draw()
        color(vcolor.r -20,vcolor.g - 20,vcolor.b - 20)
        local x,y = restart_button:getObjectPosition()
        local w,h = restart_button:getObjectSize()
        love.graphics.printf('Restart',x - w/2, y, w, 'center')
    end


end
-------------------------------------
-- EVENT  ---------------------------
-------------------------------------
function love.keypressed( key, isrepeat )
    if(key == 'escape') then
        writeScore('config/score.txt',score)
        love.event.quit()
    end
end

function love.mousepressed( x, y, button, istouch, presses )
    if(button == 1 and dead and click_object (restart_button,x,y)) then
        love.event.quit('restart')
    end
end