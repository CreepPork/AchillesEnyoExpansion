class Enyo_Behaviours_Module_Base : Enyo_Module_Base
{
	category = "Behaviours";
	icon = "";
	portrait = "";
};

class Enyo_SuicideBomber_Module : Enyo_Behaviours_Module_Base
{
	scopeCurator = 2;
	curatorCanAttach = 1;
	_generalMacro = "Enyo_SuicideBomber_Module";
	displayName = "Set Suicide Bomber";
	function = "Enyo_fnc_BehaviourSuicideBomber";
	icon = "\achilles\data_f_achilles\icons\icon_unit.paa";
	portrait = "\achilles\data_f_achilles\icons\icon_unit.paa";
};
