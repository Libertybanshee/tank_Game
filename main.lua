-- Débogueur Visual Studio Code tomblind.local-lua-debugger-vscode
if pcall(require, "lldebugger") then
    require("lldebugger").start()
end

-- Cette ligne permet d'afficher des traces dans la console pendant l'éxécution
io.stdout:setvbuf("no")

SST = 0
SSC = 0

-- projectiles
projectiles = {}

-- Cadre de Visée
focus = {}
focus.X = love.mouse.getX()
focus.Y = love.mouse.getY()
focus.taille = 40

-- Algo de l'angle focus
function math.angle(x1,y1, x2,y2) 
    return math.atan2(y2-y1, x2-x1) 
end

-- Start Spawn
spawnPlayer = {}
spawnPlayer.X = love.graphics:getWidth() / 2
spawnPlayer.Y = love.graphics:getHeight() / 2
spawnPlayer.taille = 40
spawnPlayer.angle = - math.pi / 2

-- Player Value
tank = {}
tank.X = spawnPlayer.X + (spawnPlayer.taille / 2)
tank.Y = spawnPlayer.Y + (spawnPlayer.taille / 2)
tank.angle = spawnPlayer.angle
tank.focus = 0
tank.Speed = 2
tank.tourelleX = 0
tank.tourelleY = 8

debug = false

-- Raccourcie clavier (Non utilisé)
pressZ = love.keyboard.isDown("z")
pressD = love.keyboard.isDown("d")
pressS = love.keyboard.isDown("s")
pressQ = love.keyboard.isDown("q")
pressEspace = love.keyboard.isDown("space")
leftMouse = "Off"
rightMouse = "Off"

-- Fonction Tir
function Shoot(pX, pY, pAngle, pVitesse, pImg, pMode)    
    local projectile = {}
          projectile.X = pX
          projectile.Y = pY
          projectile.angle = pAngle
          projectile.vitesse = pVitesse
          projectile.img = pImg
          projectile.mode = pMode
    table.insert(projectiles, projectile)
end

function love.load()
    -- Fichier de l'image Tank Player
    imgPlayer = love.graphics.newImage("img/Player/tank_Vert1.png")
    imgFocus = love.graphics.newImage("img/Player/tourelle1.png")
    imgProj_1 = love.graphics.newImage("img/Projectile/Tir_1.png")
    imgProj_2 = love.graphics.newImage("img/Projectile/Tir_2.png")
end

function love.update(dt)
-- Déplacer Tank Player
    -- Tourner a gauche
    if love.keyboard.isDown("q") and love.keyboard.isDown("z") or love.keyboard.isDown("d") and love.keyboard.isDown("s") then
        tank.angle = tank.angle - 0.02
    end
    -- Tourner a droite
    if love.keyboard.isDown("d") and love.keyboard.isDown("z") or love.keyboard.isDown("q") and love.keyboard.isDown("s") then
        tank.angle = tank.angle + 0.02
    end
    -- Avancer
    if love.keyboard.isDown("z") then
        local ratio_X = math.cos(tank.angle)
        local ratio_Y = math.sin(tank.angle)
        tank.X = tank.X + (tank.Speed * ratio_X)
        tank.Y = tank.Y + (tank.Speed * ratio_Y)
    end
    -- Reculer
    if love.keyboard.isDown("s") then
        local ratio_X = math.cos(tank.angle)
        local ratio_Y = math.sin(tank.angle)
        tank.X = tank.X - (tank.Speed * ratio_X)
        tank.Y = tank.Y - (tank.Speed * ratio_Y)
    end

-- Gestion Tir de Visée
    focus.X, focus.Y = love.mouse.getPosition()
    tank.focus = math.angle(tank.X, tank.Y, focus.X, focus.Y)

-- Gestion des projectile
    for k, projectile in ipairs(projectiles) do
        projectile.X = projectile.X + (dt * projectile.vitesse) * math.cos(projectile.angle)
        projectile.Y = projectile.Y + (dt * projectile.vitesse) * math.sin(projectile.angle)
        -- Fonctionnalité abondonnée
        if projectile.mode == "surcharge" then
            SST = SST + dt * SSC
            if SST >= 10 then
                SST = 0
            end
        end
    end
end

function love.draw()
    -- Afficher le tank player
    love.graphics.draw(imgPlayer, tank.X, tank.Y, tank.angle, 0.2, 0.2, imgPlayer:getWidth() / 2, imgPlayer:getHeight() / 2)

    -- Afficher Tourelle
    love.graphics.draw(imgFocus, tank.X + tank.tourelleX, tank.Y + tank.tourelleY, tank.focus, 0.2, 0.2, imgFocus:getWidth() / 4, imgFocus:getHeight() / 2)

    -- Afficher la Visée 
    love.graphics.rectangle("line", focus.X - (focus.taille / 2), focus.Y - (focus.taille / 2), focus.taille, focus.taille)

    -- Afficher projectile
    for k, projectile in ipairs(projectiles) do
        love.graphics.draw(projectile.img, projectile.X, projectile.Y, projectile.angle, 1, 1, imgProj_1:getWidth() / 2, imgProj_1:getHeight() / 2)
    end
    -- love.graphics.draw()

    -- debug
    if debug == true then
        love.graphics.print("Click Gauche : " .. tostring(leftMouse) .. " Click Droit : " .. tostring(rightMouse))
        love.graphics.print("Valeur X : " .. tostring(tank.X), 0, (15 * 1))
        love.graphics.print("Valeur Y : " .. tostring(tank.Y), 0, (15 * 2))
        love.graphics.print("Valeur Angle : " .. tostring(tank.angle), 0, (15 * 3))
        love.graphics.print("Nb de projectiles : " .. tostring(#projectiles), 0, (15 * 4))
        love.graphics.print("X.Tank : " .. tostring(imgFocus:getWidth() / 4), 0, (15 * 5))
        love.graphics.print("Y.Tank : " .. tostring(imgFocus:getHeight() / 2), 0, (15 * 6))
        love.graphics.print("Timer Shoot Spécial : " .. tostring(SST), 0, (15 * 7))

    end

    -- spanw start
    love.graphics.rectangle("line", spawnPlayer.X, spawnPlayer.Y, spawnPlayer.taille, spawnPlayer.taille)
end

function love.mousepressed(b)  

    -- Test Clique gauche (Remettre dans la MousePressed avec David)
    if love.mouse.isDown(1) then
        leftMouse = "Up"
        Shoot(tank.X, tank.Y, tank.focus, 700, imgProj_1) 
    else
        leftMouse = "Off"
    end

    -- Test Clique droit (Remettre dans la MousePressed avec David)
    if love.mouse.isDown(2) then
        rightMouse = "Up"
        Shoot(tank.X, tank.Y, tank.focus, 1000, imgProj_2, "surcharge") 
    else
        rightMouse = "Off"
    end
end

function love.keypressed(key)  
    -- Activer le Debug
    if love.keyboard.isDown("f1") then
        debug = true 
    elseif love.keyboard.isDown("f2") and debug == true then
        debug = false
    end  
end
