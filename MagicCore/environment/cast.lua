local addonName, _A, MagicCore = ...
local C_Spell = MagicCore.C_Spell

MagicCore.cast = MagicCore.cast or {}
local cast = MagicCore.cast
 
cast.castable = function(spellID, unit)
    unit = unit or MagicCore.Environment.GetUnit("player")
    return unit.spell(spellID).castable
end

cast.cast = function(spellID, unit, forceID)
    unit = unit or MagicCore.Environment.GetUnit("player")
	local bad_fix = spellID;
	
	if not forceID then
		bad_fix = C_Spell.GetSpellName(spellID)
	end
    return _A.Cast(bad_fix, unit.unitID)
end

cast.cast_ground = function(spellID, unit, forceID)
    unit = unit or MagicCore.Environment.GetUnit("player")
	local bad_fix = spellID;
	
	if not forceID then
		bad_fix = C_Spell.GetSpellName(spellID)
	end
	if unit.moving then
		return _A.CastGroundSpeed(bad_fix, unit.unitID)
	end
    return _A.CastGround(bad_fix, unit.unitID)
end
