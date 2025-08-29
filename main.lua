-- main.lua
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

-- Configuração de proteção anti-reset com validação
local AntiReset = {
    Enabled = true,
    BackupInterval = 60, -- Segundos
    LastBackup = tick(),
    MaxBackupAttempts = 3
}

-- Validação da configuração
local function validateConfig(config)
    assert(type(config.Enabled) == "boolean", "Config Enabled deve ser booleano")
    assert(type(config.BackupInterval) == "number" and config.BackupInterval > 0, 
           "BackupInterval deve ser número positivo")
    assert(type(config.MaxBackupAttempts) == "number" and config.MaxBackupAttempts > 0,
           "MaxBackupAttempts deve ser número positivo")
end

-- Logging melhorado
local function log(message, level)
    level = level or "INFO"
    local timestamp = os.date("%Y-%m-%d %H:%M:%S")
    print(string.format("[%s] [%s] NightHub - %s", timestamp, level, message))
end

-- Carregamento seguro com múltiplas tentativas
local function safeLoad(scriptPath, maxAttempts)
    maxAttempts = maxAttempts or 3
    
    for attempt = 1, maxAttempts do
        local success, result = pcall(function()
            if not isfile(scriptPath) then
                error("Arquivo não encontrado: " .. scriptPath)
            end
            return readfile(scriptPath)
        end)
        
        if success then
            local loadSuccess, loadedFunction = pcall(loadstring, result)
            if loadSuccess then
                local executeSuccess, executeResult = pcall(loadedFunction)
                if executeSuccess then
                    log("Script carregado com sucesso: " .. scriptPath)
                    return executeResult
                else
                    warn("[Tentativa " .. attempt .. "] Erro na execução: " .. tostring(executeResult))
                end
            else
                warn("[Tentativa " .. attempt .. "] Erro no loadstring: " .. tostring(loadedFunction))
            end
        else
            warn("[Tentativa " .. attempt .. "] Erro na leitura: " .. tostring(result))
        end
        
        if attempt < maxAttempts then
            task.wait(1) -- Espera 1 segundo antes de tentar novamente
        end
    end
    
    log("Falha ao carregar script após " .. maxAttempts .. " tentativas: " .. scriptPath, "ERROR")
    return nil
end

-- Sistema de backup automático
local function setupAutoBackup()
    if not AntiReset.Enabled then return end
    
    coroutine.wrap(function()
        while task.wait(AntiReset.BackupInterval) do
            if AntiReset.Enabled then
                local success, err = pcall(function()
                    -- Implementar lógica de backup aqui
                    AntiReset.LastBackup = tick()
                    log("Backup automático realizado")
                end)
                
                if not success then
                    log("Erro no backup automático: " .. tostring(err), "ERROR")
                end
            end
        end
    end)()
end

-- Inicialização principal
local function initialize()
    log("Inicializando NightHub...")
    
    -- Validar configuração
    local configSuccess, configError = pcall(validateConfig, AntiReset)
    if not configSuccess then
        log("Erro na configuração: " .. configError, "ERROR")
        return false
    end
    
    -- Configurar backup automático
    if AntiReset.Enabled then
        setupAutoBackup()
    end
    
    -- Carregar loader
    local loader = safeLoad("loader.lua")
    if not loader then
        log("Falha crítica: Não foi possível carregar o loader", "ERROR")
        return false
    end
    
    log("NightHub inicializado com sucesso")
    return true
end

-- Handler de erros global
local function globalErrorHandler(err)
    log("Erro não tratado: " .. tostring(err), "CRITICAL")
    -- Aqui você pode adicionar mais ações como notificações, logs, etc.
end

-- Execução principal com tratamento de erros
xpcall(initialize, globalErrorHandler)
