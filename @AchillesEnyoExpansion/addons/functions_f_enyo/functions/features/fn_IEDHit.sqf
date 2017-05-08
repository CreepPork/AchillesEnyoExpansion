_dummyObject = _this select 0;
_damage = _this select 2;
_projectile = _this select 4;
_object = _dummyObject getVariable ["object", objNull];
_return = 0;

_object setDamage ((damage _object) + _damage);
if (!alive _dummyObject || !alive _object) exitWith
{
  _dummyObject setVariable ["armed", true, true];
  _dummyObject setVariable ["iedTriggered", true, true];
  _object removeEventHandler ["HandleDamage", 0];
};

if (_projectile in ["ClaymoreDirectionalMine_Remote_Ammo","DemoCharge_Remote_Ammo","SatchelCharge_Remote_Ammo","pipebombExplosion","PipeBomb","ACE_DummyAmmo_Explosives"]) then
{
  _object setDamage 1;
  _dummyObject setVariable ["armed", true, true];
  _dummyObject setVariable ["iedTriggered", true, true];
};

_return;
