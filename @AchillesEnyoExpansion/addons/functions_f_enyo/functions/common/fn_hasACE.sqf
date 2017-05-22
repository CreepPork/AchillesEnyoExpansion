/*
	Author: CreepPork_LV

	Description:
	 Checks if ACE3 is present.

  Parameters:
    NONE

  Returns:
    True / False if present or not
*/

_hasACE = false;

if (isClass (configFile >> "CfgPatches" >> "ace_main")) then
{
  _hasACE = true;
}

_hasACE;
