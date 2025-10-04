local addonName, _A, MagicCore = ...
local buff = { }

local function UB(unit, spellID, filter)
    local spellName = GetSpellInfo(spellID)
    if filter == nil then
        return UnitBuff(unit, spellName)
    else
        return UnitBuff(unit, spellName, nil, filter)
    end
end



function buff:exists()
  local buff, rank, icon, count, debuffType, duration, expires, caster, isStealable, shouldConsolidate, id = UB(self.unitID, self.spell, 'any')
  if id == self.spell and (not self.casterCheck and (caster == 'player' or caster == 'pet')) then
    return true
  end
  return false
end

local lastSeenCache = {}

function buff:seen()
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

function buff:down()
  return not self.exists
end

function buff:up()
  return self.exists
end

function buff:any()
  local buff, rank, icon, count, debuffType, duration, expires, caster, isStealable, shouldConsolidate, id = UB(self.unitID, self.spell, 'any')
  if buff then
    return true
  end
  return false
end

function buff:count()
  local buff, rank, icon, count, debuffType, duration, expires, caster, isStealable, shouldConsolidate, id  = UB(self.unitID, self.spell, 'any')
  if id == self.spell and (not self.casterCheck and (caster == 'player' or caster == 'pet')) then
    return count
  end
  return 0
end

function buff:remains()
  local buff, rank, icon, count, debuffType, duration, expires, caster, isStealable, shouldConsolidate, id = UB(self.unitID, self.spell, 'any')
  if id == self.spell and (not self.casterCheck and (caster == 'player' or caster == 'pet')) then
    return expires - GetTime()
  end
  return 0
end

function buff:duration()
  local buff, rank, icon, count, debuffType, duration, expires, caster, isStealable, shouldConsolidate, id = UB(self.unitID, self.spell, 'any')
  if buff and (not self.casterCheck and (caster == 'player' or caster == 'pet')) then
    return duration
  end
  return 0
end

function buff:stealable()
  local buff, rank, icon, count, debuffType, duration, expires, caster, isStealable, shouldConsolidate, id = UB(self.unitID, self.spell, 'any')
  if stealable then
    return true
  end
  return false
end

function MagicCore.buff(unit)
  return setmetatable({
    unitID = unit.unitID
  }, {
    __index = function(self, key)
      if buff[key] and type(buff[key]) == "function" then
        return buff[key](self)
      else
        return rawget(self, key)
      end
    end,
    __call = function(self, arg)
      local id = arg
      self.spell = id
      self.casterCheck = false
      return self
    end,
    __unm = function(t)
      return buff.exists(t)
    end
  })
end

