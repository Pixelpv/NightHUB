--[[
    Night Hub - 99 Nights in the Forest UI
    Interface do usuário usando Fluent UI
--]]

-- Carregar Fluent UI
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

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
    Size = UDim2.fromOffset(500, 500),  -- Aumentado para caber a logo
    Acrylic = true,
    Theme = "Dark"
})

-- Adicionar logo do Discord
local LogoUrl = "https://cdn.discordapp.com/icons/1309865141525020672/7b0fa16db0e6fdc6238b4bf3b1a71b54.png?size=2048"

local LogoFrame = Instance.new("Frame")
LogoFrame.Size = UDim2.new(1, -40, 0, 100)
LogoFrame.Position = UDim2.new(0, 20, 0, 10)
LogoFrame.BackgroundTransparency = 1
LogoFrame.Parent = Window:GetParent()

local LogoImage = Instance.new("ImageLabel")
LogoImage.Image = LogoUrl
LogoImage.Size = UDim2.new(0, 80, 0, 80)
LogoImage.Position = UDim2.new(0.5, -40, 0, 10)
LogoImage.BackgroundTransparency = 1
LogoImage.Parent = LogoFrame

local LogoText = Instance.new("TextLabel")
LogoText.Text = "NIGHT HUB"
LogoText.Size = UDim2.new(1, 0, 0, 30)
LogoText.Position = UDim2.new(0, 0, 0, 90)
LogoText.TextColor3 = Color3.fromRGB(255, 255, 255)
LogoText.TextScaled = true
LogoText.Font = Enum.Font.GothamBold
LogoText.BackgroundTransparency = 1
LogoText.Parent = LogoFrame

-- Efeito de brilho suave na logo
spawn(function()
    while true do
        for i = 0, 1, 0.1 do
            LogoImage.ImageTransparency = 0.1 * i
            wait(0.1)
        end
        for i = 0, 1, 0.1 do
            LogoImage.ImageTransparency = 0.1 - (0.1 * i)
            wait(0.1)
        end
    end
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
    Content = "Interface carregada com sucesso!",
    Duration = 5
})

-- Selecionar a primeira aba
Window:SelectTab(1)

print("Night Hub - Interface carregada com sucesso!")
