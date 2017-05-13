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

_dummyObject setVariable["activationType", _activationType, true];
[_object, ["HandleDamage", {_this call Enyo_fnc_IEDHit}]] remoteExec ["addEventHandler", _object];

_dummyObject setVariable ["object", _object, true];
_dummyObject setVariable ["armed", true, true];
_dummyObject setVariable ["explode", false, true];
_dummyObject setVariable ["disarmTime", _disarmTime, true];

_object setVariable ["dummyObject", _dummyObject, true];

_targets = ["Car", "Tank", "Man"];
_loop = true;
_armed = _dummyObject getVariable ["armed", true];
_triggered = _dummyObject getVariable ["iedTriggered", false];
_object = _dummyObject getVariable ["object", objNull];
_defused = _dummyObject getVariable ["defused", false];
_explode = false;
_targetSpeed = false;

_explosives = ["IEDLandSmall_Remote_Ammo", "IEDLandBig_Remote_Ammo", "IEDUrbanSmall_Remote_Ammo", "IEDUrbanBig_Remote_Ammo"];

switch (_isJammable) do
{
    case 0:
		{
      _isJammable = true;
    };
		case 1:
		{
			_isJammable = false;
		};
};
switch (_canBeDefused) do
{
    case 0:
    {
      _canBeDefused = true;
    };
    case 1:
    {
      _canBeDefused = false;
    };
};

if (_canBeDefused) then
{
  [
    _object,
    "Disarm",
    "\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_unbind_ca.paa",
    "\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_unbind_ca.paa",
    "_this distance _target < 3",
    "_caller distance _target < 3",
    {},
    {},
      {
        private ["_dummyObject", "_object"];
        _returnArray = _this select 3;

        _dummyObject = _returnArray select 1;
        _object = _returnArray select 0;

        _random = random 100;

        if (_random <= 70) then
        {
          systemChat "Disarmed";
          _dummyObject setVariable["armed", false, true];
          _dummyObject setVariable["iedTriggered", false, true];
          _dummyObject setVariable["defused", true, true];
          _object setVariable["armed", false, true];
          _object setVariable["iedTriggered", false, true];
          _object setVariable["defused", true, true];
          _defused = true;
        }
        else
        {
          systemChat "Failed to Disarm";
          _dummyObject setVariable["armed", true, true];
          _dummyObject setVariable["iedTriggered", true, true];
          _dummyObject setVariable["defused", false, true];
          _object setVariable["armed", true, true];
          _object setVariable["iedTriggered", true, true];
          _object setVariable["defused", false, true];
          _defused = false;
        };
      },
    {},
    [_object, _dummyObject],
    _disarmTime,
    20,
    true,
    false
  ] remoteExec ["BIS_fnc_holdActionAdd", 0, _object];
};

if (_activationType == 0) then
{
	while {!_triggered} do
	{
		_triggered = _dummyObject getVariable ["iedTriggered", false];
		_armed = _dummyObject getVariable ["armed", false];
    _defused = _dummyObject getVariable ["defused", false];

    if ((!alive _object && _armed) || (isNull _object && _armed)) then
    {
      if (_defused) then
      {
        _armed = false;
        _triggered = false;

        _dummyObject setVariable ["armed", false, true];
        _dummyObject setVariable ["iedTriggered", false, true];

        sleep 5;
        deleteVehicle _dummyObject;
      }
      else
      {
        _dummyObject setVariable ["iedTriggered", true, true];
        _triggered = true;
      };
    };
		sleep 1;
	};
}
else
{
	while {alive _object && !isNull _object && _loop && _armed && !_triggered} do
	{
		sleep 3;
		_triggered = _dummyObject getVariable ["iedTriggered", false];
		_armed = _dummyObject getVariable ["armed", true];

		_nearestObjects = (getPos _dummyObject) nearObjects 150;

		if ({side _x in _activationSide} count _nearestObjects > 0) then
		{
			while {alive _object && _loop && _armed && !_triggered} do
			{
				sleep 1;
				_nearestTarget  = (getPos _dummyObject) nearObjects (_activationDistance);
				_nearestSide = [];

				{
					if (side _x in _activationSide) then
					{
						_nearestSide = _nearestSide + [_x]
					};
				} forEach _nearestTarget;

				_howMany = count _nearestSide;

				for [{_x = 0}, {_x < _howMany}, {_x = _x + 1}] do
				{
					_target = _nearestSide select _x;
					_isJammableVehicle = _target getVariable ["isECM", false];

					if (_isJammable && _isJammableVehicle && ((_target distance _dummyObject) <= 80)) then
					{
							_random = random 100;
							while {((_target distance _dummyObject) < 80) && (_random > 1)} do
							{
								_random = random 100;
								sleep 2;
							};
							if (_random <= 1) exitWith {_loop = false; _dummyObject setVariable ["iedTriggered", true, true];};
					};

					if (_loop) then
					{
						{
							_targetSpeed = if (_activationType == 2) then {true} else {(speed _target) > 7};
							if ((_target isKindOf _x) && ((_target distance _dummyObject) <= _activationDistance) && _targetSpeed) exitWith {_loop = false; _dummyObject setVariable ["iedTriggered", true, true]};
						} forEach _targets;
					};
				};
			};
		};
	};
};

_armed = _dummyObject getVariable ["armed", false];
_triggered = _dummyObject getVariable ["iedTriggered", false];

_object setVariable ["armed", _armed, true];
_object setVariable ["iedTriggered", _triggered, true];

_spawnPos = [((getposATL _object) select 0),((getposATL _object) select 1),(((getPosATL _object) select 2) + 3)];

_explosion = {};

switch (_explosionEffect) do
{
	case 0:
	{
		_explosion = Enyo_fnc_IEDDeadlyExplosion;
	};
	case 1:
	{
	   _explosion = Enyo_fnc_IEDDisablingExplosion;
	};
	case 2:
	{
	   _explosion = Enyo_fnc_IEDFakeExplosion;
	};
	case 3:
	{
	   _explosion = {};
	};
};

if ((_armed && _triggered) || (!alive _object && _armed)) then{
	[_spawnPos, _explosionSize] spawn _explosion;
	_explode = true;
};

if (!_armed) then
{
	if (_triggered) then
	{
		sleep random 3;
		[_spawnPos, _explosionSize] spawn _explosion;
		_explode = true;
	}
	else
	{
		if (typeOf _object in _explosives) then {deleteVehicle _object};
	};
};

_object setVariable ["isIED", false, true];
_object setVariable ["armed", false, true];
_object setVariable ["iedTriggered", false, true];

sleep 2;
deleteVehicle _dummyObject;
