local addonName, _A, MagicCore = ...
local C_Spell = MagicCore.C_Spell

local IsUsableSpell = IsUsableSpell
--local GetSpellCharges = C_Spell.GetSpellCharges
local spell = {}

local lastCastTimes = {}

MagicCore.Listener:Add(
    "DBMAffliction_CastSuccess",
    "UNIT_SPELLCAST_SUCCEEDED",
    function(unitID, lineID, spellID)
        if unitID == "player" then
            lastCastTimes[spellID] = GetTime()
            MagicCore.tmp.store("lastcast", spellID)
        end
    end
)

MagicCore.Listener:Add(
    "DBMAffliction_WipeOnRegen",
    "PLAYER_REGEN_ENABLED",
    function()
        wipe(lastCastTimes)
    end
)


 
function spell:cooldown()
  local _table = C_Spell.GetSpellCooldown(self.spell)
  if not _table then return 0 end
  local time, value = _table.startTime, _table.duration, _table.isEnabled
  if not time or time == 0 then
    return 0
  end
  local cd = time + value - GetTime()
  if cd > 0 and not MagicCore.settings.fetch('_engine_turbo', false) then
    return cd
  else
    return 0
  end
end

function spell:icon() 
  local textureA, textureB = C_Spell.GetSpellTexture(self.spell)
  return textureA ~= textureB
end
 
function spell:exists()
  return IsPlayerSpell(self.spell)
end



function spell:casting_remains()
  local casting_name, _, _, startTime, casting_end_time, _, _, notInterruptible = UnitCastingInfo(self.unitID)
  local channel_name, _, _, startTime, channel_end_time, _, notInterruptible = UnitChannelInfo(self.unitID)
  if casting_name == C_Spell.GetSpellName(self.spell) then return casting_end_time / 1000 - GetTime() end
  if channel_name == C_Spell.GetSpellName(self.spell) then return channel_end_time / 1000 - GetTime() end
  return 0
end

function spell:castingtime()
  local name = C_Spell.GetSpellInfo(self.spell).name
  local castingTime = C_Spell.GetSpellInfo(self.spell).castTime
  if name and castingTime then
    return castingTime / 1000
  end
  return 9999
end
 
function spell:lastcast()
  local lastcast = MagicCore.tmp.fetch('lastcast', false)
  return lastcast == self.spell
end

function spell:lastcast_time()
  return lastCastTimes[self.spell] or 0
end

function spell:seen()
    if not self.spell or not lastCastTimes[self.spell] then
        return -1
    end
    return GetTime() - lastCastTimes[self.spell]
end

function spell:castable()
  local usable, noMana = IsUsableSpell(C_Spell.GetSpellName(self.spell))
  if usable then
    if self.cooldown == 0 then
      return true
    else
      return false
    end
  end
  return false
end

function spell:current()
  local _, _, _, _, _, _, _, _, casting = UnitCastingInfo(self.unitID)
  local _, _, _, _, _, _, _, channel = UnitChannelInfo(self.unitID)
  if casting then return self.spell == casting end
  if channel then return self.spell == channel end
  return false
end

function MagicCore.spell(unit)
  return setmetatable({
    unitID = unit.unitID
  }, {
    __index = function(t, k)
      local result = spell[k](t)
      return result
    end,
    __call = function(t, k)
      t.spell = k
      if tonumber(t.spell) then
		t.spell = t.spell;
      end
      return t
    end,

    __unm = function(t)
      local result = spell['cooldown'](t)
      return spell['cooldown'](t)
    end
  })
end
 



--idTIP

local LastBaa = 0;
local cleartime = 0;
local melee = 0;
local annoying = true;

local function onUpdate(self,elapsed) 
  if self.time < GetTime() - 2 then
    if self:GetAlpha() == 0 then self:Hide() else self:SetAlpha(self:GetAlpha() - .05) end
  end
end

local messanger = CreateFrame("Frame",nil,UIParent) 
messanger:SetSize(ChatFrame1:GetWidth(),30)
messanger:Hide()
--messanger:SetScript("OnUpdate",onUpdate)
messanger:SetPoint("CENTER",0,70)
messanger.text = messanger:CreateFontString(nil,"OVERLAY","MovieSubtitleFont")
messanger.text:SetAllPoints()
messanger.texture = messanger:CreateTexture()
messanger.texture:SetAllPoints()
--messanger.time = 0

function messanger:message(message) 
  self.text:SetText(message)
  self:SetAlpha(1)
  --self.time = GetTime()
  self:Show() 
end

local MouseoverFrame = CreateFrame("Frame");
MouseoverFrame:RegisterEvent("UPDATE_MOUSEOVER_UNIT");
MouseoverFrame:SetScript("OnEvent", function(self,event,...)
	if event == "UPDATE_MOUSEOVER_UNIT" then
	    if (UnitExists("mouseover") == 1) then
		GameTooltip:ClearLines();
		GameTooltip:SetUnit("mouseover")
        local guildName, guildRank = GetGuildInfo("mouseover");
			if guildName ~= nil and guildRank ~= nil then
				--GameTooltip:AddLine("|cffffffff"..guildName);
				GameTooltip:AddLine("|cffffffffGuild Rank: "..guildRank);
				if UnitExists("mouseover-target") then
					GameTooltip:AddLine("|cffffffffTargeting: "..UnitName("mouseover-target"));
				end
				GameTooltip:Show();
			end
		end
    end
end);

local select, UnitBuff, UnitDebuff, UnitAura, tonumber, strfind, hooksecurefunc =
	select, UnitBuff, UnitDebuff, UnitAura, tonumber, strfind, hooksecurefunc

local function addLine(self,id,isItem,Caster)
	if isItem then
		self:AddDoubleLine("ItemID:","|cffffffff"..id)
	elseif Caster then
		self:AddDoubleLine("Applied by:","|cffffffff"..id)
	else
		self:AddDoubleLine("SpellID:","|cffffffff"..id)
	end
	self:Show()
end

-- Spell Hooks ----------------------------------------------------------------
hooksecurefunc(GameTooltip, "SetUnitBuff", function(self,...)
	local id = select(11,UnitBuff(...))
	local name = select(8, UnitBuff(...))
	if id then addLine(self,id) end
	if name then 
		local exactname = UnitName(name);
		addLine(self,exactname,nil,true);
	end
end)

hooksecurefunc(GameTooltip, "SetUnitDebuff", function(self,...)
	local id = select(11,UnitDebuff(...));
	local name = select(8, UnitDebuff(...));
	if id then addLine(self,id) end
	if name then 
		local exactname = UnitName(name);
		addLine(self,exactname,nil,true);
	end
end)

hooksecurefunc(GameTooltip, "SetUnitAura", function(self,...)
	local id = select(11,UnitAura(...));
	local name = select(8, UnitAura(...));
	if id then addLine(self,id) end
	if name then 
		local exactname = UnitName(name);
		addLine(self,exactname,nil,true);
	end
end)

GameTooltip:HookScript("OnTooltipSetSpell", function(self)
	local id = select(3,self:GetSpell())
	if id then addLine(self,id) end
end)

hooksecurefunc("SetItemRef", function(link, ...)
	local id = tonumber(link:match("spell:(%d+)"))
	if id then addLine(ItemRefTooltip,id) end
end)
local function addTalentIDLine(self, talentID)
    if talentID then
        self:AddDoubleLine("TalentID:", "|cffffffff" .. talentID)
        self:Show()
    end
end

hooksecurefunc(GameTooltip, "SetTalent", function(self, tab, index, ...)
    local talentID
    local link = GetTalentLink(tab, index)
    
    if link then
        local _, _, id = string.find(link, "talent:(%d+)")
        talentID = tonumber(id)
    end

    if talentID then
        addTalentIDLine(self, talentID)
    end
end)
-- Item Hooks -----------------------------------------------------------------

local function attachItemTooltip(self)
	local link = select(2,self:GetItem())
	if not link then return end
	local id = select(3,strfind(link, "^|%x+|Hitem:(%-?%d+):(%d+):(%d+):(%d+):(%d+):(%d+):(%-?%d+):(%-?%d+)"))
	if id then addLine(self,id,true) end
end

GameTooltip:HookScript("OnTooltipSetItem", attachItemTooltip)
ItemRefTooltip:HookScript("OnTooltipSetItem", attachItemTooltip)
ItemRefShoppingTooltip1:HookScript("OnTooltipSetItem", attachItemTooltip)
ItemRefShoppingTooltip2:HookScript("OnTooltipSetItem", attachItemTooltip)
ItemRefShoppingTooltip3:HookScript("OnTooltipSetItem", attachItemTooltip)
ShoppingTooltip1:HookScript("OnTooltipSetItem", attachItemTooltip)
ShoppingTooltip2:HookScript("OnTooltipSetItem", attachItemTooltip)
ShoppingTooltip3:HookScript("OnTooltipSetItem", attachItemTooltip)

SlashCmdList["READYCHECK"] = function() DoReadyCheck() end
SLASH_READYCHECK1 = '/rc'