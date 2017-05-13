_object = _this select 0;
_projectile = _this select 4;
_dummyObject = _object getVariable ["dummyObject", objNull];
_activationType = _dummyObject getVariable["activationType", 0];

_explosives =
[
"ClaymoreDirectionalMine_Remote_Ammo",
"DemoCharge_Remote_Ammo",
"SatchelCharge_Remote_Ammo",
"pipebombExplosion",
"PipeBomb",
"ACE_DummyAmmo_Explosives"
];

if (_projectile in _explosives) then
{
  _object setDamage 1;
  _dummyObject setVariable ["armed", true, true];
  _dummyObject setVariable ["iedTriggered", true, true];
  [_object, [_object, 0]] remoteExec ["BIS_fnc_holdActionRemove", 0, _object];
  _object removeEventHandler["HandleDamage", 0];
};
