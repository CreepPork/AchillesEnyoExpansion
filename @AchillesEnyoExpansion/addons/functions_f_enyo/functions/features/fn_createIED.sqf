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
_activationType = _this select 5;
_isJammable = _this select 6;
_disarmTime = _this select 7;
_canBeDefused = _this select 8;

_activationDistance = parseNumber _activationDistance;
_disarmTime = parseNumber _disarmTime;

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

_dummyObject setVariable ["object", _object, true];
_dummyObject setVariable ["armed", true, true];
_dummyObject setVariable ["explode", false, true];
_dummyObject setVariable ["disarmTime", _disarmTime, true];

_object setVariable ["dummyObject", _dummyObject, true];

[_dummyObject, _explosionSize, _explosionEffect, _activationDistance, _activationSide, _activationType, _isJammable, _disarmTime, _canBeDefused] spawn Enyo_fnc_IEDLogic;

[_dummyObject, _object];
