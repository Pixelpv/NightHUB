-- Night Hub para 99 Nights in the Forest
-- PlaceID: 7326934954 (secundária) | 79546208627805 (padrão)

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("Night Hub | 99 Nights", "DarkTheme")

-- Anti-detection básico
local function SafeCall(callback, errorMsg)
    local success, result = pcall(callback)
    if not success then
        warn("Night Hub: " .. errorMsg .. " - " .. result)
        return nil
    end
    return result
end

-- Serviços
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

-- Main Tab
local MainTab = Window:NewTab("Principal")
local MainSection = MainTab:NewSection("Funções Principais")

MainSection:NewButton("Coletar Itens Próximos", "Coleta todos os itens próximos", function()
    SafeCall(function()
        local character = LocalPlayer.Character
        if not character then return end
        
        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
        if not humanoidRootPart then return end
        
        local items = Workspace:FindFirstChild("Items") or Workspace:FindFirstChild("Resources")
        if not items then 
            Library:Notify("Itens não encontrados!", "Verifique se há uma pasta 'Items' ou 'Resources' no Workspace")
            return 
        end
        
        local collected = 0
        for _, item in pairs(items:GetChildren()) do
            if item:IsA("BasePart") or (item:IsA("Model") and item:FindFirstChildWhichIsA("BasePart")) then
                local itemPart = item:IsA("BasePart") and item or item:FindFirstChildWhichIsA("BasePart")
                if (humanoidRootPart.Position - itemPart.Position).Magnitude < 50 then
                    firetouchinterest(humanoidRootPart, itemPart, 0)
                    firetouchinterest(humanoidRootPart, itemPart, 1)
                    collected = collected + 1
                    task.wait(0.1)
                end
            end
        end
        
        Library:Notify("Coleta concluída!", "Itens coletados: " .. collected)
    end, "Erro ao coletar itens")
end)

MainSection:NewButton("Teleport para Base", "Teleporta para a base do jogo", function()
    SafeCall(function()
        local character = LocalPlayer.Character
        if not character then return end
        
        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
        if not humanoidRootPart then return end
        
        -- Procurar por possíveis bases
        local baseCandidates = {
            Workspace:FindFirstChild("Base"),
            Workspace:FindFirstChild("Spawn"),
            Workspace:FindFirstChild("SpawnPoint"),
            Workspace:FindFirstChild("Home")
        }
        
        local foundBase = nil
        for _, candidate in pairs(baseCandidates) do
            if candidate and candidate:FindFirstChildWhichIsA("BasePart") then
                foundBase = candidate
                break
            end
        end
        
        if foundBase then
            local basePart = foundBase:FindFirstChildWhichIsA("BasePart")
            humanoidRootPart.CFrame = basePart.CFrame + Vector3.new(0, 5, 0)
            Library:Notify("Teleport realizado!", "Teleportado para a base")
        else
            Library:Notify("Base não encontrada!", "Não foi possível encontrar a base no Workspace")
        end
    end, "Erro no teleporte")
end)

MainSection:NewButton("Curar Personagem", "Restaura a saúde do personagem", function()
    SafeCall(function()
        local character = LocalPlayer.Character
        if not character then return end
        
        local humanoid = character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.Health = humanoid.MaxHealth
            Library:Notify("Cura realizada!", "Saúde restaurada: " .. humanoid.Health)
        else
            Library:Notify("Humanoid não encontrado!", "Não foi possível encontrar o Humanoid")
        end
    end, "Erro ao curar personagem")
end)

-- Player Tab
local PlayerTab = Window:NewTab("Jogador")
local PlayerSection = PlayerTab:NewSection("Ajustes do Jogador")

local walkSpeedValue = 16
PlayerSection:NewSlider("Velocidade", "Altera a velocidade de movimento", 100, 16, function(value)
    walkSpeedValue = value
    SafeCall(function()
        local character = LocalPlayer.Character
        if character then
            local humanoid = character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = value
            end
        end
    end, "Erro ao alterar velocidade")
end)

local jumpPowerValue = 50
PlayerSection:NewSlider("Força do Pulo", "Altera a altura do pulo", 200, 50, function(value)
    jumpPowerValue = value
    SafeCall(function()
        local character = LocalPlayer.Character
        if character then
            local humanoid = character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.JumpPower = value
            end
        end
    end, "Erro ao alterar força do pulo")
end)

PlayerSection:NewToggle("Noclip", "Atravessa paredes", function(state)
    _G.Noclip = state
    SafeCall(function()
        local character = LocalPlayer.Character
        if not character then return end
        
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = not state
            end
        end
    end, "Erro ao alternar noclip")
end)

-- Auto Farm Tab
local AutoFarmTab = Window:NewTab("Auto Farm")
local AutoFarmSection = AutoFarmTab:NewSection("Auto Farm")

AutoFarmSection:NewToggle("Auto Coletar Itens", "Coleta automaticamente itens próximos", function(state)
    _G.AutoCollect = state
    
    while _G.AutoCollect do
        SafeCall(function()
            local character = LocalPlayer.Character
            if not character then return end
            
            local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
            if not humanoidRootPart then return end
            
            local items = Workspace:FindFirstChild("Items") or Workspace:FindFirstChild("Resources")
            if not items then return end
            
            for _, item in pairs(items:GetChildren()) do
                if not _G.AutoCollect then break end
                
                if item:IsA("BasePart") or (item:IsA("Model") and item:FindFirstChildWhichIsA("BasePart")) then
                    local itemPart = item:IsA("BasePart") and item or item:FindFirstChildWhichIsA("BasePart")
                    if (humanoidRootPart.Position - itemPart.Position).Magnitude < 50 then
                        firetouchinterest(humanoidRootPart, itemPart, 0)
                        firetouchinterest(humanoidRootPart, itemPart, 1)
                        task.wait(0.2)
                    end
                end
            end
        end, "Erro no auto coletar")
        
        task.wait(1)
    end
end)

AutoFarmSection:NewToggle("Auto Farm Moedas", "Farma moedas automaticamente (se existirem)", function(state)
    _G.AutoFarmCoins = state
    
    while _G.AutoFarmCoins do
        SafeCall(function()
            local character = LocalPlayer.Character
            if not character then return end
            
            local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
            if not humanoidRootPart then return end
            
            -- Procurar por moedas
            local coins = Workspace:FindFirstChild("Coins") or 
                         Workspace:FindFirstChild("Currency") or
                         Workspace:FindFirstChild("Money")
            
            if coins then
                for _, coin in pairs(coins:GetChildren()) do
                    if not _G.AutoFarmCoins then break end
                    
                    if coin:IsA("BasePart") or (coin:IsA("Model") and coin:FindFirstChildWhichIsA("BasePart")) then
                        local coinPart = coin:IsA("BasePart") and coin or coin:FindFirstChildWhichIsA("BasePart")
                        if (humanoidRootPart.Position - coinPart.Position).Magnitude < 50 then
                            firetouchinterest(humanoidRootPart, coinPart, 0)
                            firetouchinterest(humanoidRootPart, coinPart, 1)
                            task.wait(0.2)
                        end
                    end
                end
            end
        end, "Erro no auto farm de moedas")
        
        task.wait(1)
    end
end)

-- Settings Tab
local SettingsTab = Window:NewTab("Configurações")
local SettingsSection = SettingsTab:NewSection("Configurações do Hub")

SettingsSection:NewKeybind("Toggle UI", "Abre/fecha a interface", Enum.KeyCode.RightShift, function()
    Library:ToggleUI()
end)

SettingsSection:NewButton("Destruir UI", "Remove completamente a interface", function()
    Library:Destroy()
end)

SettingsSection:NewButton("Copiar Discord", "Copia o link do Discord para a área de transferência", function()
    setclipboard("https://discord.gg/example")
    Library:Notify("Discord copiado!", "Link do Discord copiado para a área de transferência")
end)

-- Inicialização
Library:Notify("Night Hub Carregado!", "Bem-vindo ao Night Hub para 99 Nights!")
print("Night Hub carregado com sucesso!")

-- Atualizar velocidade e pulo quando o personagem spawnar
LocalPlayer.CharacterAdded:Connect(function(character)
    character:WaitForChild("Humanoid")
    
    SafeCall(function()
        local humanoid = character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = walkSpeedValue
            humanoid.JumpPower = jumpPowerValue
        end
    end, "Erro ao atualizar velocidade/pulo")
end)

-- Loop para manter noclip ativo se estiver ligado
spawn(function()
    while task.wait(0.1) do
        if _G.Noclip then
            SafeCall(function()
                local character = LocalPlayer.Character
                if not character then return end
                
                for _, part in pairs(character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end, "Erro no loop noclip")
        end
    end
end)
