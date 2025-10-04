local addonName, _A, MagicCore = ...

MagicCore.cast = MagicCore.cast or {}
local cast = MagicCore.cast
 
cast.castable = function(spellID, unit)
    unit = unit or MagicCore.Environment.GetUnit("player")
    return unit.spell(spellID).castable
end

cast.cast = function(spellID, unit)
    unit = unit or MagicCore.Environment.GetUnit("player")
    return _A.Cast(spellID, unit.unitID)
end

cast.cast_ground = function(spellID, unit)
    unit = unit or MagicCore.Environment.GetUnit("player")
	if unit.moving then
		return _A.CastGroundSpeed(spellID, unit.unitID)
	end
    return _A.CastGround(spellID, unit.unitID)
end
