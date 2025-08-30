--[[
    Night Hub - 99 Nights in the Forest Functions
    Funções específicas para o jogo
--]]

local Functions = {}

-- Serviços
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Função para coletar itens automaticamente
function Functions.AutoCollect()
    spawn(function()
        while getgenv().AutoCollect do
            local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
            local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
            
            -- Encontrar itens próximos
            for _, item in ipairs(workspace:GetChildren()) do
                if item:FindFirstChild("ClickDetector") and (humanoidRootPart.Position - item.Position).Magnitude < 20 then
                    fireclickdetector(item.ClickDetector)
                    task.wait(0.1)
                end
            end
            task.wait(0.5)
        end
    end)
end

-- Função para evitar inimigos automaticamente
function Functions.AvoidEnemies()
    spawn(function()
        while getgenv().AvoidEnemies do
            local character = LocalPlayer.Character
            if character then
                local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
                if humanoidRootPart then
                    for _, enemy in ipairs(workspace:GetChildren()) do
                        if enemy:FindFirstChild("Humanoid") and enemy:FindFirstChild("HumanoidRootPart") then
                            if (humanoidRootPart.Position - enemy.HumanoidRootPart.Position).Magnitude < 15 then
                                -- Mover para longe do inimigo
                                local direction = (humanoidRootPart.Position - enemy.HumanoidRootPart.Position).Unit
                                humanoidRootPart.CFrame = humanoidRootPart.CFrame + direction * 5
                                break
                            end
                        end
                    end
                end
            end
            task.wait(0.3)
        end
    end)
end

-- Função para teleportar para locais específicos
function Functions.TeleportTo(position)
    local character = LocalPlayer.Character
    if character then
        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
        if humanoidRootPart then
            humanoidRootPart.CFrame = CFrame.new(position)
        end
    end
end

-- Função para coleta noturna automática
function Functions.NightCollect()
    spawn(function()
        while getgenv().NightCollect do
            -- Verificar se é noite no jogo
            local lighting = game:GetService("Lighting")
            if lighting.ClockTime > 18 or lighting.ClockTime < 6 then
                Functions.AutoCollect()
            end
            task.wait(10) -- Verificar a cada 10 segundos
        end
    end)
end

return Functions
