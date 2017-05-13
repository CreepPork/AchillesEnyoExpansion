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
if (_object isKindOf "Man") then
{
  ["Units not allowed, use Suicide Bomber module instead!"] call Ares_fnc_ShowZeusMessage; playSound "FD_Start_F";
}
else
{
  _dialogResult =
  [
    "Set Object as IED",
    [
      ["Explosion Size", ["Small", "Medium", "Large"]],
      ["Explosion Effect", ["Deadly", "Disabling", "Fake", "None"]],
      ["Can be Disarmed", ["Yes", "No"]],
      ["Disarm Time [s]", "", "10"],
      ["Activation Type", ["Manual", "Proximity", "Radio"]],
      ["Is Jammable", ["Yes", "No"]],
      ["Activation Distance [m]", "", "10"],
      ["Activation Side", "SIDE"]
    ]
  ] call Ares_fnc_showChooseDialog;

  if (isNil "_dialogResult") exitWith {};
  if (count _dialogResult == 0) exitWith {};

  _object setVariable ["isIED", true, true];

  _explosionSize = _dialogResult select 0;
  _explosionEffect = _dialogResult select 1;
  _canBeDefused = _dialogResult select 2;
  _disarmTime = _dialogResult select 3;
  _activationType = _dialogResult select 4;
  _isJammable = _dialogResult select 5;
  _activationDistance = _dialogResult select 6;
  _activationSide = _dialogResult select 7;

  [_object, _explosionSize, _explosionEffect, _activationDistance, _activationSide, _activationType, _isJammable, _disarmTime, _canBeDefused] remoteExec ["Enyo_fnc_createIED", 2, false];
};

#include "\achilles\modules_f_ares\module_footer.hpp"
