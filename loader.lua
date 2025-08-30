--[[
    Night Hub Loader - Versão Atualizada
    Autor: ntzinho
    Repositório: https://github.com/Pixelpv/NightHUB.git
--]]

local PlaceId = game.PlaceId

-- Verificar se o jogo atual é suportado
if PlaceId == 79546208627805 or PlaceId == 7326934954 then
    -- Notificação de inicialização
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Night Hub",
        Text = "Injetando script...",
        Duration = 3
    })
    
    -- Esperar o jogador entrar no jogo completamente
    if not game:IsLoaded() then
        game.Loaded:Wait()
    end
    
    if not game.Players.LocalPlayer then
        game.Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
    end
    
    -- Carregar o script principal
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Pixelpv/NightHUB/main/main.lua"))()
else
    game:GetService("Players").LocalPlayer:Kick("Night Hub não suporta este jogo. Jogos suportados: 99 Nights in the Forest")
end
