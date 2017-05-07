/*
	Author: CreepPork_LV, shay_gman

	Description:
	Creates a fake (small) explosion.

  Parameters:
    _this select: 0 - ARRAY - Spawn position
*/

_spawnPos = _this select 0;

_explosive = "SmallSecondary" createVehicle _spawnPos;
_explosive setPos _spawnPos;
