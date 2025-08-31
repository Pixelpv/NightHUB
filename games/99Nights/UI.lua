--[[
    Night Hub - 99 Nights in the Forest UI
    Improved interface with better error handling and organization
    Version: 2.0
--]]

-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")

-- Load Fluent UI with error handling
local Fluent
local success, err = pcall(function()
    Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
end)

if not success then
    warn("Failed to load Fluent UI: " .. tostring(err))
    return
end

-- Configuration
local CONFIG = {
    TOGGLE_SIZE = {60, 60},
    TOGGLE_SIZE_HOVER = {65, 65},
    TOGGLE_SIZE_SMALL = {50, 50},
    ANIMATION_TIME = 0.3,
    HOVER_TIME = 0.2,
    TOGGLE_IMAGE_ID = "rbxassetid://81425308934092",
    DEFAULT_POSITION = UDim2.new(0, 20, 0.5, -30)
}

-- State variables
local NightHub = {
    isUIOpen = true,
    toggleImage = nil,
    screenGui = nil,
    window = nil,
    tabs = {},
    autoCollectEnabled = false,
    dragging = false
}

-- Utility functions
local function SafeDestroy(instance)
    if instance and instance.Parent then
        pcall(function()
            instance:Destroy()
        end)
    end
end

local function GetWindowTitle()
    local currentPlaceId = game.PlaceId
    if currentPlaceId == 126509999114328 then
        return "Night Hub - Partida Ativa"
    end
    return "Night Hub - 99 Nights in the Forest"
end

local function CreateTween(object, properties, time)
    time = time or CONFIG.ANIMATION_TIME
    local tween = TweenService:Create(object, TweenInfo.new(time), properties)
    tween:Play()
    return tween
end

-- Toggle functionality
local function ToggleUI()
    if not NightHub.window then return end
    
    NightHub.isUIOpen = not NightHub.isUIOpen
    
    pcall(function()
        NightHub.window:GetGui().Enabled = NightHub.isUIOpen
    end)
    
    -- Animate toggle button
    if NightHub.toggleImage then
        local targetSize = NightHub.isUIOpen and 
            UDim2.new(0, CONFIG.TOGGLE_SIZE[1], 0, CONFIG.TOGGLE_SIZE[2]) or
            UDim2.new(0, CONFIG.TOGGLE_SIZE_SMALL[1], 0, CONFIG.TOGGLE_SIZE_SMALL[2])
        
        local targetTransparency = NightHub.isUIOpen and 0 or 0.5
        
        CreateTween(NightHub.toggleImage, {
            ImageTransparency = targetTransparency,
            Size = targetSize
        })
    end
    
    -- Notification
    pcall(function()
        Fluent:Notify({
            Title = "Night Hub",
            Content = NightHub.isUIOpen and "Interface aberta" or "Interface fechada",
            Duration = 2
        })
    end)
end

-- Toggle creation
local function CreateToggleLogo()
    -- Clean up existing toggle
    SafeDestroy(NightHub.toggleImage)
    SafeDestroy(NightHub.screenGui)
    
    -- Create screen gui
    NightHub.screenGui = Instance.new("ScreenGui")
    NightHub.screenGui.Name = "NightHubToggleGui"
    NightHub.screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    NightHub.screenGui.ResetOnSpawn = false
    
    -- Create toggle button
    NightHub.toggleImage = Instance.new("ImageButton")
    NightHub.toggleImage.Name = "NightHubToggle"
    NightHub.toggleImage.Image = CONFIG.TOGGLE_IMAGE_ID
    NightHub.toggleImage.ImageTransparency = 0
    NightHub.toggleImage.BackgroundTransparency = 1
    NightHub.toggleImage.Size = UDim2.new(0, CONFIG.TOGGLE_SIZE[1], 0, CONFIG.TOGGLE_SIZE[2])
    NightHub.toggleImage.Position = CONFIG.DEFAULT_POSITION
    NightHub.toggleImage.ZIndex = 1000
    NightHub.toggleImage.Active = true
    NightHub.toggleImage.Selectable = true
    NightHub.toggleImage.Visible = true
    NightHub.toggleImage.Parent = NightHub.screenGui
    
    -- Hover effects
    NightHub.toggleImage.MouseEnter:Connect(function()
        if not NightHub.dragging then
            CreateTween(NightHub.toggleImage, {
                Size = UDim2.new(0, CONFIG.TOGGLE_SIZE_HOVER[1], 0, CONFIG.TOGGLE_SIZE_HOVER[2])
            }, CONFIG.HOVER_TIME)
        end
    end)
    
    NightHub.toggleImage.MouseLeave:Connect(function()
        if not NightHub.dragging then
            local targetSize = NightHub.isUIOpen and 
                UDim2.new(0, CONFIG.TOGGLE_SIZE[1], 0, CONFIG.TOGGLE_SIZE[2]) or
                UDim2.new(0, CONFIG.TOGGLE_SIZE_SMALL[1], 0, CONFIG.TOGGLE_SIZE_SMALL[2])
            CreateTween(NightHub.toggleImage, {Size = targetSize}, CONFIG.HOVER_TIME)
        end
    end)
    
    -- Click handler
    NightHub.toggleImage.MouseButton1Click:Connect(function()
        if not NightHub.dragging then
            ToggleUI()
        end
    end)
    
    -- Add to CoreGui
    pcall(function()
        NightHub.screenGui.Parent = CoreGui
    end)
    
    return NightHub.toggleImage
end

-- Drag functionality
local function SetupDragFunctionality()
    if not NightHub.toggleImage then return end
    
    local dragInput, dragStart, startPos
    
    NightHub.toggleImage.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or 
           input.UserInputType == Enum.UserInputType.Touch then
            NightHub.dragging = true
            dragStart = input.Position
            startPos = NightHub.toggleImage.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    NightHub.dragging = false
                end
            end)
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if NightHub.dragging and NightHub.toggleImage and 
           (input.UserInputType == Enum.UserInputType.MouseMovement or 
            input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            NightHub.toggleImage.Position = UDim2.new(
                startPos.X.Scale, 
                startPos.X.Offset + delta.X, 
                startPos.Y.Scale, 
                startPos.Y.Offset + delta.Y
            )
        end
    end)
end

-- Auto-collect functionality
local function ToggleAutoCollect(enabled)
    NightHub.autoCollectEnabled = enabled
    
    if enabled then
        -- Implement auto-collect logic here
        spawn(function()
            while NightHub.autoCollectEnabled and task.wait(1) do
                -- Auto-collect items logic would go here
                -- This is a placeholder for the actual implementation
            end
        end)
    end
end

-- Create main window
local function CreateMainWindow()
    NightHub.window = Fluent:CreateWindow({
        Title = GetWindowTitle(),
        SubTitle = "by ntzinho",
        TabWidth = 160,
        Size = UDim2.fromOffset(500, 400),
        Acrylic = true,
        Theme = "Dark"
    })
    
    return NightHub.window
end

-- Setup tabs
local function SetupTabs()
    if not NightHub.window then return end
    
    -- Create tabs
    NightHub.tabs = {
        Main = NightHub.window:AddTab({ Title = "Principal", Icon = "home" }),
        Player = NightHub.window:AddTab({ Title = "Jogador", Icon = "user" }),
        Settings = NightHub.window:AddTab({ Title = "Configurações", Icon = "settings" })
    }
    
    -- MAIN TAB
    NightHub.tabs.Main:AddParagraph({
        Title = "Bem-vindo ao Night Hub",
        Content = "Clique na logo para abrir/fechar o menu! Arraste a logo para movê-la."
    })
    
    NightHub.tabs.Main:AddToggle("AutoCollectToggle", {
        Title = "Coleta Automática",
        Default = false,
        Callback = function(Value)
            ToggleAutoCollect(Value)
            Fluent:Notify({
                Title = "Night Hub",
                Content = Value and "Coleta automática ativada" or "Coleta automática desativada",
                Duration = 3
            })
        end
    })
    
    NightHub.tabs.Main:AddButton({
        Title = "Abrir/Fechar Menu",
        Description = "Alterna a visibilidade do menu",
        Callback = function()
            ToggleUI()
        end
    })
    
    -- PLAYER TAB
    NightHub.tabs.Player:AddSlider("WalkSpeedSlider", {
        Title = "Velocidade de Movimento",
        Description = "Ajusta a velocidade do personagem",
        Default = 16,
        Min = 16,
        Max = 100,
        Rounding = 0,
        Callback = function(Value)
            local player = Players.LocalPlayer
            local character = player and player.Character
            local humanoid = character and character:FindFirstChild("Humanoid")
            
            if humanoid then
                humanoid.WalkSpeed = Value
                Fluent:Notify({
                    Title = "Night Hub",
                    Content = "Velocidade ajustada para: " .. Value,
                    Duration = 2
                })
            else
                Fluent:Notify({
                    Title = "Night Hub",
                    Content = "Personagem não encontrado!",
                    Duration = 3
                })
            end
        end
    })
    
    NightHub.tabs.Player:AddSlider("JumpPowerSlider", {
        Title = "Poder de Pulo",
        Description = "Ajusta o poder de pulo do personagem",
        Default = 50,
        Min = 50,
        Max = 200,
        Rounding = 0,
        Callback = function(Value)
            local player = Players.LocalPlayer
            local character = player and player.Character
            local humanoid = character and character:FindFirstChild("Humanoid")
            
            if humanoid then
                humanoid.JumpPower = Value
                Fluent:Notify({
                    Title = "Night Hub",
                    Content = "Poder de pulo ajustado para: " .. Value,
                    Duration = 2
                })
            end
        end
    })
    
    NightHub.tabs.Player:AddButton({
        Title = "Resetar Stats",
        Description = "Volta aos valores padrão",
        Callback = function()
            local player = Players.LocalPlayer
            local character = player and player.Character
            local humanoid = character and character:FindFirstChild("Humanoid")
            
            if humanoid then
                humanoid.WalkSpeed = 16
                humanoid.JumpPower = 50
                Fluent:Notify({
                    Title = "Night Hub",
                    Content = "Stats resetados para os valores padrão",
                    Duration = 3
                })
            end
        end
    })
    
    -- SETTINGS TAB
    NightHub.tabs.Settings:AddToggle("ToggleVisibility", {
        Title = "Mostrar Botão Toggle",
        Default = true,
        Callback = function(Value)
            if NightHub.toggleImage then
                NightHub.toggleImage.Visible = Value
            end
        end
    })
    
    NightHub.tabs.Settings:AddButton({
        Title = "Resetar Posição do Toggle",
        Description = "Move o botão toggle para a posição padrão",
        Callback = function()
            if NightHub.toggleImage then
                CreateTween(NightHub.toggleImage, {
                    Position = CONFIG.DEFAULT_POSITION
                })
                Fluent:Notify({
                    Title = "Night Hub",
                    Content = "Posição do toggle resetada",
                    Duration = 2
                })
            end
        end
    })
    
    NightHub.tabs.Settings:AddButton({
        Title = "Fechar Interface",
        Description = "Fecha completamente o Night Hub",
        Callback = function()
            Fluent:Notify({
                Title = "Night Hub",
                Content = "Interface será fechada em 3 segundos...",
                Duration = 3
            })
            
            task.wait(3)
            
            -- Clean up
            SafeDestroy(NightHub.window and NightHub.window:GetGui())
            SafeDestroy(NightHub.toggleImage)
            SafeDestroy(NightHub.screenGui)
            
            -- Reset state
            NightHub.window = nil
            NightHub.tabs = {}
            NightHub.toggleImage = nil
            NightHub.screenGui = nil
            NightHub.autoCollectEnabled = false
        end
    })
end

-- Initialize the hub
local function Initialize()
    -- Create main window
    if not CreateMainWindow() then
        warn("Failed to create main window")
        return false
    end
    
    -- Setup tabs
    SetupTabs()
    
    -- Create toggle logo
    CreateToggleLogo()
    
    -- Setup drag functionality
    SetupDragFunctionality()
    
    -- Select first tab
    pcall(function()
        NightHub.window:SelectTab(1)
    end)
    
    -- Success notification
    pcall(function()
        Fluent:Notify({
            Title = "Night Hub",
            Content = "Interface carregada com sucesso! Clique na logo para alternar.",
            Duration = 5
        })
    end)
    
    print("Night Hub - Versão melhorada carregada com sucesso!")
    return true
end

-- Start the hub
if not Initialize() then
    warn("Failed to initialize Night Hub")
else
    -- Export for external access if needed
    _G.NightHub = NightHub
end
