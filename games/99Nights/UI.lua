--[[
    Night Hub - 99 Nights in the Forest UI
    Interface do usuário usando Fluent UI com toggle de logo
--]]

-- Carregar Fluent UI
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

-- Variáveis de estado
local isUIOpen = true
local toggleImage

-- Determinar título da janela
local currentPlaceId = game.PlaceId
local windowTitle = "Night Hub - 99 Nights in the Forest"
if currentPlaceId == 126509999114328 then
    windowTitle = "Night Hub - Partida Ativa"
end

-- Criar interface
local Window = Fluent:CreateWindow({
    Title = windowTitle,
    SubTitle = "by ntzinho",
    TabWidth = 160,
    Size = UDim2.fromOffset(500, 400),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.RightShift
})

-- Função para criar o toggle de logo
local function CreateToggleLogo()
    -- Criar a imagem toggle
    toggleImage = Instance.new("ImageButton")
    toggleImage.Name = "NightHubToggle"
    toggleImage.Image = "rbxassetid://81425308934092"
    toggleImage.ImageTransparency = 0.2
    toggleImage.BackgroundTransparency = 1
    toggleImage.Size = UDim2.new(0, 50, 0, 50)
    toggleImage.Position = UDim2.new(0, 10, 0, 10)
    toggleImage.ZIndex = 1000
    toggleImage.Parent = game:GetService("CoreGui")
    
    -- Efeitos de hover
    toggleImage.MouseEnter:Connect(function()
        game:GetService("TweenService"):Create(toggleImage, TweenInfo.new(0.2), {
            ImageTransparency = 0,
            Size = UDim2.new(0, 55, 0, 55)
        }):Play()
    end)
    
    toggleImage.MouseLeave:Connect(function()
        game:GetService("TweenService"):Create(toggleImage, TweenInfo.new(0.2), {
            ImageTransparency = 0.2,
            Size = UDim2.new(0, 50, 0, 50)
        }):Play()
    end)
    
    -- Função de toggle
    toggleImage.MouseButton1Click:Connect(function()
        if isUIOpen then
            -- Fechar/minimizar a UI
            Window:Minimize()
            isUIOpen = false
            
            -- Esconder o toggle gradualmente
            game:GetService("TweenService"):Create(toggleImage, TweenInfo.new(0.5), {
                ImageTransparency = 1,
                Size = UDim2.new(0, 0, 0, 0)
            }):Play()
            
            -- Remover completamente após animação
            wait(0.5)
            if toggleImage then
                toggleImage:Destroy()
                toggleImage = nil
            end
        else
            -- Abrir a UI
            Window:Restore()
            isUIOpen = true
        end
    end)
end

-- Função para restaurar o toggle quando a UI é fechada por outros meios
local function RestoreToggle()
    if not toggleImage and isUIOpen then
        CreateToggleLogo()
    end
end

-- Conectar eventos de minimização/restauração da janela
Window.Minimized:Connect(function()
    isUIOpen = false
    if toggleImage then
        toggleImage:Destroy()
        toggleImage = nil
    end
end)

Window.Restored:Connect(function()
    isUIOpen = true
    CreateToggleLogo()
end)

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
    Title = "Teleport para Base",
    Description = "Volta rapidamente para a base",
    Callback = function()
        Fluent:Notify({
            Title = "Night Hub",
            Content = "Teleport em desenvolvimento",
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
            Fluent:Notify({
                Title = "Night Hub",
                Content = "Velocidade ajustada para: " .. Value,
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
                Content = "Pulo ajustado para: " .. Value,
                Duration = 2
            })
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

Tabs.Settings:AddToggle("ShowToggleToggle", {
    Title = "Mostrar Botão Toggle",
    Default = true,
    Callback = function(Value)
        if Value and not toggleImage then
            CreateToggleLogo()
        elseif not Value and toggleImage then
            toggleImage:Destroy()
            toggleImage = nil
        end
    end
})

Tabs.Settings:AddButton({
    Title = "Fechar Interface",
    Description = "Fecha a interface do Night Hub",
    Callback = function()
        Window:Destroy()
        if toggleImage then
            toggleImage:Destroy()
            toggleImage = nil
        end
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

-- Criar o toggle inicial
CreateToggleLogo()

-- Inicializar interface
Fluent:Notify({
    Title = "Night Hub",
    Content = "Interface carregada com sucesso!",
    Duration = 5
})

-- Selecionar a primeira aba
Window:SelectTab(1)

print("Night Hub - Interface carregada com sucesso!")
