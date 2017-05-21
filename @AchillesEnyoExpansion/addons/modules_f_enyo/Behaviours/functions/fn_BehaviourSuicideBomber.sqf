/*
	Author: CreepPork_LV, shay_gman

	Description:
	 Sets a unit to be an suicide bomber

  Parameters:
    _this select: 0 - OBJECT - Object that the module was placed upon
*/

#include "\achilles\modules_f_ares\module_header.hpp"

// Gets the object that the module was placed upon
_object = [_logic, false] call Ares_fnc_GetUnitUnderCursor;

// Displays error message if no object or unit has been selected.
if (isNull _object) exitWith {[localize "STR_NO_UNIT_SELECTED"] call Ares_fnc_ShowZeusMessage; playSound "FD_Start_F";};

// Displays error message if the module has been placed on top of a player.
if (isPlayer _object || isPlayer driver _object) exitWith {[localize "STR_NO_UNIT_SELECTED"] call Ares_fnc_ShowZeusMessage; playSound "FD_Start_F";};

// Displays error message if module has been placed on top of another IED
if (_object getVariable ["isIED", false]) exitWith {["Object is an IED already!"] call Ares_fnc_ShowZeusMessage; playSound "FD_Start_F";};

if (_object getVariable ["isSB", false]) exitWith {["Unit is an Suicide Bomber already!"] call Ares_fnc_ShowZeusMessage; playSound "FD_Start_F";};

// Sets Suicide Bomber functionality
if (_object isKindOf "Man") then
{
  _dialogResult =
  [
    "Set Unit as a Suicide Bomber",
    [
      ["Explosion Size", ["Small", "Medium", "Large"]],
      ["Explosion Effect", ["Deadly", "Disabling", "Fake", "None"]],
      ["Activation Distance [m]", "", "10"],
      ["Patrol Radius [m]", "", "100"],
      ["Activation Side", "SIDE"]
    ]
  ] call Ares_fnc_showChooseDialog;

  if (isNil "_dialogResult") exitWith {};
  if (count _dialogResult == 0) exitWith {};

  _object setVariable ["isSB", true, true];

  _explosionSize = _dialogResult select 0;
  _explosionEffect = _dialogResult select 1;
  _activationDistance = _dialogResult select 2;
  _patrolRadius = _dialogResult select 3;
  _activationSide = _dialogResult select 4;

  [_object, _explosionSize, _explosionEffect, _activationSide, _patrolRadius, _activationDistance] remoteExec ["Enyo_fnc_createSuicideBomber", _object, false];
}
else
{
  ["Objects not allowed! Use the Create IED module instead!"] call Ares_fnc_ShowZeusMessage; playSound "FD_Start_F";
};

#include "\achilles\modules_f_ares\module_footer.hpp"
