class CfgPatches
{
	class enyo_modules_f
	{
		weapons[] = {};
		requiredVersion = 0.1;
		author = "CreepPork_LV";
		authorUrl = "https://github.com/CreepPork/AchillesEnyoExpansion";
		version = 0.0.1;
		versionStr = "0.0.1";
		versionAr[] = {0,0,1};

		units[] =
		{
      "Enyo_SuicideBomber_Module",
			"Enyo_IED_Module",
			"Enyo_AddECM_Module"
		};

		requiredAddons[] =
		{
			"A3_UI_F",
			"A3_UI_F_Curator",
			"A3_Functions_F",
			"A3_Functions_F_Curator",
			"A3_Modules_F",
			"A3_Modules_F_Curator",
			"A3_Modules_F_Bootcamp_Misc",
			"achilles_language_f",
			"achilles_modules_f_ares",
			"achilles_functions_f_ares",
			"achilles_functions_f_achilles",
			"achilles_data_f_achilles",
			"achilles_data_f_ares",
			"enyo_language_f",
			"enyo_ui_f",
      "enyo_functions_f",
			"enyo_data_f"
		};
	};
};

#include "cfgFunctions.hpp"
#include "cfgVehiclesModuleBase.hpp"
