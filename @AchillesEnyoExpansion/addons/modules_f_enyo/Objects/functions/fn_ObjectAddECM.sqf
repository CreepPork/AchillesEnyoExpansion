#include "\achilles\modules_f_ares\module_header.hpp"

_object = [_logic, false] call Ares_fnc_GetUnitUnderCursor;

if (isNull _object) exitWith {["No vehicle selected!"] call Ares_fnc_ShowZeusMessage; playSound "FD_Start_F";};

if (isPlayer _object || isPlayer driver _object) exitWith {["No vehicle selected!"] call Ares_fnc_ShowZeusMessage; playSound "FD_Start_F";};

if (_object getVariable ["isECM", false]) exitWith {["Vehicle has a ECM already!"] call Ares_fnc_ShowZeusMessage; playSound "FD_Start_F";};

if (_object isKindOf "Car" || _object isKindOf "Tank") then
{
  _dialogResult =
  [
    "Add ECM to Vehicle",
    [
      ["Add ECM", ["Yes", "No"]]
    ]
  ] call Ares_fnc_showChooseDialog;

  if (isNil "_dialogResult") exitWith {};
  if (count _dialogResult == 0) exitWith {};

  _isECM = _dialogResult select 0;

  if (_isECM == 0) then
  {
    _object setVariable ["isECM", true, true];
  };
}
else
{
  ["No vehicle selected!"] call Ares_fnc_ShowZeusMessage; playSound "FD_Start_F";
};

#include "\achilles\modules_f_ares\module_footer.hpp"
