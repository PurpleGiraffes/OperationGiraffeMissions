enableSaving [false,false];
call compile preprocessFile "=BTC=_revive\=BTC=_revive_init.sqf";
{_x setmarkeralpha 0} foreach ["minefield","minefield_1","minefield_2","minefield_3","minefield_4","minefield_5","minefield_6","minefield_7","minefield_8","minefield_9"];
distr_grp = group fia1;
sniper_grp = group sniper1;
distr_grp setGroupId ["Distraction Team"]; sniper_grp setGroupId ["Sniper Team"];