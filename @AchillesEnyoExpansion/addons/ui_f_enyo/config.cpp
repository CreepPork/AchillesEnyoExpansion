class CfgPatches
{
	class enyo_ui_f
	{
		weapons[] = {};
		requiredVersion = 0.1;
		author = "CreepPork_LV";
		authorUrl = "https://github.com/CreepPork/AchillesEnyoExpansion";
		version = 0.0.1;
		versionStr = "0.0.1";
		versionAr[] = {0,0,1};

		units[] = {};

		requiredAddons[] =
		{
			"A3_UI_F",
			"A3_UI_F_Curator",
			"A3_Functions_F",
			"A3_Functions_F_Curator",
			"A3_Modules_F",
			"A3_Modules_F_Curator",
			"achilles_language_f",
			"achilles_functions_f_ares",
			"achilles_functions_f_achilles",
			"achilles_data_f_achilles",
			"achilles_data_f_ares",
      "achilles_settings_f"
		};
	};
};

#include "cfgFunctions.hpp"
#include "cfgResources.hpp"
#include "cfgHints.hpp"
#include "cfgMods.hpp"
