--[[
    Night Hub - 99 Nights in the Forest UI
    Interface do usuário usando Fluent UI
--]]

-- Carregar Fluent UI
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

-- Carregar funções
local Functions = loadstring(game:HttpGet("https://raw.githubusercontent.com/Pixelpv/NightHUB/main/games/99Nights/Functions.lua"))()

-- Criar interface
local Window = Fluent:CreateWindow({
    Title = "Night Hub - 99 Nights in the Forest",
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

-- Variáveis globais
getgenv().AutoCollect = false
getgenv().AvoidEnemies = false
getgenv().NightCollect = false

-- ABA PRINCIPAL
Tabs.Main:AddParagraph({
    Title = "Bem-vindo ao Night Hub",
    Content = "Selecione as funções desejadas para 99 Nights in the Forest."
})

Tabs.Main:AddToggle("AutoCollectToggle", {
    Title = "Coleta Automática",
    Default = false,
    Callback = function(Value)
        getgenv().AutoCollect = Value
        if Value then
            Functions.AutoCollect()
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
        getgenv().AvoidEnemies = Value
        if Value then
            Functions.AvoidEnemies()
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

Tabs.Main:AddToggle("NightCollectToggle", {
    Title = "Coleta Noturna",
    Default = false,
    Callback = function(Value)
        getgenv().NightCollect = Value
        if Value then
            Functions.NightCollect()
            Fluent:Notify({
                Title = "Night Hub",
                Content = "Coleta noturna ativada",
                Duration = 3
            })
        else
            Fluent:Notify({
                Title = "Night Hub",
                Content = "Coleta noturna desativada",
                Duration = 3
            })
        end
    end
})

Tabs.Main:AddButton({
    Title = "Coletar Todos os Itens Próximos",
    Description = "Coleta instantaneamente todos os itens próximos",
    Callback = function()
        Functions.AutoCollect()
        task.wait(1)
        getgenv().AutoCollect = false
        Fluent:Notify({
            Title = "Night Hub",
            Content = "Itens próximos coletados",
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

Tabs.Settings:AddToggle("AntiBanToggle", {
    Title = "Proteção Anti-Ban",
    Default = true,
    Callback = function(Value)
        if Value then
            Fluent:Notify({
                Title = "Night Hub",
                Content = "Proteção Anti-Ban ativada",
                Duration = 3
            })
        else
            Fluent:Notify({
                Title = "Night Hub",
                Content = "Proteção Anti-Ban desativada",
                Duration = 3
            })
        end
    end
})

Tabs.Settings:AddToggle("AntiResetToggle", {
    Title = "Proteção Anti-Reset",
    Default = true,
    Callback = function(Value)
        if Value then
            Fluent:Notify({
                Title = "Night Hub",
                Content = "Proteção Anti-Reset ativada",
                Duration = 3
            })
        else
            Fluent:Notify({
                Title = "Night Hub",
                Content = "Proteção Anti-Reset desativada",
                Duration = 3
            })
        end
    end
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
