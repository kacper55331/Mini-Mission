/*----------------------------------------------------------------------------
			===================================
			Callback Event (c) 2010 by Logitech
			===================================
----------------------------------------------------------------------------*/
#if defined _e_included
	#endinput
#endif	
#define _e_included

#include "foreach.inc"

// Type of events:
#define playerConnect 		1
#define playerDisconnect 	2
#define playerDeath			3
#define playerSpawn			4
#define playerText			5
#define playerUpdate		6
#define playerClickPlayer 	7
#define playerDialog      8

// End type of events


#define MAX_EVENT 128
#define MAX_GEVENTS 2048

#define addEvent(%1,%2); \
	forward e_%1(); \
	public e_%1() \
	{ \
		add(%2); \
	} 
		

enum cEvents
{
	etype,
	ecallback[128]
}

new Event[MAX_GEVENTS][cEvents];
new Events = 0;
new cname[128];

// variable to foreach
new Iterator:playerConn<MAX_EVENT>;
new Iterator:playerDisconn<MAX_EVENT>;
new Iterator:playerDeat<MAX_EVENT>;
new Iterator:playerSpaw<MAX_EVENT>;
new Iterator:playerTex<MAX_EVENT>;
new Iterator:playerUpdat<MAX_EVENT>;
new Iterator:playerClickPlaye<MAX_EVENT>;
new Iterator:playerDialo<MAX_EVENT>;


stock add(type, callback[])
{
	format(cname, 128, "%s", callback);
	Events++;
	Event[Events][etype] = type;
	Event[Events][ecallback] = cname;
	printf("[EventsINC] Handle:%d, %s", Events, cname);
	if(type == playerConnect)
	{
		Iter_Add(playerConn, Events);

	}
	else if(type == playerDisconnect)
	{
		Iter_Add(playerDisconn, Events);
	}
	else if(type == playerDeath)
	{
		Iter_Add(playerDeat, Events);
	}
	else if(type == playerSpawn)
	{
		Iter_Add(playerSpaw, Events);
	}
	else if(type == playerText)
	{
		Iter_Add(playerTex, Events);
	}
	else if(type == playerUpdate)
	{
		Iter_Add(playerUpdat, Events);
	}
	else if(type == playerClickPlayer)
	{
		Iter_Add(playerClickPlaye, Events);
	}
	else if(type == playerDialog)
	{
    Iter_Add(playerDialo, Events);
	}

} 

#if defined FILTERSCRIPT

public OnFilterScriptInit()
{
    return CallLocalFunction("e_OnFilterScriptInit", "");
}

#if defined _ALS_OnFilterScriptInit
    #undef OnFilterScriptInit
#else
    #define _ALS_OnFilterScriptInit
#endif
#define OnFilterScriptInit e_OnFilterScriptInit
forward e_OnFilterScriptInit();

#else /*not a filterscript*/

public OnGameModeInit()
{
	if (funcidx("e_OnGameModeInit") != -1)
	{
		for(new i; i<MAX_GEVENTS; i++)
		{
			new string[8];
			format(string, 8, "e_%d", i);
			if(funcidx(string) != -1)
				CallLocalFunction(string, "");
		}
		print("Events Include by Logitech has been loaded.");
		return CallLocalFunction("e_OnGameModeInit", "");
	}	
	return 1;
}

#if defined _ALS_OnGameModeInit
    #undef OnGameModeInit
#else
    #define _ALS_OnGameModeInit
#endif
#define OnGameModeInit e_OnGameModeInit
forward e_OnGameModeInit();

#endif /*if defined FILTERSCRIPT */


public OnPlayerConnect(playerid)
{
	if (funcidx("e_OnPlayerConnect") != -1)
	{
		foreach(playerConn, ev)
		{
			return CallLocalFunction(Event[ev][ecallback], "d", playerid);
		}
	}	
	return 1;
}



#if defined _ALS_OnPlayerConnect
    #undef OnPlayerConnect
#else
    #define _ALS_OnPlayerConnect
#endif
#define OnPlayerConnect e_OnPlayerConnect

forward e_OnPlayerConnect(playerid);



public OnPlayerDisconnect(playerid, reason)
{
	if (funcidx("e_OnPlayerDisconnect") != -1)
	{
		foreach(playerDisconn, ev)
		{
			return CallLocalFunction(Event[ev][ecallback], "dd", playerid, reason);
		}
	}	
	return 1;
}



#if defined _ALS_OnPlayerDisconnect
    #undef OnPlayerDisconnect
#else
    #define _ALS_OnPlayerDisconnect
#endif
#define OnPlayerDisconnect e_OnPlayerDisconnect

forward e_OnPlayerDisconnect(playerid, reason);

public OnPlayerDeath(playerid, killerid, reason)
{
	if (funcidx("e_OnPlayerDeath") != -1)
	{
		foreach(playerDeat, ev)
		{
			return CallLocalFunction(Event[ev][ecallback], "ddd", playerid, killerid, reason);
		}
	}	
	return 1;
}


#if defined _ALS_OnPlayerDeath
    #undef OnPlayerDeath
#else
    #define _ALS_OnPlayerDeath
#endif
#define OnPlayerDeath e_OnPlayerDeath

forward e_OnPlayerDeath(playerid, killerid, reason);


public OnPlayerSpawn(playerid)
{
	if (funcidx("e_OnPlayerSpawn") != -1)
	{
		foreach(playerSpaw, ev)
		{
			return CallLocalFunction(Event[ev][ecallback], "d", playerid);
		}
	}	
	return 1;
}



#if defined _ALS_OnPlayerSpawn
    #undef OnPlayerSpawn
#else
    #define _ALS_OnPlayerSpawn
#endif
#define OnPlayerSpawn e_OnPlayerSpawn

forward e_OnPlayerSpawn(playerid);




public OnPlayerText(playerid, text[])
{
	if (funcidx("e_OnPlayerText") != -1)
	{
		foreach(playerTex, ev)
		{
			return CallLocalFunction(Event[ev][ecallback], "ds", playerid, text);
		}
	}	
	return 1;
}



#if defined _ALS_OnPlayerText
    #undef OnPlayerText
#else
    #define _ALS_OnPlayerText
#endif
#define OnPlayerText e_OnPlayerText

forward e_OnPlayerText(playerid, text[]);



public OnPlayerUpdate(playerid)
{
	if (funcidx("e_OnPlayerUpdate") != -1)
	{
		foreach(playerUpdat, ev)
		{
			return CallLocalFunction(Event[ev][ecallback], "d", playerid);
		}
	}	
	return 1;
}



#if defined _ALS_OnPlayerUpdate
    #undef OnPlayerUpdate
#else
    #define _ALS_OnPlayerUpdate
#endif
#define OnPlayerUpdate e_OnPlayerUpdate

forward e_OnPlayerUpdate(playerid);



public OnPlayerClickPlayer(playerid, clickedplayerid, source)
{
	if (funcidx("e_OnPlayerClickPlayer") != -1)
	{
		foreach(playerClickPlaye, ev)
		{
			return CallLocalFunction(Event[ev][ecallback], "ddd", playerid, clickedplayerid, source);
		}
	}	
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	if (funcidx("e_OnPlayerClickPlayer") != -1)
	{
		foreach(playerDialo, ev)
		{
			return CallLocalFunction(Event[ev][ecallback], "dddds", playerid, dialogid, response, listitem, inputtext);
		}
	}	
	return 1;
}

#if defined _ALS_OnPlayerClickPlayer
    #undef OnPlayerClickPlayer
#else
    #define _ALS_OnPlayerClickPlayer
#endif
#define OnPlayerClickPlayer e_OnPlayerClickPlayer

forward e_OnPlayerClickPlayer(playerid, clickedplayerid, source);