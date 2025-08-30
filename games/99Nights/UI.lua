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
    Size = UDim2.fromOffset(500, 400),
    Acrylic = true,
    Theme = "Dark"
})

-- Variável para controlar se a GUI está visível
local GuiVisible = true

-- Adicionar logo do Discord como botão minimizar
local LogoUrl = "https://cdn.discordapp.com/icons/1309865141525020672/7b0fa16db0e6fdc6238b4bf3b1a71b54.png?size=2048"

-- Esperar a interface ser criada
task.wait(1)

local LogoButton = Instance.new("ImageButton")
LogoButton.Name = "NightHubMinimizeButton"
LogoButton.Image = LogoUrl
LogoButton.Size = UDim2.new(0, 50, 0, 50)
LogoButton.Position = UDim2.new(1, -60, 0, 10)
LogoButton.BackgroundTransparency = 1
LogoButton.ZIndex = 100

-- Verificar se a imagem carregou, se não, usar fallback
LogoButton:GetPropertyChangedSignal("Image"):Connect(function()
    if LogoButton.Image == "" then
        LogoButton.Image = "rbxassetid://0"  -- Fallback
    end
end)

-- Adicionar à tela
if game:GetService("CoreGui"):FindFirstChild("NightHubMinimizeButton") then
    game:GetService("CoreGui").NightHubMinimizeButton:Destroy()
end
LogoButton.Parent = game:GetService("CoreGui")

-- Função para toggle da GUI
local function ToggleGUI()
    GuiVisible = not GuiVisible
    local mainFrame = Window:GetParent()
    
    if mainFrame then
        mainFrame.Visible = GuiVisible
        if GuiVisible then
            LogoButton.ImageTransparency = 0
        else
            LogoButton.ImageTransparency = 0.5
        end
    end
end

-- Conectar o clique do botão
LogoButton.MouseButton1Click:Connect(ToggleGUI)

-- Efeito hover no botão
LogoButton.MouseEnter:Connect(function()
    game:GetService("TweenService"):Create(LogoButton, TweenInfo.new(0.2), {Size = UDim2.new(0, 55, 0, 55)}):Play()
end)

LogoButton.MouseLeave:Connect(function()
    game:GetService("TweenService"):Create(LogoButton, TweenInfo.new(0.2), {Size = UDim2.new(0, 50, 0, 50)}):Play()
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
    Content = "Clique na logo para minimizar/abrir"
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

Tabs.Settings:AddButton({
    Title = "Fechar Interface",
    Description = "Fecha completamente a interface",
    Callback = function()
        Window:Destroy()
        if game:GetService("CoreGui"):FindFirstChild("NightHubMinimizeButton") then
            game:GetService("CoreGui").NightHubMinimizeButton:Destroy()
        end
        Fluent:Notify({
            Title = "Night Hub",
            Content = "Interface fechada. Use o loader para reabrir.",
            Duration = 5
        })
    end
})

-- Notificação inicial
Fluent:Notify({
    Title = "Night Hub",
    Content = "Logo adicionada como botão minimizar!",
    Duration = 5
})

Window:SelectTab(1)

print("✅ Night Hub - Logo carregada como botão minimizar!")
