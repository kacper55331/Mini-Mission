// plugin natives

native ModelStartListening(port);
native ModelSocketClose();
native CheckFiles();
native ModelPlayerConnect(playerid,name[],ip[]);
native ModelPlayerDisconnect(playerid);
native PlayerReplaceCar(playerid,vehicleid);
native PlayerReplaceAllCar(playerid);
native ReturnCar(vehicleid);

//Only for my own gamemode, don't use this functions
//Только для моего игрового мода, не используйте эти функции
native SetFunctionid(Hour,Minute,Second,functionid);
native StartBeginDebug();
native ClearSecond();
////////////////////////////////////////////////////////////

// plugin callbacks

forward OnFileTransferPercentage(playerid,modelid,size,percentage);
forward OnOldVersion(playerid);

forward OnFileTransfer(playerid);
forward ModelOnPlayerConnect(playerid);
forward OnStartCopyFiles(playerid);
forward OnTimer();
forward OnTimer1MS();

static bool:Model_g_CTS = false;
static bool:Model_g_GME = false;
static bool:Model_g_OPC = false;
static bool:Model_g_OPDC = false;

public OnGameModeInit()
{
	if (!Model_g_CTS)
	{
		Model_g_CTS = true;
		Model_g_OPC = (funcidx("Model_OnPlayerConnect") != -1);
		Model_g_OPDC = (funcidx("Model_OnPlayerDisconnect") != -1);
		Model_g_GME = (funcidx("OnGameModeExit") != -1);
		CheckFiles();
		ModelStartListening(7111);
	}
	if (funcidx("Model_OnGameModeInit") != -1)
	{
		return CallLocalFunction("Model_OnGameModeInit", "");
	}
	return 1;
}

#if defined _ALS_OnGameModeInit
	#undef OnGameModeInit
#else
	#define _ALS_OnGameModeInit
#endif
#define OnGameModeInit Model_OnGameModeInit

forward Model_OnGameModeInit();


public OnPlayerConnect(playerid)
{
	if (!IsPlayerNPC(playerid))
	{
		new nametemp[MAX_PLAYER_NAME], iptemp[16];
		GetPlayerName(playerid, nametemp, sizeof(nametemp));
		GetPlayerIp(playerid, iptemp, sizeof(iptemp));
		format(nametemp[playerid],MAX_PLAYER_NAME,nametemp[playerid]);
		ModelPlayerConnect(playerid, nametemp, iptemp);
	}
	if (Model_g_OPC)
	{
		return CallLocalFunction("Model_OnPlayerConnect", "d", playerid);
	}
	return 1;
}

#if defined _ALS_OnPlayerConnect
	#undef OnPlayerConnect
#else
	#define _ALS_OnPlayerConnect
#endif
#define OnPlayerConnect Model_OnPlayerConnect

forward Model_OnPlayerConnect(playerid);

public OnPlayerDisconnect(playerid, reason)
{
	if (!IsPlayerNPC(playerid))
	{
		ModelPlayerDisconnect(playerid);
	}
	if (Model_g_OPDC)
	{
		return CallLocalFunction("Model_OnPlayerDisconnect", "dd", playerid, reason);
	}
	return 1;
}

#if defined _ALS_OnPlayerDisconnect
	#undef OnPlayerDisconnect
#else
	#define _ALS_OnPlayerDisconnect
#endif
#define OnPlayerDisconnect Model_OnPlayerDisconnect

forward Model_OnPlayerDisconnect(playerid, reason);


public OnGameModeExit()
{
	ModelSocketClose();
	if (Model_g_GME)
	{
		return CallLocalFunction("Model_OnGameModeExit", "");
	}
	return 1;
}

#if defined _ALS_OnGameModeExit
	#undef OnGameModeExit
#else
	#define _ALS_OnGameModeExit
#endif
#define OnGameModeExit Model_OnGameModeExit

forward Model_OnGameModeExit();


public OnFilterScriptInit()
{
	if (!Model_g_CTS)
	{
		Model_g_CTS = true;
		Model_g_OPC = (funcidx("Model_OnPlayerConnect") != -1);
		Model_g_OPDC = (funcidx("Model_OnPlayerDisconnect") != -1);
		Model_g_GME = (funcidx("OnGameModeExit") != -1);
		CheckFiles();
		ModelStartListening(7111);
	}
	if (funcidx("Model_OnFilterScriptInit") != -1)
	{
		return CallLocalFunction("Model_OnFilterScriptInit", "");
	}
	return 1;
}

#if defined _ALS_OnFilterScriptInit
	#undef OnFilterScriptInit
#else
	#define _ALS_OnFilterScriptInit
#endif
#define OnFilterScriptInit Model_OnFilterScriptInit

forward Model_OnFilterScriptInit();


public OnFilterScriptExit()
{
	ModelSocketClose();
	if (Model_g_GME)
	{
		return CallLocalFunction("Model_OnFilterScriptExit", "");
	}
	return 1;
}

#if defined _ALS_OnFilterScriptExit
	#undef OnFilterScriptExit
#else
	#define _ALS_OnFilterScriptExit
#endif
#define OnFilterScriptExit Model_OnFilterScriptExit

forward Model_OnFilterScriptExit();