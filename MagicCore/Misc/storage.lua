local addonName, _A, MagicCore = ...
 
if GetLocale() == "ruRU" then
    L_Build = "Билд:"
    L_CreateProfile = "Создаю новый профиль настроек."
    L_LoadedCFG = "Настройки загружены."
    L_ShareExport = "Экспорт профиля"
    L_ShareImport = "Импорт профиля"
    L_ShareSuccess = "Профиль успешно импортирован"
    L_ShareError = "Ошибка импорта профиля"
else
    L_Build = "Build: "
    L_CreateProfile = "Creating settings profile."
    L_LoadedCFG = "Settings loaded."
    L_ShareExport = "Export Profile"
    L_ShareImport = "Import Profile"
    L_ShareSuccess = "Profile imported successfully"
    L_ShareError = "Profile import error"
end

if MagicCore_storage == nil then 
    MagicCore_storage = {}
end

local frame = CreateFrame('Frame')
frame:RegisterEvent('ADDON_LOADED')
frame:SetScript('OnEvent', function(self, event, arg1)
    if event == 'ADDON_LOADED' and arg1 == addonName then
        if MagicCore_storage == nil then
			MagicCore_storage = {}
        end
        MagicCore.settings_ready = true
    end
end)

MagicCore.settings = {}

function MagicCore.settings.store(key, value)
    MagicCore_storage[key] = value
    return true
end

function MagicCore.settings.fetch(key, default)
    local value = MagicCore_storage[key]
    return value == nil and default or value
end

-- function DBM_Affliction.settings.store_toggle(key, value)
    -- if not DBM_Affliction.rotation.current_spec then return end
    -- local active_rotation = DBM_Affliction.settings.fetch('active_rotation_' .. DBM_Affliction.rotation.current_spec, false)
    -- if not active_rotation then return end
    -- local full_key = DBM_Affliction.rotation.active_rotation and (active_rotation .. '_toggle_' .. key) or ('toggle_' .. key)
    -- MagicCore_storage[full_key] = value
    -- return true
-- end

-- function DBM_Affliction.settings.fetch_toggle(key, default)
    -- if not DBM_Affliction.rotation.current_spec then return end
    -- local active_rotation = DBM_Affliction.settings.fetch('active_rotation_' .. DBM_Affliction.rotation.current_spec, false)
    -- if not active_rotation then return end
    -- local full_key = DBM_Affliction.rotation.active_rotation and (active_rotation .. '_toggle_' .. key) or ('toggle_' .. key)
    -- return MagicCore_storage[full_key] or default
-- end
  

MagicCore.tmp = { cache = {} }

function MagicCore.tmp.store(key, value)
    MagicCore.tmp.cache[key] = value
    return true
end

function MagicCore.tmp.fetch(key, default)
    return MagicCore.tmp.cache[key] or default
end

MagicCore.on_ready(function()
    MagicCore.environment.hooks.toggle = function(key, default)
        return MagicCore.settings.fetch_toggle(key, default)
    end
    MagicCore.environment.hooks.storage = function(key, default)
        return MagicCore.settings.fetch(key, default)
    end
end)
