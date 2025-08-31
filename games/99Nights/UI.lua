
--[[
    Night Hub - 99 Nights in the Forest UI
    Interface do usuário usando Fluent UI com toggle mobile
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
    Theme = "Dark"
})

-- Remover o minimize key para mobile
Window.MinimizeKey = nil

-- Função para criar o toggle de logo
local function CreateToggleLogo()
    -- Destruir toggle existente se houver
    if toggleImage then
        toggleImage:Destroy()
    end
    
    -- Criar screen gui para o toggle
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "NightHubToggleGui"
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.ResetOnSpawn = false
    
    -- Criar a imagem toggle
    toggleImage = Instance.new("ImageButton")
    toggleImage.Name = "NightHubToggle"
    toggleImage.Image = "rbxassetid://81425308934092"
    toggleImage.ImageTransparency = 0
    toggleImage.BackgroundTransparency = 1
    toggleImage.Size = UDim2.new(0, 60, 0, 60)
    toggleImage.Position = UDim2.new(0, 20, 0.5, -30)
    toggleImage.ZIndex = 1000
    toggleImage.Parent = screenGui
    
    -- Tornar o toggle sempre visível
    toggleImage.Active = true
    toggleImage.Selectable = true
    toggleImage.Visible = true
    
    -- Efeitos de hover
    toggleImage.MouseEnter:Connect(function()
        game:GetService("TweenService"):Create(toggleImage, TweenInfo.new(0.2), {
            Size = UDim2.new(0, 65, 0, 65)
        }):Play()
    end)
    
    toggleImage.MouseLeave:Connect(function()
        game:GetService("TweenService"):Create(toggleImage, TweenInfo.new(0.2), {
            Size = UDim2.new(0, 60, 0, 60)
        }):Play()
    end)
    
    -- Função de toggle
    toggleImage.MouseButton1Click:Connect(function()
        if isUIOpen then
            -- Fechar a UI
            Window:Hide()
            isUIOpen = false
            
            -- Animação de fechamento do toggle
            game:GetService("TweenService"):Create(toggleImage, TweenInfo.new(0.3), {
                ImageTransparency = 0.2,
                Size = UDim2.new(0, 50, 0, 50)
            }):Play()
            
        else
            -- Abrir a UI
            Window:Show()
            isUIOpen = true
            
            -- Animação de abertura do toggle
            game:GetService("TweenService"):Create(toggleImage, TweenInfo.new(0.3), {
                ImageTransparency = 0,
                Size = UDim2.new(0, 60, 0, 60)
            }):Play()
        end
    end)
    
    screenGui.Parent = game:GetService("CoreGui")
    return toggleImage
end

-- Abas
local Tabs = {
    Main = Window:AddTab({ Title = "Principal", Icon = "home" }),
    Player = Window:AddTab({ Title = "Jogador", Icon = "user" }),
    Settings = Window:AddTab({ Title = "Configurações", Icon = "settings" })
}

-- ABA PRINCIPAL
Tabs.Main:AddParagraph({
    Title = "Bem-vindo ao Night Hub",
    Content = "Clique na logo para abrir/fechar o menu!"
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
    Title = "Configurações Mobile",
    Content = "Configurações para dispositivos móveis"
})

Tabs.Settings:AddToggle("ToggleVisibility", {
    Title = "Mostrar Botão Toggle",
    Default = true,
    Callback = function(Value)
        if toggleImage then
            toggleImage.Visible = Value
        end
    end
})

Tabs.Settings:AddButton({
    Title = "Mover Botão Toggle",
    Description = "Clique e arraste para reposicionar",
    Callback = function()
        if toggleImage then
            Fluent:Notify({
                Title = "Night Hub",
                Content = "Segure e arraste o botão para mover",
                Duration = 5
            })
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

-- Adicionar funcionalidade de arrastar ao toggle
if toggleImage then
    local dragging = false
    local dragInput, dragStart, startPos

    toggleImage.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = toggleImage.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    toggleImage.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            toggleImage.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- Inicializar interface
Fluent:Notify({
    Title = "Night Hub",
    Content = "Interface carregada! Use a logo para toggle.",
    Duration = 5
})

-- Selecionar a primeira aba
Window:SelectTab(1)

print("Night Hub - Interface mobile carregada com sucesso!")
