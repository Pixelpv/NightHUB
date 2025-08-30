-- Night Hub Main Interface
-- 99 Nights in the Forest

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- Biblioteca de UI
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/AikaV3rm/UiLib/master/Lib.lua"))()

-- Criar a janela principal
local Window = Library:CreateWindow("Night Hub | 99 Nights", UDim2.new(0, 500, 0, 400))

-- Carregar funções específicas do jogo
local GameFunctions
local success, err = pcall(function()
    GameFunctions = loadstring(game:HttpGet("https://raw.githubusercontent.com/Pixelpv/NightHUB/main/games/99Nights/Functions.lua"))()
end)

if not success then
    warn("[Night Hub] Erro ao carregar funções: " .. err)
    return
end

-- Tabs principais
local MainTab = Window:CreateTab("Principal")
local PlayerTab = Window:CreateTab("Jogador")
local AutoFarmTab = Window:CreateTab("Auto Farm")
local SettingsTab = Window:CreateTab("Configurações")

-- Seção Principal
local MainSection = MainTab:CreateSection("Informações do Jogo")

MainSection:CreateLabel("Versão: 1.0.0")
MainSection:CreateLabel("Jogo: 99 Nights in the Forest")
MainSection:CreateLabel("Status: Online")

-- Seção de Utilidades
local UtilitiesSection = MainTab:CreateSection("Utilidades")

UtilitiesSection:CreateButton("Coletar Todos os Itens", function()
    GameFunctions.CollectAllItems()
end)

UtilitiesSection:CreateButton("Teleport para Base", function()
    GameFunctions.TeleportToBase()
end)

UtilitiesSection:CreateButton("Curar Personagem", function()
    GameFunctions.HealCharacter()
end)

-- Seção do Jogador
local SpeedSection = PlayerTab:CreateSection("Movimento")

local WalkSpeedSlider = SpeedSection:CreateSlider("Velocidade", 16, 100, 16, function(value)
    LocalPlayer.Character:WaitForChild("Humanoid").WalkSpeed = value
end)

local JumpPowerSlider = SpeedSection:CreateSlider("Pulo", 50, 200, 50, function(value)
    LocalPlayer.Character:WaitForChild("Humanoid").JumpPower = value
end)

-- Auto Farm Section
local FarmSection = AutoFarmTab:CreateSection("Auto Farm")

local AutoCollectToggle = FarmSection:CreateToggle("Auto Coletar Itens", false, function(state)
    _G.AutoCollect = state
    while _G.AutoCollect do
        GameFunctions.AutoCollectItems()
        wait(1)
    end
end)

local AutoKillToggle = FarmSection:CreateToggle("Auto Matar Inimigos", false, function(state)
    _G.AutoKill = state
    while _G.AutoKill do
        GameFunctions.AutoKillEnemies()
        wait(2)
    end
end)

-- Configurações
local UISection = SettingsTab:CreateSection("UI Settings")

UISection:CreateKeybind("Toggle UI", Enum.KeyCode.RightShift, function()
    Library:ToggleUI()
end)

UISection:CreateButton("Destruir UI", function()
    Library:Destroy()
end)

UISection:CreateButton("Copiar Discord", function()
    setclipboard("https://discord.gg/nighthub")
end)

-- Inicializar
Library:Init()
print("Night Hub Carregado com Sucesso!")
