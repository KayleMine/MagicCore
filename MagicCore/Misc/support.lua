local addonName, _A, MagicCore = ...
MagicCore.Support = MagicCore.Support or {}
local Support = MagicCore.Support
local talentCache = {}
local isCacheBuilt = false

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
    local numTabs = GetNumTalentTabs()
    for tab = 1, numTabs do
        local numTalents = GetNumTalents(tab)
        for i = 1, numTalents do
            local link = GetTalentLink(tab, i)
            if link then
                local _, _, talentId = string.find(link, "talent:(%d+)")
                if talentId then
					--print('link: ', link, " :: ", talentId)
                    talentCache[tonumber(talentId)] = { tab = tab, index = i }
                end
            end
        end
    end
    isCacheBuilt = true
end

local talentEventHandler = CreateFrame("Frame")
talentEventHandler:RegisterEvent("PLAYER_TALENTS_CHANGED")
talentEventHandler:SetScript("OnEvent", function(self, event, ...)
    if event == "PLAYER_TALENTS_CHANGED" then
        isCacheBuilt = false
    end
end)


Support.iknow = function(spellID) --print(spellID)
	if type(spellID) == 'nil' then return false end
    if not isCacheBuilt then
        BuildTalentCache()
    end
	local rank;
    local IsSpellKnown = IsSpellKnown(spellID, isPetSpell)
    local location = talentCache[spellID]
	
    if location then
		_, _, _, _, rank = GetTalentInfo(location.tab, location.index)
    end

    if IsSpellKnown or rank and (rank > 0) then
        return true 
    else 
        return false 
    end
end

Support.TalentRank = function(spellID)
	if type(spellID) == 'nil' then return false end
    if not isCacheBuilt then
        BuildTalentCache()
    end
	local rank;
    local IsSpellKnown = IsSpellKnown(spellID, isPetSpell)
    local location = talentCache[spellID]
	
    if location then
		_, _, _, _, rank = GetTalentInfo(location.tab, location.index)
    end

    if rank and (rank > 0) then
        return rank 
    else 
        return 0 
    end
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