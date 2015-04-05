/*
	#############################
 	#                      	  	#
	#	    Kacper Michewicz   	#
	#	 © All right reserved  	#
	#                         	#
	#############################
*/

/*----------------------------------------------------------------------------*-
Functions:
	native GetPlayerBiz(playerid);
	native SetPlayerBiz(playerid, bizid, rank);
	native RemovePlayerBiz(playerid);
	native GetPlayerOrg(playerid);
	native SetPlayerOrg(playerid, orgid, rank);
	native RemovePlayerOrg(playerid);
	native IsBizLider(playerid, bizid);
	native IsOrgLider(playerid, bizid);
	native GetPlayerOrgRank(playerid);
	native GetPlayerBizRank(playerid);
 
	native RemovePlayerItem(playerid, itemuid);
	native SendClienMessageEx(Float:radi, playerid, string[], col1, col2, col3, col4, col5, bool:echo)
-*----------------------------------------------------------------------------*/

#if defined _a_rp_included
	#endinput
#endif
#define _a_rp_included

#if !defined _samp_included
	#error "Umiesc `a_samp.inc` lub `a_npc.inc` przed includem `a_rp.inc`"
#endif

#if !defined FunctionCall
	#define FunctionCall(%0) forward _%0; public _%0 return %0
#endif

#if !defined RANK_LEADER
	#define RANK_LEADER		(255)
#endif

#if !defined IVALID_ORG_ID
	#define IVALID_ORG_ID	(0)
#endif

#if !defined IVALID_ORG_ID
	#define IVALID_BIZ_ID	(0)
#endif

native GetPlayerBiz(playerid);
/*----------------------------------------------------------------------------*-
Parametr:
	playerid	- ID gracza.
Return/Zwraca:
	Zwraca '0', je¿eli gracz nie nale¿y do biznesu.
	Zwraca 'ID biznesu', je¿eli gracz nale¿y do biznesu.
-*----------------------------------------------------------------------------*/

native SetPlayerBiz(playerid, bizid, rank);
/*----------------------------------------------------------------------------*-
Parametr:
	playerid	- ID gracza.
	bizid		- ID biznesu.
	rank		- Ranga.
Return/Zwraca:
  -
-*----------------------------------------------------------------------------*/

native RemovePlayerBiz(playerid);
/*----------------------------------------------------------------------------*-
Parametr:
	playerid	- ID gracza.
Return/Zwraca:
  -
-*----------------------------------------------------------------------------*/

native IsBizLider(playerid, bizid);
/*----------------------------------------------------------------------------*-
Parametr:
	playerid	- ID gracza.
	bizid		- ID biznesu.
Return/Zwraca:
	Funkcja zwraca '0', je¿eli gracz nie nale¿y do biznesu.
	Funkcja zwraca '1', je¿eli gracz jest liderem.
	Funkcja zwraca '2', je¿eli gracz nale¿y do biznesu, ale ma za nisk¹ rangê.
-*----------------------------------------------------------------------------*/

native GetPlayerBizRank(playerid);
/*----------------------------------------------------------------------------*-
Parametr:
	playerid	- ID gracza.
Return/Zwraca:
	Funkcja zwraca '0', je¿eli gracz nie nale¿y do biznesu.
	Funkcja zwraca 'rangê', je¿eli gracz nale¿y do biznesu.
-*----------------------------------------------------------------------------*/

native GetPlayerOrg(playerid);
/*----------------------------------------------------------------------------*-
Parametr:
	playerid	- ID gracza.
Return/Zwraca:
	Zwraca '0', je¿eli gracz nie nale¿y do organizacji.
	Zwraca 'ID biznesu', je¿eli gracz nale¿y do organizacji.
-*----------------------------------------------------------------------------*/

native SetPlayerOrg(playerid, orgid, rank);
/*----------------------------------------------------------------------------*-
Parametr:
	playerid	- ID gracza.
	orgid		- ID organizacji.
	rank		- Ranga.
Return/Zwraca:
	-
-*----------------------------------------------------------------------------*/

native RemovePlayerOrg(playerid);
/*----------------------------------------------------------------------------*-
Parametr:
	playerid	- ID gracza.
Return/Zwraca:
	-
-*----------------------------------------------------------------------------*/

native IsOrgLider(playerid, orgid);
/*----------------------------------------------------------------------------*-
Parametr:
	playerid	- ID gracza.
	orgid		- ID biznesu.
Return/Zwraca:
	Funkcja zwraca '0', je¿eli gracz nie nale¿y do organizacji.
	Funkcja zwraca '1', je¿eli gracz jest liderem.
	Funkcja zwraca '2', je¿eli gracz nale¿y do organizacji, ale ma za nisk¹ rangê.
-*----------------------------------------------------------------------------*/

native GetPlayerOrgRank(playerid);
/*----------------------------------------------------------------------------*-
Parametr:
	playerid	- ID gracza.
Return/Zwraca:
	Funkcja zwraca '0', je¿eli gracz nie nale¿y do organizacji.
	Funkcja zwraca 'rangê', je¿eli gracz nale¿y do organizacji.
-*----------------------------------------------------------------------------*/

native RemovePlayerItem(playerid, itemuid);
/*----------------------------------------------------------------------------*-
Parametr:
	playerid	- ID gracza.
	itemuid		- UID przedmiotu.
Return/Zwraca:
	-
-*----------------------------------------------------------------------------*/

native SendClienMessageEx(Float:radi, playerid, string[], col1, col2, col3, col4, col5, bool:echo=false);
/*----------------------------------------------------------------------------*-
Parametr:
	radi		- Odleg³oœæ z jak¹ ma byæ s³yszana wiadomoœæ.
	playerid	- ID gracza.
	string		- wiadomoœæ.
	col1-col5	- Kolory wiadomoœci.
	echo		- Czy (playerid) ma widzieæ swoj¹ wiadomoœæ.
		True: Gracz widzi swoj¹ wiadomoœæ.
		False: Gracz nie widzi wiadomoœci.
		
Return/Zwraca:
	-
-*----------------------------------------------------------------------------*/

forward OnPlayerRemoveItem(playerid, itemuid);