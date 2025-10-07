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

cast.cast_mouse = function(spellID, unit, forceID)
	local bad_fix = spellID;
	
	if not forceID then
		bad_fix = C_Spell.GetSpellName(spellID)
	end
	local mX, mY = _A.GetCursorPosition()
	local collision, x, y, z = _A.ScreenToWorld(mX, mY)
	local px, py, pz = _A.ObjectPosition("player")
	local distance = _A.GetDistanceBetweenPositions(x, y, z, px, py, pz)
	if not collision or distance > 45 or not _A.IsForeground() then return end
	if SpellIsTargeting() then
		_A.ClickPosition(x, y, z)
	end
	_A.Cast(bad_fix)
end
