--[[
    Night Hub - Sistema de Toggle Profissional
--]]

-- Carregar Fluent UI
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

-- Criar interface PRIMEIRO
local Window = Fluent:CreateWindow({
    Title = "Night Hub - 99 Nights",
    SubTitle = "by ntzinho",
    TabWidth = 160,
    Size = UDim2.fromOffset(450, 350),
    Acrylic = true,
    Theme = "Dark"
})

-- Obter a main frame da interface
local mainFrame = Window:GetParent()

-- Sistema de toggle da GUI
local GuiVisible = true
local LogoUrl = "https://raw.githubusercontent.com/Pixelpv/NightHUB/main/logo.png"

-- Criar botão da logo
local LogoButton = Instance.new("ImageButton")
LogoButton.Name = "NightHubToggle"
LogoButton.Image = LogoUrl
LogoButton.Size = UDim2.new(0, 50, 0, 50)
LogoButton.Position = UDim2.new(1, -60, 0, 10)
LogoButton.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
LogoButton.BackgroundTransparency = 0.3
LogoButton.BorderSizePixel = 0
LogoButton.ZIndex = 100

-- Arredondar botão
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = LogoButton

-- Remover botão anterior se existir
if game:GetService("CoreGui"):FindFirstChild("NightHubToggle") then
    game:GetService("CoreGui").NightHubToggle:Destroy()
end

LogoButton.Parent = game:GetService("CoreGui")

-- Função para toggle suave
local function ToggleGUI()
    GuiVisible = not GuiVisible
    
    if mainFrame then
        mainFrame.Visible = GuiVisible
    end
    
    -- Feedback visual no botão
    if GuiVisible then
        LogoButton.BackgroundTransparency = 0.3
        LogoButton.ImageTransparency = 0
    else
        LogoButton.BackgroundTransparency = 0.1
        LogoButton.ImageTransparency = 0.3
    end
end

-- Conectar clique
LogoButton.MouseButton1Click:Connect(ToggleGUI)

-- Efeitos hover profissionais
LogoButton.MouseEnter:Connect(function()
    game:GetService("TweenService"):Create(LogoButton, TweenInfo.new(0.2), {
        Size = UDim2.new(0, 55, 0, 55),
        BackgroundTransparency = 0.2
    }):Play()
end)

LogoButton.MouseLeave:Connect(function()
    game:GetService("TweenService"):Create(LogoButton, TweenInfo.new(0.2), {
        Size = UDim2.new(0, 50, 0, 50),
        BackgroundTransparency = GuiVisible and 0.3 or 0.1
    }):Play()
end)

-- Abas (conteúdo normal)
local Tabs = {
    Main = Window:AddTab({Title = "Principal", Icon = "home"}),
    Player = Window:AddTab({Title = "Jogador", Icon = "user"})
}

Tabs.Main:AddParagraph({
    Title = "🌙 Night Hub",
    Content = "Use a logo para abrir/fechar o menu"
})

Tabs.Main:AddToggle("AutoFarm", {
    Title = "Coleta Automática",
    Default = false,
    Callback = function(Value)
        Fluent:Notify({
            Title = "Night Hub",
            Content = Value and "Farm ativado!" or "Farm desativado!",
            Duration = 2
        })
    end
})

Tabs.Player:AddSlider("WalkSpeed", {
    Title = "Velocidade",
    Default = 16,
    Min = 16,
    Max = 100,
    Callback = function(Value)
        local char = game.Players.LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.WalkSpeed = Value
        end
    end
})

-- Fechar completamente
Tabs.Main:AddButton({
    Title = "Fechar Hub",
    Callback = function()
        Window:Destroy()
        if game:GetService("CoreGui"):FindFirstChild("NightHubToggle") then
            game:GetService("CoreGui").NightHubToggle:Destroy()
        end
        Fluent:Notify({
            Title = "Night Hub",
            Content = "Hub fechado!",
            Duration = 3
        })
    end
})

-- Notificação inicial
Fluent:Notify({
    Title = "✅ Night Hub",
    Content = "Clique na logo para toggle!",
    Duration = 4
})

Window:SelectTab(1)
