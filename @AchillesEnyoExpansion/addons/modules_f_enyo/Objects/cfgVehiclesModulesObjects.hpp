class Enyo_Objects_Module_Base : Enyo_Module_Base
{
	category = "Objects";
	icon = "\enyo\data_f_enyo\icons\icon_object.paa";
	portrait = "\enyo\data_f_enyo\icons\icon_object.paa";
};

class Enyo_IED_Module : Enyo_Objects_Module_Base
{
	scopeCurator = 2;
	curatorCanAttach = 1;
	_generalMacro = "Enyo_IED_Module";
	displayName = "Create IED";
	function = "Enyo_fnc_ObjectIED";
};

class Enyo_AddECM_Module : Enyo_Objects_Module_Base
{
	scopeCurator = 2;
	curatorCanAttach = 1;
	_generalMacro = "Enyo_AddECM_Module";
	displayName = "Add ECM to Vehicle";
	function = "Enyo_fnc_ObjectAddECM";
};
