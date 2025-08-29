-- loader.lua
local gamePlaceId = game.PlaceId

-- IDs suportados
local supportedGames = {
    [7326934954] = true, -- Secundário
    [79546208627805] = true -- Padrão
}

-- Carregamento dinâmico
if supportedGames[gamePlaceId] then
    local gameFolder = "games/99Nights/"
    
    -- Carrega UI
    local uiModule = safeLoad(gameFolder.."UI.lua")
    if uiModule then
        uiModule.Init()
    end
    
    -- Carrega funções
    local funcModule = safeLoad(gameFolder.."Functions.lua")
    if funcModule then
        funcModule.Setup()
    end
else
    warn("[NightHub] Jogo não suportado!")
end

-- Proteção anti-ban
coroutine.wrap(function()
    while getgenv().AntiReset.Enabled do
        wait(getgenv().AntiReset.BackupInterval)
        -- Lógica de backup aqui
    end
end)()
