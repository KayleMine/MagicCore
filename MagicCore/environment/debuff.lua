local addonName, _A, MagicCore = ...
local debuff = { }

local function UB(unit, spellID, filter) 
    local spellName = GetSpellInfo(spellID)
	if filter == nil then
        return UnitDebuff(unit, spellName)
    else
		--local buff, rank, icon, count, debuffType, duration, expires, caster, isStealable, shouldConsolidate, id = UnitDebuff(unit, spellName, nil, filter)
		return UnitDebuff(unit, spellName, nil, filter)
    end
end

function debuff:exists()
  local buff, rank, icon, count, debuffType, duration, expires, caster, isStealable, shouldConsolidate, id = UB(self.unitID, self.spell, 'any')
  if id == self.spell and (not self.casterCheck and (caster == 'player' or caster == 'pet')) then
    return true
  end
  return false
end

local lastSeenCache = {}

function debuff:seen()
  local key = self.unitID .. "_" .. tostring(self.spell)
  local buff, rank, icon, count, debuffType, duration, expires, caster, isStealable, shouldConsolidate, id = UB(self.unitID, self.spell, 'any')
  if buffName and id == self.spell then
    lastSeenCache[key] = GetTime()
    return 0
  elseif lastSeenCache[key] then
    return GetTime() - lastSeenCache[key]
  else
    return 9999
  end
end

function debuff:down()
  return not self.exists
end

function debuff:up()
  return self.exists
end

function debuff:any()
  local buff, rank, icon, count, debuffType, duration, expires, caster, isStealable, shouldConsolidate, id = UB(self.unitID, self.spell, 'any')
  if buff then
    return true
  end
  return false
end

function debuff:count()
  local buff, rank, icon, count, debuffType, duration, expires, caster, isStealable, shouldConsolidate, id  = UB(self.unitID, self.spell, 'any')
  if id == self.spell and (not self.casterCheck and (caster == 'player' or caster == 'pet')) then
    return count
  end
  return 0
end

function debuff:remains()
  local buff, rank, icon, count, debuffType, duration, expires, caster, isStealable, shouldConsolidate, id = UB(self.unitID, self.spell, 'any')
  if id == self.spell and (not self.casterCheck and (caster == 'player' or caster == 'pet')) then
    return expires - GetTime()
  end
  return 0
end

function debuff:duration()
  local buff, rank, icon, count, debuffType, duration, expires, caster, isStealable, shouldConsolidate, id = UB(self.unitID, self.spell, 'any')
  if buff and (not self.casterCheck and (caster == 'player' or caster == 'pet')) then
    return duration
  end
  return 0
end

function debuff:stealable()
  local buff, rank, icon, count, debuffType, duration, expires, caster, isStealable, shouldConsolidate, id = UB(self.unitID, self.spell, 'any')
  if stealable then
    return true
  end
  return false
end
 
function debuff:rank()
  local buff, rank, icon, count, debuffType, duration, expires, caster, isStealable, shouldConsolidate, id = UB(self.unitID, self.spell, 'any')
  if rank then
    return rank
  end
  return 0
end
 
function MagicCore.debuff(unit)
  return setmetatable({
    unitID = unit.unitID
  }, {
    __index = function(t, k)
      local result = debuff[k](t)
      return result
    end,
    __call = function(t, k)
      t.spell = k
      if tonumber(t.spell) then
		t.spell = t.spell;
      end
		if type(bool) == 'boolean' then
		t.casterCheck = bool or false
	  else
		t.casterCheck = false -- uh, retard moment (._.)
	  end
      return t
    end,

    __unm = function(t)
      local result = debuff['exists'](t)
      return debuff['exists'](t)
    end
  })
end
