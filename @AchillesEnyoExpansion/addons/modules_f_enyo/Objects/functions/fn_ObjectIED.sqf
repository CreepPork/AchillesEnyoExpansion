/*
	Author: CreepPork_LV, shay_gman

	Description:
	 Makes a object / unit an IED.

  Parameters:
    NONE
*/

#include "\achilles\modules_f_ares\module_header.hpp"

// Gets Module placed object.
_object = [_logic, false] call Ares_fnc_GetUnitUnderCursor;

// Displays error message if no object or unit has been selected.
if (isNull _object) exitWith {["No object selected!"] call Ares_fnc_ShowZeusMessage; playSound "FD_Start_F";};

// Displays error message if the module has been placed on top of a player.
if (isPlayer _object || isPlayer driver _object) exitWith {["No object selected!"] call Ares_fnc_ShowZeusMessage; playSound "FD_Start_F";};

// Displays error message if module has been placed on top of another IED
if (_object getVariable ["isIED", false]) exitWith {["Object is a IED already!"] call Ares_fnc_ShowZeusMessage; playSound "FD_Start_F";};

if (_object getVariable ["isSB", false]) exitWith {["Unit is an Suicide Bomber already!"] call Ares_fnc_ShowZeusMessage; playSound "FD_Start_F";};

// Sets IED functionality
if (!_object isKindOf "Man") then
{
  _dialogResult =
  [
    "Set Object as IED",
    [
      ["Explosion Size", ["Small", "Medium", "Large"]],
      ["Explosion Effect", ["Deadly", "Disabling", "Fake", "None"]],
      ["Disarm Time [s]", "", "30"],
      ["Activation Distance [m]", "", "10"],
      ["Activation Side", "SIDE"]
    ]
  ] call Ares_fnc_showChooseDialog;

  if (isNil "_dialogResult") exitWith {};
  if (count _dialogResult == 0) exitWith {};

  _object setVariable ["isIED", true, true];

  _explosionSize = _dialogResult select 0;
  _explosionEffect = _dialogResult select 1;
  _activationDistance = _dialogResult select 2;
  _activationSide = _dialogResult select 3;

  [_object, _explosionSize, _explosionEffect, _activationDistance, _activationSide] remoteExec ["Enyo_fnc_createIED", 2, false];
}
else
{
  ["No object selected!"] call Ares_fnc_ShowZeusMessage; playSound "FD_Start_F";
};

#include "\achilles\modules_f_ares\module_footer.hpp"
