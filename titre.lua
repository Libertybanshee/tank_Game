function updateMenu(dt)  
end

function drawMenu()
    love.graphics.draw(imgFond, 0, 0, 0, 0.7, 0.9)
    love.graphics.draw(imgDemoT, love.graphics:getWidth() / 2, 70, 0 , 0.8, 0.8, imgDemoT:getWidth() / 2)
    love.graphics.draw(imgGamecodeurT, love.graphics:getWidth() / 2, 140, 0 , 0.8, 0.8, imgGamecodeurT:getWidth() / 2)
    love.graphics.draw(imgGametankT, love.graphics:getWidth() / 2, 290, 0 , 0.8, 0.8, imgGametankT:getWidth() / 2)
    if showTitre == true then
        love.graphics.setColor(255, 165, 0, 1)
        love.graphics.print("Appuyez sur espace pour commencez", 190, 500, 0, 2)
        love.graphics.setColor(1, 1, 1, 1)
    end
end