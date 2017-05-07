class CfgPatches
{
	class enyo_data_f
	{
		weapons[] = {};
		requiredVersion = 0.1;
		author = "CreepPork_LV";
		authorUrl = "https://github.com/CreepPork/AchillesEnyoExpansion";
		version = 0.0.1;
		versionStr = "0.0.1";
		versionAr[] = {0,0,1};

		units[] = {};

		requiredAddons[] = {"A3_Structures_F"};

		// this prevents any patched class from requiring this addon
    addonRootClass = "A3_Structures_F";
	};
};

#include "cfgSounds.hpp"
