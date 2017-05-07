/*
	Author: CreepPork_LV, shay_gman

	Description:
	 Sets any object as IED.

  Parameters:
    _this select: 0 - OBJECT - IED object
    _this select: 1 - STRING - Explosion Size
    _this select: 2 - NUMBER - Explosion Effect
    _this select: 3 - STRING - Activation Distance
    _this select: 4 - NUMBER - Activation Side
*/

_object = _this select 0;
_explosionSize = _this select 1;
_explosionEffect = _this select 2;
_activationDistance = _this select 3;
_activationSide = _this select 4;

_activationDistance = parseNumber _activationDistance;

_activationSide = switch (_activationSide) do
{
  case 1: {[east]};
  case 2: {[west]};
  case 3: {[resistance]};
  default {[west]};
};

if (typeName _activationSide == typeName sideLogic) then {_activationSide = [_activationSide]};

_spawnPos = getPosATL _object;
_spawnDir = getDir _object;

_dummyObject = "Land_HelipadEmpty_F" createVehicle (_spawnPos);
_dummyObject attachTo [_object,[0,0,0]];
_dummyObject addEventHandler ["HandleDamage", {_this call Enyo_fnc_IEDHit;0}];

[_object, _dummyObject] spawn
{
  _object_1 = _this select 0;
  _dummyObject = _this select 1;
  waitUntil {!alive _object_1 || isNull _object_1};
  sleep 1;
  deleteVehicle _dummyObject;
};

_dummyObject setVariable ["object", _object, true];
_dummyObject setVariable ["armed", true, true];
_dummyObject setVariable ["explode", false, true];

_object setVariable ["dummyObject", _dummyObject, true];

[_dummyObject, ["Disarm IED", "functions_f_enyo\funtions\features\fn_disarmIED.sqf"]] remoteExec ["addAction", -2, _obj];

_handle = [_dummyObject, _explosionSize, _explosionEffect, _activationDistance, _activationSide] execVM "functions_f_enyo\scripts\IED.sqf";

[_dummyObject, _object];
