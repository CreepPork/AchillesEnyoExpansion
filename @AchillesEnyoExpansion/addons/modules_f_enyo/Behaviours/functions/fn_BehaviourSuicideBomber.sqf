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
if (isNull _object) exitWith {["No unit selected!"] call Ares_fnc_ShowZeusMessage; playSound "FD_Start_F";};

// Displays error message if the module has been placed on top of a player.
if (isPlayer _object || isPlayer driver _object) exitWith {["No unit selected!"] call Ares_fnc_ShowZeusMessage; playSound "FD_Start_F";};

// Displays error message if module has been placed on top of another IED
if (_object getVariable ["isIED", false]) exitWith {["Unit is an Suicide Bomber already!"] call Ares_fnc_ShowZeusMessage; playSound "FD_Start_F";};

// Sets Suicide Bomber functionality
if (_object isKindOf "Man") then
{
  _dialogResult =
  [
    "Set Unit as a Suicide Bomber",
    [
      ["Explosion Size", ["Small", "Medium", "Large"]],
      ["Explosion Effect", ["Deadly", "Disabling", "Fake", "None"]],
      ["Activation Side", "SIDE"],
      ["Patrol Radius [m]", "", "100"]
    ]
  ] call Ares_fnc_showChooseDialog;

  if (isNil "_dialogResult") exitWith {};
  if (count _dialogResult == 0) exitWith {};

  _object setVariable ["isIED", true, true];

  _explosionSize = _dialogResult select 0;
  _explosionEffect = _dialogResult select 1;
  _activationSide = _dialogResult select 2;
  _patrolRadius = _dialogResult select 3;

  [_object, _explosionSize, _explosionEffect, _activationSide, _patrolRadius] remoteExec ["Enyo_fnc_createSuicideBomber", _object, false];
}
// Sets Vehicle-born IED functionality
else
{
  exitWith {["No unit selected!"] call Ares_fnc_ShowZeusMessage; playSound "FD_Start_F";
};

#include "\achilles\modules_f_ares\module_footer.hpp"
