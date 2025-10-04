local addonName, _A, MagicCore = ...
local Destruction = {};
local EC;
local SB = {
	LifeTap = 11687,
	DemonSkin = 687,
	CorruptionR4 = 7648,
}

Destruction.etc = function()
	if health.percent >= 55 and power.mana.percent <= 35 and castable(SB.LifeTap) then
		cast(SB.LifeTap)
		return true
	end
end


Destruction.ST = function()
if castable(SB.CorruptionR4) and target.debuff(SB.CorruptionR4).down then
	cast(SB.CorruptionR4, target)
	return true
end

end

Destruction.AOE = function()

end


local function combat()
	if not player or not player.exists or not player.alive then return end
	if Destruction.etc() then return end

	if target.exists and target.alive and target.enemy then
	local EC_Melee = EnemyCount(8);
	local EC_Ranged = EnemyCount(15, target);
	
	if EC_Ranged >= EC_Melee then
		EC = EC_Ranged;
	else
		EC = EC_Melee;
	end
	
	if EC >= 3 then
		return Destruction.AOE();
	else
		return Destruction.ST();
	end
	
	end
	
end

local function resting()
	if not player or not player.exists or not player.alive then return end
	if Destruction.etc() then return end
	local unit = buffTarget(5, C_Spell.GetSpellName(42995))
	if unit then
		cast(42995)
	end
	if power.mana.percent > 60 and castable(SB.DemonSkin) and player.buff(SB.DemonSkin).down then
		cast(SB.DemonSkin)
		return true
	end
end

for _, func in pairs(Destruction) do
    setfenv(func, MagicCore.Environment.env)
end

return MagicCore.register({
  classID = 8,
  name = "corruption",
  label = "|cff33ff99 Corruption warlock|r",
  combat = combat,
  resting = resting,
})
