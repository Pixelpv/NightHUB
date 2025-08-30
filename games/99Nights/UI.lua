-- UI específica para 99 Nights (opcional - pode ser integrada no main.lua)

local NightUI = {}

function NightUI.CreateGameSpecificUI(parent)
    local section = parent:CreateSection("99 Nights Específico")
    
    section:CreateButton("Farm de Madeira", function()
        -- Implementar farm específico
    end)
    
    section:CreateButton("Farm de Pedra", function()
        -- Implementar farm específico
    end)
    
    section:CreateButton("Craft Automático", function()
        -- Implementar craft automático
    end)
end

return NightUI
