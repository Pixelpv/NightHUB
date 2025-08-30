--[[
    Night Hub - Script Hub para Roblox
    Autor: ntzinho
    Versão: 1.2
    Grátis: Sim, sem sistema de chaves
--]]

-- Lista de PlaceIds suportados
local SupportedPlaceIds = {
    79546208627805,    -- PlaceId principal
    7326934954,        -- PlaceId secundário  
    126509999114328    -- PlaceId das partidas
}

-- Verificar se estamos em um jogo suportado
local currentPlaceId = game.PlaceId
local isSupported = false

for _, supportedId in ipairs(SupportedPlaceIds) do
    if currentPlaceId == supportedId then
        isSupported = true
        break
    end
end

if not isSupported then
    return
end

-- Anti-ban básico
local function AntiBan()
    -- Previne detecção por nome
    if not pcall(function() game:GetService("CoreGui").NightHub = nil end) then
        game:GetService("CoreGui")["\78\105\103\104\116\72\117\98"] = nil
    end
end

-- Inicializar proteção
spawn(AntiBan)

-- Carregar a interface do jogo específico
loadstring(game:HttpGet("https://raw.githubusercontent.com/Pixelpv/NightHUB/main/games/99Nights/UI.lua"))()
