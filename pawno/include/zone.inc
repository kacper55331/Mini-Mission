/* -------------------------- Zone RP -----------------------
   Copyright by Kacper Michiewicz
   ---------------------------------------------------------- */
   
#include <a_samp>   
#include <zcmd>
#include <DUDB>
#include <a_mysql>
#include <a_audio>
#include <sscanf2>
#include <streamer>
#include <md5>
#include <foreach>
#include <gvar>

#undef  MAX_PLAYERS
#define MAX_PLAYERS 	150

#define MAX_BIZ 	  100
#define MAX_ORG 	  100
#define MAX_GAS     30
#define MAX_ANIM    180
#define MAX_LINE    64
#define MAX_DOOR    200

#define TEXT_LOGIN  "{FFFFFF}Witaj na serwerze {008000}"IN_NAME".\n{FFFFFF}Aby siê zalogowaæ wpisz poni¿ej swoje has³o i\nrozpocznij wirtualn¹ przygodê razem z nami."
#define TEXT_OOC    "{FFFFFF}Administrator {E31919}zablokowa³ Ci mo¿liwoœæ rozmowy na kanale OOC.\n\n{FFFFFF}Jeœli uwa¿asz ¿e ta kara zostala nadana bezpodstawnie, {008000}napisz apelacje na forum{FFFFFF}."
#define TEXT_BRON   "{FFFFFF}Administrator {E31919}zablokowa³ Ci mo¿liwoœæ u¿ywania broni.\n\n{FFFFFF}Jeœli uwa¿asz ¿e ta kara zostala nadana bezpodstawnie, {2F991A}napisz apelacje na forum{FFFFFF}."
#define TEXT_NOVEH  "{FFFFFF}Administrator {E31919}zablokowa³ Ci mo¿liwoœæ korzystania z aut.\n\n{FFFFFF}Jeœli uwa¿asz ¿e ta kara zostala nadana bezpodstawnie, {008000}napisz apelacje na forum{FFFFFF}."
#define TEXT_AJ     "{E31919}W tym miejscu nie mo¿esz u¿ywaæ czatu {FFFFFF}IC{E31919}!"
#define TEXT_P1     "{FFFFFF}Witamy na {008000}"IN_NAME"{FFFFFF}.\nZosta³eœ w³aœnie wci¹gniêty w wirtualny œwiat naszego serwera.\nPamiêtaj o przestrzeganiu zasad i komendzie {2F991A}/pomoc{FFFFFF}.\n¯yczymy przyjemnej rozgrywki.\n\t\t\t\t\t\tEkipa {008000}"IN_NAME""

#define IN_VERSION    "0.1 BETA"
#define IN_NAME 			"Zone Role Play"
#define IN_CITY				"Postapokaliptyczny"
#define IN_BAZA       "connect.txt"
#define IN_BOT        0 // 0 - Nie  /   1 - Tak

#define DEF_PLATE     "Zone"

#define NPC_TRAM        "tramwaj"
#define NPC_TRAM_NAME   "tramwaj"

#define isnull(%1) 		((!(%1[0])) || (((%1[0]) == '\1') && (!(%1[1]))))

#define FuncPub::%1(%2) 	  forward %1(%2);public %1(%2)
#define Cmd::Input->%1(%2)  COMMAND:%1(%2)
#define Chat::Output        SendClientMessage
#define Dialog::Output      ShowPlayerDialog

#define ShowInfo(%1,%2) 	  Dialog::Output(%1, 999, DIALOG_STYLE_MSGBOX, "{FFFFFF}"IN_NAME" "IN_VERSION"", %2, "Okey", "")
#define ShowList(%1,%2) 	  Dialog::Output(%1, 999, DIALOG_STYLE_LIST, "{FFFFFF}"IN_NAME" "IN_VERSION"", %2, "Okey", "")
#define NoPlayer(%1)		    Dialog::Output(%1, 999, DIALOG_STYLE_MSGBOX, "{FFFFFF}"IN_NAME" "IN_VERSION"", "{E31919}Nie znaleziono gracza.", "Okey", "")

#define serwerdo(%1,%2) 	  SendClientMessageEx(14.0, %1, %2, COLOR_DO, COLOR_DO2, COLOR_DO3, COLOR_DO4, COLOR_DO5)
#define serwerme(%1,%2) 	  SendClientMessageEx(14.0, %1, %2, COLOR_PURPLE, COLOR_PURPLE2, COLOR_PURPLE3, COLOR_PURPLE4, COLOR_PURPLE5)

#define PLACE_HEAD	0
#define PLACE_BODY	1
#define PLACE_HAND	2
#define PLACE_HEAD2	3
#define PLACE_ELSE	4

#define NONE		    0
#define ORG     	  1
#define ORGANIZACJA	1
#define GRACZ   	  2
#define PLAYER   	  2
#define	BOT			    3

#define NONE_T			  "0"
#define ORG_T     		"1"
#define ORGANIZACJA_T	"1"
#define GRACZ_T   		"2"
#define PLAYER_T   		"2"
#define	BOT_T			    "3"

#define DOOR_NONE		  0
#define DOOR_ORG    	3
#define DOOR_DOM    	4
#define DOOR_HOTEL  	5
#define DOOR_BANK   	6

#define MEN         	  1
#define WOMAN           2

#define PLACE_NONE		  0
#define PLACE_PLAYER	  1
#define PLACE_VEHICLE	  2
#define PLACE_HOUSE		  3
#define PLACE_ORG		    4

#define TYPE_NONE     0
#define TYPE_PLAYER   1
#define TYPE_ITEM     2
#define TYPE_VEHICLE  3
#define TYPE_LEAVE    4
#define TYPE_DOOR     5

#define RADIO_DISTANCE  100

#define KARA_SYSTEM	-1

#define AJ_NOLIMIT	999999999

#define ITEM_NONE        0 // bez funkcji
#define ITEM_WEAPON      1 // bronie        (val1 = model, val2 = ammo)
#define ITEM_RADIO       2 // Krótkofalówka (val1 = kana³)
#define ITEM_NARZEDZIA   3 // Narzêdzia     (val1 = typ, val2 = hp)
#define ITEM_PRZYBORY    4 // Przybory      (val1 = typ, val2 = iloœæ)
#define ITEM_FOOD        5 // Jedzenie      (val1 = hp, val2 = iloœæ)
#define ITEM_CLOTH       6 // Ubranie       (val1 = id skina)
#define ITEM_DRINK       7 // Napój         (val1 = id animacji, val2 = iloœæ)
#define ITEM_MEGAFONE    8 // Megafon
#define ITEM_KANISTER    9 // Kanister      (val1 = ilosc paliwa, val2 = iloœæ miejsca)
#define ITEM_AMMO       10 // Amunicja      (val1 = model broni, val2 = iloœæ);
#define ITEM_CONTAINER  11 // Torba         (val1 = pojemnoœæ)

#define MAX_ITEM_TYPE   11

#define OFFER_NONE      0   // Brak funkcji
#define OFFER_ITEM      1 	// Przedmiot
#define OFFER_VEHICLE   2 	// Pojazd
#define OFFER_ANIM   	  3	  // Animacja
#define OFFER_PAY       4	  // Zap³ata
#define OFFER_FUEL      5	  // Tankowanie
#define OFFER_FOOD      6	  // Jedzenie
#define OFFER_ORGRP		  7	  // Organizacja RP


#define P_KIJ           0
#define P_KAMIEN        1
#define P_BLASZKA       2
#define P_DREWNO        3
#define P_SZKLO         4
#define P_SZNUREK       5
#define P_PUSZKA        6
#define P_SIATKA        7
#define P_SZMATA        8
#define P_RURKA         9
#define P_SILNIK        10
#define P_METAL         11

new item_name[][] = 
{
  "Kij",          // P_KIJ
  "Kamieñ",       // P_KAMIEN
  "Blaszka",      // P_BLASZKA
  "Drewno",       // P_DREWNO
  "Szk³o",        // P_SZKLO
  "Sznurek",      // P_SZNUREK
  "Puszka",       // P_PUSZKA
  "Siatka",       // P_SIATKA
  "Szmata",       // P_SZMATA
  "Rurka",        // P_RURKA
  "Silnik",       // P_SILNIK
  "Elementy Metalowe", // P_METAL
};

#define CLR_BLACK 		  0x000000FF
#define CLR_GRAY 		    0xAFAFAFAA
#define CLR_WHITE 		  0xFFFFFFFF
#define CLR_RED 		    0xFF0000FF
#define CLR_DARKRED 	  0xCF4028FF
#define CLR_ORANGE 		  0xFFC973FF
#define CLR_DARKORANGE 	0xFDAE33FF
#define CLR_GREEN 		  0x42B542FF
#define CLR_LIGHTGREEN 	0xA8EEA8FF
#define CLR_LIGHTBLUE 	0x1E90FFFF
#define CLR_YELLOW 		  0xFFFF02FF
#define CLR_CYAN 		    0x42D3FFFF
#define CLR_DARKCYAN 	  0x59BDC6FF
#define CLR_PINK 		    0xC2A2DAFF
#define CLR_LIGHTPINK 	0xFFC3FFFF
#define CLR_NIEBIESKI 	0x688CCEAA
#define CLR_ZOLTY 		  0xFFFF00AA
#define CLR_KREMOWY 	  0xF5DEB3AA
#define CLR_ROZOWY 		  0xFFBFFFAA

#define BIALY           0xFFFFFFFF
#define COLOR_YELLOW    0xFFFF00AA
#define COLOR_FADE1     0xE6E6E6E6
#define COLOR_FADE2     0xC8C8C8C8
#define COLOR_FADE3     0xAAAAAAAA
#define COLOR_FADE4     0x8C8C8C8C
#define COLOR_FADE5     0x6E6E6E6E
#define COLOR_PURPLE 	  0xC2A2DAAA
#define COLOR_PURPLE2 	0xBB98D6FF
#define COLOR_PURPLE3 	0xAD83CDFF
#define COLOR_PURPLE4 	0xA778C9FF
#define COLOR_PURPLE5 	0x9963C0FF
#define COLOR_DO 		    0x88A2ECFF
#define COLOR_DO2 		  0x88A2ECFF
#define COLOR_DO3 		  0x6283E6FF
#define COLOR_DO4 		  0x486FE1FF
#define COLOR_DO5 		  0x3C65DFFF
#define SZARY           0xAFAFAFAA
#define RED             0xFF0000FF
#define ITEM_COLOR      0x8a5fe7aa
#define KREMOWY         0xFFBFFFAA
#define COLOR_LIGHTBLUE 0x33CCFFAA
#define ITEM_COLOR 		  0x8a5fe7aa
#define COLOR_LIGHTORANGE 0xF7A26FFF
#define GREEN 			    0x33AA33AA
#define COLOR_YELLOW    0xFFFF00AA

#define INVALID_ORG_ID		0
#define INVALID_ITEM_ID		0
#define INVALID_VEH_ID		0
#define INVALID_DOOR_ID		0
#define INVALID_ANIM_ID		0


// -- Pojazd -- //
new
    Iterator:Vehicle<MAX_VEHICLES>;

// -- Org -- //
new
    Iterator:Organisation<MAX_ORG>;

// -- Stacja -- //
new
    Iterator:Gas<MAX_GAS>;

// -- Animki -- //
new
    Iterator:Anims<MAX_ANIM>;
    
// -- Drzwi -- //
new
    Iterator:Doors<MAX_DOOR>;
	
// -- 3dtext -- //
new 
    Iterator:Textd<MAX_3DTEXT_GLOBAL>;
	
new NazwyPojazdow[212][] =
{
	"Landstalker", "Bravura", "Buffalo", "Linerunner", "Pereniel", "Sentinel", "Dumper", "Firetruck",
	"Trashmaster", "Stretch", "Manana", "Infernus", "Voodoo", "Pony", "Mule", "Cheetah",
	"Ambulans", "Leviathan", "Moonbeam", "Esperanto", "Taxi", "Washington", "Bobcat", "Mr Whoopee",
	"BF Injection", "Hunter", "Premier", "Enforcer", "Securicar", "Banshee", "Predator", "Bus",
	"Rhino", "Barracks", "Hotknife", "Trailer", "Previon", "Coach", "Cabbie", "Stallion",
	"Rumpo", "RC Bandit", "Romero", "Packer", "Monster", "Admiral", "Squalo", "Seasparrow",
	"Pizzaboy", "Tram", "Trailer", "Turismo", "Speeder", "Reefer", "Tropic", "Flatbed",
	"Yankee", "Caddy", "Solair", "Berkley's RC Van", "Skimmer", "PCJ-600", "Faggio", "Freeway",
	"RC Baron", "RC Raider", "Glendale", "Oceanic", "Sanchez", "Sparrow", "Patriot", "Quad",
	"Coastguard", "Dinghy", "Hermes", "Sabre", "Rustler", "ZR3 50", "Walton", "Regina",
	"Comet", "BMX", "Burrito", "Camper", "Marquis", "Baggage", "Dozer", "Maverick",
	"News Chopper", "Rancher", "FBI Rancher", "Virgo", "Greenwood", "Jetmax", "Hotring", "Sandking",
	"Blista Compact", "Police Maverick", "Boxville", "Benson", "Mesa", "RC Goblin", "Hotring Racer", "Hotring Racer",
	"Bloodring Banger", "Rancher", "Super GT", "Elegant", "Journey", "Bike", "Mountain Bike", "Beagle", "Cropdust",
	"Stunt", "Tanker", "RoadTrain", "Nebula", "Majestic", "Buccaneer", "Shamal", "Hydra",
	"FCR-900", "NRG-500", "HPV1000", "Cement Truck", "Tow Truck", "Fortune", "Cadrona", "FBI Truck",
	"Willard", "Forklift", "Tractor", "Combine", "Feltzer", "Remington", "Slamvan", "Blade",
	"Freight", "Streak", "Vortex", "Vincent", "Bullet", "Clover", "Sadler", "Firetruck",
	"Hustler", "Intruder", "Primo", "Cargobob", "Tampa", "Sunrise", "Merit", "Utility",
	"Nevada", "Yosemite", "Windsor", "Monster", "Monster", "Uranus", "Jester", "Sultan",
	"Stratum", "Elegy", "Raindance", "RC Tiger", "Flash", "Tahoma", "Savanna", "Bandito",
	"Freight", "Trailer", "Kart", "Mower", "Duneride", "Sweeper", "Broadway", "Tornado",
	"AT-400", "DFT-30", "Huntley", "Stafford", "BF-400", "Newsvan", "Tug", "Trailer",
	"Emperor", "Wayfarer", "Euros", "Hotdog", "Club", "Trailer", "Trailer", "Andromeda",
	"Dodo", "RC Cam", "Launch", "Police Car", "Police Car", "Police Car", "Police Ranger", "Picador",
	"S.W.A.T. Van", "Alpha", "Phoenix", "Glendale", "Sadler", "Luggage Trailer", "Luggage Trailer", "Stair Trailer",
	"Boxville", "Farm Plow", "Utility Trailer"
};

// -- Pogoda -- //
new
    Weathers[] = {9, 19, 20, 32, 43};

// -- ID broni -- //
new ObjectModel[48] =
{
	-1,
	331,
	333,
	334,
	335,
	336,
	337,
	338,
	339,
	341,
	321,
	322,
	323,
	324,
	325,
	326,
	342,
	343,
	344,
	-1,
	-1,
	-1,
	346,
	347,
	348,
	349,
	350,
	351,
	352,
	353,
	355,
	356,
	372,
	357,
	358,
	359,
	360,
	361,
	362,
	363,
	364,
	365,
	366,
	367,
	368,
	369,
	371,
	-1
};

// -- Player - Enum -- //
enum ePlayer {
	guid,
	player_uid,
	nick[MAX_PLAYER_NAME],
	aj,
	bw,
	skin,
	sex,
	age,
	pdp,
	prisontime,
	cash,
	cashinbank,
	ban,
	Float:pos_x,
	Float:pos_y,
	Float:pos_z,
	crash,
	pos_int,
	pos_vw,
	skin2,
	Float:health,
	adminlvl,
	ck,
	hours,
	minutes,
	gmlvl,
	ajreason[32],
	blockooc,
	noveh,
	run,
	drunklvl,
	bron,
	dom,
	domrank,
	audio,
	panor,
	akcent[10],
	globname[MAX_PLAYER_NAME],
	//
	radio,
	//----
	PlayerColor,
	org,
  orgrank,
	//----
	GP,
};
new PlayerData[MAX_PLAYERS][ePlayer];

// -- Veh - Enum -- //
enum eVehicles {
	vUID,
	vModel,
	Float:vX,
	Float:vY, 
	Float:vZ,
	Float:vAngle,
	Float:vPos[3],
	vColor1,
	vColor2,
	vOwnerType,
	vOwner,
	vLock,
	Float:vFuel,
	Float:vHP,
	vTow,
	vID,
	Spawned,
	engine,
	plate[64]
}
new CarInfo[MAX_VEHICLES][eVehicles];

// -- Org - Enum -- //
enum eOrganisation {
	org_uid,
	cash,
	desc[32],
	typed,
	typid,
	ooc
}
new Org[MAX_ORG][eOrganisation];

// -- Gas - Enum -- //
enum eStation {
	stat_uid,
	Float:stat_pos[3],
	stat_pos_vw,
	Float:stat_fuel
}
new Station[MAX_GAS][eStation];

// -- Ustawienia - Enum -- //
enum eUstawienia {
	Float:Spawn_Pos[4],
 	Spawn_INT,
 	Spawn_VW,
 	
 	Float:AJ_X,
 	Float:AJ_Y,
 	Float:AJ_Z,
 	AJ_INT,
};
new Ustawienia[eUstawienia];

// -- Anim - Enum -- //
enum eAnims {
	anim_id,
	anim_name[64],
	anim_animlib[64],
	anim_animname[64],
	Float:anim_speed,
	anim_opt1,
	anim_opt2,
	anim_opt3,
	anim_opt4,
	anim_opt5,
}
new Anim[MAX_ANIM][eAnims];

// -- Ofer - Enum -- //
enum eOffer {
	o_active,
	o_player,
	o_playeruid,
	o_type,
	o_price,
	o_value1,
	o_value2,
	o_value3,
	o_value4[64],
}
new Offer[MAX_PLAYERS][eOffer];

// -- Door - Enum -- //
enum eDoor
{
	door_uid,
	uniq_name[32],
	desc[32],
	closed,
	owner_type,
	owner_id,
	
	Float:inside_a,
	Float:inside_x,
	Float:inside_y,
	Float:inside_z,
	inside_int,
	inside_vw,
	
	Float:outside_a,
	Float:outside_x,
	Float:outside_y,
	Float:outside_z,
	outside_int,
	outside_vw,
	pickup_id,
	
	pickupUID,
};
new DoorInfo[MAX_DOOR][eDoor];

// -- Enum - 3dText -- //
enum eTextLabel
{
  t_uid,
  Float:t_posX,
  Float:t_posY,
  Float:t_posZ,
  t_posVW,
  t_type,
  t_typid,
  Text3D:t_id
}
new TextInfo[MAX_3DTEXT_GLOBAL][eTextLabel];

FuncPub::GetWeaponAmmo(playerid, weaponid)
{
  new 
    weap, 
    ammo,
    slot = 0;
  switch(weaponid)
  {
    case 0,1:                       slot=0;
    case 2,3,4,5,6,7,8,9:   		    slot=1;
    case 22,23,24:                  slot=2;
    case 25,26,27:                  slot=3;
    case 28,29,32:                  slot=4;
    case 30,31:                     slot=5;
    case 33,34:                     slot=6;
    case 35,36,37,38:               slot=7;
    case 16,17,18,39:               slot=8;
    case 41,42,43:                  slot=9;
    case 10,11,12,13,14,15: 		    slot=10;
    case 44,45,46:                  slot=11;
    case 40:                        slot=12;
  }
  GetPlayerWeaponData(playerid, slot, weap, ammo);
  return ammo;
}

FuncPub::GetItemValue(uid, val[], sync[])
{
	new
		str[256];
	format(str, sizeof(str), "SELECT %s FROM `1items` WHERE `iUID`=%d LIMIT 1", val, uid);
	mysql_query(str);
	mysql_store_result();
	if(mysql_num_rows() != 0) return mysql_fetch_row(sync);
    mysql_free_result();
	return INVALID_ITEM_ID;
}

FuncPub::HavePlayerItem(playerid, type)
{
	new 
    zapytanie[126];
	format(zapytanie, sizeof(zapytanie), "SELECT * FROM `1items` WHERE `iPlace` = %d AND `iOwner` = '%d' AND `iType` = '%d'", PLAYER, PlayerData[playerid][player_uid], type);
	mysql_query(zapytanie);
	mysql_store_result();
	if(mysql_num_rows() >= 1) 
	{
    mysql_free_result();
    return 1;
	}
	else 	
	{
    mysql_free_result();
    return 0;
	}
}

stock GetPlayerOrganisation(playerid) 
  return PlayerData[playerid][org];

FuncPub::Createitem(playerid, typ, val1, val2, waga, Nazwa[])
{
	new query[256];
	format(query, sizeof(query), "INSERT INTO `1items` (`iType`, `iOwner`, `iValue1`, `iValue2`, `iName`, `iPlace`, `iWeight`) VALUES ('%d', '%d', '%d', '%d', '%s', '1', '%d')", typ, PlayerData[playerid][player_uid], val1, val2, Nazwa, waga);
	mysql_query(query);
	return mysql_insert_id();
}  

stock SendClientMessageEx(Float:radi, playerid, string[], col1, col2, col3, col4, col5, bool:echo=false)
{
	if(IsPlayerConnected(playerid))
	{
		new Float:posx, Float:posy, Float:posz;
		new Float:oldposx, Float:oldposy, Float:oldposz;
		new Float:tempposx, Float:tempposy, Float:tempposz;
		GetPlayerPos(playerid, oldposx, oldposy, oldposz);
		foreach(Player, i)
		{
			if(GetPlayerVirtualWorld(playerid) == GetPlayerVirtualWorld(i))
			{
				GetPlayerPos(i, posx, posy, posz);
				tempposx = (oldposx -posx);
				tempposy = (oldposy -posy);
				tempposz = (oldposz -posz);
	        	if(echo == false)
	        	{
					if (((tempposx < radi/16) && (tempposx > -radi/16)) && ((tempposy < radi/16) && (tempposy > -radi/16)) && ((tempposz < radi/16) && (tempposz > -radi/16)))
						Chat::Output(i, col1, string);
					else if (((tempposx < radi/8) && (tempposx > -radi/8)) && ((tempposy < radi/8) && (tempposy > -radi/8)) && ((tempposz < radi/8) && (tempposz > -radi/8)))
						Chat::Output(i, col2, string);
					else if (((tempposx < radi/4) && (tempposx > -radi/4)) && ((tempposy < radi/4) && (tempposy > -radi/4)) && ((tempposz < radi/4) && (tempposz > -radi/4)))
						Chat::Output(i, col3, string);
					else if (((tempposx < radi/2) && (tempposx > -radi/2)) && ((tempposy < radi/2) && (tempposy > -radi/2)) && ((tempposz < radi/2) && (tempposz > -radi/2)))
						Chat::Output(i, col4, string);
					else if (((tempposx < radi) && (tempposx > -radi)) && ((tempposy < radi) && (tempposy > -radi)) && ((tempposz < radi) && (tempposz > -radi)))
						Chat::Output(i, col5, string);

				}
				else if(echo == true)
				{
					if(i != playerid)
					{
						if (((tempposx < radi/16) && (tempposx > -radi/16)) && ((tempposy < radi/16) && (tempposy > -radi/16)) && ((tempposz < radi/16) && (tempposz > -radi/16)))
							Chat::Output(i, col1, string);
						else if (((tempposx < radi/8) && (tempposx > -radi/8)) && ((tempposy < radi/8) && (tempposy > -radi/8)) && ((tempposz < radi/8) && (tempposz > -radi/8)))
							Chat::Output(i, col2, string);
						else if (((tempposx < radi/4) && (tempposx > -radi/4)) && ((tempposy < radi/4) && (tempposy > -radi/4)) && ((tempposz < radi/4) && (tempposz > -radi/4)))
							Chat::Output(i, col3, string);
						else if (((tempposx < radi/2) && (tempposx > -radi/2)) && ((tempposy < radi/2) && (tempposy > -radi/2)) && ((tempposz < radi/2) && (tempposz > -radi/2)))
							Chat::Output(i, col4, string);
						else if (((tempposx < radi) && (tempposx > -radi)) && ((tempposy < radi) && (tempposy > -radi)) && ((tempposz < radi) && (tempposz > -radi)))
							Chat::Output(i, col5, string);
					}
				}
			}
		}
	}
	return 1;
}

stock OdlegloscMiedzyGraczami(Float:radi, playerid, targetid)
{
	if(IsPlayerConnected(playerid)&&IsPlayerConnected(targetid))
	{
		new Float:posx, Float:posy, Float:posz;
		new Float:oldposx, Float:oldposy, Float:oldposz;
		new Float:tempposx, Float:tempposy, Float:tempposz;
		GetPlayerPos(playerid, oldposx, oldposy, oldposz);
		GetPlayerPos(targetid, posx, posy, posz);
		tempposx = (oldposx -posx);
		tempposy = (oldposy -posy);
		tempposz = (oldposz -posz);
		if (((tempposx < radi) && (tempposx > -radi)) && ((tempposy < radi) && (tempposy > -radi)) && ((tempposz < radi) && (tempposz > -radi))) return 1;
	}
	return 0;
}

stock strtoupper(string[])
{
	for(new l = 0; l < strlen(string); l++)
		string[l] = toupper(string[l]);
}

stock CharCode(playerid, zmienna=0)
{
	if(zmienna == 0) zmienna = PlayerData[playerid][player_uid];
	new text[32];
	format(text, sizeof(text), "%d", zmienna);
	new string1[32], char1[5], char2[5], char3[5], char4[4], charcode2[5];
	strmid(charcode2, MD5_Hash(text), 0, strlen(MD5_Hash(text)), 255);
	strmid(char1, charcode2[0], 0, 1, 255);
	strmid(char2, charcode2[1], 0, 1, 255);
	strmid(char3, charcode2[2], 0, 1, 255);
	strmid(char4, charcode2[3], 0, 1, 255);
	format(string1, sizeof(string1), "%s%s%s%s", char1, char2, char3, char4);
	strtoupper(string1);
	return string1;
}

stock MenOrWoman(whatid)
{
	new str[15];
	if(whatid == MEN) 			format(str, sizeof(str), "Mê¿czyzna");
	else if(whatid == WOMAN)	format(str, sizeof(str), "Kobieta");
	else 						format(str, sizeof(str), "Nieznany");
	return str;
}

stock YesOrNo(whatid)
{
	new str[4];
	if(whatid == 1) 		format(str, sizeof(str), "Tak");
	else if(whatid == 0)	format(str, sizeof(str), "Nie");
	return str;
}

stock GetVehicleMaxFuel(model)
{
	if(model == 400) return 70;
	else if(model == 401) return 52;
	else if(model == 402) return 60;
	else if(model == 403) return 400;
	else if(model == 404) return 50;
	else if(model == 405) return 52;
	else if(model == 406) return 150;
	else if(model == 407) return 250;
	else if(model == 408) return 150;
	else if(model == 409) return 110;
	else if(model == 410) return 66;
	else if(model == 411) return 66;
	else if(model == 412) return 52;
	else if(model == 413) return 80;
	else if(model == 414) return 120;
	else if(model == 415) return 76;
	else if(model == 416) return 120;
	else if(model == 417) return 408;
	else if(model == 418) return 80;
	else if(model == 419) return 72;
	else if(model == 420) return 80;
	else if(model == 421) return 82;
	else if(model == 422) return 80;
	else if(model == 423) return 90;
	else if(model == 424) return 30;
	else if(model == 425) return 500;
	else if(model == 426) return 70;
	else if(model == 427) return 120;
	else if(model == 428) return 120;
	else if(model == 429) return 68;
	else if(model == 430) return 220;
	else if(model == 431) return 315;
	else if(model == 432) return 1020;
	else if(model == 433) return 430;
	else if(model == 434) return 30;
	else if(model == 435) return 0;
	else if(model == 436) return 60;
	else if(model == 437) return 310;
	else if(model == 438) return 80;
	else if(model == 439) return 72;
	else if(model == 440) return 80;
	else if(model == 441) return 0;
	else if(model == 442) return 61;
	else if(model == 443) return 180;
	else if(model == 444) return 162;
	else if(model == 445) return 56;
	else if(model == 446) return 101;
	else if(model == 447) return 140;
	else if(model == 448) return 7;
	else if(model == 449) return 0;
	else if(model == 450) return 0 ;
	else if(model == 451) return 78;
	else if(model == 452) return 111;
	else if(model == 453) return 201;
	else if(model == 454) return 221;
	else if(model == 455) return 198;
	else if(model == 456) return 101;
	else if(model == 457) return 15;
	else if(model == 458) return 70;
	else if(model == 459) return 84;
	else if(model == 460) return 30;
	else if(model == 461) return 25;
	else if(model == 462) return 7;
	else if(model == 463) return 30;
	else if(model == 464) return 0;
	else if(model == 465) return 0;
	else if(model == 466) return 71;
	else if(model == 467) return 61;
	else if(model == 468) return 27;
	else if(model == 469) return 50;
	else if(model == 470) return 110;
	else if(model == 471) return 35;
	else if(model == 472) return 110;
	else if(model == 473) return 69;
	else if(model == 474) return 70;
	else if(model == 475) return 71 ;
	else if(model == 476) return 68;
	else if(model == 477) return 69;
	else if(model == 478) return 45;
	else if(model == 479) return 61;
	else if(model == 480) return 67;
	else if(model == 481) return 0;
	else if(model == 482) return 96;
	else if(model == 483) return 75;
	else if(model == 484) return 87;
	else if(model == 485) return 40;
	else if(model == 486) return 141;
	else if(model == 487) return 123;
	else if(model == 488) return 121;
	else if(model == 489) return 91;
	else if(model == 490) return 101;
	else if(model == 491) return 81;
	else if(model == 492) return 62;
	else if(model == 493) return 130;
	else if(model == 494) return 99;
	else if(model == 495) return 81;
	else if(model == 496) return 61;
	else if(model == 497) return 140;
	else if(model == 498) return 121;
	else if(model == 499) return 104;
	else if(model == 500) return 71;
	else if(model == 501) return 0;
	else if(model == 502) return 96;
	else if(model == 503) return 97;
	else if(model == 504) return 91;
	else if(model == 505) return 84;
	else if(model == 506) return 67;
	else if(model == 507) return 81;
	else if(model == 508) return 133;
	else if(model == 509) return 0;
	else if(model == 510) return 0;
	else if(model == 511) return 210;
	else if(model == 512) return 130;
	else if(model == 513) return 54;
	else if(model == 514) return 300;
	else if(model == 515) return 300;
	else if(model == 516) return 63;
	else if(model == 517) return 64;
	else if(model == 518) return 67;
	else if(model == 519) return 300;
	else if(model == 520) return 290;
	else if(model == 521) return 35;
	else if(model == 522) return 35;
	else if(model == 523) return 121;
	else if(model == 524) return 91;
	else if(model == 525) return 65;
	else if(model == 526) return 63;
	else if(model == 527) return 71;
	else if(model == 528) return 71;
	else if(model == 529) return 67;
	else if(model == 530) return 12;
	else if(model == 531) return 21;
	else if(model == 532) return 36;
	else if(model == 533) return 61;
	else if(model == 534) return 71;
	else if(model == 535) return 85;
	else if(model == 536) return 69;
	else if(model == 537) return 0;
	else if(model == 538) return 0;
	else if(model == 539) return 33;
	else if(model == 540) return 60;
	else if(model == 541) return 71;
	else if(model == 542) return 69;
	else if(model == 543) return 60;
	else if(model == 544) return 120;
	else if(model == 545) return 74;
	else if(model == 546) return 64;
	else if(model == 547) return 67;
	else if(model == 548) return 210;
	else if(model == 549) return 71;
	else if(model == 550) return 64;
	else if(model == 551) return 64;
	else if(model == 552) return 68;
	else if(model == 553) return 330;
	else if(model == 554) return 81;
	else if(model == 555) return 61;
	else if(model == 556) return 123;
	else if(model == 557) return 124;
	else if(model == 558) return 61;
	else if(model == 559) return 63;
	else if(model == 560) return 71;
	else if(model == 561) return 74;
	else if(model == 562) return 66;
	else if(model == 563) return 210;
	else if(model == 564) return 0;
	else if(model == 565) return 57;
	else if(model == 566) return 65;
	else if(model == 567) return 66;
	else if(model == 568) return 45;
	else if(model == 569) return 0;
	else if(model == 570) return 0;
	else if(model == 571) return 10;
	else if(model == 572) return 10;
	else if(model == 573) return 121;
	else if(model == 574) return 21;
	else if(model == 575) return 71;
	else if(model == 576) return 75;
	else if(model == 577) return 900;
	else if(model == 578) return 210;
	else if(model == 579) return 85;
	else if(model == 580) return 80;
	else if(model == 581) return 31;
	else if(model == 582) return 81;
	else if(model == 583) return 20;
	else if(model == 584) return 0;
	else if(model == 585) return 64;
	else if(model == 586) return 30;
	else if(model == 587) return 66;
	else if(model == 588) return 79;
	else if(model == 589) return 59;
	else if(model == 590) return 0;
	else if(model == 591) return 0;
	else if(model == 592) return 0;
	else if(model == 593) return 110;
	else if(model == 594) return 0;
	else if(model == 595) return 151;
	else if(model == 596) return 89;
	else if(model == 597) return 89;
	else if(model == 598) return 89;
	else if(model == 599) return 94;
	else if(model == 600) return 61;
	else if(model == 601) return 120;
	else if(model == 602) return 61;
	else if(model == 603) return 59;
	else if(model == 604) return 91;
	else if(model == 605) return 64;
	else if(model == 606) return 0;
	else if(model == 607) return 0;
	else if(model == 608) return 0;
	else if(model == 609) return 99;
	else if(model == 610) return 0;
	else if(model == 611) return 0;
	else return 0;
}

stock AntyUnderscoreToSpace(name[])
{
	new pos = strfind(name, " ", true);
	if(pos != -1)
	name[pos] = '_';
	return name;
}

stock name_add_tabs(names[])
{
	new ret[40];
	if(strlen(names) <= 8)	format(ret, sizeof(ret), "%s\t\t", names);
	else					format(ret, sizeof(ret), "%s\t", names);
	return ret;
}

stock VehicleDriverID(vehicleid)
{
	foreach(Player, i) if((IsPlayerConnected(i)) && (GetPlayerVehicleID(i) == vehicleid) && (GetPlayerState(i) == 2)) return i;
  	return -1;
}

stock IsVehicleInUse(vehicleid)
{
	if(VehicleDriverID(vehicleid) != -1) return 1;
	return 0;
}

stock GetClosestCar(playerid, Float:Prevdist=5.0)
{
	if(!IsPlayerConnected(playerid))return -1;
	new
		Prevcar;
	foreach(Vehicle, carid)
	{
		new
			Float:Dist = GetDistanceToCar(playerid, carid);
		if((Dist < Prevdist))
		{
			Prevdist = Dist;
			Prevcar = carid;
		}
	}
	return Prevcar;
}

stock GetDistanceToCar(playerid, carid)
{
	new
		Float:x1,
		Float:y1,
		Float:z1,
		Float:x2,
		Float:y2,
		Float:z2,
		Float:Dis;
	if(!IsPlayerConnected(playerid)) return -1;
	GetPlayerPos(playerid, x1, y1, z1);
	GetVehiclePos(carid, x2, y2, z2);
	Dis = floatsqroot(floatpower(floatabs(floatsub(x2,x1)),2)+floatpower(floatabs(floatsub(y2,y1)),2)+floatpower(floatabs(floatsub(z2,z1)),2));
	return floatround(Dis);
}

FuncPub::Warn(typ[], giveid, playerid, tresc[])
{

	new
		h,
		m,
		s,
		y,
		mm,
		d,
		query[256];
	getdate(y, mm, d);
	gettime(h, m, s);
 	format(query, sizeof(query), "%d/%d/%d %d:%d", y, mm, d, h, m);
	format(query, sizeof(query), "INSERT INTO `1warn` (`Type`, `Dostal`, `dostal_uid`, `Nadal`, `Powod`, `Data`) VALUES ('%s', '%d', '%d', '%d', '%s', '%s')",
	typ,
	PlayerData[giveid][player_uid],
	PlayerData[giveid][guid],
	PlayerData[playerid][player_uid],
	tresc,
	query);
	mysql_query(query);
}

stock wordwrap(givenString[128])
{
	new
		temporalString[128];
	memcpy(temporalString, givenString, 0, 128 * 4);

	new
		comaPosition = strfind(temporalString, ",", true, 0),
		dotPosition  = strfind(temporalString, ".", true, 0);
	while(comaPosition != -1)
	{
		if(temporalString[comaPosition+1] != ' ') strins(temporalString, " ", comaPosition + 1);
		comaPosition = strfind(temporalString, ",", true, comaPosition + 1);
	}
	while(dotPosition != -1)
	{
		if(temporalString[dotPosition+1] != ' ') strins(temporalString, " ", dotPosition + 1);
		dotPosition = strfind(temporalString, ",", true, dotPosition + 1);
	}

	new spaceCounter = 0,
		spacePosition = strfind(temporalString, " ", true, 0);

	while(spacePosition != -1)
	{
		spaceCounter++;
		if(spaceCounter % 4 == 0 && spaceCounter != 0)
			strins(temporalString, "\n", spacePosition + 1);
		spacePosition = strfind(temporalString, " ", true, spacePosition + 1);
	}
	return temporalString;
}

FuncPub::SprawdzCarID(carid)
{
	foreach(Vehicle, i)
		if(CarInfo[i][vID] == carid)
			return i;
	return 1;
}

FuncPub::IsAtGasStation(playerid)
{
	foreach(Gas, s)
	{
	    if(GetPlayerVirtualWorld(playerid) == Station[s][stat_pos_vw])
	    {
			if(IsPlayerInRangeOfPoint(playerid, 30.0, Station[s][stat_pos][0], Station[s][stat_pos][1], Station[s][stat_pos][2]))
				return 1;
		}
	}
	return 0;
}

stock GetItemTypeName(type)
{
    new 
      typ[16];
    if(type == ITEM_NONE) 			format(typ, sizeof(typ), "Normalny");
    else if(type == ITEM_WEAPON)	format(typ, sizeof(typ), "Broñ");
    else if(type == ITEM_RADIO)		format(typ, sizeof(typ), "Krótkofalówka");
  	else if(type == ITEM_NARZEDZIA) format(typ, sizeof(typ), "Narzêdzia");
  	else if(type == ITEM_PRZYBORY)	format(typ, sizeof(typ), "Przybory");
    else if(type == ITEM_FOOD)      format(typ, sizeof(typ), "Jedzenie");
    else if(type == ITEM_CLOTH) 	format(typ, sizeof(typ), "Ubranie");
    else if(type == ITEM_DRINK) 	format(typ, sizeof(typ), "Napój");
    else if(type == ITEM_MEGAFONE)	format(typ, sizeof(typ), "Megafon");
    else if(type == ITEM_KANISTER)	format(typ, sizeof(typ), "Kanister");
    else if(type == ITEM_AMMO)      format(typ, sizeof(typ), "Amunicja");
    else if(type == ITEM_CONTAINER) format(typ, sizeof(typ), "Plecak");
    else 							format(typ, sizeof(typ), "Nieznany");
	return typ;
}

stock encode_doors(bonnet, boot, driver_door, passenger_door, behind_driver_door, behind_passenger_door)
{
    #pragma unused behind_driver_door
    #pragma unused behind_passenger_door
    return bonnet | (boot << 8) | (driver_door << 16) | (passenger_door << 24);
}

stock encode_panels(flp, frp, rlp, rrp, windshield, front_bumper, rear_bumper) return flp | (frp << 4) | (rlp << 8) | (rrp << 12) | (windshield << 16) | (front_bumper << 20) | (rear_bumper << 24);
stock encode_lights(light1, light2, light3, light4) return light1 | (light2 << 1) | (light3 << 2) | (light4 << 3);
stock encode_tires(tires1, tires2, tires3, tires4) return tires1 | (tires2 << 1) | (tires3 << 2) | (tires4 << 3);
