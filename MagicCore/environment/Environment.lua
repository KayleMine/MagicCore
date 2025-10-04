local addonName, _A, MagicCore = ...

MagicCore.Environment = MagicCore.Environment or {}
MagicCore.Environment.Units = MagicCore.Environment.Units or {}
MagicCore.Environment.env = MagicCore.Environment.env or {}

MagicCore.Environment.Prefixes = {
  '^player',
  '^pet',
  '^vehicle',
  '^target',
  '^focus',
  '^mouseover',
  '^none',
  '^npc',
  '^party[1-4]',
  '^raid[1-4]?[0-9]',
  '^boss[1-5]',
  '^arena[1-5]'
}


function MagicCore.Environment.ValidateUnit(unitID)
    if type(unitID) ~= "string" then return false end

    for _, prefix in ipairs(MagicCore.Environment.Prefixes) do
        if string.find(unitID, prefix) then
            return true
        end
    end

    if string.match(unitID, "^0x%x+$") then
        return true
    end
    return false
end



local function CreateVirtualUnit(unitID)
  local obj = {
    id = unitID,
	unitID = unitID,
    pointer = _A.Object(unitID),
	unit_methods = MagicCore.unit, 

    methods = {
      exists = function(self) return self.pointer ~= nil and self.pointer:exists() end,
      refresh = function(self) self.pointer = _A.Object(self.id) end,
    }
  }
  
  obj.health = MagicCore.health(obj)
  obj.buff = MagicCore.buff(obj)
  obj.debuff = MagicCore.debuff(obj)
  obj.powerType = MagicCore.powerType(obj)
  obj.power = MagicCore.power(obj)
  obj.spell = MagicCore.spell(obj)
  obj.C_Spell = MagicCore.C_Spell


  local mt = {
	__index = function(t, k)
		local fn = t.methods[k]
		if type(fn) == "function" then
			return fn(t) 
		end
		local unit_fn = t.unit_methods[k]
		if type(unit_fn) == "function" then
			calledUnit = t
			return unit_fn(t) 
		end
		return rawget(t, k)
	end
  }

  return setmetatable(obj, mt)
end

function MagicCore.Environment.GetUnit(unitID)
  if not MagicCore.Environment.ValidateUnit(unitID) then
    return nil
  end

  if not MagicCore.Environment.Units[unitID] then
    MagicCore.Environment.Units[unitID] = CreateVirtualUnit(unitID)
  else
    MagicCore.Environment.Units[unitID].pointer = _A.Object(unitID)
  end

  return MagicCore.Environment.Units[unitID]
end

local _G = _G
setmetatable(MagicCore.Environment.env, {
  __index = function(t, k)
    if MagicCore.Environment.ValidateUnit(k) then
      return MagicCore.Environment.GetUnit(k)
    end

	if MagicCore.cast and MagicCore.cast[k] then
		return MagicCore.cast[k]
	end
	
	if MagicCore.unit_around and MagicCore.unit_around[k] then
		return MagicCore.unit_around[k]
	end

    local player = MagicCore.Environment.GetUnit("player")
    if player and player[k] ~= nil then
      return player[k]
    end
    return _G[k]
  end
})
