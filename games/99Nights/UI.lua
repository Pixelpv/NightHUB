--[[
    Night Hub - Interface Simples com Movimento
--]]

-- Carregar Fluent UI
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

-- Criar interface com tema escuro
local Window = Fluent:CreateWindow({
    Title = "Night Hub - 99 Nights",
    SubTitle = "by ntzinho",
    TabWidth = 160,
    Size = UDim2.fromOffset(400, 300),
    Acrylic = false, -- Desativar acrílico para melhor performance
    Theme = "Dark"
})

-- Obter a main frame para tornar móvel
local mainFrame = Window:GetParent()
mainFrame.Active = true
mainFrame.Draggable = true

-- Estilizar a janela para tema cinza/preto
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 1
mainFrame.BorderColor3 = Color3.fromRGB(80, 80, 80)

-- Abas com estilo minimalista
local Tabs = {
    Main = Window:AddTab({Title = "Principal", Icon = "home"}),
    Player = Window:AddTab({Title = "Jogador", Icon = "user"})
}

-- ABA PRINCIPAL - Estilo simples
Tabs.Main:AddParagraph({
    Title = "🌙 NIGHT HUB",
    Content = "Arraste para mover • by ntzinho"
})

Tabs.Main:AddToggle("AutoCollect", {
    Title = "Coleta Automática",
    Default = false,
    Callback = function(Value)
        Fluent:Notify({
            Title = "Night Hub",
            Content = Value and "Coleta ativada!" or "Coleta desativada!",
            Duration = 2
        })
    end
})

Tabs.Main:AddToggle("AvoidEnemies", {
    Title = "Evitar Inimigos", 
    Default = false,
    Callback = function(Value)
        Fluent:Notify({
            Title = "Night Hub",
            Content = Value and "Evasão ativada!" or "Evasão desativada!",
            Duration = 2
        })
    end
})

Tabs.Main:AddButton({
    Title = "Teleport para Base",
    Callback = function()
        Fluent:Notify({
            Title = "Night Hub", 
            Content = "Função em desenvolvimento",
            Duration = 2
        })
    end
})

-- ABA JOGADOR
Tabs.Player:AddSlider("WalkSpeed", {
    Title = "Velocidade",
    Description = "16 (normal) até 100",
    Default = 16,
    Min = 16,
    Max = 100,
    Rounding = 0,
    Callback = function(Value)
        local char = game.Players.LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.WalkSpeed = Value
        end
    end
})

Tabs.Player:AddSlider("JumpPower", {
    Title = "Força do Pulo", 
    Description = "50 (normal) até 200",
    Default = 50,
    Min = 50,
    Max = 200,
    Rounding = 0,
    Callback = function(Value)
        local char = game.Players.LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.JumpPower = Value
        end
    end
})

Tabs.Player:AddButton({
    Title = "Resetar Valores",
    Callback = function()
        local char = game.Players.LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.WalkSpeed = 16
            char.Humanoid.JumpPower = 50
            Fluent:Notify({
                Title = "Night Hub",
                Content = "Valores resetados!",
                Duration = 2
            })
        end
    end
})

-- Botão para fechar
Tabs.Main:AddButton({
    Title = "❌ Fechar Interface",
    Callback = function()
        Window:Destroy()
        Fluent:Notify({
            Title = "Night Hub",
            Content = "Interface fechada!",
            Duration = 3
        })
    end
})

-- Notificação inicial
Fluent:Notify({
    Title = "NIGHT HUB",
    Content = "Interface carregada • Arraste para mover",
    Duration = 4
})

Window:SelectTab(1)

print("✅ Night Hub - Interface simples carregada!")
