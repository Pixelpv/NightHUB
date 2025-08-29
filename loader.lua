-- loader.lua
local gamePlaceId = game.PlaceId

-- IDs suportados
local supportedGames = {
    [7326934954] = true, -- Secundário
    [79546208627805] = true -- Padrão
}

-- Carregamento dinâmico
if supportedGames[gamePlaceId] then
    -- Carrega FluentUI primeiro
    local success, Fluent = pcall(function()
        return loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
    end)
    
    if not success then
        warn("[NightHub] Erro ao carregar FluentUI:", Fluent)
        return
    end
    
    -- Inicializa FluentUI
    Fluent:Initialize()
    
    Fluent:Notify({
        Title = "Night Hub",
        Content = "Carregando interface...",
        Duration = 3
    })
    
    -- Espera o FluentUI terminar de inicializar
    repeat task.wait() until Fluent.Initialized
    
    local gameFolder = "games/99Nights/"
    
    -- Carrega UI com Fluent
    local uiModule = safeLoad(gameFolder.."UI.lua")
    if uiModule then
        uiModule.Init(Fluent)
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
