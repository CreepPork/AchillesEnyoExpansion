class Enyo_Behaviours_Module_Base : Enyo_Module_Base
{
	category = "Behaviours";
	icon = "\enyo\data_f_enyo\icons\icon_unit.paa";
	portrait = "\enyo\data_f_enyo\icons\icon_unit.paa";
};

class Enyo_SuicideBomber_Module : Enyo_Behaviours_Module_Base
{
	scopeCurator = 2;
	curatorCanAttach = 1;
	_generalMacro = "Enyo_SuicideBomber_Module";
	displayName = "$STR_ENYO_SET_SUICIDE_BOMBER";
	function = "Enyo_fnc_BehaviourSuicideBomber";
};
