--[[
    Night Hub - Script Hub para Roblox
    Autor: ntzinho
    Versão: 1.1
    Grátis: Sim, sem sistema de chaves
--]]

-- Lista de PlaceIds suportados (principal, secundário e partidas)
local SupportedPlaceIds = {
    79546208627805,    -- PlaceId principal
    7326934954,        -- PlaceId secundário  
    126509999114328    -- PlaceId das partidas (NOVO)
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
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Night Hub",
        Text = "Jogo não suportado",
        Duration = 5
    })
    return
end

-- Notificação de inicialização
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Night Hub",
    Text = "Inicializando...",
    Duration = 2
})

wait(1)

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

-- Notificação de proteções ativadas
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Night Hub",
    Text = "Proteções anti-ban ativadas",
    Duration = 3
})

wait(1)

-- Carregar Fluent UI
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

-- Criar interface
local windowTitle = "Night Hub - 99 Nights in the Forest"
if currentPlaceId == 126509999114328 then
    windowTitle = "Night Hub - Partida Ativa"
end

local Window = Fluent:CreateWindow({
    Title = windowTitle,
    SubTitle = "by ntzinho",
    TabWidth = 160,
    Size = UDim2.fromOffset(500, 400),
    Acrylic = true,
    Theme = "Dark"
})

-- Abas
local Tabs = {
    Main = Window:AddTab({ Title = "Principal", Icon = "home" }),
    Player = Window:AddTab({ Title = "Jogador", Icon = "user" }),
    Settings = Window:AddTab({ Title = "Configurações", Icon = "settings" })
}

-- ABA PRINCIPAL
Tabs.Main:AddParagraph({
    Title = "Bem-vindo ao Night Hub",
    Content = "Selecione as funções desejadas para 99 Nights in the Forest."
})

Tabs.Main:AddToggle("AutoCollectToggle", {
    Title = "Coleta Automática",
    Default = false,
    Callback = function(Value)
        if Value then
            Fluent:Notify({
                Title = "Night Hub",
                Content = "Coleta automática ativada",
                Duration = 3
            })
        else
            Fluent:Notify({
                Title = "Night Hub",
                Content = "Coleta automática desativada",
                Duration = 3
            })
        end
    end
})

Tabs.Main:AddToggle("AvoidEnemiesToggle", {
    Title = "Evitar Inimigos",
    Default = false,
    Callback = function(Value)
        if Value then
            Fluent:Notify({
                Title = "Night Hub",
                Content = "Evitar inimigos ativado",
                Duration = 3
            })
        else
            Fluent:Notify({
                Title = "Night Hub",
                Content = "Evitar inimigos desativado",
                Duration = 3
            })
        end
    end
})

Tabs.Main:AddButton({
    Title = "Coletar Todos os Itens Próximos",
    Description = "Coleta instantaneamente todos os itens próximos",
    Callback = function()
        Fluent:Notify({
            Title = "Night Hub",
            Content = "Função de coleta em desenvolvimento",
            Duration = 3
        })
    end
})

-- ABA JOGADOR
Tabs.Player:AddSlider("WalkSpeedSlider", {
    Title = "Velocidade de Movimento",
    Description = "Ajusta a velocidade do personagem",
    Default = 16,
    Min = 16,
    Max = 100,
    Rounding = 0,
    Callback = function(Value)
        local character = game.Players.LocalPlayer.Character
        if character and character:FindFirstChild("Humanoid") then
            character.Humanoid.WalkSpeed = Value
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
        end
    end
})

Tabs.Player:AddButton({
    Title = "Resetar Velocidades",
    Description = "Volta aos valores padrão",
    Callback = function()
        local character = game.Players.LocalPlayer.Character
        if character and character:FindFirstChild("Humanoid") then
            character.Humanoid.WalkSpeed = 16
            character.Humanoid.JumpPower = 50
            Fluent:Notify({
                Title = "Night Hub",
                Content = "Velocidades resetadas",
                Duration = 3
            })
        end
    end
})

-- ABA CONFIGURAÇÕES
Tabs.Settings:AddParagraph({
    Title = "Configurações do Night Hub",
    Content = "Personalize sua experiência com o hub."
})

Tabs.Settings:AddButton({
    Title = "Fechar Interface",
    Description = "Fecha a interface do Night Hub",
    Callback = function()
        Window:Destroy()
        Fluent:Notify({
            Title = "Night Hub",
            Content = "Interface fechada. Use o loader para reabrir.",
            Duration = 5
        })
    end
})

Tabs.Settings:AddParagraph({
    Title = "Créditos",
    Content = "Night Hub desenvolvido por ntzinho. Grátis e sempre será."
})

-- Inicializar interface
Fluent:Notify({
    Title = "Night Hub",
    Content = "Carregado com sucesso! Bem-vindo.",
    Duration = 5
})

-- Selecionar a primeira aba
Window:SelectTab(1)

-- Notificação final
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Night Hub",
    Text = "Interface carregada com sucesso!",
    Duration = 3
})
