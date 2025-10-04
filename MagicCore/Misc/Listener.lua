local addonName, _A, MagicCore = ...
local onEvent = _G.onEvent
local CreateFrame = _G.CreateFrame

MagicCore.Listener = {}
local listeners = {}

local MagicCore_listener = CreateFrame('Frame')
MagicCore_listener:SetScript('OnEvent', function(_, event, ...)
    if not listeners[event] then return end
    for _, callback in pairs(listeners[event]) do
        callback(...)
    end
end)

function MagicCore.Listener:Add(name, event, callback)
    if not listeners[event] then
        MagicCore_listener:RegisterEvent(event)
        listeners[event] = {}
    end
    listeners[event][name] = callback
end

function MagicCore.Listener:Remove(name, event)
    if listeners[event] then
        listeners[event][name] = nil
    end
end

function MagicCore.Listener:Trigger(event, ...)
    onEvent(nil, event, ...)
end
