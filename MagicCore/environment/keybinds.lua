local addonName, _A, MagicCore = ...
MagicCore.keybinds = MagicCore.keybinds or {}
local keybinds = MagicCore.keybinds

local vKeyCodes = {
    -- Мышь
    ["LBUTTON"]=0x01, ["RBUTTON"]=0x02, ["MBUTTON"]=0x04,
    ["XBUTTON1"]=0x05, ["XBUTTON2"]=0x06,

    -- Управляющие
    ["BACK"]=0x08, ["TAB"]=0x09, ["RETURN"]=0x0D,
    ["SHIFT"]=0x10, ["CONTROL"]=0x11, ["MENU"]=0x12,
    ["PAUSE"]=0x13, ["CAPITAL"]=0x14, ["ESCAPE"]=0x1B, ["SPACE"]=0x20,
    ["PRIOR"]=0x21, ["NEXT"]=0x22, ["END"]=0x23, ["HOME"]=0x24,
    ["LEFT"]=0x25, ["UP"]=0x26, ["RIGHT"]=0x27, ["DOWN"]=0x28,
    ["INSERT"]=0x2D, ["DELETE"]=0x2E,

    -- Цифры и буквы
    ["0"]=0x30, ["1"]=0x31, ["2"]=0x32, ["3"]=0x33, ["4"]=0x34, ["5"]=0x35, ["6"]=0x36, ["7"]=0x37, ["8"]=0x38, ["9"]=0x39,
    ["A"]=0x41, ["B"]=0x42, ["C"]=0x43, ["D"]=0x44, ["E"]=0x45, ["F"]=0x46, ["G"]=0x47, ["H"]=0x48, ["I"]=0x49, ["J"]=0x4A,
    ["K"]=0x4B, ["L"]=0x4C, ["M"]=0x4D, ["N"]=0x4E, ["O"]=0x4F, ["P"]=0x50, ["Q"]=0x51, ["R"]=0x52, ["S"]=0x53, ["T"]=0x54,
    ["U"]=0x55, ["V"]=0x56, ["W"]=0x57, ["X"]=0x58, ["Y"]=0x59, ["Z"]=0x5A,

    -- Win / NumPad / F-клавиши
    ["LWIN"]=0x5B, ["RWIN"]=0x5C,
    ["NUMPAD0"]=0x60, ["NUMPAD1"]=0x61, ["NUMPAD2"]=0x62, ["NUMPAD3"]=0x63, ["NUMPAD4"]=0x64,
    ["NUMPAD5"]=0x65, ["NUMPAD6"]=0x66, ["NUMPAD7"]=0x67, ["NUMPAD8"]=0x68, ["NUMPAD9"]=0x69,
    ["MULTIPLY"]=0x6A, ["ADD"]=0x6B, ["SUBTRACT"]=0x6D, ["DECIMAL"]=0x6E, ["DIVIDE"]=0x6F,
    ["F1"]=0x70, ["F2"]=0x71, ["F3"]=0x72, ["F4"]=0x73, ["F5"]=0x74, ["F6"]=0x75,
    ["F7"]=0x76, ["F8"]=0x77, ["F9"]=0x78, ["F10"]=0x79, ["F11"]=0x7A, ["F12"]=0x7B,

    -- Модификаторы
    ["LSHIFT"]=0xA0, ["RSHIFT"]=0xA1, ["LCONTROL"]=0xA2, ["RCONTROL"]=0xA3,
    ["LMENU"]=0xA4, ["RMENU"]=0xA5,

    -- 🎮 Геймпад
    ["GAMEPAD_A"]=0x5800, ["GAMEPAD_B"]=0x5801, ["GAMEPAD_X"]=0x5802, ["GAMEPAD_Y"]=0x5803,
    ["GAMEPAD_DPAD_UP"]=0x5810, ["GAMEPAD_DPAD_DOWN"]=0x5811,
    ["GAMEPAD_DPAD_LEFT"]=0x5812, ["GAMEPAD_DPAD_RIGHT"]=0x5813,
    ["GAMEPAD_START"]=0x5814, ["GAMEPAD_BACK"]=0x5815,
    ["GAMEPAD_LEFT_SHOULDER"]=0x5816, ["GAMEPAD_RIGHT_SHOULDER"]=0x5817,
    ["GAMEPAD_LEFT_TRIGGER"]=0x5820, ["GAMEPAD_RIGHT_TRIGGER"]=0x5821,
}

local keyAliases = {
    -- mods
    ["alt"]="LMENU", ["lalt"]="LMENU", ["ralt"]="RMENU",
    ["ctrl"]="LCONTROL", ["lctrl"]="LCONTROL", ["rctrl"]="RCONTROL",
    ["shift"]="LSHIFT", ["lshift"]="LSHIFT", ["rshift"]="RSHIFT",

    -- mice
    ["mouse1"]="LBUTTON", ["mouse2"]="RBUTTON", ["mouse3"]="MBUTTON",

    -- gaypad
    ["a"]="GAMEPAD_A", ["b"]="GAMEPAD_B", ["x"]="GAMEPAD_X", ["y"]="GAMEPAD_Y",
    ["up"]="GAMEPAD_DPAD_UP", ["down"]="GAMEPAD_DPAD_DOWN",
    ["left"]="GAMEPAD_DPAD_LEFT", ["right"]="GAMEPAD_DPAD_RIGHT",
    ["start"]="GAMEPAD_START", ["back"]="GAMEPAD_BACK",
    ["lt"]="GAMEPAD_LEFT_TRIGGER", ["rt"]="GAMEPAD_RIGHT_TRIGGER",
    ["lb"]="GAMEPAD_LEFT_SHOULDER", ["rb"]="GAMEPAD_RIGHT_SHOULDER",
}


local function resolveKey(key)
    local lower = key:lower()
    return keyAliases[lower] or key:upper()
end

function keybinds.IsPressed(key)
    if not key or type(key) ~= "string" then return false end
    local resolved = resolveKey(key)
    local code = vKeyCodes[resolved]
    if not code then return false end
    return _A.GetKeyState(code)
end

function keybinds.IsCombo(combo)
    if not combo or type(combo) ~= "string" then return false end
    local parts = {}
    for part in combo:gmatch("[^%+]+") do
        table.insert(parts, part:match("^%s*(.-)%s*$"))
    end
    for _, key in ipairs(parts) do
        if not keybinds.IsPressed(key) then
            return false
        end
    end
    return true
end

------------------------------------------------------------
-- Примеры проверки
------------------------------------------------------------
-- Нажаты ли shift и alt вместе:
-- keybinds.IsCombo("shift+alt")
-- Ctrl+Space:
-- keybinds.IsCombo("ctrl+space")
-- Геймпад:
-- keybinds.IsCombo("a+lb")
