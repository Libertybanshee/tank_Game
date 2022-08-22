-- Débogueur Visual Studio Code tomblind.local-lua-debugger-vscode
if pcall(require, "lldebugger") then
    require("lldebugger").start()
end

-- Cette ligne permet d'afficher des traces dans la console pendant l'éxécution
io.stdout:setvbuf("no")

-- Variable d'essai Coding

-- Algo impact elements
function distance(x1, y1, x2, y2)
    return ((x2 - x1) ^ 2 + (y2 - y1) ^ 2) ^ 0.5
end

-- Création MAP / drawn ligne 207
local MAP_LARGEUR = 20
local MAP_HAUTEUR = 15
local TILE_LARGEUR = 40
local TILE_HAUTEUR = 40

MAP = {}
MAP =  {
              { 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1 },
              { 1,1,1,1,0,0,0,1,1,0,0,0,1,1,1,1,1,1,1,0 },
              { 1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0 },
              { 1,0,0,0,1,1,1,1,1,0,0,0,0,0,0,1,0,0,0,0 },
              { 1,0,0,0,1,1,1,1,0,1,1,1,1,0,0,0,0,0,0,0 },
              { 1,0,0,0,0,1,1,1,0,1,1,0,0,0,0,1,0,0,1,1 },
              { 1,0,0,0,0,1,1,1,1,1,1,0,0,0,0,1,0,0,0,1 },
              { 1,0,0,0,0,1,1,1,0,0,0,0,0,0,0,1,1,0,0,0 },
              { 1,0,0,0,0,0,1,0,0,0,1,1,0,0,0,0,1,0,0,1 },
              { 1,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,1,0,0,1 },
              { 1,0,0,1,1,1,1,0,0,0,0,0,1,0,0,0,0,0,0,0 },
              { 1,0,0,0,0,1,1,1,0,0,0,0,0,0,0,0,1,0,0,0 },
              { 1,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,1,0,0,0 },
              { 1,1,1,1,1,1,1,1,0,0,1,1,1,1,1,1,1,1,1,1 },
              { 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1 },
            }

MAP.Sprite_MAP = {}

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
spawnPlayer.X = (10 * 40) - spawnPlayer.taille
spawnPlayer.Y = (14 * 40) - spawnPlayer.taille
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
tank.ligne = 1
tank.colonne = 1
tank.map = 0

-- mode Debug / keypress ligne 262 / draw ligne 226
debug = false
debug_Grille = false
debug_Tile = false

-- Raccourcie clavier (Non utilisé)
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
          projectile.ligne = 1
          projectile.colonne = 1
          projectile.map = 0
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

-- liste bloc / *pour gérer les colision avec la map, les projecile étant dans une fonction, on ne peut pas se position sur la variable MAP*
    local obstacles = {}
-- fonction Obstacle / Call ligne
function Obstacle(pObsX, pObsY, pObsTL, pObsTH)
    local obstacle = {}
          obstacle.X = pObsX
          obstacle.Y = pObsY
          obstacle.TL = pObsTL
          obstacle.TH = pObsTH
    table.insert(obstacles, obstacle)
end

-- Détecte la colision
function Collision(pID)
    tank.map = MAP[tank.ligne][tank.colonne]
end


function love.load()
-- Fichier de l'image Tank Player
    imgPlayer = love.graphics.newImage("img/Player/tank_Vert1.png")
    imgFocus = love.graphics.newImage("img/Player/tourelle1.png")
    imgProj_1 = love.graphics.newImage("img/Projectile/Tir_1.png")
    imgProj_2 = love.graphics.newImage("img/Projectile/Tir_2.png")
    imgEnnemi_1 = love.graphics.newImage("img/Ennemi/tank_Bleu1.png")
    imgTarget = love.graphics.newImage("img/UI/target_1.png")

    -- Terrain par tuile
    MAP.Sprite_MAP[0] = nil
    MAP.Sprite_MAP[1] = nil
    MAP.Sprite_MAP[2] = love.graphics.newImage("img/Terrain/grass_1.png")
    MAP.Sprite_MAP[3] = love.graphics.newImage("img/Terrain/road_2.png")
    MAP.Sprite_MAP[4] = love.graphics.newImage("img/Terrain/road_3.png")
    MAP.Sprite_MAP[5] = love.graphics.newImage("img/Terrain/road_4.png")

    -- Fichier de la Carte
    imgMap = love.graphics.newImage("img/Map/02_Mirror_Islands.png")

    -- Evènement de terrain
    if distance(tank.X, tank.Y, 180, 540) < 20 then
        print("COLISION")
    end

-- Obstacle pour les projectiles
    Obstacle(100, 200, 40, 40)

-- Apparation des Ennemi
    -- Orientation spawn
    northWest = 7.5
    north = - math.pi 
    northEast = - math.pi / 2
    east = 0
    southEast = math.pi / 2
    south = math.pi / 2
    southWest = 4.5
    west =  - 3.15
    -- fonction + legende des paramètres ligne 67 / Draw ligne 153
    SpanwEnnemi(100, 180, south, 0.225, 0, imgEnnemi_1)
    SpanwEnnemi(460, 100, east, 0.225, 0, imgEnnemi_1)
    SpanwEnnemi(540, 255, south, 0.225, 0, imgEnnemi_1)
    SpanwEnnemi(780, 140, south, 0.225, 0, imgEnnemi_1)
    SpanwEnnemi(700, 420, west, 0.225, 0, imgEnnemi_1)

-- Destination Trajet / Draw ligne 203 / Load ligne 180 / Update ligne 180
          goal = {}
          goal.X = 40
          goal.Y = 40
          goal.nbX = 18
          goal.nbY = 10
          goal.taille = 40
          goal.hit = false
end

function love.update(dt)
-- Raccourcie Souris
    mouseR = love.mouse.isDown(2)
    mouseL = love.mouse.isDown(1)

-- Raccourcie Clavier
    pressZ = love.keyboard.isDown("z")
    pressD = love.keyboard.isDown("d")
    pressS = love.keyboard.isDown("s")
    pressQ = love.keyboard.isDown("q")
    pressSpace = love.keyboard.isDown("space")
    
-- Prérequis collision / enregistrer les anciennes valeurs
    old_X, old_Y = tank.X, tank.Y 

-- Déplacer Tank Player
    -- Tourner a gauche
    if pressQ and pressZ or pressD and pressS then
        tank.angle = tank.angle - 0.05
    end
    -- Tourner a droite
    if pressD and pressZ or pressQ and pressS then
        tank.angle = tank.angle + 0.05
    end
    -- Avancer
    if pressZ then
        local ratio_X = math.cos(tank.angle)
        local ratio_Y = math.sin(tank.angle)
        tank.X = tank.X + (tank.Speed * ratio_X)
        tank.Y = tank.Y + (tank.Speed * ratio_Y)
    end
    -- Reculer
    if pressS then
        local ratio_X = math.cos(tank.angle)
        local ratio_Y = math.sin(tank.angle)
        tank.X = tank.X - (tank.Speed * ratio_X)
        tank.Y = tank.Y - (tank.Speed * ratio_Y)
    end

    -- Calcul la position du tank en ligne/colonne
    tank.colonne = math.floor((tank.X - 20) / TILE_LARGEUR) + 1
    tank.ligne = math.floor((tank.Y + 20) / TILE_HAUTEUR) + 1
    Collision()
    if tank.map == 1 then
       -- print("MUR")
        tank.X = old_X
        tank.Y = old_Y
    else
       -- print("RAS")
    end

-- Gestion Tir de Visée
    focus.X, focus.Y = love.mouse.getPosition()
    tank.focus = math.angle(tank.X, tank.Y, focus.X, focus.Y)

-- Gestion des projectile / Draw ligne 188
    for k, projectile in ipairs(projectiles) do
        projectile.X = projectile.X + (dt * projectile.vitesse) * math.cos(projectile.angle)
        projectile.Y = projectile.Y + (dt * projectile.vitesse) * math.sin(projectile.angle)
    end
    if mouseR then
        if charge == false then
            timer = timer - (1 / 30)
        end
    else
        timer = 4
        charge = false
    end
    if timer <= 0.9 and charge == false then
        charge = true
        Shoot(tank.X, tank.Y, tank.focus, 1000, imgProj_2, "surcharge") 
        timer = 4
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

-- Gestion des Obstacles projectiles / create list at ligne 121
    -- Parcours de la liste des Obstacle
    for nbO = #obstacles, 1, -1 do
        local obstacleG = obstacles[nbO]
        -- Parcours de la liste des projectiles
        for nbk = #projectiles, 1, -1 do
            local projectileG = projectiles[nbk]
            -- Suppression de l'ennemi après un impact de projectile
            if distance(projectileG.X, projectileG.Y, obstacleG.X, obstacleG.Y) < 10 then
                table.remove(projectiles, nbk)
            end
        end
    end

-- Condition de victoire par destination / load 1igne 116 / Draw ligne 202 
    if distance(tank.X, tank.Y, (goal.X * goal.nbX), (goal.Y * goal.nbY)) < 20 then
        goal.hit = true
    end

-- Condition de victoire par destruction 
    if #ennemis <= 0 then
        goal.hit = true
    end
end

function love.draw()
-- Afficher Carte
    love.graphics.draw(imgMap,0 ,0)

    -- Afficher un éléments par Tuile    
  c,l = nil  
  for l=1,MAP_HAUTEUR do
    for c=1,MAP_LARGEUR do
      local id = MAP[l][c]
      local spriteM = MAP.Sprite_MAP[id]
      if spriteM ~= nil then
        love.graphics.draw(spriteM, (c-1)*TILE_LARGEUR, (l-1)*TILE_HAUTEUR)
      end
    end
  end
  -- Afficher les obstacles  obstacle.X
    for i, obstacle in ipairs(obstacles) do
        love.graphics.rectangle("fill", obstacle.X, obstacle.Y, obstacle.TL, obstacle.TH)
    end

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
    -- spriteMte Tir Chargé * goal.hit == false est ajouté pour évité la supersition du spriteMte GOOD !!*
    if mouseR and goal.hit == false then
        love.graphics.print(math.floor(timer), tank.X - 8, tank.Y - 55, 0, 2, 2)
        if mouseR and timer == 4 then
            love.graphics.print("BOUM !!", tank.X - 35, tank.Y - 50, 0, 1.5, 1.5)
        end
    end

-- spanw start
    love.graphics.print( "START", spawnPlayer.X - 10, spawnPlayer.Y - 25 , 0, 1.5, 1.5)
    love.graphics.rectangle("line", spawnPlayer.X, spawnPlayer.Y, spawnPlayer.taille, spawnPlayer.taille)

-- Destination Trajet / load 1igne 116 / Update ligne 180
    love.graphics.print( "FINISH", (goal.X * goal.nbX) - 10,(goal.Y * goal.nbY) - 25 , 0, 1.5, 1.5)
    love.graphics.rectangle( "line", (goal.X * goal.nbX), (goal.Y * goal.nbY), goal.taille, goal.taille)
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
        love.graphics.print("X.Tank : " .. tostring(focus.X - (focus.taille / 2)), 0, (15 * 5))
        love.graphics.print("Y.Tank : " .. tostring(focus.Y - (focus.taille / 2)), 0, (15 * 6))
        love.graphics.print("Timer Shoot Spécial : " .. tostring(timer), 0, (15 * 7))
        love.graphics.print("Nb ennemi : " .. tostring(#ennemis), 0, (15 * 8))
        love.graphics.print("Valeur Grille X : " .. tostring(tank.colonne), 0, (15 * 9))
        love.graphics.print("Valeur Grille Y : " .. tostring(tank.ligne), 0, (15 * 10))

        -- Affichage à droite
        love.graphics.print("Largeur écran : " .. tostring(screenLargeur), screenLargeur - 123, (15 * 0))
        love.graphics.print("Hauteur écran : " .. tostring(screenHauteur), screenLargeur - 125, (15 * 1))
        love.graphics.print("Nb de tuile_X : " .. tostring(MAP_LARGEUR), screenLargeur - 110, (15 * 2))
        love.graphics.print("Nb de tuile_Y : " .. tostring(MAP_HAUTEUR), screenLargeur - 110, (15 * 3))
        love.graphics.print("Taille d'une tuile : " .. tostring(TILE_LARGEUR) .. " px", screenLargeur - 148, (15 * 4))

        -- Affichage position de la souris sur la grille
        local mX = love.mouse.getX()
        local mY = love.mouse.getY()
        local cM = math.floor(mX / TILE_LARGEUR) + 1
        local lM = math.floor(mY / TILE_HAUTEUR) + 1
        if lM > 0 and cM> 0 and lM <= MAP_HAUTEUR and cM<= MAP_LARGEUR then
            local idM = MAP[lM][cM]
            love.graphics.print("Ligne souris: " .. tostring(lM), 0, (15 * 11))
            love.graphics.print("Colonne souris: " .. tostring(cM), 0, (15 * 12))
            love.graphics.print("Case ID souris: "..tostring(idM), 0, (15 * 13))
        end

        -- Affichage position de Player sur la grille
        local tX = tank.X
        local tY = tank.Y
        local cT = math.floor(tX / TILE_LARGEUR) + 1
        local lT = math.floor(tY / TILE_HAUTEUR) + 1
        if lT > 0 and cT> 0 and lT <= MAP_HAUTEUR and cT<= MAP_LARGEUR then
            local idT = MAP[lT][cT]
            love.graphics.print("Ligne Tank: " .. tostring(lT), 0, (15 * 14))
            love.graphics.print("Colonne Tank: " .. tostring(cT), 0, (15 * 15))
            love.graphics.print("Case ID Tank: "..tostring(idT), 0, (15 * 16))
        end
    end
    
    -- Afficher la grille pour debug
    if debug_Grille == true then
        for nbLigne_V = 1, MAP_LARGEUR do
            love.graphics.line((nbLigne_V * TILE_LARGEUR), 0, (nbLigne_V * TILE_LARGEUR), 600)
        end
        for nbLigne_H = 1, MAP_HAUTEUR do
            love.graphics.line( 0, (nbLigne_H * TILE_HAUTEUR), 800, (nbLigne_H * TILE_HAUTEUR))
        end
    end

    if debug_Tile == true then 
        cD,lD = nil  
        for lD=1,MAP_HAUTEUR do
          for cD=1,MAP_LARGEUR do
            local idD = MAP[lD][cD]
            local spriteMD = idD
            if spriteMD == 1 then
              love.graphics.rectangle("fill", (cD-1)*TILE_LARGEUR, (lD-1)*TILE_HAUTEUR, 40, 40)
            end
          end
        end
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
    else
        rightMouse = "Off"
    end
end

function love.keypressed(key)  
    -- Activer le Debug / create variable ligne 49 / draw ligne 226
    if love.keyboard.isDown("f1") then
        debug = not debug
    end  
    -- Méthode 2
    if love.keyboard.isDown("f2") then
        if debug_Grille == true then 
            debug_Grille = false
        else 
            debug_Grille = true
        end
    end

    if love.keyboard.isDown("f3") then
        debug_Tile = not debug_Tile
    end
end
