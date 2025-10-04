local addonName, _A, MagicCore = ...
MagicCore = MagicCore or {}
MagicCore.name = 'MagicCore'
MagicCore.version = '0'
MagicCore.color = '727bad'
MagicCore.color2 = '72ad98'
MagicCore.color3 = '96ad72'
MagicCore.ready = false
MagicCore.settings_ready = false
MagicCore.ready_callbacks = { }
function MagicCore.on_ready(callback)
  MagicCore.ready_callbacks[callback] = callback
end
