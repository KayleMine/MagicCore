local addonName, _A, MagicCore = ...
MagicCore.Support = MagicCore.Support or {}
local Support = MagicCore.Support
local talentCache = {}
local isCacheBuilt = false
local time_talents = 0

MagicCore.CEnum = {
    None = 0,
    WARRIOR = 1,
    PALADIN = 2,
    HUNTER = 3,
    ROGUE = 4,
    PRIEST = 5,
    DEATHKNIGHT = 6,
    SHAMAN = 7,
    MAGE = 8,
    WARLOCK = 9,
    MONK = 10,
    DRUID = 11,
    DEMONHUNTER = 12
}

local function BuildTalentCache()
    wipe(talentCache)

    for tab = 1, GetNumTalentTabs() do
        for idx = 1, GetNumTalents(tab) do
            local name, _, _, _, rank = GetTalentInfo(tab, idx)
            local link = GetTalentLink(tab, idx)

            if link and name then
                local _, _, talentId = string.find(link, "talent:(%d+)")
                talentId = tonumber(talentId)

                if talentId then
                    talentCache[talentId] = { name = name, rank = rank, tab = tab, index = idx }
                    talentCache[name] = { spellID = talentId, rank = rank, tab = tab, index = idx }
                end
            end
        end
    end

    isCacheBuilt = true
end


local talentEventHandler = CreateFrame("Frame")
talentEventHandler:RegisterEvent("PLAYER_TALENT_UPDATE")
talentEventHandler:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
talentEventHandler:RegisterEvent("PLAYER_ENTERING_WORLD")
talentEventHandler:SetScript("OnEvent", function()
	local now = GetTime()
	-- Prevent consecutive updates in case any of the three events fire within a short period of time. -- from Morb
	if  now-time_talents > 1 then
		time_talents = now
		BuildTalentCache()
	end
end)


Support.iknow = function(spell)
    if not spell then return false end
    if not isCacheBuilt then BuildTalentCache() end

    local entry = talentCache[spell]
    if not entry then return IsSpellKnown(spell) end

    local rank = entry.rank or 0
    return (rank > 0) or IsSpellKnown(entry.spellID or spell)
end

Support.TalentRank = function(spell)
    if not spell then return 0 end
    if not isCacheBuilt then BuildTalentCache() end

    local entry = talentCache[spell]
    if not entry then return 0 end

    return entry.rank or 0
end

Support.toggle = function(name)
	if _A.DSL:Get("toggle")(_,name) then
		return true
	end
	return false
end

Support.IsCasting = function()
    if UnitCastingInfo('player') or UnitChannelInfo('player') then
        return true
    end
    return false
end

Support.FlexItem = function(itemID, width, height, bool)
	local itemIcon = GetItemIcon(itemID) 
	local var = " \124T"..(itemIcon)..":"..(height or 25)..":"..(width or 25).."\124t "
	if bool then
		return var .. GetItemInfo(itemID)
	else
		return var
	end
end
