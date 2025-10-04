local addonName, _A, MagicCore = ...

local powerType = { }

local function runes_actual()
  local runes_ready = 0.0
  for i = 1, 6 do
    local start, duration, runeReady = GetRuneCooldown(i)
    local percent = start == 0 and 1.0 or (1 - (((start + duration) - GetTime()) / duration) * 1)
    runes_ready = runes_ready + percent
  end
  return math.floor(runes_ready)
end

function powerType:actual()
local actual;

if self.type ~= 5 then
  actual = UnitPower(self.unitID, self.type)
end
if self.type == 5 then
  actual = runes_actual()
end

  return actual or 0
end

function powerType:max()
	local max = 0;
	if self.type ~= 5 then
	  max = UnitPowerMax(self.unitID, self.type)
	end
	if self.type == 5 then
	  max = 6
	end
  return max or 0
end

function powerType:deficit()
  local deficit = self.max - self.actual
  return deficit or 0
end

function powerType:deficitpercent()
  local deficitpercent = (self.deficit / self.max) * 100
  return deficitpercent or 0
end

function powerType:percent()
  local percent = (self.actual / self.max) * 100
  return percent or 0
end

function powerType:regen()
  local regen = select(2, GetPowerRegen())
  return regen or 0
end

function powerType:predict()
  local ina, act = GetPowerRegen()
  local predict = (self.actual + (act))
  return predict or 0
end

function powerType:predictpercent()
  local ina, act = GetPowerRegen()
  local predictpercent = ((self.actual + (act)) / self.max) * 100
  return predictpercent or 0
end

function powerType:regenpercent()
  local regenpercent = (self.regen / self.max) * 100
  return regenpercent or 0
end

function powerType:tomax()
  local tomax = self.deficit / GetPowerRegen()
  return tomax or 0
end

function MagicCore.powerType(unit, power_type, power_type_name)
  return setmetatable({
    unitID = unit.unitID,
    type = power_type,
    type_name = power_type_name
  }, {
    __index = function(t, k)
      if powerType[k] then
        local result = powerType[k](t)
        return result
      end
    end,
    __unm = function(t)
        local result = powerType['actual'](t)
        return result
    end
  })
end
