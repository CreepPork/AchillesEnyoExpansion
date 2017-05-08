/*
	Author: CreepPork_LV, shay_gman

	Description:
	Sets a unit to be a suicide bomber.

  Parameters:
    _this select: 0 - OBJECT - Person to be a Suicide Bomber
    _this select: 1 - STRING - Explosion Size
    _this select: 2 - NUMBER - Explosion Effect
    _this select: 3 - NUMBER - Activation Side
		_this select: 4 - STRING - Patrol Distance
*/

_bomber = _this select 0;
_explosionSize = _this select 1;
_explosionEffect = _this select 2;
_activationSide = _this select 3;
_patrolRadius = _this select 4;

_patrolRadius = parseNumber _patrolRadius;

_activationSide = switch (_activationSide) do
{
	case 1:	{[east]};
	case 2:	{[west]};
	case 3:	{[resistance]};
	default {[west]};
};


if (typeName _activationSide == typeName sideLogic) then {_activationSide = [_activationSide]};

_sound = 1;
_targets = ["Car", "Tank", "Man"];

removeAllWeapons _bomber;

_dummyObject = "Land_HelipadEmpty_F" createVehicle (getPos _bomber);
_dummyObject attachTo [_bomber,[0,0,0]];

_bomberGroup = group _bomber;
_bomberGroup setBehaviour "CARELESS";
_bomberGroup setSpeedMode "LIMITED";

if (_patrolRadius > 0) then
{
	_numberOfWaypoints = 6;
	_degreesPerWaypoint = 360 / _numberOfWaypoints;
	_centerPoint = position _bomber;
	for "_waypointNumber" from 0 to (_numberOfWaypoints - 1) do
	{
		private ["_currentDegrees"];
		_currentDegrees = _degreesPerWaypoint * _waypointNumber;
		_waypoint = _bomberGroup addWaypoint [[_centerPoint, _patrolRadius, _currentDegrees] call Bis_fnc_relPos, 5];
	};
	_waypoint = _bomberGroup addWaypoint [[_centerPoint, _patrolRadius, 0] call BIS_fnc_relPos, 5];
	_waypoint setWaypointType "CYCLE";
};

_check = true;

while {alive _bomber && _check} do
{
    sleep 1;
		_nearestObjects = (getPos _bomber) nearObjects 100;

		if ({side _x in _activationSide} count _nearestObjects > 0) then
		{
			while {(alive _bomber) && (_check)} do
			{
				sleep 1;
				_nearestUnit = [];
				{if (side _x in _activationSide) then {_nearestUnit = _nearestUnit + [_x]}} forEach _nearestObjects;
				_count = count _nearestUnit;

				for [{_x = 0}, {_x < _count}, {_x = _x + 1}] do
				{
					_enemyUnit = _nearestUnit select _x;
					{
						if (_enemyUnit isKindOf _x && alive _enemyUnit) then
						{
							_bomber setSkill 1;
							_bomber doMove (getPos _enemyUnit);
							sleep 5 + random 5;
							if ((_bomber distance _enemyUnit) < 40) then
							{
								_bomberGroup setSpeedMode "FULL";
								_bomberGroup setBehaviour "CARELESS";
								_bomber setUnitPos "UP";
								_bomber disableAI "TARGET";
								_bomber disableAI "AUTOTARGET";

								_bomberGroup setCombatMode "BLUE";
								_bomberGroup allowFleeing 0;
								while {alive _bomber} do
								{
									sleep 1;
									_bomber doMove (getPos _enemyUnit);
									_bomber addRating -10000;

									if (_sound == 1) then
									{
										[_bomber, format ["suicide%1", (floor random 4)+1]] remoteExec ["say3D", 0, _bomber];
										_sound = 0;
									};
								if ((_bomber distance _enemyUnit) <= 15) exitWith{_check = false;};
								};
						};
					};
				} forEach _targets;
			};
		};
	};
};

if (alive _bomber) then
{
	switch (_explosionEffect) do
	{
		case 0:
		{
			[getPos _bomber, _explosionSize] call Enyo_fnc_IEDDeadlyExplosion;
			_bomber setDamage 1;
		};
		case 1:
		{
		   [getPos _bomber, _explosionSize] call Enyo_fnc_IEDDisablingExplosion;
			 _bomber setDamage 1;
		};
		case 2:
		{
			[getPos _bomber] call Enyo_fnc_IEDFakeExplosion;
			_bomber setDamage 1;
		};
	};
};

deleteVehicle _dummyObject;
if (true) exitWith {};
