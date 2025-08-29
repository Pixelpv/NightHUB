-- main.lua
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

-- Proteção anti-reset
getgenv().AntiReset = {
    Enabled = true,
    BackupInterval = 60, -- Segundos
    LastBackup = tick()
}

-- Carregamento seguro
local function safeLoad(scriptPath)
    local success, result = pcall(function()
        return readfile(scriptPath)
    end)
    
    if success and result then
        return loadstring(result)()
    else
        warn("[NightHub] Falha ao carregar:", scriptPath)
        return nil
    end
end

-- Inicialização
safeLoad("loader.lua")
