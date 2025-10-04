local addonName, _A, MagicCore = ...
MagicCore.UnitAuras335 = MagicCore.UnitAuras335 or {}
local UnitAuras335 = MagicCore.UnitAuras335

local UNIT_AURA_FIELDS = {
    "name", "rank", "icon", "count", "debuffType", "duration", 
    "expirationTime", "unitCaster", "isStealable", "nameplateShowPersonal"
}

local AURA_MANAGER_OFFSET = 0xB20
local AURA_ARRAY_START    = 0x4
local AURA_ENTRY_SIZE     = 0x30
local AURA_SPELLID_OFFSET = 0x8

function UnitAuras335.GetAuraDataByIndex(unitToken, index, filter)
    local name, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable, nameplateShowPersonal, spellId = UnitAura(unitToken, index, filter)
    if not name then
        return nil
    end
    local result = {}
    result.name = name
    result.rank = rank
    result.icon = icon
    result.count = count
    result.debuffType = debuffType
    result.duration = duration
    result.expirationTime = expirationTime or 0
    result.unitCaster = unitCaster
    result.isStealable = isStealable
    result.nameplateShowPersonal = nameplateShowPersonal
    local unitAddress = _A.ObjectPointer(unitToken)
    
    if unitAddress then
        local auraManagerPtr = _A.ReadMemory("int", unitAddress, AURA_MANAGER_OFFSET)
        if auraManagerPtr and auraManagerPtr > 0 then
            local auraOffset = AURA_ARRAY_START + ((index - 1) * AURA_ENTRY_SIZE)
            local auraEntryPtr = _A.ReadMemory("int", auraManagerPtr, auraOffset)
            if auraEntryPtr and auraEntryPtr > 0 then
                local memorySpellId = _A.ReadMemory("int", auraEntryPtr, AURA_SPELLID_OFFSET)
                if memorySpellId and memorySpellId > 0 then
                    result.spellId = memorySpellId
                end
            end
        end
    end
    result.spellId = result.spellId or spellId or 0
    result.isHelpful = not result.debuffType
    result.isHarmful = not result.isHelpful
    return result
end

function UnitAuras335.ForEachAura(unitToken, filter, func)
    local index = 1
    while true do
        local auraData = UnitAuras335.GetAuraDataByIndex(unitToken, index, filter)
        
        if not auraData then
            break
        end
        
        func(auraData)
        index = index + 1
    end
end