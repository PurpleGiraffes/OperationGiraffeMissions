// Place hostages script
// Version 0.1
/*
PLACE HOSTAGES:
	Spawns a given number of hostages picked from a list of available units, into one of a
	given set of positions in one of a given set of buildings, makes them captives and adds
	a "Free captive" action.

Parameters:
	this select 0: number of hostages
	this select 1: buildings and positions [[building, [pos1, pos2,..]],[building2,[pos1,pos2,..]],..]
*/
private ["_buildings","_side", "_numHostages","_hostageTypes", "_hostageType", "_buildingPos","_i","_sideHQ","_side","_hostages"];

_hostageTypes  = ["C_man_p_beggar_F_afro", "C_man_p_beggar_F_asia", "C_man_p_fugitive_F_afro", "C_man_p_fugitive_F_asia", "C_man_p_shorts_1_F_afro", "C_man_p_shorts_1_F_asia", "C_man_polo_1_F_asia", "C_man_polo_1_F_afro", "C_man_polo_2_F_afro", "C_man_polo_2_F_asia", "C_man_polo_3_F_afro", "C_man_polo_1_F_asia", "C_man_shorts_4_F_afro", "C_man_shorts_4_F_asia"];

sleep 5;
_numHostages = [_this, 0, grpNull] call bis_fnc_param;
_buildings = [_this, 1, grpNull] call bis_fnc_param;
player sidechat format ["Creating %1 hostages...", _numHostages];

_side = civilian;
_hostages = createGroup _side;

player sidechat "Hostage group created";

for "_i" from 1 to _numHostages /* step +1 */ do
{
	player sidechat format ["Creating hostage %1",_i];
	_hostageType = _hostageTypes call BIS_fnc_selectRandom;
	_building = _buildings call BIS_fnc_selectRandom;
	_buildingPos = _building select 1 call BIS_fnc_selectRandom;
	_building = _building select 0;

	player sidechat format ["  %1: %2 @%3:%4", _i, _hostageType, _building, _buildingPos];
	_hostageType createUnit [_building buildingPos _buildingPos, _side, "_null = [this, _building buildingPos _buildingPos] execVM ""makeCaptive.sqf"""];
};

_hostages;
