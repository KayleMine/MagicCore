local addonName, _A, MagicCore = ...
MagicCore.Support = MagicCore.Support or {}
local Support = MagicCore.Support

MagicCore.CEnum = {
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

Support.iknow = function(spellID)
	--local isKnown = IsPlayerSpell(spellID, isPetSpell)
    local IsSpellKnown = IsSpellKnown(spellID, isPetSpell)
    --local talent = DBM_Affliction.rotation.allTalents[spellID]
    --local isTalentActive = talent and talent.active or false

    if IsSpellKnown --[[or isKnown or isTalentActive]] then
        return true 
    else 
        return false 
    end
end