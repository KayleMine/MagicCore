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
	local unit = buffTarget(5, GetSpellName(42995))
	if unit then
		cast(42995)
	end
	
	--print(iknow(42995))
	
	if power.mana.percent > 60 and castable(SB.DemonSkin) and player.buff(SB.DemonSkin).down then
		cast(SB.DemonSkin)
		return true
	end
	
	local lifeTapMP_check = MagicCore.settings.InterfaceFetch("lifeTapMP_check")
    local lifeTapMP_spin = tonumber(MagicCore.settings.InterfaceFetch("lifeTapMP_spin")) -- Возвращает число (MP %)
	print(tostring(lifeTapMP_check), tostring(lifeTapMP_spin))
end







-- Вспомогательная функция для цветного текста
local function c(c,t)
	return "|cff"..c..""..t.."|r"
end

local m = {
	MainSettings = c("FFFF00","Главные настройки"),
	Combat = c("EE4000","Настройки боя"),
	Resting = c("95f900","Настройки вне боя"),
}

local GUI = {
    -- Главные настройки
    {type = "Section", text = m.MainSettings, size = 14, align = "CENTER", contentHeight = 50, expanded = true, height = 20},
    {type = "Spacer"},
    
    -- Пример настройки: Жизнеотвод (Life Tap)
    {type = "Checkspin", cw = 14, ch = 14, size = 14, text = " ".._A.Core:GetSpellIcon(11687, 14, 14).." Жизнеотвод", tooltip = "Использовать Жизнеотвод при MP < %", spin = 35, min = 0, max = 100, step = 1, width = 60, key = "lifeTapMP"},
    {type = "Spacer", size = 10},
   
    -- Настройки боя
    {type = "Section", text = m.Combat, size = 14, align = "CENTER", contentHeight = 40, expanded = true, height = 20},
    {type = "Spacer"},
    {type = "Checkbox", cw = 14, ch = 14, size = 14, text = " ".._A.Core:GetSpellIcon(7648, 14, 14).." Использовать Порчу", tooltip = "Автоматически обновлять Порчу на цели.", default = true, key = "useCorruption"},
    {type = "Spacer", size = 10},

    -- Настройки вне боя
    {type = "Section", text = m.Resting, size = 14, align = "CENTER", contentHeight = 40, expanded = true, height = 20},
    {type = "Spacer"},
    {type = "Checkbox", cw = 14, ch = 14, size = 14, text = " ".._A.Core:GetSpellIcon(687, 14, 14).." Поддерживать Демоническую броню", tooltip = "Автоматически поддерживать Демоническую броню вне боя.", default = true, key = "buffDemonSkin"},
    {type = "Spacer", size = 10},
}

for _, func in pairs(Destruction) do
    setfenv(func, MagicCore.Environment.env)
end

return MagicCore.register({
  classID = MagicCore.CEnum.MAGE,
  name = "agony",
  label = "|cff33ff99 Agony warlock|r",
  combat = combat,
  resting = resting,
  gui = GUI,
  gui_st = {title="Destro Settings", color="67E667", width=320, height=420},
})
