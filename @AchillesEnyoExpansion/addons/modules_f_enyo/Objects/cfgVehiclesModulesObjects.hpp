class Enyo_Objects_Module_Base : Enyo_Module_Base
{
	category = "Objects";
	icon = "";
	portrait = "";
};

class Enyo_IED_Module : Enyo_Objects_Module_Base
{
	scopeCurator = 2;
	curatorCanAttach = 1;
	_generalMacro = "Enyo_IED_Module";
	displayName = "Set IED";
	function = "Enyo_fnc_ObjectIED";
	icon = "\achilles\data_f_achilles\icons\icon_object.paa";
	portrait = "\achilles\data_f_achilles\icons\icon_object.paa";
};
