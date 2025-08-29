-- loader.lua (modificado)
local gamePlaceId = game.PlaceId

print("[NightHub] ID do jogo:", gamePlaceId)

-- IDs suportados
local supportedGames = {
    [7326934954] = true, -- Secundário
    [79546208627805] = true -- Padrão
}

print("[NightHub] Suporte ao jogo:", supportedGames[gamePlaceId])

-- Carregamento dinâmico
if supportedGames[gamePlaceId] then
    -- Carrega FluentUI primeiro
    local success, Fluent = pcall(function()
        return loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
    end)
    
    print("[NightHub] Status FluentUI:", success and "OK" or "ERRO")
    
    if not success then
        warn("[NightHub] Erro ao carregar FluentUI:", Fluent)
        return
    end
    
    Fluent:Initialize()
    Fluent:Notify({
        Title = "Night Hub",
        Content = "Carregando interface...",
        Duration = 3
    })
    
    -- Espera o FluentUI terminar de inicializar
    repeat task.wait() until Fluent.Initialized
    print("[NightHub] FluentUI inicializado")
    
    -- Continuação normal...
else
    warn("[NightHub] Jogo não suportado!")
end
