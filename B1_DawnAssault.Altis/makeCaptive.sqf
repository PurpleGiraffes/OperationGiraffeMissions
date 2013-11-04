//########################################
//Hostage-Script by Dr_Cox1911
//Version:	0.2 (modified by EsotericReverie)
//########################################

//####################
//USAGE:
//####################
//Place this in the init-line of the hostage: _null = [this, position, elevation] execVM "makeCaptive.sqf"
//Make sure to set spawnmarker(s) for the hostage and name them according to the _position array (e.g. "cap_pos0" and so on).
//####################


//####################
//DON`T CHANGE ANY CODE BELOW UNLESS YOU KNOW WHAT YOU ARE DOING!
//####################
_cap = _this select 0;
_position = _this select 1;
_elevation = _this select 2;

// Set captive position
if (isServer || isDedicated) then {
	if (count _this > 2) then
	{
		_cap setPos [_position select 0, _position select 1, _position select 2 + _elevation];
	}
	else
	{
		_cap setPos _position;
	}
};


//making the captive captive^^
_cap setCaptive true;
sleep 0.001;
removeAllWeapons _cap;
removeAllAssignedItems _cap;
removeBackpack _cap;
removeVest _cap;
_cap switchMove "UnaErcPoslechVelitele1";	//Animation for the tied hostage
_cap disableAI "autoTarget";
_cap disableAI "ANIM";
_cap setBehaviour "Careless";
_cap allowFleeing 0;
_cap disableAI "Move";


//####################
//free action
//####################
_freeCaptiveAction = _cap addaction ["Free captive", "freeCaptiveAction.sqf", [], 1, false, true, "", "(side _this) == west"];

waitUntil{not(captive _cap)};
_cap removeaction _freeCaptiveAction;
_cap disableAI "MOVE";
if (alive _cap) then
{
	player attachto [_cap,[0,-0.9,0]];
	player setdir 0;
	player switchMove "MountSide";	//Animation while untieing
	sleep 5;
	player switchmove "";
	_cap switchmove "SitStandUp";
	detach player;
	sleep 2;
	_cap enableAI "MOVE";
	_cap enableAI "autoTarget";
	_cap enableAI "ANIM";
	_cap setBehaviour "COMBAT";
	[_cap] joinsilent player;
};