/*
	Author: CreepPork_LV

	Description:
	 Checks if ACE3 Explosives is present.

  Parameters:
    NONE

  Returns:
    True / False if present
*/

_hasACE = false;

if (isClass (configFile >> "CfgPatches" >> "ace_explosives")) then
{
  _hasACE = true;
};

_hasACE;
