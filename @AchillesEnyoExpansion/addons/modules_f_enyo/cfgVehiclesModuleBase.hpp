class CfgVehicles
{
	class Logic;
	class Module_F : Logic
	{
		class ModuleDescription
		{
			class AnyPlayer;
			class AnyBrain;
			class EmptyDetector;
		};
	};
	class Enyo_Module_Base : Module_F
	{
		mapSize = 1;
		author = "CreepPork_LV";
		vehicleClass = "Modules";
		category = "Enyo";
		side = 7;

		scope = 1;
		scopeCurator = 1;

		displayName = "Enyo Module Base";
		icon = "\enyo\data_f_enyo\icons\icon_enyo.paa";
		picture = "\enyo\data_f_enyo\icons\icon_enyo.paa";
		portrait = "\enyo\data_f_enyo\icons\icon_enyo.paa";

		function = "";
		functionPriority = 1;
		isGlobal = 2;
		isTriggerActivated = 0;
		isDisposable = 0;

    dlc = "Enyo";

		class Arguments {};
		class ModuleDescription: ModuleDescription
		{
			description = "Enyo Module Base";
		};
	};

	class All;
	class Thing : All {};
	class ModuleEmpty_F : Thing {};

	#include "Behaviours\cfgVehiclesModulesBehaviours.hpp"
	#include "Objects\cfgVehiclesModulesObjects.hpp"
};
