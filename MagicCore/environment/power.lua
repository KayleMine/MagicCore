local addonName, _A, MagicCore = ...

local power = { }

local Enum = {
	PowerType = {
		Mana = 0,
		Rage = 1,
		Focus = 2,
		Energy = 3,
		ComboPoints = 4,
		Runes = 5,
		RunicPower = 6,
		SoulShards = 7,
		LunarPower = 8,
		HolyPower = 9,
		Maelstrom = 11,
		Chi = 12,
		Insanity = 13,
		ArcaneCharges = 16,
		Fury = 17,
		Pain = 18,
		Essence = 19
	}
}

function power:base()
  return MagicCore.powerType(self.unit)
end

function power:mana()
 return MagicCore.powerType(self.unit, Enum.PowerType.Mana, 'mana')
end

function power:rage()
 return MagicCore.powerType(self.unit, Enum.PowerType.Rage, 'rage')
end

function power:focus()
 return MagicCore.powerType(self.unit, Enum.PowerType.Focus, 'focus')
end

function power:energy()
 return MagicCore.powerType(self.unit, Enum.PowerType.Energy, 'energy')
end

function power:combopoints()
 return MagicCore.powerType(self.unit, Enum.PowerType.ComboPoints, 'combopoints')
end

function power:runes()
 return MagicCore.powerType(self.unit, Enum.PowerType.Runes, 'runes')
end

function power:runicpower()
 return MagicCore.powerType(self.unit, Enum.PowerType.RunicPower, 'runicpower')
end

function power:soulshards()
 return MagicCore.powerType(self.unit, Enum.PowerType.SoulShards, 'soulshards')
end

function power:lunarpower()
 return MagicCore.powerType(self.unit, Enum.PowerType.LunarPower, 'lunarpower')
end

function power:astral()
 return MagicCore.powerType(self.unit, Enum.PowerType.LunarPower, 'astral')
end

function power:holypower()
 return MagicCore.powerType(self.unit, Enum.PowerType.HolyPower, 'holypower')
end

function power:maelstrom()
 return MagicCore.powerType(self.unit, Enum.PowerType.Maelstrom, 'maelstrom')
end

function power:chi()
 return MagicCore.powerType(self.unit, Enum.PowerType.Chi, 'chi')
end

function power:insanity()
 return MagicCore.powerType(self.unit, Enum.PowerType.Insanity, 'insanity')
end

function power:arcanecharges()
 return MagicCore.powerType(self.unit, Enum.PowerType.ArcaneCharges, 'arcanecharges')
end

function power:fury()
 return MagicCore.powerType(self.unit, Enum.PowerType.Fury, 'fury')
end

function power:pain()
 return MagicCore.powerType(self.unit, Enum.PowerType.Pain, 'pain')
end

function power:essence()
 return MagicCore.powerType(self.unit, Enum.PowerType.Essence, 'Essence')
end

function MagicCore.power(unit, called)
  return setmetatable({
    unit = unit,
    unitID = unit.unitID
  }, {
    __index = function(t, k)
      return power[k](t)
    end,
    __unm = function(t)
      return power['base'](t)
    end
  })
end
