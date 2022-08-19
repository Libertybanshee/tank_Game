-- Débogueur Visual Studio Code tomblind.local-lua-debugger-vscode
if pcall(require, "lldebugger") then
    require("lldebugger").start()
end

-- Cette ligne permet d'afficher des traces dans la console pendant l'éxécution
io.stdout:setvbuf("no")

-- Variable d'essai Coding
SST = 0
SSC = 0

-- Algo impact elements
function distance(x1, y1, x2, y2)
    return ((x2 - x1) ^ 2 + (y2 - y1) ^ 2) ^ 0.5
end

-- Cadre de Visée 
local focus = {}
focus.X = love.mouse.getX()
focus.Y = love.mouse.getY()
focus.taille = 0.2

-- Algo de l'angle focus
function math.angle(x1,y1, x2,y2) 
    return math.atan2(y2-y1, x2-x1) 
end

-- Start Spawn
screenLargeur = love.graphics:getWidth()
screenHauteur = love.graphics:getHeight()

local spawnPlayer = {}
spawnPlayer.taille = 40
spawnPlayer.X = screenLargeur / 2 - spawnPlayer.taille
spawnPlayer.Y = screenHauteur / 1.05 - spawnPlayer.taille
spawnPlayer.angle = - math.pi / 2

-- Player Value / update ligne 117 / Draw ligne 173
local tank = {}
tank.X = spawnPlayer.X + (spawnPlayer.taille / 2)
tank.Y = spawnPlayer.Y + (spawnPlayer.taille / 2)
tank.angle = spawnPlayer.angle
tank.focus = 0
tank.Speed = 2
tank.tourelleX = 0
tank.tourelleY = 8

-- mode Debug / keypress ligne 262 / draw ligne 226
debug = false

-- Raccourcie clavier (Non utilisé)
pressZ = love.keyboard.isDown("z")
pressD = love.keyboard.isDown("d")
pressS = love.keyboard.isDown("s")
pressQ = love.keyboard.isDown("q")
pressEspace = love.keyboard.isDown("space")
leftMouse = "Off"
rightMouse = "Off"

-- Liste projectiles / Draw ligne 188 / Update ligne 143
    local projectiles = {}
-- Fonction Tir
function Shoot(pX, pY, pAngle, pVitesse, pImg, pShoot)    
    local projectile = {}
          projectile.X = pX
          projectile.Y = pY
          projectile.angle = pAngle
          projectile.vitesse = pVitesse
          projectile.img = pImg
          projectile.shoot = pShoot
    table.insert(projectiles, projectile)
end

-- liste Ennemis / Gestion ligne 156
    local ennemis = {}
-- Fonction Spawn Ennemi / Call ligne 100 / Draw ligne 153
function SpanwEnnemi(pX, pY, pAngle, pTaille, pVitesse, pImg, pShoot, pAI)
    local ennemi = {}
          ennemi.X = pX
          ennemi.Y = pY
          ennemi.angle = pAngle
          ennemi.taille = pTaille
          ennemi.vitesse = pVitesse
          ennemi.img = pImg
          ennemi.shoot = pShoot
          ennemi.AI = pAI
    table.insert(ennemis, ennemi)
end


function love.load()
-- Fichier de l'image Tank Player
    imgPlayer = love.graphics.newImage("img/Player/tank_Vert1.png")
    imgFocus = love.graphics.newImage("img/Player/tourelle1.png")
    imgProj_1 = love.graphics.newImage("img/Projectile/Tir_1.png")
    imgProj_2 = love.graphics.newImage("img/Projectile/Tir_2.png")
    imgEnnemi_1 = love.graphics.newImage("img/Ennemi/tank_Bleu1.png")
    imgTarget = love.graphics.newImage("img/UI/target_1.png")

-- Apparation des Ennemi
    -- Orientation spawn
    northWest = 7.5
    north = - math.pi 
    northEast = - math.pi / 2
    east = 0
    southEast = math.pi / 2
    south = math.pi / 2
    southWest = 4.5
    west = - math.pi / 0.5
    -- fonction + legende des paramètres ligne 67 / Draw ligne 153
    SpanwEnnemi(280, 100, south, 0.225, 0, imgEnnemi_1)
    SpanwEnnemi(330, 100, south, 0.225, 0, imgEnnemi_1)
    SpanwEnnemi(380, 100, south, 0.225, 0, imgEnnemi_1)
    SpanwEnnemi(430, 100, south, 0.225, 0, imgEnnemi_1)
    SpanwEnnemi(480, 100, south, 0.225, 0, imgEnnemi_1)

-- Destination Trajet / Draw ligne 203 / Load ligne 180 / Update ligne 180
          goal = {}
          goal.X = screenLargeur / 2
          goal.Y = screenHauteur / 2
          goal.taille = 40
          goal.hit = false
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

-- Gestion des projectile / Draw ligne 188
    for k, projectile in ipairs(projectiles) do
        projectile.X = projectile.X + (dt * projectile.vitesse) * math.cos(projectile.angle)
        projectile.Y = projectile.Y + (dt * projectile.vitesse) * math.sin(projectile.angle)
        -- Fonctionnalité abondonnée
        if projectile.shoot == "surcharge" then
            SST = SST + dt * SSC
            if SST >= 10 then
                SST = 0
            end
        end
    end

-- Gestion des Ennemis / create list at ligne 71 
    -- Parcours de la liste des ennemis
    for n = #ennemis, 1, -1 do
        local ennemiG = ennemis[n]
        -- Parcours de la liste des projectiles
        for k = #projectiles, 1, -1 do
            local projectileG = projectiles[k]
            -- Suppression de l'ennemi après un impact de projectile
            if distance(projectileG.X, projectileG.Y, ennemiG.X, ennemiG.Y) < 10 then
                table.remove(ennemis, n)
                table.remove(projectiles, k)
            end
        end
    end

-- Condition de victoire par destination / load 1igne 116 / Draw ligne 202 
    if distance(tank.X, tank.Y, goal.X, goal.Y) < 20 then
        goal.hit = true
    end

-- Condition de victoire par destruction 
    if #ennemis <= 0 then
        goal.hit = true
    end
end

function love.draw()
    -- Afficher le tank player -> paramètre ligne 30 / update 117
    love.graphics.draw(imgPlayer, tank.X, tank.Y, tank.angle, 0.2, 0.2, imgPlayer:getWidth() / 2, imgPlayer:getHeight() / 2)

    -- Afficher les ennemis -> paramètre ligne 67 / call ligne 100
    for j, ennemi in ipairs(ennemis) do
        love.graphics.draw(ennemi.img, ennemi.X, ennemi.Y, ennemi.angle, ennemi.taille, ennemi.taille, ennemi.img:getWidth() / 2, ennemi.img:getHeight() / 2)
    end

    -- Afficher Tourelle -> paramètre ligne 30
    love.graphics.draw(imgFocus, tank.X + tank.tourelleX, tank.Y + tank.tourelleY, tank.focus, 0.2, 0.2, imgFocus:getWidth() / 4, imgFocus:getHeight() / 2)

    -- Afficher la Visée -> paramètre ligne 12
    -- love.graphics.rectangle("line", focus.X - (focus.taille / 2), focus.Y - (focus.taille / 2), focus.taille, focus.taille) ANCIENNE VISÉE
    love.graphics.draw(imgTarget, focus.X - (focus.taille / 2), focus.Y - (focus.taille / 2), 0, focus.taille, focus.taille, imgTarget:getWidth() / 2, imgTarget:getHeight() / 2)

    -- Afficher projectile -> paramètre ligne 54 / update ligne 143
    for k, projectile in ipairs(projectiles) do
        love.graphics.draw(projectile.img, projectile.X, projectile.Y, projectile.angle, 1, 1, imgProj_1:getWidth() / 2, imgProj_1:getHeight() / 2)
    end    

    -- spanw start
    love.graphics.print( "START", spawnPlayer.X - 10, spawnPlayer.Y - 25 , 0, 1.5, 1.5)
    love.graphics.rectangle("line", spawnPlayer.X, spawnPlayer.Y, spawnPlayer.taille, spawnPlayer.taille)

    -- Destination Trajet / load 1igne 116 / Update ligne 180
    love.graphics.print( "FINISH", goal.X - 10, goal.Y - 25 , 0, 1.5, 1.5)
    love.graphics.rectangle( "line", goal.X, goal.Y, goal.taille, goal.taille)
    if goal.hit == true then
        love.graphics.print("GOOD !!", tank.X - 35, tank.Y - 50, 0, 1.5, 1.5)
    end

    -- Afficher le debug / create variable ligne 49 / keypress ligne 262 
    if debug == true then
        love.graphics.print("Click Gauche : " .. tostring(leftMouse) .. " Click Droit : " .. tostring(rightMouse))
        love.graphics.print("Valeur X : " .. tostring(tank.X), 0, (15 * 1))
        love.graphics.print("Valeur Y : " .. tostring(tank.Y), 0, (15 * 2))
        love.graphics.print("Valeur Angle : " .. tostring(tank.focus), 0, (15 * 3))
        love.graphics.print("Nb de projectiles : " .. tostring(#projectiles), 0, (15 * 4))
        love.graphics.print("X.Tank : " .. tostring(imgFocus:getWidth() / 4), 0, (15 * 5))
        love.graphics.print("Y.Tank : " .. tostring(imgFocus:getHeight() / 2), 0, (15 * 6))
        love.graphics.print("Timer Shoot Spécial : " .. tostring(SST), 0, (15 * 7))
        love.graphics.print("Nb ennemi : " .. tostring(#ennemis), 0, (15 * 8))
        love.graphics.print("Largeur écran : " .. tostring(screenLargeur), screenLargeur - 123, (15 * 0))
        love.graphics.print("Hauteur écran : " .. tostring(screenHauteur), screenLargeur - 125, (15 * 1))
    end
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
    -- Activer le Debug / create variable ligne 49 / draw ligne 226
    if love.keyboard.isDown("f1") then
        debug = not debug
    end  

    if love.keyboard.isDown("f2") then
        if debug == true then 
            debug = false
        else 
            debug = true
        end
    end
end
