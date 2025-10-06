local addonName, _A, MagicCore = ...
local C_Spell = MagicCore.C_Spell
local Support = MagicCore.Support

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


local foodlist = {
    [430] = true,	-- Drink
    [431] = true,	-- Drink
    [432] = true,	-- Drink
    [433] = true,	-- Drink
    [1133] = true,  -- Drink
    [1135] = true,  -- Drink
    [1137] = true,  -- Drink
    [10250] = true, -- Drink
    [22734] = true, -- Drink
    [25990] = true, -- Graccus Mince Meat Fruitcake
    [26261] = true, -- Drink
    [27089] = true, -- Drink
    [34291] = true, -- Drink
    [43155] = true, -- Drink
    [43182] = true, -- Drink
    [43183] = true, -- Drink
    [43706] = true, -- Drink
    [46755] = true, -- Drink
    [52911] = true, -- Drink
    [57073] = true, -- Drink
    [58984] = true, -- Shadowmeld
    [61830] = true, -- Drink
    [64356] = true, -- Drink
    [66041] = true, -- Drink
    [72623] = true, -- Drink
}

local function HavingFood()
    local player = _A.Object('player')
	if player then
	    for id, _ in pairs(foodlist) do
	        if player:Buff(id) then
	            return true
	        end
	    end
    end
    return false
end


-- CR-Ticker
if not MagicCore.ticker then
  MagicCore.ticker = C_Timer.NewTicker(GetDynamicInterval(), function()
    local routine = MagicCore.activeRotation
    if not routine then return end
	if IsMounted() == 1 or HavingFood() then return end
	if not Support.toggle("MasterToggle") then return end
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
