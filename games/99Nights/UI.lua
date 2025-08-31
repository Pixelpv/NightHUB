--[[
    Night Hub - UI com Logo Correta
--]]

-- Carregar Fluent UI
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Night Hub - 99 Nights",
    SubTitle = "by ntzinho",
    TabWidth = 160,
    Size = UDim2.fromOffset(450, 350),
    Acrylic = true,
    Theme = "Dark"
})

-- Logo do SEU GitHub
local LogoUrl = "https://raw.githubusercontent.com/Pixelpv/NightHUB/main/logo.png"
local GuiVisible = true

task.wait(1) -- Esperar carregamento

local LogoButton = Instance.new("ImageButton")
LogoButton.Name = "NightHubLogoBtn"
LogoButton.Image = LogoUrl
LogoButton.Size = UDim2.new(0, 45, 0, 45)
LogoButton.Position = UDim2.new(1, -55, 0, 5)
LogoButton.BackgroundTransparency = 1
LogoButton.ZIndex = 100

-- Remover botão anterior se existir
if game:GetService("CoreGui"):FindFirstChild("NightHubLogoBtn") then
    game:GetService("CoreGui").NightHubLogoBtn:Destroy()
end

LogoButton.Parent = game:GetService("CoreGui")

-- Verificar se a imagem carregou
spawn(function()
    task.wait(2)
    if LogoButton.Image == LogoUrl then
        -- Se ainda estiver com a URL, significa que não carregou
        LogoButton.Image = "rbxassetid://7072717762" -- Fallback: ícone de lua
    end
end)

-- Função minimizar
LogoButton.MouseButton1Click:Connect(function()
    GuiVisible = not GuiVisible
    local mainFrame = Window:GetParent()
    if mainFrame then
        mainFrame.Visible = GuiVisible
        LogoButton.ImageTransparency = GuiVisible and 0 or 0.6
    end
end)

-- Efeito hover
LogoButton.MouseEnter:Connect(function()
    game:GetService("TweenService"):Create(LogoButton, TweenInfo.new(0.2), {Size = UDim2.new(0, 50, 0, 50)}):Play()
end)

LogoButton.MouseLeave:Connect(function()
    game:GetService("TweenService"):Create(LogoButton, TweenInfo.new(0.2), {Size = UDim2.new(0, 45, 0, 45)}):Play()
end)

-- Abas
local Tabs = {
    Main = Window:AddTab({Title = "Principal", Icon = "home"}),
    Player = Window:AddTab({Title = "Jogador", Icon = "user"})
}

Tabs.Main:AddParagraph({
    Title = "🌙 Night Hub",
    Content = "Clique na logo para minimizar/abrir"
})

Tabs.Main:AddToggle("AutoFarm", {
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

Tabs.Player:AddSlider("Speed", {
    Title = "Velocidade",
    Description = "Velocidade do personagem",
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

Tabs.Player:AddButton({
    Title = "Resetar Velocidade",
    Description = "Volta ao normal",
    Callback = function()
        local char = game.Players.LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.WalkSpeed = 16
            Fluent:Notify({
                Title = "Night Hub",
                Content = "Velocidade resetada!",
                Duration = 2
            })
        end
    end
})

Fluent:Notify({
    Title = "✅ Night Hub",
    Content = "Logo carregada do GitHub!",
    Duration = 4
})

Window:SelectTab(1)
print("Night Hub - Logo do GitHub carregada!")
