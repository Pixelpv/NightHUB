--[[
    Night Hub - Script Hub para Roblox
    Autor: ntzinho
    Versão: 1.0
    Grátis: Sim, sem sistema de chaves
--]]

-- Anti-ban e anti-reset básicos
local function AntiBan()
    -- Previne detecção por nome
    if not pcall(function() game:GetService("CoreGui").NightHub = nil end) then
        game:GetService("CoreGui")["\78\105\103\104\116\72\117\98"] = nil
    end
    
    -- Proteção contra kicks
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    
    local originalKick = LocalPlayer.Kick
    LocalPlayer.Kick = function(self, ...)
        warn("[Night Hub] Tentativa de kick bloqueada")
        return nil
    end
end

local function AntiReset()
    -- Proteção contra reset
    local originalReset = game:GetService("Players").LocalPlayer.ResetCharacter
    game:GetService("Players").LocalPlayer.ResetCharacter = function(self)
        warn("[Night Hub] Tentativa de reset bloqueada")
        return nil
    end
end

-- Inicializar proteções
spawn(AntiBan)
spawn(AntiReset)

-- Carregar interface para o jogo específico
local PlaceId = game.PlaceId
if PlaceId == 79546208627805 or PlaceId == 7326934954 then
    -- Notificação de carregamento
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Night Hub",
        Text = "Carregando interface para 99 Nights...",
        Duration = 3
    })
    
    -- Dar tempo para a notificação aparecer
    wait(1)
    
    -- Carregar a interface
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Pixelpv/NightHUB/main/games/99Nights/UI.lua"))()
else
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Night Hub",
        Text = "Jogo não suportado",
        Duration = 5
    })
end
