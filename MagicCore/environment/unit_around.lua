local addonName, _A, MagicCore = ...

MagicCore.unit_around = MagicCore.unit_around or {}
local unit_around = MagicCore.unit_around


--[[ todododooo; обновить текст ниже
Функция														Описание																				Пример вызова
lowestInRange(rangeYards, role)								Самый низкохп союзник в радиусе. role опционально ("HEALER", "TANK", "DAMAGER")			unit_around.lowestInRange(20) | unit_around.lowestInRange(20, "HEALER")
lowestEnemyInRange(rangeYards)								Самый низкохп враг вокруг игрока														unit_around.lowestEnemyInRange(15)
lowestEnemyCombatInRange(rangeYards)						Самый низкохп враг в бою вокруг игрока													unit_around.lowestEnemyCombatInRange(15)
EnemyCount(rangeYards)										Количество врагов в радиусе																unit_around.EnemyCount(15)
FriendlyCount(rangeYards)									Количество союзников в радиусе															unit_around.FriendlyCount(15)
FriendlyHPCount(rangeYards, hpPercent)						Количество союзников с HP ниже hpPercent												unit_around.FriendlyHPCount(15, 35)
FriendAroundUnitHPCount(unitID, rangeYards, hpPercent)		Количество союзников вокруг юнита с HP ниже hpPercent									unit_around.FriendAroundUnitHPCount('raid25', 15, 35)
EnemyHPCount(rangeYards, hpPercent)							Количество врагов с HP ниже hpPercent вокруг игрока										unit_around.EnemyHPCount(15, 35)
EnemyAroundUnitHPCount(unitID, rangeYards, hpPercent)		Количество врагов вокруг юнита с HP ниже hpPercent										unit_around.EnemyAroundUnitHPCount('raid25', 15, 35)
]]

-- Союзники
unit_around.lowestInRange = function(rangeYards, role)
    local tempTable = {}
    for _, Obj in pairs(_A.OM:Get('Roster')) do
		Obj.pointer = _A.ObjectPointer(Obj.guid)
        if _A.ObjectIsUnit(Obj.pointer) and (not role or (role and Obj:role() == role:upper())) then
            local dist = _A.GetDistanceBetweenObjects("player", Obj.pointer)
            if dist and dist <= rangeYards then
                tempTable[#tempTable+1] = {
                    guid = Obj.pointer,
                    health = Obj:health()
                }
            end
        end
    end
    table.sort(tempTable, function(a,b) return a.health < b.health end)
	local lowestGUID = tempTable[1] and tempTable[1].guid

    if lowestGUID then
        return MagicCore.Environment.GetUnit(lowestGUID)
    else
        return nil
    end
end


-- Враги
unit_around.lowestEnemyInRange = function(rangeYards)
    local tempTable = {}
    for _, Obj in pairs(_A.OM:Get('Enemy')) do
        Obj.pointer = _A.ObjectPointer(Obj.guid)
        if _A.ObjectIsUnit(Obj.pointer) then
            local dist = _A.GetDistanceBetweenObjects("player", Obj.pointer)
            if dist and dist <= rangeYards then
                tempTable[#tempTable+1] = {
                    guid = Obj.pointer,
                    health = Obj:health()
                }
            end
        end
    end
    table.sort(tempTable, function(a,b) return a.health < b.health end)
    
    local lowestGUID = tempTable[1] and tempTable[1].guid

    if lowestGUID then
        return MagicCore.Environment.GetUnit(lowestGUID) -- Возвращаем объект юнита
    else
        return nil
    end
end

-- Враги в бою
unit_around.lowestEnemyCombatInRange = function(rangeYards)
    local tempTable = {}
    for _, Obj in pairs(_A.OM:Get('EnemyCombat')) do
        Obj.pointer = _A.ObjectPointer(Obj.guid)
        if _A.ObjectIsUnit(Obj.pointer) then
            local dist = _A.GetDistanceBetweenObjects("player", Obj.pointer)
            if dist and dist <= rangeYards then
                tempTable[#tempTable+1] = {
                    guid = Obj.pointer,
                    health = Obj:health()
                }
            end
        end
    end
    table.sort(tempTable, function(a,b) return a.health < b.health end)
    

    if lowestGUID then
        return MagicCore.Environment.GetUnit(lowestGUID) -- Возвращаем объект юнита
    else
        return nil
    end
end

-- =========================
-- Подсчёт союзников и врагов вокруг игрока
-- =========================

-- Количество врагов в радиусе (вокруг указанного юнита, или вокруг "player" по умолчанию)
unit_around.EnemyCount = function(rangeYards, unitID)
    local sourceUnit = unitID or "player"
    local count = 0
    for _, Obj in pairs(_A.OM:Get('Enemy')) do
        Obj.pointer = Obj.pointer or _A.ObjectPointer(Obj.guid)
        if _A.ObjectIsUnit(Obj.pointer) then
            local dist = _A.GetDistanceBetweenObjects(sourceUnit, Obj.pointer) 
            if dist and dist <= rangeYards then
                count = count + 1
            end
        end
    end
    return count
end
 
-- Количество союзников в радиусе
unit_around.FriendlyCount = function(rangeYards, sourceUnit)
	local sourceUnit = unitID or "player"
    local count = 0
    for _, Obj in pairs(_A.OM:Get('Roster')) do
		Obj.pointer = _A.ObjectPointer(Obj.guid)
        if _A.ObjectIsUnit(Obj.pointer) then
            local dist = _A.GetDistanceBetweenObjects(sourceUnit, Obj.pointer)
            if dist and dist <= rangeYards then
                count = count + 1
            end
        end
    end
    return count
end

-- Количество союзников в радиусе с HP меньше hpPercent
unit_around.FriendlyHPCount = function(rangeYards, hpPercent)
    local count = 0
    for _, Obj in pairs(_A.OM:Get('Roster')) do
		Obj.pointer = _A.ObjectPointer(Obj.guid)
        if _A.ObjectIsUnit(Obj.pointer) then
            local dist = _A.GetDistanceBetweenObjects("player", Obj.pointer)
            if dist and dist <= rangeYards then
                if Obj:healthPercent() <= hpPercent then
                    count = count + 1
                end
            end
        end
    end
    return count
end

-- Количество союзников вокруг указанного юнита с HP меньше hpPercent
unit_around.FriendAroundUnitHPCount = function(unitID, rangeYards, hpPercent)
    local count = 0
    for _, Obj in pairs(_A.OM:Get('Roster')) do
		Obj.pointer = _A.ObjectPointer(Obj.guid)
        if _A.ObjectIsUnit(Obj.pointer) then
            local dist = _A.GetDistanceBetweenObjects(unitID, Obj.pointer)
            if dist and dist <= rangeYards then
                if Obj:healthPercent() <= hpPercent then
                    count = count + 1
                end
            end
        end
    end
    return count
end

-- =========================
-- Подсчёт врагов вокруг игрока
-- =========================

-- Количество врагов с HP меньше hpPercent
unit_around.EnemyHPCount = function(rangeYards, hpPercent)
    local count = 0
    for _, Obj in pairs(_A.OM:Get('Enemy')) do
		Obj.pointer = _A.ObjectPointer(Obj.guid)
        if _A.ObjectIsUnit(Obj.pointer) then
            local dist = _A.GetDistanceBetweenObjects("player", Obj.pointer)
            if dist and dist <= rangeYards then
                if Obj:healthPercent() <= hpPercent then
                    count = count + 1
                end
            end
        end
    end
    return count
end

-- Количество врагов вокруг указанного юнита с HP меньше hpPercent
unit_around.EnemyAroundUnitHPCount = function(unitID, rangeYards, hpPercent)
    local count = 0
    for _, Obj in pairs(_A.OM:Get('Enemy')) do
		Obj.pointer = _A.ObjectPointer(Obj.guid)
        if _A.ObjectIsUnit(Obj.pointer) then
            local dist = _A.GetDistanceBetweenObjects(unitID, Obj.pointer)
            if dist and dist <= rangeYards then
                if Obj:healthPercent() <= hpPercent then
                    count = count + 1
                end
            end
        end
    end
    return count
end
