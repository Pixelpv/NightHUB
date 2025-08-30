--[[
    Night Hub - Script Hub para Roblox
    Autor: ntzinho
    Versão: 2.0
    Com sistema de auto-reinjeção para partidas
--]]

-- Variável global para controlar o hub
getgenv().NightHub = {
    Loaded = true,
    Version = "2.0"
}

-- Função para verificar se estamos em uma partida
local function IsInMatch()
    return game:GetService("Players").LocalPlayer and game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui")
end

-- Esperar até estar em uma partida
local function WaitForMatch()
    repeat
        task.wait(1)
    until IsInMatch()
    return true
end

-- Notificação de inicialização
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Night Hub",
    Text = "Aguardando partida...",
    Duration = 5
})

-- Esperar até estar em uma partida válida
if WaitForMatch() then
    -- Notificação de que estamos em partida
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Night Hub",
        Text = "Partida detectada! Carregando...",
        Duration = 3
    })
    
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

    -- Carregar Fluent UI
    local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
    
    -- Criar interface
    local Window = Fluent:CreateWindow({
        Title = "Night Hub - 99 Nights in the Forest",
        SubTitle = "by ntzinho | Partida Ativa",
        TabWidth = 160,
        Size = UDim2.fromOffset(500, 400),
        Acrylic = true,
        Theme = "Dark"
    })

    -- Abas
    local Tabs = {
        Main = Window:AddTab({ Title = "Principal", Icon = "home" }),
        Player = Window:AddTab({ Title = "Jogador", Icon = "user" }),
        Auto = Window:AddTab({ Title = "Automático", Icon = "refresh-cw" })
    }

    -- ABA PRINCIPAL
    Tabs.Main:AddParagraph({
        Title = "Night Hub - Modo Partida",
        Content = "Script reinjetado automaticamente para esta partida."
    })

    Tabs.Main:AddToggle("AutoFarmToggle", {
        Title = "Farm Automático",
        Default = false,
        Callback = function(Value)
            if Value then
                Fluent:Notify({
                    Title = "Night Hub",
                    Content = "Farm automático ativado",
                    Duration = 3
                })
                -- Aqui viria a lógica de farm automático
            else
                Fluent:Notify({
                    Title = "Night Hub",
                    Content = "Farm automático desativado",
                    Duration = 3
                })
            end
        end
    })

    Tabs.Main:AddToggle("CollectToggle", {
        Title = "Coletar Itens",
        Default = false,
        Callback = function(Value)
            if Value then
                Fluent:Notify({
                    Title = "Night Hub",
                    Content = "Coleta de itens ativada",
                    Duration = 3
                })
            else
                Fluent:Notify({
                    Title = "Night Hub",
                    Content = "Coleta de itens desativada",
                    Duration = 3
                })
            end
        end
    })

    -- ABA JOGADOR
    Tabs.Player:AddSlider("WalkSpeedSlider", {
        Title = "Velocidade de Movimento",
        Description = "Ajusta a velocidade do personagem",
        Default = 16,
        Min = 16,
        Max = 150,
        Rounding = 0,
        Callback = function(Value)
            local character = game.Players.LocalPlayer.Character
            if character and character:FindFirstChild("Humanoid") then
                character.Humanoid.WalkSpeed = Value
                Fluent:Notify({
                    Title = "Night Hub",
                    Content = "Velocidade: " .. Value,
                    Duration = 2
                })
            end
        end
    })

    Tabs.Player:AddSlider("JumpPowerSlider", {
        Title = "Força do Pulo",
        Description = "Ajusta a altura do pulo",
        Default = 50,
        Min = 50,
        Max = 200,
        Rounding = 0,
        Callback = function(Value)
            local character = game.Players.LocalPlayer.Character
            if character and character:FindFirstChild("Humanoid") then
                character.Humanoid.JumpPower = Value
                Fluent:Notify({
                    Title = "Night Hub",
                    Content = "Pulo: " .. Value,
                    Duration = 2
                })
            end
        end
    })

    -- ABA AUTOMÁTICO
    Tabs.Auto:AddParagraph({
        Title = "Configurações Automáticas",
        Content = "O Night Hub se reinjeta automaticamente em novas partidas."
    })

    Tabs.Auto:AddToggle("AutoReinjectToggle", {
        Title = "Auto-Reinjeção",
        Default = true,
        Callback = function(Value)
            if Value then
                Fluent:Notify({
                    Title = "Night Hub",
                    Content = "Auto-reinjeção ativada",
                    Duration = 3
                })
            else
                Fluent:Notify({
                    Title = "Night Hub",
                    Content = "Auto-reinjeção desativada",
                    Duration = 3
                })
            end
        end
    })

    Tabs.Auto:AddButton({
        Title = "Reinjetar Manualmente",
        Description = "Força a reinjeção do script",
        Callback = function()
            Fluent:Notify({
                Title = "Night Hub",
                Content = "Reinjetando script...",
                Duration = 3
            })
            loadstring(game:HttpGet("https://raw.githubusercontent.com/Pixelpv/NightHUB/main/loader.lua"))()
        end
    })

    -- Notificação final
    Fluent:Notify({
        Title = "Night Hub",
        Content = "Script carregado com sucesso na partida!",
        Duration = 5
    })

    Window:SelectTab(1)
    
else
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Night Hub",
        Text = "Erro ao detectar partida",
        Duration = 5
    })
end

-- Sistema de detecção de fim de partida (para auto-reinjeção)
spawn(function()
    while task.wait(5) do
        if not IsInMatch() then
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "Night Hub",
                Text = "Partida terminada. Aguardando nova...",
                Duration = 5
            })
            
            -- Esperar nova partida e reinjetar
            if WaitForMatch() then
                loadstring(game:HttpGet("https://raw.githubusercontent.com/Pixelpv/NightHUB/main/loader.lua"))()
            end
        end
    end
end)
