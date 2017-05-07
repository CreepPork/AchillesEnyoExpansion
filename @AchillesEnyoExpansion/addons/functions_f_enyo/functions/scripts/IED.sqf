/*
Advance IED script by Shay_Gman 12.10
*/
private ["_dummy","_trapvolume","_IEDExplosionType","_IEDJammable","_IEDTriggerType","_trapdistance","_iedside","_targets",
		"_loop","_nearObjects","_nearTargets","_nrsd","_count","_target","_dummyMarker","_armed", "_triggered","_pos",
		"_IedExplosion","_wh","_randomChanceCREW","_explode","_targetSpeed","_isJammable","_effect","_hidden"];

_dummyObject = _this select 0;
_explosionSize = _this select 1;
_explosionEffect = _this select 2;
_activationDistance = _this select 4;
_activationSide = _this select 5;

_targets = ["Car", "Tank", "Man"];
_loop = true;
_armed = _dummyObject getVariable ["armed", true];
_triggered = _dummyObject getVariable ["iedTriggered", false];
_object = _dummyObject getVariable ["object", objNull];
_explode = false;
_targetSpeed = false;

_explosives = ["IEDLandSmall_Remote_Ammo","IEDLandBig_Remote_Ammo","IEDUrbanSmall_Remote_Ammo","IEDUrbanBig_Remote_Ammo"];

// TODO

//manual detonation
if (_IEDTriggerType in [2,4]) then	{
		while {! _triggered && _armed} do {
			_triggered 	= _dummy getvariable ["iedTrigered",false];
			_armed 		= _dummy getvariable ["armed",true];
			sleep 0.5;
		};
} else {
//Proximity or radio
	while {alive _fakeIed && !isNull _fakeIed && _loop && _armed && !_triggered} do
	{
		sleep 3;
		_triggered 	= _dummy getvariable ["iedTrigered",false];
		_armed 		= _dummy getvariable ["armed",true];

		_nearObjects = (getPos _dummy) nearObjects 150;

		if({side _x in _iedside} count _nearObjects > 0) then {
			while {(alive _fakeIed) && (_loop) && _armed && !_triggered} do {
				sleep 1;
				_triggered 	= _dummy getvariable ["iedTrigered",false];
				_armed 		= _dummy getvariable ["armed",true];

				_nearTargets = (getPos _dummy) nearObjects (_trapdistance);
				_nrsd = [];
				{if(side _x in _iedside) then {_nrsd = _nrsd + [_x]}} forEach _nearTargets;
				_count = count _nrsd;

				for [{_x=0},{_x<_count},{_x=_x+1}] do {
					//check if it's a CREW vehicle
					_target = _nrsd select _x;
					_isJammable = _target getvariable ["MCC_ECM",false];
					if(_IEDJammable && _isJammable && ((_target distance _dummy) <= 80)) then
					{
						_randomChanceCREW = random 100;
						//While CREW is near IED got only 1% per 2 second to go off
						while {((_target distance _dummy) < 80) && (_randomChanceCREW>1)} do
						{
							_randomChanceCREW = random 100;
							sleep 2;
						};
						if (_randomChanceCREW <=1) exitWith {_loop=false; _dummy setvariable ["iedTrigered",true,true];}
					};

					//If we come this far someone is near the IED
					if (_loop) then
					{
						{
							_targetSpeed = if (_IEDTriggerType==1) then {true} else {(speed _target) > 7}; //if it is radio IED speed dosen't matter
							if((_target isKindOf _x) && ((_target distance _dummy) <= _trapdistance) && _targetSpeed)exitWith {_loop=false;_dummy setvariable ["iedTrigered",true,true]};
						} forEach _targets;
					};
				};
			};
		};
	};
};

_dummyMarker = _dummy getvariable "iedMarkerName";
if (!isnil "_dummyMarker") then {[[2,compile format ["deletemarkerlocal '%1';",_dummyMarker]], "MCC_fnc_globalExecute", true, false] spawn BIS_fnc_MP};	//delete IED marker

_armed 		= _dummy getvariable ["armed",false];
_triggered 	= _dummy getvariable ["iedTrigered",false];

//Broadcast to fakeIED
_fakeIed setvariable ["armed",_armed,true];
_fakeIed setvariable ["iedTrigered",_triggered,true];

_pos=[((getposATL _fakeIed) select 0),(getposATL _fakeIed) select 1,((getPosATL _fakeIed) select 2)];	//position of the IED

switch (_IEDExplosionType) do {
	case 0:	{
		_IedExplosion = MCC_fnc_IedDeadlyExplosion;
	};

	case 1: {
	   _IedExplosion = MCC_fnc_IedDisablingExplosion;
	};

	case 2: {
	   _IedExplosion = MCC_fnc_IedFakeExplosion;
	};

	case 3: {
	   _IedExplosion = {};
	};
};

//If triger epxplosion or destroyed
if ((_armed && _triggered) || (!alive _fakeIed && _armed )) then{
	[_pos,_trapvolume] spawn _IedExplosion;
	_explode = true;
};

if (!_armed ) then {
	//If IED critical fail while trying to disarm it
	if (_triggered) then {
		sleep random 3;
		[_pos,_trapvolume] spawn _IedExplosion;
		_explode = true;
	} else {
		if (typeOf _fakeIed in _hidden) then {deleteVehicle _fakeIed};
	};
};

sleep 0.2;
if (_explode) then {
	//If IED is a car lets make it burn
	if (_fakeIed isKindOf "Car" || _fakeIed isKindOf "Wreck_Base") then {
		_fakeIed setdamage 1;
		_effect = "test_EmptyObjectForFireBig" createVehicle (getpos _fakeIed);
		_effect attachto [_fakeIed,[0,0,0]];
		_effect spawn
		{
			sleep 180 + random 360;
			while {!isnull (attachedTo _this)} do {detach _this};
			_nearObjects =  (getpos _this) nearObjects 3;
			{
				if (typeOf _x in ["test_EmptyObjectForFireBig","#particlesource","#lightpoint"]) then {deletevehicle _x};
			} foreach _nearObjects;
		};
	} else {
		if (str _IedExplosion != str {}) then {deletevehicle _fakeIed};
	};
};

//Delete helper
sleep 2;
[_dummy] spawn MCC_fnc_deleteHelper;

//fail safe give the game enough time to read the variable from it before deleting it.
sleep 1;
if (typeOf _fakeIed in _hidden) then {deletevehicle _fakeIed};

//Delete the dummyIED
deletevehicle _dummy;
