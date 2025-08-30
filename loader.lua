--[[
    Night Hub Loader
    Autor: ntzinho
    Repositório: https://github.com/Pixelpv/NightHUB.git
--]]

local PlaceId = game.PlaceId

-- Verificar se o jogo atual é suportado
if PlaceId == 79546208627805 or PlaceId == 7326934954 then
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Pixelpv/NightHUB/main/main.lua"))()
else
    game:GetService("Players").LocalPlayer:Kick("Night Hub não suporta este jogo. Jogos suportados: 99 Nights in the Forest")
end
