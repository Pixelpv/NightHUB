--[[
    Night Hub Loader
    Autor: ntzinho
    Repositório: https://github.com/Pixelpv/NightHUB.git
--]]

local PlaceId = game.PlaceId
local SupportedPlaceIds = {
    79546208627805,    -- PlaceId principal
    7326934954,        -- PlaceId secundário
    126509999114328    -- PlaceId das partidas
}

-- Verificar se o jogo atual é suportado
local isSupported = false
for _, supportedId in ipairs(SupportedPlaceIds) do
    if PlaceId == supportedId then
        isSupported = true
        break
    end
end

if isSupported then
    -- Notificação de inicialização
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Night Hub",
        Text = "Carregando para 99 Nights...",
        Duration = 3
    })
    
    wait(1)
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Pixelpv/NightHUB/main/main.lua"))()
else
    game:GetService("Players").LocalPlayer:Kick("Night Hub não suporta este jogo. Jogos suportados: 99 Nights in the Forest")
end
