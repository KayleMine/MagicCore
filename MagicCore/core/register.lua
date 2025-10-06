local addonName, _A, MagicCore = ...
local C_Spell = MagicCore.C_Spell

MagicCore.routines = MagicCore.routines or {}
MagicCore.activeRotation = nil
local env = MagicCore.Environment and MagicCore.Environment.env

function MagicCore.register(cfg)
    if not cfg.name then
        print("|cFFff0000Core:|r Rotation must have unique name")
        return
    end
    if env then
        if cfg.combat and type(cfg.combat) == 'function' then
            setfenv(cfg.combat, env)
        end
        if cfg.resting and type(cfg.resting) == 'function' then
            setfenv(cfg.resting, env)
        end
        if cfg.gcd and type(cfg.gcd) == 'function' then
            setfenv(cfg.gcd, env)
        end
    end

    MagicCore.routines[cfg.name] = cfg
    print("|cFF00ff00Core:|r Registered rotation: " .. cfg.name)
	local data = { id = cfg.name, label = cfg.label or cfg.name, classID = cfg.classID or class_table.None}
	 return data --cfg.name
end


function MagicCore.setActiveRotation(name)
  if MagicCore.activeRotation and MagicCore.activeRotation.name == name then
      return true 
  end
  
  local routine = MagicCore.routines[name]
  if not routine then
    print("|cFFff0000Core:|r Rotation not found: " .. tostring(name))
    return false
  end
  MagicCore.activeRotation = routine
  print("|cFF00ffffCore:|r Active rotation set -> " .. name)
  return true
end
