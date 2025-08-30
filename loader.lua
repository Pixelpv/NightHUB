-- Night Hub Loader
-- Repository: https://github.com/Pixelpv/NightHUB.git

local NightHub = {
    Version = "1.0.0",
    Author = "Pixelpv",
    Repository = "https://github.com/Pixelpv/NightHUB.git",
    Free = true,
    NoKey = true
}

-- Anti-ban básico
local function AntiBan()
    local originalNamecall
    originalNamecall = hookmetamethod(game, "__namecall", function(self, ...)
        local method = getnamecallmethod()
        local args = {...}
        
        -- Prevenir detecções comuns
        if method == "Kick" or method == "kick" then
            return nil
        end
        
        if method == "Teleport" and tostring(self) == "TeleportService" then
            return nil
        end
        
        return originalNamecall(self, ...)
    end)
end

-- Anti-reset básico
local function AntiReset()
    game:GetService("Players").LocalPlayer.CharacterAdded:Connect(function(character)
        character:WaitForChild("Humanoid").Died:Connect(function()
            wait(2)
            if game:GetService("Players").LocalPlayer.Character then
                game:GetService("Players").LocalPlayer.Character:BreakJoints()
            end
        end)
    end)
end

-- Carregador principal
local function LoadNightHub()
    -- Aplicar proteções
    AntiBan()
    AntiReset()
    
    -- Verificar se o jogo é suportado
    local currentPlaceId = game.PlaceId
    local supportedGames = {
        [7326934954] = true,
        [79546208627805] = true
    }
    
    if not supportedGames[currentPlaceId] then
        warn("[Night Hub] Jogo não suportado: " .. currentPlaceId)
        return
    end
    
    -- Carregar a UI principal
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Pixelpv/NightHUB/main/main.lua"))()
end

-- Inicializar
if not _G.NightHubLoaded then
    _G.NightHubLoaded = true
    LoadNightHub()
end

return NightHub
