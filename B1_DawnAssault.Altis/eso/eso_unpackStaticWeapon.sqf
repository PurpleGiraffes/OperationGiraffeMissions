/*
	File: eso_unpackStaticWeapon.sqf
	Author: Dean "Rocket" Hall
	Edited by: EsotericReverie

	Description:
	Function which uses a weapon team to unpack a static weapon such
	as the HMG or Mortar. Requires three personnel in the team as
	a minimum (leader, gunner, assistant).
	If given an artillery support provider, the unit will be linked
	to that and becomes available as a support option to any
	linked support requesters.

	Parameter(s):
	_this select 0: the support team group (group)
	_this select 1: location to place gun (position)
	_this select 2: location of target (position)
	_this select 3: artillery support provider to link the weapon to once it is deployed
*/
private["_group","_position","_targetPos","_provider","_leader","_units","_gunner","_assistant","_type","_weapon","_wait","_tripodBP","_dirTo"];


_group = 		[_this, 0, grpNull] call bis_fnc_param;
_position =		[_this, 1, grpNull] call bis_fnc_param;
_targetPos = 	[_this, 2, grpNull] call bis_fnc_param;
_provider = 	[_this, 3, grpNull] call bis_fnc_param;
_weapon = 		objNull;
_leader = 		leader _group;
_units = 		(units _group) - [leader _group];
_gunner = 		_units select 0;
_assistant = 	_units select 1;
_type = 		_group getVariable ["supportWeapon","B_HMG_01_F"];

// Clearing all waypoints makes it a bit more likely that people won't wander off or order gunners out of the gun etc.
while {(count (waypoints _group)) > 0}
do {
   deleteWaypoint ((waypoints _group) select 0);
};

_leader disableAI "MOVE";
_leader setUnitPos "Middle";

_assistant doMove _position;

// Assistant drops his pack
waitUntil{unitReady _assistant};
_assistant disableAI "move";
_assistant action ["PutBag", _assistant];
_assistant disableAI "MOVE";
_assistant setUnitPos "Middle";
waitUntil{unitReady _assistant};

// Then the gunner moves (in case he ran off again) over and assembles the weapon
_gunner doMove _position;
waitUntil{unitReady _gunner};
_gunner action ["Assemble", unitbackpack _gunner];
_gunner disableAI "MOVE";

_wait = true;

// Wait until the game registers the weapon as being deployed
while {_wait} do
{
	_weapon = _position nearObjects ["StaticWeapon", 10] select 0;
	if (alive _weapon) then {_wait = false};
	sleep 1;
};

// Man the weapon, face it the right way
_tripodBP = nearestObject [_position,"B_HMG_01_support_F"];
_weapon = nearestObject [_position,"StaticWeapon"];
_dirTo = [position _weapon,_targetPos] call BIS_fnc_dirTo;
_weapon setDir _dirTo;
deleteVehicle _tripodBP;
sleep 2;
_group setVariable ["supportWeaponSetup",_weapon];
sleep 1;
_gunner assignAsGunner _weapon;
_gunner moveInGunner _weapon;
_gunner commandWatch _targetPos;
_leader selectWeapon "Binocular";
´´
// Leader watches in direction of target position
sleep 6;
_leader disableAI "ANIM";
_leader commandWatch _targetPos;
_dirTo = [position _leader,_targetPos] call BIS_fnc_dirTo;
_leader setDir _dirTo;´´
_gunner assignAsGunner _weapon;
_gunner moveInGunner _weapon;


// Sync with the artillery provider if one was passed as a parameter
if (count _this > 3) then {
	_provider synchronizeObjectsAdd [_weapon];
	_gunner synchronizeObjectsAdd [_provider];
	// Ask the server to refresh available supports
	BIS_supp_refresh = TRUE; publicVariable "BIS_supp_refresh";
};
