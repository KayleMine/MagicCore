local addonName, _A, MagicCore = ...
local Arcane = {};
local EC;
local SB = {
	ArcaneBlast = 42897,
	ArcaneMissiles = 42846,
	ArcanePower = 12042,
	PresenceOfMind = 12043,
	MirrorImage = 55342,
	
	FlameStrike8 = 42925,
	FlameStrike9 = 42926,
	Blizzard9 = 42940,
	
	ArcaneIntellect = 42995,
	MageArmor = 43024,
	AmplifyMagic = 43017,
	
	ArcaneBlast_Stacks = 36032,
	
	MissileBarrage = 44401,
	ClearCasting = 12536,
	
	MissileBarrage_Talent = 2209,
	
	ArcaneExplosion = 42921,
	ConeOfCold = 42931,
	Evocation = 12051,
}


Arcane.etc = function()
	if iknow(SB.ArcaneIntellect) and player.buff(SB.ArcaneIntellect).down and castable(SB.ArcaneIntellect) then
		cast(SB.ArcaneIntellect, player)
		return true
	end
	if iknow(SB.MageArmor) and player.buff(SB.MageArmor).down and castable(SB.MageArmor) then
		cast(SB.MageArmor, player)
		return true
	end
	if iknow(SB.AmplifyMagic) and player.buff(SB.AmplifyMagic).down and castable(SB.AmplifyMagic) then
		cast(SB.AmplifyMagic, player)
		return true
	end
end	

Arcane.cooldowns = function()
if not toggle("Cooldowns") then return end
	
	if not player.moving and iknow(SB.Evocation) and castable(SB.Evocation) and player.power.mana.percent <= 40 then
		cast(SB.Evocation, player)
		return true
	end
	
	if iknow(SB.MirrorImage) and castable(SB.MirrorImage) and player.debuff(SB.ArcaneBlast_Stacks).count >= 3 then
		cast(SB.MirrorImage)
		return true
	end

	if iknow(SB.ArcanePower) and castable(SB.ArcanePower) and player.debuff(SB.ArcaneBlast_Stacks).count >= 3 then
		cast(SB.ArcanePower)
		return true
	end

	if iknow(SB.PresenceOfMind) and castable(SB.PresenceOfMind) and player.debuff(SB.ArcaneBlast_Stacks).count == 3 then
		cast(SB.PresenceOfMind, player)
		return true
	end

end

SB.MageInterrupt_Blank = 12345; -- <- hey hey its blank change id!
Arcane.interrupts = function()
if not toggle("Interrupts") then return end
--[[
	local intpercent = math.random(35,65)
	if castable(SB.MageInterrupt_Blank) and target.interrupt(intpercent, false) and target.distance <= 30 then
		cast(SB.MageInterrupt_Blank, "target")
		return true
	end
]]
end




Arcane.AMissiles = function()
	local stacks = player.debuff(SB.ArcaneBlast_Stacks).count
	local hasMissileBarrage = player.buff(SB.MissileBarrage).up
	local hasClearCasting = player.buff(SB.ClearCasting).up
	local targettingStackCount = 4
	if hasMissileBarrage and stacks == targettingStackCount then
		return true
	end
	if hasMissileBarrage and stacks >= 3 then
		return true
	end
	if hasClearCasting and stacks == targettingStackCount then
		return true
	end
	return false
end


Arcane.ST = function()
	local stacks = player.debuff(SB.ArcaneBlast_Stacks).count

	if iknow(SB.ArcaneMissiles) and Arcane.AMissiles() and castable(SB.ArcaneMissiles) then
		cast(SB.ArcaneMissiles, target)
		return true
	end

	if stacks < 4 and castable(SB.ArcaneBlast) then
		cast(SB.ArcaneBlast, target)
		return true
	end

	if stacks == 4 and castable(SB.ArcaneBlast) then
		cast(SB.ArcaneBlast, target)
		return true
	end
end

local AoEStep = 0;
Arcane.AOE = function()
		local step = AoEStep;
		if player.moving then
			local near_enemy = highestEnemyInRange(10);
			if near_enemy and near_enemy.alive and iknow(SB.ArcaneExplosion) and castable(SB.ArcaneExplosion) then
				cast(SB.ArcaneExplosion)
				return true
			end
		end
		-- Шаг 0: Flamestrike R9
		if step == 0 or step == 3 then
			if iknow(SB.FlameStrike9) and castable(SB.FlameStrike9) then
				cast_ground(SB.FlameStrike9, target, true)
				AoEStep = 1
				return true
			end
		end

		-- Шаг 1: Flamestrike R8
		if step == 1 then
			if iknow(SB.FlameStrike8) and castable(SB.FlameStrike8) then
				cast_ground(SB.FlameStrike8, target, true)
				AoEStep = 2
				return true
			end
		end
		
		-- Шаг 2: Blizzard
		if step == 2 then
			if iknow(SB.Blizzard9) and castable(SB.Blizzard9) then
				cast_ground(SB.Blizzard9, target)
				AoEStep = 3
				return true
			end
		end
		-- Reset... 
		if step == 3 then
			AoEStep = 0
		end
end

local EC_Ranged
local function combat()
	if not player or not player.exists or not player.alive or IsCasting() then return end
	if Arcane.etc() then return end
	local EC_Melee = EnemyCount(8);
	EC_Ranged = EnemyCount(15, player);
	
	if target and target.exists and target.alive and target.enemy then
	EC_Ranged = EnemyCount(15, target);
	
	if EC_Ranged >= EC_Melee then
		EC = EC_Ranged;
	else
		EC = EC_Melee;
	end
	if EC <= 0 then EC = 1 end
	
	if Arcane.etc() then return end
	if Arcane.interrupts() then return end
	if Arcane.cooldowns() then return end
	
	if EC >= 3 or toggle("AoE") then
		return Arcane.AOE();
	else
		return Arcane.ST();
	end
	
	end
	
end
 

local function resting()
	if not player or not player.alive then return end
	if Arcane.etc() then return end

	-- if (IsPressed("ctrl") or IsCombo("shift+alt")) and castable(SB.Blizzard9) then
		-- cast_mouse(SB.Blizzard9)
		-- return true
	-- end	--							an test

	-- local lifeTapMP_check = MagicCore.settings.InterfaceFetch("lifeTapMP_check")
    -- local lifeTapMP_spin = tonumber(MagicCore.settings.InterfaceFetch("lifeTapMP_spin"))
	-- print(tostring(lifeTapMP_check), lifeTapMP_spin)

end





local function c(c,t)
	return "|cff"..c..""..t.."|r"
end

local m = {
	MainSettings = c("FFFF00","Главные настройки"),
	Combat = c("EE4000","Настройки боя"),
	Resting = c("95f900","Настройки вне боя"),
}

local GUI = {
    {type = "Section", text = m.MainSettings, size = 14, align = "CENTER", contentHeight = 50, expanded = true, height = 20},
    {type = "Spacer"},

    -- {type = "Checkspin", cw = 14, ch = 14, size = 14, text = " ".._A.Core:GetSpellIcon(11687, 14, 14).." Жизнеотвод", tooltip = "Использовать Жизнеотвод при MP < %", spin = 35, min = 0, max = 100, step = 1, width = 60, key = "lifeTapMP"},
    -- {type = "Spacer", size = 10},

    -- {type = "Section", text = m.Combat, size = 14, align = "CENTER", contentHeight = 40, expanded = true, height = 20},
    -- {type = "Spacer"},
    -- {type = "Checkbox", cw = 14, ch = 14, size = 14, text = " ".._A.Core:GetSpellIcon(7648, 14, 14).." Использовать Порчу", tooltip = "Автоматически обновлять Порчу на цели.", default = true, key = "useCorruption"},
    -- {type = "Spacer", size = 10},

    -- {type = "Section", text = m.Resting, size = 14, align = "CENTER", contentHeight = 40, expanded = true, height = 20},
    -- {type = "Spacer"},
    -- {type = "Checkbox", cw = 14, ch = 14, size = 14, text = " ".._A.Core:GetSpellIcon(687, 14, 14).." Поддерживать Демоническую броню", tooltip = "Автоматически поддерживать Демоническую броню вне боя.", default = true, key = "buffDemonSkin"},
    -- {type = "Spacer", size = 10},
}

for _, func in pairs(Arcane) do
    setfenv(func, MagicCore.Environment.env)
end

return MagicCore.register({
  classID = MagicCore.CEnum.MAGE,
  name = "arcanemage",
  label = "|cff33ff99 Arcane Mage|r",
  combat = combat,
  resting = resting,
  gui = GUI,
  gui_st = {title="Arcane Settings", color="67E667", width=320, height=420},
})
