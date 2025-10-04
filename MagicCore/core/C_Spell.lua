local addonName, _A, MagicCore = ...
MagicCore.C_Spell = MagicCore.C_Spell or {}
local C_Spell = MagicCore.C_Spell

C_Spell.GetSpellCooldown = function(spell)
    local start, duration, enabled, modRate = GetSpellCooldown(spell)
    
    local _table = {
        startTime = start,
        duration = duration,
        isEnabled = enabled,
        modRate = modRate
    }
    return _table
end

C_Spell.GetSpellTexture = function(spell)
    local A, B = GetSpellTexture(spell)
    return A, B
end

C_Spell.GetSpellName = function(spell)
    local name = GetSpellInfo(spell)
    return name;
end

C_Spell.GetSpellInfo = function(spell)
    local name, rank, icon, castTime, minRange, maxRange, spellID, originalIcon = GetSpellInfo(spell)
    local SpellInfo = {
        name = name,
        iconID = icon,
        originalIconID = originalIcon,
        castTime = castTime,
        minRange = minRange,
        maxRange = maxRange,
        spellID = spellID,
        rank = rank
    }
    return SpellInfo
end

