-- Débogueur Visual Studio Code tomblind.local-lua-debugger-vscode
if pcall(require, "lldebugger") then
    require("lldebugger").start()
end

-- Cette ligne permet d'afficher des traces dans la console pendant l'éxécution
io.stdout:setvbuf("no")

-- projectiles
projectiles = {}

-- Start Spawn
spawnPlayer = {}
spawnPlayer.X = love.graphics:getWidth() / 2
spawnPlayer.Y = love.graphics:getHeight() / 2
spawnPlayer.taille = 40
spawnPlayer.Angle = - math.pi / 2

-- Player Value
tank = {}
tank.X = spawnPlayer.X + (spawnPlayer.taille / 2)
tank.Y = spawnPlayer.Y + (spawnPlayer.taille / 2)
tank.Angle = spawnPlayer.Angle
tank.Speed = 2

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
          projectile.Vitesse = pVitesse
          projectile.Image = pImg
          projectile.Mode = pMode
    table.insert(projectiles, projectile)
end

function love.load()
    -- Fichier de l'image Tank Player
    imgPlayer = love.graphics.newImage("img/Player/tank_Vert1.png")
end

function love.update(dt)
-- Déplacer Tank Player
    -- Tourner a gauche
    if love.keyboard.isDown("q") and love.keyboard.isDown("z") or love.keyboard.isDown("d") and love.keyboard.isDown("s") then
        tank.Angle = tank.Angle - 0.02
    end
    -- Tourner a droite
    if love.keyboard.isDown("d") and love.keyboard.isDown("z") or love.keyboard.isDown("q") and love.keyboard.isDown("s") then
        tank.Angle = tank.Angle + 0.02
    end
    -- Avancer
    if love.keyboard.isDown("z") then
        local ratio_X = math.cos(tank.Angle)
        local ratio_Y = math.sin(tank.Angle)
        tank.X = tank.X + (tank.Speed * ratio_X)
        tank.Y = tank.Y + (tank.Speed * ratio_Y)
    end
    -- Reculer
    if love.keyboard.isDown("s") then
        local ratio_X = math.cos(tank.Angle)
        local ratio_Y = math.sin(tank.Angle)
        tank.X = tank.X - (tank.Speed * ratio_X)
        tank.Y = tank.Y - (tank.Speed * ratio_Y)
    end
    -- Activer le Debug
    if love.keyboard.isDown("f1") then
        debug = true 
    elseif love.keyboard.isDown("f2") and debug == true then
        debug = false
    end  

    -- Test Clique gauche (Remettre dans la MousePressed avec David)
    if love.mouse.isDown(1) then
        leftMouse = "Up"
        Shoot() 
    else
        leftMouse = "Off"
    end

    -- Test Clique droit (Remettre dans la MousePressed avec David)
    if love.mouse.isDown(2) then
        rightMouse = "Up"
        table.remove(projectiles, b)
    else
        rightMouse = "Off"
    end
end

function love.draw()
    -- Afficher le tank player
    love.graphics.draw(imgPlayer,tank.X,tank.Y,tank.Angle,0.2,0.2, imgPlayer:getWidth()/ 2, imgPlayer:getHeight()/2)

    -- Afficher projectile
    -- love.graphics.draw()

    -- debug
    if debug == true then
        love.graphics.print("Click Gauche : " .. tostring(leftMouse) .. " Click Droit : " .. tostring(rightMouse))
        love.graphics.print("Valeur X : " .. tostring(tank.X), 0, (15 * 1))
        love.graphics.print("Valeur Y : " .. tostring(tank.Y), 0, (15 * 2))
        love.graphics.print("Valeur Angle : " .. tostring(tank.Angle), 0, (15 * 3))
        love.graphics.print("Nb de projectiles : " .. tostring(#projectiles), 0, (15 * 4))
    end

    -- spanw start
    love.graphics.rectangle("line", spawnPlayer.X, spawnPlayer.Y, spawnPlayer.taille, spawnPlayer.taille)
end

function love.mousepressed(b)  
end

function love.keypressed(key)  
end
