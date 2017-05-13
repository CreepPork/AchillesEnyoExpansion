#define IDD_DYNAMIC_GUI 133798
#define IDC_CTRL_BASE				20000
#define IDCs_INTEL_TEXT				[10004,20004]
#define IDCs_SHARED					[10005,20005]
#define	DYNAMIC_BOTTOM_IDCs			[2010,3000,3010]

disableSerialization;
_mode = (_this select 0);
_ctrl = param [1, controlNull, [controlNull]];
_comboIndex = param [2, 0, [0]];

_dialog = findDisplay IDD_DYNAMIC_GUI;

switch (_mode) do
{
    //TODO: I have no fucking clue what I'm doing.
};
