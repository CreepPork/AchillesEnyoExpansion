_object = _this select 0;
_unit = _this select 1;

_random = random 1;

_unit hint "Disarming IED...";
sleep 5;

if (_random == 0) then
{
  _unit hint "IED Disarmed";
  _object setVariable ("armed", false, true);
  _object setVariable ("explode", false, true);
}
else
{
  _object setVariable ("explode", true, true);
};

exitWith {};
