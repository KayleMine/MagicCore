local addonName, _A, MagicCore = ...
local C_Spell = MagicCore.C_Spell
MagicCore.unit = {}
local unit = MagicCore.unit
local calledUnit;

local dummies = {
-- Misc/Unknown
	[79987]  = "Training Dummy", 	          -- Location Unknown
	[92169]  = "Raider's Training Dummy",     -- Tanking (Eastern Plaguelands)
	[96442]  = "Training Dummy", 			  -- Damage (Location Unknown)
	[109595] = "Training Dummy",              -- Location Unknown
	[113963] = "Raider's Training Dummy", 	  -- Damage (Location Unknown)
	[131985] = "Dungeoneer's Training Dummy", -- Damage (Zuldazar)
	[131990] = "Raider's Training Dummy",     -- Tanking (Zuldazar)
	[132976] = "Training Dummy", 			  -- Morale Booster (Zuldazar)
-- Level 1
	[17578]  = "Hellfire Training Dummy",     -- Lvl 1 (The Shattered Halls)
	[60197]  = "Training Dummy",              -- Lvl 1 (Scarlet Monastery)
	[64446]  = "Training Dummy",              -- Lvl 1 (Scarlet Monastery)
	[144077] = "Training Dummy",              -- Lvl 1 (Dazar'alor) - Morale Booster
-- Level 3
	[44171]  = "Training Dummy",              -- Lvl 3 (New Tinkertown, Dun Morogh)
	[44389]  = "Training Dummy",              -- Lvl 3 (Coldridge Valley)
	[44848]  = "Training Dummy", 			  -- Lvl 3 (Camp Narache, Mulgore)
	[44548]  = "Training Dummy",              -- Lvl 3 (Elwynn Forest)
	[44614]  = "Training Dummy",              -- Lvl 3 (Teldrassil, Shadowglen)
	[44703]  = "Training Dummy", 			  -- Lvl 3 (Ammen Vale)
	[44794]  = "Training Dummy", 			  -- Lvl 3 (Dethknell, Tirisfal Glades)
	[44820]  = "Training Dummy",              -- Lvl 3 (Valley of Trials, Durotar)
	[44937]  = "Training Dummy",              -- Lvl 3 (Eversong Woods, Sunstrider Isle)
	[48304]  = "Training Dummy",              -- Lvl 3 (Kezan)
-- Level 55
	[32541]  = "Initiate's Training Dummy",   -- Lvl 55 (Plaguelands: The Scarlet Enclave)
	[32545]  = "Initiate's Training Dummy",   -- Lvl 55 (Eastern Plaguelands)
-- Level 60
	[32666]  = "Training Dummy",              -- Lvl 60 (Siege of Orgrimmar, Darnassus, Ironforge, ...)
-- Level 65
	[32542]  = "Disciple's Training Dummy",   -- Lvl 65 (Eastern Plaguelands)
-- Level 70
	[32667]  = "Training Dummy",              -- Lvl 70 (Orgrimmar, Darnassus, Silvermoon City, ...)
-- Level 75
	[32543]  = "Veteran's Training Dummy",    -- Lvl 75 (Eastern Plaguelands)
-- Level 80
	[31144]  = "Training Dummy",              -- Lvl 80 (Orgrimmar, Darnassus, Ironforge, ...)
	[32546]  = "Ebon Knight's Training Dummy",-- Lvl 80 (Eastern Plaguelands)
-- Level 85
	[46647]  = "Training Dummy",              -- Lvl 85 (Orgrimmar, Stormwind City)
-- Level 90
	[67127]  = "Training Dummy",              -- Lvl 90 (Vale of Eternal Blossoms)
-- Level 95
	[79414]  = "Training Dummy",              -- Lvl 95 (Broken Shore, Talador)
-- Level 100
	[87317]  = "Training Dummy",              -- Lvl 100 (Lunarfall, Frostwall) - Damage
	[87321]  = "Training Dummy",              -- Lvl 100 (Stormshield) - Healing
	[87760]  = "Training Dummy",              -- Lvl 100 (Frostwall) - Damage
	[88289]  = "Training Dummy",              -- Lvl 100 (Frostwall) - Healing
	[88316]  = "Training Dummy",              -- Lvl 100 (Lunarfall) - Healing
	[88835]  = "Training Dummy",              -- Lvl 100 (Warspear) - Healing
	[88906]  = "Combat Dummy",                -- Lvl 100 (Nagrand)
	[88967]  = "Training Dummy",              -- Lvl 100 (Lunarfall, Frostwall)
	[89078]  = "Training Dummy",              -- Lvl 100 (Frostwall, Lunarfall)
-- Levl 100 - 110
	[92164]  = "Training Dummy", 			  -- Lvl 100 - 110 (Dalaran) - Damage
	[92165]  = "Dungeoneer's Training Dummy", -- Lvl 100 - 110 (Eastern Plaguelands) - Damage
	[92167]  = "Training Dummy",              -- Lvl 100 - 110 (The Maelstrom, Eastern Plaguelands, The Wandering Isle)
	[92168]  = "Dungeoneer's Training Dummy", -- Lvl 100 - 110 (The Wandering Isles, Easter Plaguelands)
	[100440] = "Training Bag", 				  -- Lvl 100 - 110 (The Wandering Isles)
	[100441] = "Dungeoneer's Training Bag",   -- Lvl 100 - 110 (The Wandering Isles)
	[102045] = "Rebellious Wrathguard",       -- Lvl 100 - 110 (Dreadscar Rift) - Dungeoneer
	[102048] = "Rebellious Felguard",         -- Lvl 100 - 110 (Dreadscar Rift)
	[102052] = "Rebellious Imp", 			  -- Lvl 100 - 110 (Dreadscar Rift) - AoE
	[103402] = "Lesser Bulwark Construct",    -- Lvl 100 - 110 (Hall of the Guardian)
	[103404] = "Bulwark Construct",           -- Lvl 100 - 110 (Hall of the Guardian) - Dungeoneer
	[107483] = "Lesser Sparring Partner",     -- Lvl 100 - 110 (Skyhold)
	[107555] = "Bound Void Wraith",           -- Lvl 100 - 110 (Netherlight Temple)
	[107557] = "Training Dummy",              -- Lvl 100 - 110 (Netherlight Temple) - Healing
	[108420] = "Training Dummy",              -- Lvl 100 - 110 (Stormwind City, Durotar)
	[111824] = "Training Dummy", 			  -- Lvl 100 - 110 (Azsuna)
	[113674] = "Imprisoned Centurion",        -- Lvl 100 - 110 (Mardum, the Shattered Abyss) - Dungeoneer
	[113676] = "Imprisoned Weaver", 	      -- Lvl 100 - 110 (Mardum, the Shattered Abyss)
	[113687] = "Imprisoned Imp",              -- Lvl 100 - 110 (Mardum, the Shattered Abyss) - Swarm
	[113858] = "Training Dummy",              -- Lvl 100 - 110 (Trueshot Lodge) - Damage
	[113859] = "Dungeoneer's Training Dummy", -- Lvl 100 - 110 (Trueshot Lodge) - Damage
	[113862] = "Training Dummy",              -- Lvl 100 - 110 (Trueshot Lodge) - Damage
	[113863] = "Dungeoneer's Training Dummy", -- Lvl 100 - 110 (Trueshot Lodge) - Damage
	[113871] = "Bombardier's Training Dummy", -- Lvl 100 - 110 (Trueshot Lodge) - Damage
	[113966] = "Dungeoneer's Training Dummy", -- Lvl 100 - 110 - Damage
	[113967] = "Training Dummy",              -- Lvl 100 - 110 (The Dreamgrove) - Healing
	[114832] = "PvP Training Dummy",          -- Lvl 100 - 110 (Stormwind City)
	[114840] = "PvP Training Dummy",          -- Lvl 100 - 110 (Orgrimmar)
-- Level 102
	[87318]  = "Dungeoneer's Training Dummy", -- Lvl 102 (Lunarfall) - Damage
	[87322]  = "Dungeoneer's Training Dummy", -- Lvl 102 (Stormshield) - Tank
	[87761]  = "Dungeoneer's Training Dummy", -- Lvl 102 (Frostwall) - Damage
	[88288]  = "Dungeoneer's Training Dummy", -- Lvl 102 (Frostwall) - Tank
	[88314]  = "Dungeoneer's Training Dummy", -- Lvl 102 (Lunarfall) - Tank
	[88836]  = "Dungeoneer's Training Dummy", -- Lvl 102 (Warspear) - Tank
	[93828]  = "Training Dummy",              -- Lvl 102 (Hellfire Citadel)
	[97668]  = "Boxer's Trianing Dummy",      -- Lvl 102 (Highmountain)
	[98581]  = "Prepfoot Training Dummy",     -- Lvl 102 (Highmountain)
-- Level 110 - 120
	[126781] = "Training Dummy", 			  -- Lvl 110 - 120 (Boralus) - Damage
	[131989] = "Training Dummy", 			  -- Lvl 110 - 120 (Boralus) - Damage
	[131994] = "Training Dummy", 			  -- Lvl 110 - 120 (Boralus) - Healing
	[144082] = "Training Dummy",              -- Lvl 110 - 120 (Dazar'alor) - PVP Damage
	[144085] = "Training Dummy", 			  -- Lvl 110 - 120 (Dazar'alor) - Damage
	[144081] = "Training Dummy",              -- Lvl 110 - 120 (Dazar'alor) - Damage
	[153285] = "Training Dummy", 			  -- Lvl 110 - 120 (Ogrimmar) - Damage
	[153292] = "Training Dummy", 			  -- Lvl 110 - 120 (Stormwind) - Damage
-- Level 111 - 120
	[131997] = "Training Dummy", 			  -- Lvl 111 - 120 (Boralus, Zuldazar) - PVP Damage
	[131998] = "Training Dummy",              -- Lvl 111 - 120 (Boralus, Zuldazar) - PVP Healing
-- Level 112 - 120
	[144074] = "Training Dummy", 			  -- Lvl 112 - 120 (Dazar'alor) - PVP Healing
-- Level 112 - 122
	[131992] = "Dungeoneer's Training Dummy",  -- Lvl 112 - 122 (Boralus) - Tanking
-- Level 113 - 120
	[132036] = "Training Dummy", 			  -- Lvl 113 - 120 (Boralus) - Healing
-- Level 113 - 122
	[144078] = "Dungeoneer's Training Dummy", -- Lvl 113 - 122 (Dazar'alor) - Tanking
-- Level 114 - 120
	[144075] = "Training Dummy", 			  -- Lvl 114 - 120 (Dazar'alor) - Healing
-- Level 60
	[174569] = "Training Dummy",			  -- Lvl 60 (Ardenweald)
	[174570] = "Swarm Training Dummy",		  -- Lvl 60 (Ardenweald)
	[174571] = "Cleave Training Dummy",		  -- Lvl 60 (Ardenweald)
	[174487] = "Competent Veteran", 		  -- Lvl 60 (Location Unknown)
	[173942] = "Training Dummy",			  -- Lvl 60 (Revendreth)
	[175456] = "Swarm Training Dummy",		  -- Lvl 60 (Revendreth)
	[175455] = "Cleave Training Dummy",		  -- Lvl 60 (Revendreth)
-- Level 62
	[174484] = "Immovable Champion", 		  -- Lvl 62 (Location Unknown)
	[175449] = "Dungeoneer's Training Dummy", -- Lvl 62 (Revendreth)
	[173957] = "Necrolord's Resolve",		  -- Lvl 62 (Oribos)
	[173955] = "Pride's Resolve",		 	  -- Lvl 62 (Oribos)
	[173954] = "Nature's Resolve",		 	  -- Lvl 62 (Oribos)
	[173919] = "Valiant's Resolve",		 	  -- Lvl 62 (Oribos)
-- Level ??
	[24792]  = "Advanced Training Dummy",     -- Lvl ?? Boss (Location Unknown)
	[30527]  = "Training Dummy", 		      -- Lvl ?? Boss (Location Unknown)
	[31146]  = "Raider's Training Dummy",     -- Lvl ?? (Orgrimmar, Stormwind City, Ironforge, ...)
	[87320]  = "Raider's Training Dummy",     -- Lvl ?? (Lunarfall, Stormshield) - Damage
	[87329]  = "Raider's Training Dummy",     -- Lvl ?? (Stormshield) - Tank
	[87762]  = "Raider's Training Dummy",     -- Lvl ?? (Frostwall, Warspear) - Damage
	[88837]  = "Raider's Training Dummy",     -- Lvl ?? (Warspear) - Tank
	[92166]  = "Raider's Training Dummy",     -- Lvl ?? (The Maelstrom, Dalaran, Eastern Plaguelands, ...) - Damage
	[101956] = "Rebellious Fel Lord",         -- lvl ?? (Dreadscar Rift) - Raider
	[103397] = "Greater Bulwark Construct",   -- Lvl ?? (Hall of the Guardian) - Raider
	[107202] = "Reanimated Monstrosity", 	  -- Lvl ?? (Broken Shore) - Raider
	[107484] = "Greater Sparring Partner",    -- Lvl ?? (Skyhold)
	[107556] = "Bound Void Walker",           -- Lvl ?? (Netherlight Temple) - Raider
	[113636] = "Imprisoned Forgefiend",       -- Lvl ?? (Mardum, the Shattered Abyss) - Raider
	[113860] = "Raider's Training Dummy",     -- Lvl ?? (Trueshot Lodge) - Damage
	[113864] = "Raider's Training Dummy",     -- Lvl ?? (Trueshot Lodge) - Damage
	[70245]  = "Training Dummy",              -- Lvl ?? (Throne of Thunder)
	[113964] = "Raider's Training Dummy",     -- Lvl ?? (The Dreamgrove) - Tanking
	[131983] = "Raider's Training Dummy",     -- Lvl ?? (Boralus) - Damage
	[144086] = "Raider's Training Dummy",     -- Lvl ?? (Dazal'alor) - Damage
	[174565] = "Raider's Training Dummy",	  -- Lvl ?? (Ardenweald)
	[174566] = "Dungeoneer's Tanking Dummy",  -- Lvl ?? (Ardenweald)
	[174567] = "Raider's Training Dummy",	  -- Lvl ?? (Ardenweald)
	[174568] = "Dungeoneer's Tanking Dummy",  -- Lvl ?? (Ardenweald)
	[174491] = "Iron Tester", 				  -- Lvl ?? (Location Unknown)
	[174488] = "Unbreakable Defender", 		  -- Lvl ?? (Location Unknown)
	-- [174489] = "Necromantic Guide", 		  -- Lvl ?? (Location Unknown)
	[174489] = "Raider's Training Dummy",	  -- Lvl ?? (Revendreth)
	[175452] = "Raider's Training Dummy",	  -- Lvl ?? (Location Unknown)
	[175451] = "Dungeoneer's Tanking Dummy",  -- Lvl ?? (Revendreth)
	[154580] = "Reinforced Guardian", 		  -- Elysian Hold
	[154583] = "Stalward Guardian", 		  -- Elysian Hold
	[154585] = "Valiant's Resolve",			  -- Elysian Hold
	[154586] = "Stalward Phalanx", 			  -- Elysian Hold
	[154564] = "Valiant's Humility", 		  -- Elysian Hold
	[154567] = "Purity's Cleansing", 		  -- Elysian Hold
	[160325] = "Humility's Obedience", 		  -- Elysian Hold
-- Dragonflight
	[194648] = "Training Dummy", 			  -- Valdrakken
	[194645] = "Training Dummy", 			  -- Valdrakken (Healing)
	[194649] = "Normal Tank Dummy",			  -- Valdrakken
	[198594] = "Cleave Training Dummy",	      -- Valdrakken
	[197833] = "PvP Training Dummy",		  -- Valdrakken
	[197834] = "PvP Training Dummy", 		  -- Valdrakken (Healing)
	[194646] = "Cleave Training Dummy",	      -- Valdrakken (Healing)
	[194643] = "Dungeoneer's Training Dummy", -- Valdrakken
	[194644] = "Dungeoneer's Training Dummy", -- Valdrakken (Tanking)
	[189632] = "Animated Duelist", 			  -- Valdrakken (Raider's Training Dummy)
	[189617] = "Boulderfist", 			      -- Valdrakken (Raider's Tanking Dummy)
	[225985] = "XXX", 			      -- XXX (Raider's Tanking Dummy)
	[225982] = "XXX", 			      -- XXX (Raider's Tanking Dummy)
}  

function dummy(unitID)
local unit = UnitGUID(unitID)
if unit then
local targetID = tonumber(UnitGUID(unitID):sub(-16, -12)) -- to update later maybe
if dummies[targetID] then
	is = true
		else
	is = false
end
end
if is == nil or not unit then
	is = false
end
return is
end

 
function unit:id()
if UnitExists(self.unitID) then
	id =  UnitGUID(self.unitID):match("-(%d+)-%x+$") -- to update later maybe
	return id
end
	return 0
end


function unit:IsDummy()
  if dummy(self.unitID) then
    return true
  end
end

function unit:IsBoss()
	if dummy(self.unitID) then
		return true
	end
    if UnitIsUnit(self.unitID, "Boss1") or UnitIsUnit(self.unitID, "Boss2") or UnitIsUnit(self.unitID, "Boss3") or UnitIsUnit(self.unitID, "Boss4") or UnitIsUnit(self.unitID, "Boss5")  then
        return true
    end
    local inRaid = IsInRaid()
    if UnitLevel(self.unitID) == -1 or (not inRaid and UnitLevel(self.unitID) > 82) then
        return true
    end
    if UnitIsPlayer(self.unitID) and UnitCanAttack("player", self.unitID) then
        return true
    end
    return false
end

function unit:alive() --print('self.unitID: ', self.unitID)
	local out = UnitIsDeadOrGhost(self.unitID);
	if out ~= 1 then 
		return true
	else
		return false 
	end
end

function unit:level()
  return UnitLevel(self.unitID)
end

function unit:dead()
	local out = UnitIsDeadOrGhost(self.unitID);
	if out == 1 then 
		return true
	else
		return false 
	end
end

function unit:enemy()
  return UnitCanAttack("player", self.unitID)
end

function unit:friend()
  return not UnitCanAttack("player", self.unitID)
end

function unit:name()
  return UnitName(self.unitID)
end

function unit:exists()
  return UnitExists(self.unitID)
end

function unit:guid()
  return UnitGUID(self.unitID)
end

function unit:pointer()
  return _A.ObjectPointer(self.unitID)
end

local function totem_active(name)
  local haveTotem, totemName, startTime, duration
  for i = 1, 4 do
    haveTotem, totemName, startTime, duration = GetTotemInfo(i)
    if totemName == name then
      return true
    end
  end
  return false
end

function unit:totem_active()
  return totem_active
end

function unit:distance()
	return _A.GetDistanceBetweenObjects("player", self.unitID)
end


local function channeling(spell)
  local channeling_spell = UnitChannelInfo(calledUnit.unitID)
  if channeling_spell then
    if spell then
      if tonumber(spell) then
        spell = GetSpellInfo(spell)
      end
      if channeling_spell == spell then
        return true
      else
        return false
      end
    else
      return true
    end
  else
    return false
  end
end

function unit:channeling(spell)
  return channeling
end

function unit:castingpercent()
  local castingname, _, _, _, startTime, endTime, _, _, notInterruptible  = UnitCastingInfo("player")
  if castingname then
    local castLength = (endTime - startTime) / 1000
    local secondsLeft = endTime / 1000 - GetTime()
    return ((secondsLeft / castLength) * 100)
  end
  return 0
end

function unit:moving()
  return GetUnitSpeed(self.unitID) ~= 0
end
local movingTimes = {}

function unit:movingFor()
  local unitID = self.unitID
  if not unitID then
    return 0
  end
  if GetUnitSpeed(unitID) ~= 0 then
    if not movingTimes[unitID] then
      movingTimes[unitID] = GetTime()
    end
    return GetTime() - movingTimes[unitID]
  else
    movingTimes[unitID] = nil
    return 0
  end
end

function unit:has_stealable()
  local has_stealable = false
  for i = 1, 40 do
    buff, rank, icon, count, debuffType, duration, expires, caster, stealable, shouldConsolidate, spellID = UnitBuff(self.unitID, i)
    if stealable then
      has_stealable = true
    end
  end
  return has_stealable
end

function unit:combat()
  return UnitAffectingCombat(self.unitID)
end

local function unit_interrupt(percent, spell)
  local percent = tonumber(percent) or 100
  local spell = spell and GetSpellInfo(spell) or false
  local name, startTime, endTime, notInterruptible
  
  
  name, _, _, _, startTime, endTime, _, _, notInterruptible = UnitCastingInfo(calledUnit.unitID)
  if not name then
    name, _, _, _, startTime, endTime, _, notInterruptible = UnitChannelInfo(calledUnit.unitID)
  end
  if name and startTime and endTime and ((spell and name == spell) or (not spell and not notInterruptible)) then
    local castTimeRemaining = endTime / 1000 - GetTime()
    local castTimeTotal = (endTime - startTime) / 1000
    if castTimeTotal > 0 and castTimeRemaining / castTimeTotal * 100 <= percent then
      return true
    end
  end
  return false
end
 
function unit:interrupt()
  return unit_interrupt
end

local function unit_in_range(spell)
  if tonumber(spell) then
    name = GetSpellInfo(spell)
  end
  return IsSpellInRange(spell, calledUnit.unitID) == 1
end

function unit:in_range()
  return unit_in_range
end

local function totem_cooldown(name)
  if tonumber(name) then
    name = GetSpellInfo(name)
  end
  local haveTotem, totemName, startTime, duration
  for i = 1, 4 do
    haveTotem, totemName, startTime, duration = GetTotemInfo(i)
    if totemName == name then
      return duration - (GetTime() - startTime)
    end
  end
  return 0
end

function unit:totem()
  return totem_cooldown
end

local death_tracker = {}
function unit:time_to_die()
  if death_tracker[self.unitID] and death_tracker[self.unitID].guid == UnitGUID(self.unitID) then
    local health_change = death_tracker[self.unitID].health - UnitHealth(self.unitID)
    local time_change = GetTime() - death_tracker[self.unitID].time
    local health_per_time = health_change / time_change
    local time_to_die = UnitHealth(self.unitID) / health_per_time
    return math.min(math.max(time_to_die, 0), 9999)
  end
  if not death_tracker[self.unitID] then
    death_tracker[self.unitID] = {}
  end
  death_tracker[self.unitID].guid = UnitGUID(self.unitID)
  death_tracker[self.unitID].time = GetTime()
  death_tracker[self.unitID].health = UnitHealth(self.unitID)
  return 9999
end

local function spell_cooldown(spell)
  _table = C_Spell.GetSpellCooldown(spell)
  if not _table then return 0 end
  local time, value = _table.startTime,  _table.duration

  if not time or time == 0 then
    return 0
  end
  local cd = time + value - GetTime() - (select(4, GetNetStats()) / 1000)
  if cd > 0 then
    return cd
  else
    return 0
  end
end
 

function unit:los()
	local px, py, pz = _A.ObjectPosition("player")
	local tx, ty, tz = _A.ObjectPosition(unit)
	local flags = bit.bor(0x100000, 0x10000, 0x100, 0x10, 0x1)

	local los, cx, cy, cz = _A.TraceLine(px, py, pz, tx, ty, tz, flags)
	if los then
	  return true
	else
	  return false
	end
end
 
local dispel_spell = {
    [4987] = {"Magic" }, --  "Poison", "Disease", 
    [213644] = { "Poison", "Disease" },
    [19801] = { "Magic" },
    [31224] = { "Poison", "Curse", "Disease", "Magic" },
    [527] = { "Magic" }, --  "Disease", 
    [32375] = { "Magic" },
    [528] = { "Magic" },
    [51886] = { "Curse" },
    [77130] = {"Magic" },-- "Curse", 
    [370] = { "Magic" },
    [475] = { "Curse" },
    [19505] = { "Magic" },
    [115450] = { "Magic" }, -- "Poison", "Disease", 
    [218164] = { "Poison", "Disease" },
    [2782] = { "Poison", "Curse" },
    [88423] = { "Magic" }, -- "Poison", "Curse", 
    [122288] = { "Poison", "Disease" },
    [365585] = { "Poison" },
    [374251] = { "Bleed", "Poison", "Curse", "Disease" },
    [360823] = { "Magic", "Poison" },
    [278326] = { "Magic" }
}


local forbiddenDebuffs = {
	[20184] = true, [20185] = true, [20186] = true,
	[31803] = true, [38142] = true, [47843] = true,
	[48160] = true, [53742] = true, [55360] = true,
	[60667] = true, [60814] = true, [61429] = true,
	[61840] = true, [68055] = true, [68786] = true,
	[69674] = true, [70337] = true, [70405] = true,
	[70867] = true, [70964] = true, [71224] = true,
	[74562] = true, [74567] = true, [74792] = true,
	[74795] = true,
}
	
local function ValidType(debuffType, spellID)
	local typesList = dispel_spell[spellID]
	if not typesList then return false end
	for _, validType in ipairs(typesList) do
		if validType == debuffType then
			return true
		end
	end
	return false
end
	
local function canDispel(Unit, spellID)
    local isFriend = UnitIsFriend(Unit, 'player')
    if isFriend then
        for i = 1, 40 do
            local debuffData = UnitAuras335.GetAuraDataByIndex(Unit, i, "HARMFUL") 
            if not debuffData then break end
            local dispelName = debuffData.debuffType
            local sid = debuffData.spellId
            
            if forbiddenDebuffs[sid] then 
                break 
            end
            
            if ValidType(dispelName, spellID) or tonumber(sid) == 440313 then
                return true
            end
        end
	end
    return false
end

local function unit_dispellable(spell)
    return canDispel(self.unitID, spell)
end

function unit:dispellable(spell)
    return canDispel(self.unitID, spell)
end

local function unit_dispellable(spell)
  return canDispel(calledUnit.unitID, spell)
end

function unit:dispellable(spell)
  return unit_dispellable
end

