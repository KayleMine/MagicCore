local addonName, _A, MagicCore = ...
MagicCore.keybinds = MagicCore.keybinds or {}
local keybinds = MagicCore.keybinds

local vKeyCodes = {
	["BACK"]=8, ["TAB"]=9, ["CLEAR"]=12, ["RETURN"]=13, ["SHIFT"]=16, ["CONTROL"]=17, ["MENU"]=18, ["PAUSE"]=19, ["CAPITAL"]=20, ["ESCAPE"]=27, ["SPACE"]=32,
	["PRIOR"]=33, ["NEXT"]=34, ["END"]=35, ["HOME"]=36, ["LEFT"]=37, ["UP"]=38, ["RIGHT"]=39, ["DOWN"]=40,
	["SELECT"]=41, ["PRINT"]=42, ["EXECUTE"]=43, ["SNAPSHOT"]=44, ["INSERT"]=45, ["DELETE"]=46, ["HELP"]=47,
	["0"]=48, ["1"]=49, ["2"]=50, ["3"]=51, ["4"]=52, ["5"]=53, ["6"]=54, ["7"]=55, ["8"]=56, ["9"]=57,
	["A"]=65, ["B"]=66, ["C"]=67, ["D"]=68, ["E"]=69, ["F"]=70, ["G"]=71, ["H"]=72, ["I"]=73, ["J"]=74, ["K"]=75, ["L"]=76, ["M"]=77, ["N"]=78, ["O"]=79, ["P"]=80, ["Q"]=81, ["R"]=82,
	["S"]=83, ["T"]=84, ["U"]=85, ["V"]=86, ["W"]=87, ["X"]=88, ["Y"]=89, ["Z"]=90,
	["LWIN"]=91, ["RWIN"]=92, ["APPS"]=93,
	["NUMPAD0"]=96, ["NUMPAD1"]=97, ["NUMPAD2"]=98, ["NUMPAD3"]=99, ["NUMPAD4"]=100, ["NUMPAD5"]=101, ["NUMPAD6"]=102, ["NUMPAD7"]=103, ["NUMPAD8"]=104, ["NUMPAD9"]=105,
	["MULTIPLY"]=106, ["ADD"]=107, ["SEPARATOR"]=108, ["SUBTRACT"]=109, ["DECIMAL"]=110, ["DIVIDE"]=111,
	["F1"]=112, ["F2"]=113, ["F3"]=114, ["F4"]=115, ["F5"]=116, ["F6"]=117, ["F7"]=118, ["F8"]=119, ["F9"]=120, ["F10"]=121, ["F11"]=122, ["F12"]=123,
	["NUMLOCK"]=144, ["SCROLL"]=145,
	["LSHIFT"]=160, ["RSHIFT"]=161, ["LCONTROL"]=162, ["RCONTROL"]=163, ["LMENU"]=164, ["RMENU"]=165,
	["MOUSE1"]=1001, ["MOUSE2"]=1002, ["MOUSE3"]=1003,
	["LALT"]=2001, ["RALT"]=2002, ["LEFT ALT"]=2001, ["RIGHT ALT"]=2002,
}

local keyAliases = {
	["alt"] = "LALT",
	["ctrl"] = "LCONTROL",
	["control"] = "LCONTROL",
	["shift"] = "LSHIFT",
	["left alt"] = "LALT",
	["right alt"] = "RALT",
	["left ctrl"] = "LCONTROL",
	["right ctrl"] = "RCONTROL",
	["left shift"] = "LSHIFT",
	["right shift"] = "RSHIFT",
}


keybinds.IsPressed(key)
	if not key then return false end
	key = key:upper()
	if keyAliases[key:lower()] then
		key = keyAliases[key:lower()]
	end
	local code = vKeyCodes[key]
	if not code then
		return false
	end
	return _A.keybinds:keyup(code)
end
