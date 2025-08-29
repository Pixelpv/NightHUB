-- games/99Nights/Functions.lua
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")

local Features = {}

-- Sistema de ESP
Features.ESP = {
    Enabled = false,
    Objects = {}
}

function Features.ESP.Toggle(state)
    Features.ESP.Enabled = state or not Features.ESP.Enabled
    
    if Features.ESP.Enabled then
        -- Cria caixas para jogadores
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                local box = Instance.new("BoxHandleAdornment")
                box.Adornee = player.Character
                box.Color3 = Color3.fromRGB(255, 100, 100)
                box.Transparency = 0.5
                box.AlwaysOnTop = true
                box.Parent = Workspace
                
                table.insert(Features.ESP.Objects, box)
            end
        end
    else
        -- Remove todas as caixas
        for _, obj in ipairs(Features.ESP.Objects) do
            obj:Destroy()
        end
        Features.ESP.Objects = {}
    end
end

-- Sistema de Aimbot
Features.Aimbot = {
    Enabled = false,
    Target = nil
}

function Features.Aimbot.Toggle(state)
    Features.Aimbot.Enabled = state or not Features.Aimbot.Enabled
end

-- Sistema de Speed Hack
Features.SpeedHack = {
    Enabled = false,
    Multiplier = 1.5
}

function Features.SpeedHack.SetMultiplier(value)
    Features.SpeedHack.Multiplier = value
end

function Features.SpeedHack.Toggle(state)
    Features.SpeedHack.Enabled = state or not Features.SpeedHack.Enabled
end

-- Hooking seguro
local OriginalWalkSpeed = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") and LocalPlayer.Character.Humanoid.WalkSpeed or 16

runService.Stepped:Connect(function()
    if Features.SpeedHack.Enabled and LocalPlayer.Character then
        LocalPlayer.Character.Humanoid.WalkSpeed = OriginalWalkSpeed * Features.SpeedHack.Multiplier
    end
end)

function Setup()
    -- Configuração inicial
end

return {
    Setup = Setup,
    Features = Features
}
