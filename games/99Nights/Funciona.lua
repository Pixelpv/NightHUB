-- Funções específicas para 99 Nights in the Forest

local GameFunctions = {}

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Coletar todos os itens próximos
function GameFunctions.CollectAllItems()
    local character = LocalPlayer.Character
    if not character then return end
    
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end
    
    local items = workspace:FindFirstChild("Items")
    if not items then return end
    
    for _, item in pairs(items:GetChildren()) do
        if item:IsA("BasePart") and (humanoidRootPart.Position - item.Position).Magnitude < 50 then
            firetouchinterest(humanoidRootPart, item, 0)
            firetouchinterest(humanoidRootPart, item, 1)
        end
    end
end

-- Teleport para a base
function GameFunctions.TeleportToBase()
    local character = LocalPlayer.Character
    if not character then return end
    
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end
    
    local base = workspace:FindFirstChild("Base")
    if base and base:FindFirstChild("Part") then
        humanoidRootPart.CFrame = base.Part.CFrame + Vector3.new(0, 5, 0)
    end
end

-- Curar personagem
function GameFunctions.HealCharacter()
    local character = LocalPlayer.Character
    if not character then return end
    
    local humanoid = character:FindFirstChild("Humanoid")
    if humanoid then
        humanoid.Health = humanoid.MaxHealth
    end
end

-- Auto coletar itens
function GameFunctions.AutoCollectItems()
    GameFunctions.CollectAllItems()
end

-- Auto matar inimigos
function GameFunctions.AutoKillEnemies()
    local character = LocalPlayer.Character
    if not character then return end
    
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end
    
    local enemies = workspace:FindFirstChild("Enemies")
    if not enemies then return end
    
    for _, enemy in pairs(enemies:GetChildren()) do
        if enemy:FindFirstChild("Humanoid") and enemy:FindFirstChild("HumanoidRootPart") then
            if (humanoidRootPart.Position - enemy.HumanoidRootPart.Position).Magnitude < 50 then
                enemy.Humanoid.Health = 0
            end
        end
    end
end

return GameFunctions
