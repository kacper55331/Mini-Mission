#if defined ANTI_CHEAT_PLUGIN_INCLUDED

#else

#include <a_samp>
#include <a_http>
#tryinclude <GPBMAIN>

#define ANTI_CHEAT_PLUGIN_INCLUDED
#pragma library "AntiCheat"

#define AC_INCLUDE_VERSION			(22)

//#define AC_ACTION_ONMONEY_REPORT   	(0)
//#define AC_ACTION_ONMONEY_RESET    	(1)

#define AC_DETECTED_DISABLED_WEAPON (0)
#define AC_DETECTED_JETPACK 		(1)
//#define AC_DETECTED_MONEY   		(2)
#define AC_DETECTED_SPAWNED_WEAPON  (3)
#define AC_DETECTED_SPEEDHACK		(4)
#define AC_DETECTED_MASSCARSPAWN	(5)

forward AC_OnCheatDetected(playerid,cheat_type,ac_extra);

native ACget_UpdateDelay();
native ACset_UpdateDelay(ac_ticks);

native ACget_JetpackCheck();
native ACset_JetpackCheck(ac_enable = 1);
native ACget_JetpackAllowed(playerid = 0);
native ACset_JetpackAllowed(ac_allowed = 1,playerid = (-1));

native ACget_WeaponCheck();
native ACset_WeaponCheck(ac_enable = 1);
native ACset_AllowedWeapon(weaponid,ac_allowed = 1,playerid = (-1));
native ACget_AllowedWeapon(weaponid,playerid = 0);
native ACgive_PlayerWeapon(playerid, weaponid, ammo);
native ACreset_PlayerWeapons(playerid);
native ACset_SpawnWeaponCheck(enable = 1);
native ACget_SpawnWeaponCheck();

//native ACset_MoneyCheck(ac_enable = 1);
//native ACget_MoneyCheck();
//native ACget_ActionOnMoneyCheat();
//native ACset_ActionOnMoneyCheat(ac_action = 0);
//native ACget_PlayerMoney(playerid);
//native ACgive_PlayerMoney(playerid,amount);
//native ACset_PlayerMoney(playerid,amount);
//native ACreset_PlayerMoney(playerid);
//native ACfix_PlayerMoney(playerid);

native ACget_SpeedCheck();
native ACset_SpeedCheck(ac_enable = 1);

native AC_AddPlayerClass(modelid, Float:spawn_x, Float:spawn_y, Float:spawn_z, Float:z_angle, weapon1, weapon1_ammo, weapon2, weapon2_ammo, weapon3, weapon3_ammo);
native AC_AddPlayerClassEx(teamid, modelid, Float:spawn_x, Float:spawn_y, Float:spawn_z, Float:z_angle, weapon1, weapon1_ammo, weapon2, weapon2_ammo, weapon3, weapon3_ammo);

native AC_PlayerHasWeapon(playerid, weaponid);
native ACget_PlayerWeapon(playerid);

native GPB_AntiCheatVersion();
native AC_addMassTimer(playerid);
//wtf...
/*native AC_setplayerpos(playerid,Float:X,Float:Y,Float:Z) = SetPlayerPos;
SetPlayerPos(playerid,Float:X,Float:Y,Float:Z)
{
    AC_addMassTimer(playerid);
    return AC_setplayerpos(playerid,X,Y,Z);
}

native AC_removeplayerfromvehicle(playerid) = RemovePlayerFromVehicle;
RemovePlayerFromVehicle(playerid)
{
	AC_addMassTimer(playerid);
	return AC_removeplayerfromvehicle(playerid);
}

native AC_putplayerinvehicle(playerid,vehicleid,seatid) = PutPlayerInVehicle;
PutPlayerInVehicle(playerid,vehicleid,seatid)
{
	AC_addMassTimer(playerid);
	return AC_putplayerinvehicle(playerid,vehicleid,seatid);
}*/

stock AC_SetPlayerPos(playerid,Float:X,Float:Y,Float:Z)
{
    AC_addMassTimer(playerid);
    return SetPlayerPos(playerid,X,Y,Z);
}

stock AC_SetPlayerPosFindZ(playerid,Float:X,Float:Y,Float:Z)
{
    AC_addMassTimer(playerid);
    return SetPlayerPosFindZ(playerid,X,Y,Z);
}

stock AC_RemovePlayerFromVehicle(playerid)
{
	AC_addMassTimer(playerid);
	return RemovePlayerFromVehicle(playerid);
}

stock AC_PutPlayerInVehicle(playerid,vehicleid,seatid)
{
	AC_addMassTimer(playerid);
	return PutPlayerInVehicle(playerid,vehicleid,seatid);
}

native ACset_SpeedCarChangeCheck(enable = 1, miliseconds = 110);//Anti speed car change to prevent car spawn
//
//native SetPlayerMoney(playerid, money);
/*stock SetPlayerMoney(playerid, money)
{
    return GivePlayerMoney(playerid,money-GetPlayerMoney(playerid));
}*/

/*
#if defined GivePlayerWeapon
	#error You already have GivePlayerWeapon defined somewhere, aborting script compilation due to incompatibility
#endif

#if defined ResetPlayerWeapons
	#error You already have ResetPlayerWeapons defined somewhere, aborting script compilation due to incompatibility
#endif

#if defined GetPlayerMoney
	#error You already have GetPlayerMoney defined somewhere, aborting script compilation due to incompatibility
#endif

#if defined GivePlayerMoney
	#error You already have GivePlayerMoney defined somewhere, aborting script compilation due to incompatibility
#endif

#if defined ResetPlayerMoney
	#error You already have ResetPlayerMoney defined somewhere, aborting script compilation due to incompatibility
#endif

#if defined AddPlayerClass
	#error You already have AddPlayerClass defined somewhere, aborting script compilation due to incompatibility
#endif

#if defined AddPlayerClassEx
	#error You already have AddPlayerClassEx defined somewhere, aborting script compilation due to incompatibility
#endif

#if defined GetPlayerWeapon
	#error You already have GetPlayerWeapon defined somewhere, aborting script compilation due to incompatibility
#endif

#if defined SetPlayerPos
	#error You already have SetPlayerPos defined somewhere, aborting script compilation due to incompatibility
#endif

#if defined PutPlayerInVehicle
	#error You already have PutPlayerInVehicle defined somewhere, aborting script compilation due to incompatibility
#endif

#if defined RemovePlayerFromVehicle
	#error You already have RemovePlayerFromVehicle defined somewhere, aborting script compilation due to incompatibility
#endif

#if defined SetPlayerPosFindZ
	#error You already have SetPlayerPosFindZ defined somewhere, aborting script compilation due to incompatibility
#endif
*/

#define GivePlayerWeapon ACgive_PlayerWeapon
#define ResetPlayerWeapons ACreset_PlayerWeapons
#define AddPlayerClass AC_AddPlayerClass
#define AddPlayerClassEx AC_AddPlayerClassEx
#define GetPlayerWeapon ACget_PlayerWeapon
#define SetPlayerPos AC_SetPlayerPos
#define PutPlayerInVehicle AC_PutPlayerInVehicle
#define RemovePlayerFromVehicle AC_RemovePlayerFromVehicle
#define SetPlayerPosFindZ AC_SetPlayerPosFindZ
//

/* below is the plugin callback support code, you really shouldn't touch this */

#if defined FILTERSCRIPT

public OnFilterScriptInit()
{
	#if defined GPB_libGLOBAL_included
	privGPB_AddUpdatecheck("AC",2,GPB_AntiCheatVersion(),AC_INCLUDE_VERSION);
	#endif
	return CallLocalFunction("call_antCh_OnFilterScriptInit","");
}

#if defined _ALS_OnFilterScriptInit
	#undef OnFilterScriptInit
#else
	#define _ALS_OnFilterScriptInit
#endif

#define OnFilterScriptInit call_antCh_OnFilterScriptInit
forward call_antCh_OnFilterScriptInit();

#else

public OnGameModeInit()
{
    #if defined GPB_libGLOBAL_included
    privGPB_AddUpdatecheck("AC",2,GPB_AntiCheatVersion(),AC_INCLUDE_VERSION);
    #endif
	return CallLocalFunction("call_antCh_OnGameModeInit","");
}

#if defined _ALS_OnGameModeInit
	#undef OnGameModeInit
#else
	#define _ALS_OnGameModeInit
#endif

#define OnGameModeInit call_antCh_OnGameModeInit
forward call_antCh_OnGameModeInit();

#endif

native AC_OnPlayerConnect(playerid);
native AC_OnPlayerDisconnect(playerid, reason);
native AC_OnPlayerSpawn(playerid);
native AC_OnPlayerStateChange(playerid, newstate, oldstate);
public OnPlayerConnect(playerid)
{
    AC_OnPlayerConnect(playerid);
	return CallLocalFunction("call_AC_OnPlayerConnect","d",playerid);
}

#if defined _ALS_OnPlayerConnect
	#undef OnPlayerConnect
#else
	#define _ALS_OnPlayerConnect
#endif

#define OnPlayerConnect call_AC_OnPlayerConnect
forward call_AC_OnPlayerConnect(playerid);

public OnPlayerDisconnect(playerid, reason)
{
    AC_OnPlayerDisconnect(playerid, reason);
	return CallLocalFunction("call_AC_OnPlayerDisconnect","dd",playerid,reason);
}

#if defined _ALS_OnPlayerDisconnect
	#undef OnPlayerDisconnect
#else
	#define _ALS_OnPlayerDisconnect
#endif

#define OnPlayerDisconnect call_AC_OnPlayerDisconnect
forward call_AC_OnPlayerDisconnect(playerid, reason);

public OnPlayerSpawn(playerid)
{
    AC_OnPlayerSpawn(playerid);
	return CallLocalFunction("call_AC_OnPlayerSpawn","d",playerid);
}

#if defined _ALS_OnPlayerSpawn
	#undef OnPlayerSpawn
#else
	#define _ALS_OnPlayerSpawn
#endif

#define OnPlayerSpawn call_AC_OnPlayerSpawn
forward call_AC_OnPlayerSpawn(playerid);

public OnPlayerStateChange(playerid, newstate, oldstate)
{
    AC_OnPlayerStateChange(playerid, newstate, oldstate);
	return CallLocalFunction("call_AC_OnPlayerStateChange","ddd",playerid, newstate, oldstate);
}

#if defined _ALS_OnPlayerStateChange
	#undef OnPlayerStateChange
#else
	#define _ALS_OnPlayerStateChange
#endif

#define OnPlayerStateChange call_AC_OnPlayerStateChange
forward call_AC_OnPlayerStateChange(playerid, newstate, oldstate);

#if defined GPB_libGLOBAL_included
	#if defined GPB_libGLOBAL_new

	#else
		#error Please update your GPBMAIN.inc file for AntiCheat to work.
	#endif
#endif

#endif
