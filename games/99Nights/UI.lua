--[[
    Night Hub - Interface Estilo MaruHub
--]]

-- Carregar Fluent UI
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

-- Criar interface principal
local Window = Fluent:CreateWindow({
    Title = "Night Hub",
    SubTitle = "99 Nights in the Forest",
    TabWidth = 160,
    Size = UDim2.fromOffset(500, 400),
    Acrylic = true,
    Theme = "Dark"
})

-- Variáveis de controle
local GuiVisible = true
local LogoUrl = "https://raw.githubusercontent.com/Pixelpv/NightHUB/main/logo.png"

-- Criar botão da logo FLUTUANTE
local LogoButton = Instance.new("ImageButton")
LogoButton.Name = "NightHubToggle"
LogoButton.Image = LogoUrl
LogoButton.Size = UDim2.new(0, 50, 0, 50)
LogoButton.Position = UDim2.new(0, 20, 0, 20) -- Canto superior esquerdo
LogoButton.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
LogoButton.BackgroundTransparency = 0.3
LogoButton.BorderSizePixel = 0
LogoButton.ZIndex = 1000

-- Deixar a logo redonda
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(1, 0)
UICorner.Parent = LogoButton

-- Remover se já existir
if game:GetService("CoreGui"):FindFirstChild("NightHubToggle") then
    game:GetService("CoreGui").NightHubToggle:Destroy()
end

LogoButton.Parent = game:GetService("CoreGui")

-- Função para toggle da interface
local function ToggleInterface()
    GuiVisible = not GuiVisible
    local mainFrame = Window:GetParent()
    
    if mainFrame then
        mainFrame.Visible = GuiVisible
        if GuiVisible then
            LogoButton.BackgroundTransparency = 0.3
            LogoButton.ImageTransparency = 0
        else
            LogoButton.BackgroundTransparency = 0.1
            LogoButton.ImageTransparency = 0.3
        end
    end
end

-- Conectar clique do botão
LogoButton.MouseButton1Click:Connect(ToggleInterface)

-- Efeitos de hover
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

-- Abas principais
local Tabs = {
    Main = Window:AddTab({Title = "🏠 Principal", Icon = ""}),
    Farm = Window:AddTab({Title = "⚡ Farm", Icon = ""}),
    Player = Window:AddTab({Title = "👤 Jogador", Icon = ""}),
    Settings = Window:AddTab({Title = "⚙️ Config", Icon = ""})
}

-- ABA PRINCIPAL
Tabs.Main:AddParagraph({
    Title = "🌙 NIGHT HUB",
    Content = "by ntzinho • v1.0"
})

Tabs.Main:AddToggle("AutoCollect", {
    Title = "Coleta Automática",
    Default = false,
    Callback = function(Value)
        Fluent:Notify({
            Title = "Sistema",
            Content = Value and "Coleta automática ativada!" or "Coleta automática desativada!",
            Duration = 3
        })
    end
})

Tabs.Main:AddToggle("AutoAvoid", {
    Title = "Evitar Inimigos",
    Default = false,
    Callback = function(Value)
        Fluent:Notify({
            Title = "Sistema",
            Content = Value and "Evasão ativada!" or "Evasão desativada!",
            Duration = 3
        })
    end
})

-- ABA FARM
Tabs.Farm:AddParagraph({
    Title = "⚡ Sistema de Farm",
    Content = "Configurações automáticas"
})

Tabs.Farm:AddToggle("NightFarm", {
    Title = "Farm Noturno",
    Default = false,
    Callback = function(Value)
        Fluent:Notify({
            Title = "Farm",
            Content = Value and "Farm noturno ativado!" or "Farm noturno desativado!",
            Duration = 3
        })
    end
})

-- ABA JOGADOR
Tabs.Player:AddSlider("WalkSpeed", {
    Title = "Velocidade",
    Description = "Velocidade de movimento",
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

Tabs.Player:AddSlider("JumpPower", {
    Title = "Pulo",
    Description = "Força do pulo",
    Default = 50,
    Min = 50,
    Max = 150,
    Callback = function(Value)
        local char = game.Players.LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.JumpPower = Value
        end
    end
})

-- ABA CONFIG
Tabs.Settings:AddParagraph({
    Title = "⚙️ Configurações",
    Content = "Personalize o Night Hub"
})

Tabs.Settings:AddButton({
    Title = "Recarregar Interface",
    Description = "Recarrega o menu",
    Callback = function()
        Window:Destroy()
        LogoButton:Destroy()
        Fluent:Notify({
            Title = "Sistema",
            Content = "Recarregando interface...",
            Duration = 3
        })
        task.wait(2)
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Pixelpv/NightHUB/main/main.lua"))()
    end
})

Tabs.Settings:AddButton({
    Title = "Fechar Interface",
    Description = "Fecha completamente",
    Callback = function()
        Window:Destroy()
        LogoButton:Destroy()
        Fluent:Notify({
            Title = "Sistema",
            Content = "Interface fechada!",
            Duration = 3
        })
    end
})

-- Notificação inicial
Fluent:Notify({
    Title = "🌙 NIGHT HUB",
    Content = "Interface carregada com sucesso!",
    Duration = 5
})

-- Selecionar primeira aba
Window:SelectTab(1)

print("Night Hub - Interface estilo MaruHub carregada!")
