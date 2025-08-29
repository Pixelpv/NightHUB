-- games/99Nights/UI.lua
local Fluent = require(script:FindFirstAncestor("Loader").Fluent)

local Window = Fluent:CreateWindow({
    Title = "Night Hub - 99 Nights",
    Subtitle = "By PixelPV",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 400),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

-- Abas
local Tabs = {
    Main = Window:AddTab({ Title = "Combat", Icon = "sword" }),
    Movement = Window:AddTab({ Title = "Movement", Icon = "running" }),
    Visual = Window:AddTab({ Title = "Visual", Icon = "eye" })
}

-- Função para alternar estados
local function ToggleState(toggle, state)
    toggle:Set(state)
end

-- Combat Tab
do
    local section = Tabs.Main:AddSection("Combat Features")
    
    -- ESP Toggle
    local espToggle = section:AddToggle("ESPEnabled", {
        Title = "Player ESP",
        Default = false
    })

    espToggle:OnChanged(function()
        ToggleState(espToggle, espToggle.Value)
    end)

    -- Aimbot Toggle
    local aimbotToggle = section:AddToggle("AimbotEnabled", {
        Title = "Aimbot",
        Default = false
    })

    aimbotToggle:OnChanged(function()
        ToggleState(aimbotToggle, aimbotToggle.Value)
    end)
end

-- Movement Tab
do
    local section = Tabs.Movement:AddSection("Movement Hacks")
    
    -- Speed Slider
    local speedSlider = section:AddSlider("SpeedMultiplier", {
        Title = "Walkspeed",
        Description = "Adjust your movement speed",
        Default = 1.5,
        Minimum = 1,
        Maximum = 5,
        Rounding = 1,
        Compact = false
    })

    speedSlider:OnChanged(function(value)
        -- Aplica velocidade
        if game.Players.LocalPlayer.Character then
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 16 * value
        end
    end)
end

-- Visual Tab
do
    local section = Tabs.Visual:AddSection("Visual Enhancements")
    
    -- Wallhack Toggle
    local wallhackToggle = section:AddToggle("WallhackEnabled", {
        Title = "Wallhack",
        Default = false
    })

    wallhackToggle:OnChanged(function()
        ToggleState(wallhackToggle, wallhackToggle.Value)
    end)
end

-- Função de inicialização
function Init(FluentLib)
    -- Configurações iniciais
    print("[NightHub] Interface carregada com FluentUI")
end

return {Init = Init}
