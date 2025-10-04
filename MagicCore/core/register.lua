local addonName, _A, MagicCore = ...
local C_Spell = MagicCore.C_Spell

MagicCore.routines = MagicCore.routines or {}
MagicCore.activeRotation = nil
local env = MagicCore.Environment and MagicCore.Environment.env

function MagicCore.register(cfg)
    if not cfg.name then
        print("|cFFff0000Core:|r Rotation must have unique name")
        return
    end
    if env then
        if cfg.combat and type(cfg.combat) == 'function' then
            setfenv(cfg.combat, env)
        end
        if cfg.resting and type(cfg.resting) == 'function' then
            setfenv(cfg.resting, env)
        end
        if cfg.gcd and type(cfg.gcd) == 'function' then
            setfenv(cfg.gcd, env)
        end
    end

    MagicCore.routines[cfg.name] = cfg
    print("|cFF00ff00Core:|r Registered rotation: " .. cfg.name)
	local data = { id = cfg.name, label = cfg.label or cfg.name, classID = cfg.classID or class_table.None}
	 return data --cfg.name
end


function MagicCore.setActiveRotation(name)
  if MagicCore.activeRotation and MagicCore.activeRotation.name == name then
      return true 
  end
  
  local routine = MagicCore.routines[name]
  if not routine then
    print("|cFFff0000Core:|r Rotation not found: " .. tostring(name))
    return false
  end
  MagicCore.activeRotation = routine
  print("|cFF00ffffCore:|r Active rotation set -> " .. name)
  return true
end

local function GetDynamicInterval()
	local fps = GetFramerate()
	if fps <= 0 then return 5 end -- ты чо творишь ирод
	if fps >= 120 then
		return 0.1
	-- Для FPS от 60 до 119 возвращаем пропорциональное значение между 0.2 и 0.1
	elseif fps >= 60 then
		-- Линейная интерполяция между 60 FPS (0.2) и 120 FPS (0.1)
		local t = (fps - 60) / (120 - 60)
		return 0.2 - (0.1 * t)
	-- Для FPS < 60 увеличиваем интервал на 0.05 каждые 5 FPS
	else
		-- Базовый интервал для 60 FPS
		local baseInterval = 0.2
		-- Сколько раз по 5 FPS мы ушли ниже 60
		local stepsBelow = math.floor((60 - fps) / 5)
		return baseInterval + (stepsBelow * 0.05)
	end
end


local gcd_spell = 61304

local function GetHaste()
    local CR_HASTE_MELEE  = 18
    local CR_HASTE_RANGED = 19
    local CR_HASTE_SPELL  = 20

    local meleeHaste  = GetCombatRating(CR_HASTE_MELEE)
    local rangedHaste = GetCombatRating(CR_HASTE_RANGED)
    local spellHaste  = GetCombatRating(CR_HASTE_SPELL)

    local maxHaste = math.max(meleeHaste, rangedHaste, spellHaste)
    return maxHaste
end


-- CR-Ticker
if not MagicCore.ticker then
  MagicCore.ticker = C_Timer.NewTicker(GetDynamicInterval(), function()
    local routine = MagicCore.activeRotation
    if not routine then return end

    local inCombat = UnitAffectingCombat("player")
	
	local _, _, lagWorld = GetNetStats()
	local ownHaste = GetHaste()
	local elkek = (1.5/((100+ownHaste)/100))+lagWorld 
	
	if gcd_spell  then
	local _table = C_Spell.GetSpellCooldown(gcd_spell)
	local start, duration = _table.startTime,  _table.duration
	local _table = C_Spell.GetSpellCooldown(gcd_spell)
	if not _table then return 0 end
	local time, value = _table.startTime,  _table.duration

	gcd_wait = start > 0 and (duration - (GetTime() - start)) or 0
	end

	if (gcd_wait and gcd_wait > (elkek/1000)) then 
		if routine.gcd then
			return routine.gcd()
		else
			return
		end
	end
	
    if inCombat and routine.combat then
      routine.combat()
    elseif not inCombat and routine.resting then
      routine.resting()
    end

  end)
end
