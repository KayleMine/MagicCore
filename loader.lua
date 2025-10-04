local addonName, _A, MagicCore = ...
local _G = _A._G
local apepDirectory = _A.GetApepDirectory()
local LOCAL_PATH = apepDirectory .. "\\rotations\\MagicCore\\"
local ROTATIONS_PATH = LOCAL_PATH .. "routines\\"
local ROTATION_GUI = nil; 
local CR_SETTINGS_MENU_NAME = "|cFFFF0000CR Settings|r"
local STATIC_SETTINGS_BUTTON_KEY = "Active_Rotation_Settings_Link"

-- === Вспомогательные функции ===
local _, Class = UnitClass("player");
local currentSpec
local class_table = {
    None = 0,
    WARRIOR = 1,
    PALADIN = 2,
    HUNTER = 3,
    ROGUE = 4,
    PRIEST = 5,
    DEATHKNIGHT = 6,
    SHAMAN = 7,
    MAGE = 8,
    WARLOCK = 9,
    MONK = 10,
    DRUID = 11,
    DEMONHUNTER = 12
}

local coa_class_table = {
    None = 0,
    BARBARIAN = 12,
    WITCHDOCTOR = 13,
    DEMONHUNTER = 14, --Felsworn
    WITCHHUNTER = 15,
    STORMBRINGER = 16,
    FLESHWARDEN = 17, --Knight of Xoroth
    GUARDIAN = 18,
    MONK = 19,        -- Templar
    SONOFARUGAL = 20, -- Bloodmage
    RANGER = 21,
    CHRONOMANCER = 22,
    NECROMANCER = 23,
    PYROMANCER = 24,
    CULTIST = 25,
    STARCALLER = 26,
    SUNCLERIC = 27,
    TINKER = 28,
    PROPHET = 29,    -- Venomancer
    REAPER = 30,
    WILDWALKER = 31, -- Primalist
    SPIRITMAGE = 32  -- Runemaster
}

local cid = class_table[Class]
local coaid = coa_class_table[Class]


local function ToggleRotationGUI(routine)
    if not routine or not routine.gui then
        print("|cFFff0000Core:|r Active rotation has no GUI settings.")
        return
    end

    if ROTATION_GUI then
        _A.Interface:hideGUI(ROTATION_GUI)
    end
    
    local gui_cfg = routine.gui_st or {
        title = routine.label or routine.name,
        color = "67E667",
        width = 320,
        height = 420
    }

    -- Создаем уникальный ключ для самого окна, используя формат пользователя
    local gui_key = "settings_" .. routine.name .. "_" .. UnitName('player')

    ROTATION_GUI = _A.Interface:BuildGUI({
        key = gui_key,
        width = gui_cfg.width,
        height = gui_cfg.height,
        title = "|cff00ffffMagicCore: Config|r " .. (routine.label or routine.name),
        config = routine.gui,
    })

end

local menu
local addedSubMenus = {}
local function UpdateSettingsMenu(routine)
    menu = menu or _A.Interface:AddCustomMenu(CR_SETTINGS_MENU_NAME) 

    if not routine or not routine.gui then
        if not addedSubMenus["No settings for that"] then
            _A.Interface:AddCustomSubMenu(menu, "No settings for that", function() end, STATIC_SETTINGS_BUTTON_KEY)
            addedSubMenus["No settings for that"] = true
        end
        return
    end

    local label = gsub(routine.label or routine.name, "|cff%x%x%x%x%x%x", "")
    label = gsub(label, "|r", "")
    
    local buttonText = label .. " - cfg"

if not addedSubMenus[buttonText] then
    local routineRef = routine
    _A.Interface:AddCustomSubMenu(menu, buttonText, function()
        ToggleRotationGUI(routineRef)
    end, STATIC_SETTINGS_BUTTON_KEY)

    addedSubMenus[buttonText] = true
    print("|cFF00ff00Core:|r Updated CR Settings menu: " .. buttonText)
end

end


local function LoadRotation(filePath)
    if not filePath then return false end
    local fullPath = LOCAL_PATH .. filePath
    local content = _A.ReadFile(fullPath)
    if not content then
        print("|cFFff0000Error:|r " .. filePath .. " not found")
        return false, nil
    end
    local func, errorMessage = loadstring(content, "MagicCore_" .. filePath)
    if func then
        local success, rotId, err = pcall(func, addonName, _A, MagicCore)
        if success then
            if type(rotId) == "table" then
                print("|cFF00ff00Core:|r Loaded " .. filePath .. " (ID: " .. rotId.id .. ")")
                return true, rotId
            else
                print("|cFFff8800Warning:|r " .. filePath .. " loaded, but failed to return rotation ID.")
                return true, nil
            end
        else
            print("|cFFff0000Error:|r " .. filePath .. " execution failed\n" .. err)
            return false, nil
        end 
    else
        print("|cFFff0000Error:|r " .. filePath .. " loadstring failed\n" .. errorMessage)
        return false, nil
    end
end
local function LoadCore(filePath)
    if not filePath then return false end
    local fullPath = LOCAL_PATH .. filePath
    local content = _A.ReadFile(fullPath)
    if not content then
        print("|cFFff0000Error:|r " .. filePath .. " not found")
        return false
    end
    local func, errorMessage = loadstring(content, "MagicCore_" .. filePath)
    if func then
        local success, pcallError = pcall(func, addonName, _A, MagicCore)
        if success then
            print("|cFF00ff00Core:|r Loaded " .. filePath)
            return true
        else
            print("|cFFff0000Error:|r " .. filePath .. " execution failed\n" .. pcallError)
            return false
        end 
    else
        print("|cFFff0000Error:|r " .. filePath .. " loadstring failed\n" .. errorMessage)
        return false
    end
end

local function SetActiveRotation(rotId)
    if rotId and MagicCore.setActiveRotation(rotId) then
        print("|cFF00FFFFMagicCore:|r Active rotation set to: |cFFFFD100" .. rotId .. "|r")
        return true
    else
        print("|cFFff0000MagicCore Error:|r Failed to set active rotation or rotation ID not found: " .. (rotId or "nil"))
        return false
    end
end

-- === Инициализация Core ===

-- Загрузка базовых файлов
LoadCore("core\\init.lua")
LoadCore("core\\C_Spell.lua")
LoadCore("core\\Auras.lua")
LoadCore("environment\\unit_around.lua")
LoadCore("environment\\Environment.lua")
LoadCore("core\\register.lua")
LoadCore("Misc\\Listener.lua")
LoadCore("Misc\\storage.lua")
LoadCore("Misc\\support.lua")
LoadCore("environment\\unit.lua")
LoadCore("environment\\health.lua")
LoadCore("environment\\buff.lua")
LoadCore("environment\\debuff.lua")
LoadCore("environment\\powertype.lua")
LoadCore("environment\\power.lua")
LoadCore("environment\\spell.lua")
LoadCore("environment\\cast.lua")
 

-- === Сканирование и Загрузка Ротаций ===
local rotationFiles = _A.GetDirectoryFiles(ROTATIONS_PATH, false)
local rotationOptions = {} 
local defaultRotation = "none"

if rotationFiles and #rotationFiles > 0 then
    for i, file in ipairs(rotationFiles) do
        local success, rotInfo = LoadRotation("routines\\" .. file)
        if success and type(rotInfo) == "table" and rotInfo.id and rotInfo.label then
            local rotationClassID = rotInfo.classID or class_table.None
            if rotationClassID == cid then
                table.insert(rotationOptions, { key = rotInfo.id, text = rotInfo.label }) 
                if defaultRotation == "No Rotations Found" or defaultRotation == "none" then
                    defaultRotation = rotInfo.id
                end
            end
        end
    end
end

-- В конце, если ротаций не найдено, сбросим дефолтное значение
if #rotationOptions == 0 then
    table.insert(rotationOptions, { key = "none", text = "No Rotations Available for " .. Class })
    defaultRotation = "none"
end



-- === GUI ===
local MAGIC_CORE_GUI = nil;
_A.Core:WhenInGame(function()
local MAGIC_CORE_GUI = _A.Interface:BuildGUI({
	key = "MagicCoreGUI_"..UnitName('player'),
	width = 350,
	height = 200,
	title = "|cFF00FFFFMagicCore: Rotation Loader|r",
	config = {
		{ type = 'ruler' },
		{ type = 'header', text = "Rotation Selection", },
		{ type = "spacer", size = 20 },
		{ 
			type = 'Combo', 
			text = 'Active Rotation', 
			key = 'active_rotation', 
			width = 250, 
			default = defaultRotation, 
			list = rotationOptions
		},
		{ type = "spacer", size = 20 },
		{ type = 'text', size = 11, text = 'Note: Rotation files must be in the "routines" folder.'},
		{ type = "spacer", size = 20 },
		{ type = "button", text = "Load", width = 180, height = 20, size = 24, callback = function()
			local initialRotation = _A.Interface:Fetch('MagicCoreGUI_'..UnitName('player'), 'active_rotation', defaultRotation)
				SetActiveRotation(initialRotation)
				local routine = MagicCore.routines[initialRotation]
				UpdateSettingsMenu(routine)
			end },
		}
	})

	function MAGIC_CORE_GUI.F(_, key, default)
		return _A.Interface:Fetch('MagicCoreGUI_'..UnitName('player'), key, default)
	end

   _A.Interface:Add("|cFF00FFFFMagicCore|r", function() MAGIC_CORE_GUI.parent:Show() end)
    MAGIC_CORE_GUI.parent:Hide()
	
	local initialRotation = MAGIC_CORE_GUI:F('active_rotation', defaultRotation)
	if initialRotation and initialRotation ~= "none" then
		MagicCore.setActiveRotation(initialRotation)
		local routine = MagicCore.routines[initialRotation] 
		UpdateSettingsMenu(routine) 
	end
end)
