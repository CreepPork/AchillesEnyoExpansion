/*
Advance IED script by Shay_Gman 12.10
*/

_dummyObject = _this select 0;
_explosionSize = _this select 1;
_explosionEffect = _this select 2;
_activationDistance = _this select 3;
_activationSide = _this select 4;
_activationType = _this select 5;
_isJammable = _this select 6;

_targets = ["Car", "Tank", "Man"];
_loop = true;
_armed = _dummyObject getVariable ["armed", true];
_triggered = _dummyObject getVariable ["iedTriggered", false];
_object = _dummyObject getVariable ["object", objNull];
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

// TODO: WHY THE FUCK DOES IT BLOW UP WHEN IT'S DEFUSED?!
if (_activationType == 0) then
{
	while {!_triggered} do
	{
		_triggered = _dummyObject getVariable ["iedTriggered", false];
		_armed = _dummyObject getVariable ["armed", false];
		if ((!alive _object && _armed) || (isNull _object && _armed)) then {_triggered = true; _armed = true;};
		sleep 0.5;
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

if ((_armed && _triggered) || (!alive _object && _armed )) then{
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
