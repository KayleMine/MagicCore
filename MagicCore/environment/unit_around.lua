local addonName, _A, MagicCore = ...

MagicCore.unit_around = MagicCore.unit_around or {}
local unit_around = MagicCore.unit_around

local function findAndSortUnit(objectGroup, rangeYards, filterPredicate, sortPredicate, isLowestHealth)
    local tempTable = {}
    for _, Obj in pairs(_A.OM:Get(objectGroup)) do
        Obj.pointer = Obj.pointer or _A.ObjectPointer(Obj.guid)

        if _A.ObjectIsUnit(Obj.pointer) then
            local dist = _A.GetDistanceBetweenObjects("player", Obj.pointer)
            if dist and dist <= rangeYards and (not filterPredicate or filterPredicate(Obj)) then
                tempTable[#tempTable + 1] = {
                    guid = Obj.pointer,
                    health = Obj:health()
                }
            end
        end
    end
    if #tempTable > 0 then
        table.sort(tempTable, function(a, b)
            if isLowestHealth then
                return a.health < b.health
            else
                return a.health > b.health
            end
        end)
        local targetGUID = tempTable[1].guid
        return MagicCore.Environment.GetUnit(targetGUID)
    else
        return nil
    end
end

local function countUnits(objectGroup, rangeYards, sourceUnit, filterPredicate)
    local source = sourceUnit or "player"
    local count = 0
    for _, Obj in pairs(_A.OM:Get(objectGroup)) do
        Obj.pointer = Obj.pointer or _A.ObjectPointer(Obj.guid)

        if _A.ObjectIsUnit(Obj.pointer) then
            local dist = _A.GetDistanceBetweenObjects(source, Obj.pointer)
            if dist and dist <= rangeYards and (not filterPredicate or filterPredicate(Obj)) then
                count = count + 1
            end
        end
    end
    return count
end



------------------------------
----------Find Unit-----------
------------------------------

-- Союзники (самое низкое HP, опциональная роль)
unit_around.lowestInRange = function(rangeYards, role)
    local filter = role and function(Obj) return Obj:role() == role:upper() end or nil
    return findAndSortUnit('Roster', rangeYards, filter, nil, true)
end

-- Враги (самое низкое HP)
unit_around.lowestEnemyInRange = function(rangeYards)
    return findAndSortUnit('Enemy', rangeYards, nil, nil, true)
end

unit_around.highestEnemyInRange = function(rangeYards)
    return findAndSortUnit('EnemyCombat', rangeYards, nil, nil, false)
end

-- Враги в бою (самое низкое HP)
unit_around.lowestEnemyCombatInRange = function(rangeYards)
    return findAndSortUnit('EnemyCombat', rangeYards, nil, nil, true)
end

-- Союзники без баффа (самое низкое HP)
unit_around.buffTarget = function(rangeYards, buffName--[[, minRank]])
	local filter = function(Obj)
        local buff = Obj:Buff(buffName)
        if not buff then
            return true
        end
        -- if minRank and buff and buff:rank() < minRank then 				-- de\buff:rank() not exists need to add later, and fix core, cuz now i accept names only, not id's
            -- return true
        -- end
        return false
    end
    return findAndSortUnit('Roster', rangeYards, filter, nil, true)
end

-- Враги без дебаффа
unit_around.debuffTarget = function(rangeYards, debuffName--[[, minRank]])
	local filter = function(Obj)
        local debuff = Obj:Debuff(debuffName)
        if not debuff then
            return true
        end
        -- if minRank and debuff and debuff:rank() < minRank then 
            -- return true
        -- end
        return false
    end
    return findAndSortUnit('Enemy', rangeYards, filter, nil, false)
end

------------------------------
-----------COUNTER------------
------------------------------

-- Количество врагов в радиусе
unit_around.EnemyCount = function(rangeYards, unitID)
    return countUnits('Enemy', rangeYards, unitID, nil)
end

-- Количество союзников в радиусе
unit_around.FriendlyCount = function(rangeYards, unitID)
    return countUnits('Roster', rangeYards, unitID, nil)
end

-- Количество союзников в радиусе с HP меньше hpPercent
unit_around.FriendlyHPCount = function(rangeYards, hpPercent)
    local filter = function(Obj) return Obj:healthPercent() <= hpPercent end
    return countUnits('Roster', rangeYards, "player", filter)
end

-- Количество союзников вокруг указанного юнита с HP меньше hpPercent
unit_around.FriendAroundUnitHPCount = function(unitID, rangeYards, hpPercent)
    local filter = function(Obj) return Obj:healthPercent() <= hpPercent end
    return countUnits('Roster', rangeYards, unitID, filter)
end

-- Количество врагов с HP меньше hpPercent
unit_around.EnemyHPCount = function(rangeYards, hpPercent)
    local filter = function(Obj) return Obj:healthPercent() <= hpPercent end
    return countUnits('Enemy', rangeYards, "player", filter)
end

-- Количество врагов вокруг указанного юнита с HP меньше hpPercent
unit_around.EnemyAroundUnitHPCount = function(unitID, rangeYards, hpPercent)
    local filter = function(Obj) return Obj:healthPercent() <= hpPercent end
    return countUnits('Enemy', rangeYards, unitID, filter)
end