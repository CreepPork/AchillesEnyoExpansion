/*
	Author: CreepPork_LV

	Description:
	 Changes the side of a unit and sets back all of its waypoints

  Note:
    Supports only the main 4 sides:
      west,
      east,
      resistance (independent),
      civilian.

  Parameters:
    _this select: 0 - ARRAY - Array of units that needs the side to be changed
    _this select: 1 - SIDE - The wanted side
*/

_units = _this select 0;
_side = _this select 1;

_unit = _units select 0;

// Fetch all old group info
_oldGroup = group _unit;
_groupID = groupID _oldGroup;

// Create the new group and set back its name
_newGroup = createGroup _side;
_newGroup setGroupIDGlobal [_groupID];

// Adds back the waypoints from the old group
_newGroup copyWaypoints _oldGroup;

// Adds the unit to the new group
[_unit] joinSilent _newGroup;
