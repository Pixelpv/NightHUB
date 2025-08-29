-- main.lua
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

-- Proteção anti-reset com validação adicional
local AntiReset = {
    Enabled = true,
    BackupInterval = 60, -- Segundos
    LastBackup = tick(),
    MaxBackupAttempts = 3, -- Tentativas máximas de backup
    BackupPath = "backups/" -- Pasta para backups
}

-- Sistema de logging para melhor debug
local logHistory = {}
local function log(message, level)
    level = level or "INFO"
    local timestamp = os.date("%Y-%m-%d %H:%M:%S")
    local logEntry = string.format("[%s] [%s] %s", timestamp, level, message)
    table.insert(logHistory, logEntry)
    print(logEntry)
    
    -- Manter apenas os últimos 100 logs na memória
    if #logHistory > 100 then
        table.remove(logHistory, 1)
    end
end

-- Verificar se a função readfile existe (depende do ambiente)
local function canReadFiles()
    return type(readfile) == "function"
end

-- Verificar se a função writefile existe
local function canWriteFiles()
    return type(writefile) == "function"
end

-- Verificar se a função makefolder existe
local function canCreateFolders()
    return type(makefolder) == "function"
end

-- Verificar se arquivo existe de forma segura
local function fileExists(path)
    if not canReadFiles() then return false end
    
    local success, exists = pcall(function()
        return isfile(path)
    end)
    
    return success and exists
end

-- Criar diretório se não existir
local function ensureDirectory(path)
    if not canCreateFolders() then return false end
    
    local success, result = pcall(function()
        if not isfolder(path) then
            makefolder(path)
        end
        return true
    end)
    
    return success
end

-- Função de backup melhorada
local function performBackup()
    if not AntiReset.Enabled then return false end
    
    local currentTime = tick()
    if currentTime - AntiReset.LastBackup < AntiReset.BackupInterval then
        return false -- Ainda não é hora de fazer backup
    end
    
    -- Garantir que o diretório de backups existe
    if not ensureDirectory(Antibackup.BackupPath) then
        log("Não foi possível criar diretório de backups", "ERROR")
        return false
    end
    
    local backupName = string.format("%sbackup_%s.json", 
        AntiReset.BackupPath, 
        os.date("%Y%m%d_%H%M%S")
    )
    
    local backupData = {
        timestamp = os.time(),
        playerData = {}, -- Aqui você adicionaria dados relevantes para backup
        logHistory = logHistory
    }
    
    local success, result = pcall(function()
        if canWriteFiles() then
            writefile(backupName, HttpService:JSONEncode(backupData))
            AntiReset.LastBackup = tick()
            log("Backup realizado com sucesso: " .. backupName)
            return true
        else
            error("Função writefile não disponível neste ambiente")
        end
    end)
    
    if not success then
        log("Falha ao realizar backup: " .. tostring(result), "ERROR")
        return false
    end
    
    return true
end

-- Carregamento seguro com múltiplas tentativas
local function safeLoad(scriptPath, maxAttempts)
    maxAttempts = maxAttempts or 3
    
    -- Verificar se o arquivo existe primeiro
    if not fileExists(scriptPath) then
        log("Arquivo não encontrado: " .. scriptPath, "ERROR")
        return nil
    end
    
    for attempt = 1, maxAttempts do
        local success, result = pcall(function()
            local source = readfile(scriptPath)
            local chunk = loadstring(source)
            return chunk()
        end)
        
        if success then
            log("Script carregado com sucesso: " .. scriptPath)
            return result
        else
            log(string.format("Tentativa %d falhou para %s: %s", 
                attempt, scriptPath, tostring(result)), "WARNING")
            
            -- Esperar um pouco antes de tentar novamente
            if attempt < maxAttempts then
                wait(1)
            end
        end
    end
    
    log("Falha ao carregar após " .. maxAttempts .. " tentativas: " .. scriptPath, "ERROR")
    return nil
end

-- Verificação periódica de backup
local function startBackupScheduler()
    spawn(function()
        while true do
            performBackup()
            wait(AntiReset.BackupInterval)
        end
    end)
end

-- Inicialização segura
local function initialize()
    log("Iniciando NightHub...")
    
    -- Verificar se estamos em um ambiente com acesso a arquivos
    if not canReadFiles() then
        log("Ambiente não suporta operações de arquivo", "ERROR")
        return false
    end
    
    -- Iniciar agendador de backups
    if AntiReset.Enabled then
        startBackupScheduler()
        log("Proteção anti-reset ativada")
    end
    
    -- Tentar carregar o loader
    local loader = safeLoad("loader.lua")
    if not loader then
        log("Falha crítica ao carregar loader.lua", "CRITICAL")
        return false
    end
    
    log("NightHub inicializado com sucesso")
    return true
end

-- Handler de erro global para evitar quebras
local function errorHandler(err)
    log("Erro não tratado: " .. tostring(err), "CRITICAL")
    -- Aqui você pode adicionar lógica para recuperação ou notificação
end

-- Inicializar com tratamento de erro
local success, result = xpcall(initialize, errorHandler)
if not success then
    log("Falha na inicialização: " .. tostring(result), "CRITICAL")
end

return {
    AntiReset = AntiReset,
    log = log,
    safeLoad = safeLoad,
    performBackup = performBackup
}
