#if defined _NL_included
  #endinput
#endif
#define _NL_included
#pragma library Time

#include <a_samp>
#include <zcmd>
#include <DUDB>
#include <a_mysql>
#include <a_audio>
#include <sscanf2>
#include <streamer>
#include <mapandreas>
#include <td>
#include <a_angles>
#include <md5>
#include <foreach>
#include <onplayershoot>

#define servname 		"Country Role Play"
#define cityname		"MontGomery"
#define foreachEx(%2,%1) 	for(new %2 = 0; %2 < %1; %2++)
#define serwerdo(%1,%2) 	SendClientMessageEx(14.0, %1, %2, COLOR_DO, COLOR_DO2, COLOR_DO3, COLOR_DO4, COLOR_DO5)
#define serwerme(%1,%2) 	SendClientMessageEx(14.0, %1, %2, COLOR_PURPLE, COLOR_PURPLE2, COLOR_PURPLE3, COLOR_PURPLE4, COLOR_PURPLE5)
#define Distance3D(%1,%2,%3,%4,%5,%6) (floatsqroot((%1 - %4) * (%1 - %4) + (%2 - %5) * (%2 - %5) + (%3 - %6) * (%3 - %6))*1000.0)
#define isnull(%1) 			((!(%1[0])) || (((%1[0]) == '\1') && (!(%1[1]))))

#define ShowInfo(%1,%2) 	ShowPlayerDialog(%1, DIALOG_INFO, DIALOG_STYLE_MSGBOX, "{FFFFFF}"servname" » {008000}Tip:", %2, "Okey", "")
#define NoPlayer(%1)		ShowPlayerDialog(%1, DIALOG_INFO, DIALOG_STYLE_MSGBOX, "{FFFFFF}"servname" » {008000}Tip{FFFFFF} » {008000}Error", "{E31919}Nie znaleziono gracza.", "Okey", "")
#define Info(%1,%2,%3)		ShowPlayerDialog(%1, DIALOG_INFO, DIALOG_STYLE_MSGBOX, %2, %3, "Okey", "")

#define In(%1)				ShowPlayerDialog(playerid, DIALOG_INFO, DIALOG_STYLE_MSGBOX, "{FFFFFF}"servname" » {008000}Informacja", %1, "Okey", "")

#define FuncPub::%1(%2) 	forward %1(%2);public %1(%2)

forward OnPlayerRemoveItem(playerid, uid);
forward OnPlayerUseItem(playerid, itemid);

#undef  MAX_PLAYERS
#define MAX_PLAYERS 	150
#define MAX_DOOR	500
#define MAX_VEH		1000
#define MAX_ITEMS	2000
#define MAX_BIZ 	100
#define MAX_ORG 	100
#define MAX_FRA  	7
#define MAX_PICK	40
#define MAX_OBJ		1000
#define MAX_ANIM	200
#define MAX_HOTEL	5
#define MAX_ORDERS	300
#define MAX_BUS		20
#define MAX_3D		50

#define NONE		0 
#define FRAC 		1
#define FRAKCJA 	1
#define ORG     	2
#define ORGANIZACJA	2
#define BIZ     	3
#define BIZNES		3
#define GRACZ   	4
#define	BOT			5

#define FRAC_NONE   	0
#define FRAC_PD     	1
#define FRAC_GOV    	2
#define FRAC_MC     	3
#define FRAC_FD     	4
#define FRAC_NEWS   	5
#define FRAC_FBI    	6
#define FRAC_TAXI		7

#define BIZ_NONE		0
#define ORG_NONE		0

#define DOOR_NONE		0
#define DOOR_FRAC   	1
#define DOOR_BIZ    	2
#define DOOR_ORG    	3
#define DOOR_DOM    	4
#define DOOR_HOTEL  	5
#define DOOR_BANK   	6
#define DOOR_STACJA 	7
#define DOOR_BINGO		8

#define GAZ     		1
#define BENZ    		2

#define PLACE_NONE		0
#define PLACE_PLAYER	1
#define PLACE_VEHICLE	2
#define PLACE_HOUSE		3
#define PLACE_BIZ		4
#define PLACE_FRAC		5
#define PLACE_ORG		6
#define PLACE_TUNE_CAR	7
#define PLACE_MAGAZYN	8

#define PHASE_NONE       0
#define PHASE_MOVE_XY    1
#define PHASE_MOVE_Z     2
#define PHASE_MOVE_ROT   3

#define P_NONE			0
#define P_KSIADZ  		1
#define P_MECHANIK    	2
#define P_KURIER      	3

#define MEN         	1
#define WOMAN           2

#define GATE_CLOSE      0
#define GATE_OPEN       1

// Typy ofert
#define OFFER_ITEM      1 	// Przedmiot
#define OFFER_VEHICLE   2 	// Pojazd
#define OFFER_INTERVIEW 3	// Podgl¹d int
#define OFFER_LICENSE   4	// Licencja
#define OFFER_MANDATE   6	// Mandat
#define OFFER_REPAIR    7	// Naprawa
#define OFFER_ANIM   	8	// Animacja
#define OFFER_PAY       9	// Zap³ata
#define OFFER_AD        10	// Reklama
#define OFFER_PAINT    	11	// Malowanie
#define OFFER_LICENCE   12	// Licencja
#define OFFER_FUEL      13	// Tankowanie
#define OFFER_FOOD      14	// Jedzenie	
#define OFFER_TRENING	15	// Trening si³owy
#define OFFER_WALKA		16	// Sztuka walki
#define OFFER_BIZESRP	17	// Biznes RP
#define OFFER_FRAKCJARP	18	// Frakcja RP
#define OFFER_ORGRP		19	// Organizacja RP
#define OFFER_KEY		20	// Kluczyki od auta
#define OFFER_WYWIAD	21	// Wywiad
#define OFFER_BLOKADA	22	// Blokada ko³a
#define OFFER_LEKCJA	23	// Lekcja jazdy
#define OFFER_PAINTJOB	24	// Malowanie PaintJoba
#define OFFER_SLUB		25	// Œlub
#define OFFER_COMP		26	// Montowanie komponentu
#define OFFER_VCARD		27	// Wizytówka vcard
#define OFFER_LECZENIE	28	// Leczenie
#define OFFER_CZESC	29	// Naprawa czêœci

#define DIALOG_INFO 		999
#define DIALOG_ITEM                112

#pragma unused 			ret_memcpy
#define BIALY           0xFFFFFFFF
#define COLOR_YELLOW    0xFFFF00AA
#define COLOR_FADE1     0xE6E6E6E6
#define COLOR_FADE2     0xC8C8C8C8
#define COLOR_FADE3     0xAAAAAAAA
#define COLOR_FADE4     0x8C8C8C8C
#define COLOR_FADE5     0x6E6E6E6E
#define COLOR_PURPLE 	0xC2A2DAAA
#define COLOR_PURPLE2 	0xBB98D6FF
#define COLOR_PURPLE3 	0xAD83CDFF
#define COLOR_PURPLE4 	0xA778C9FF
#define COLOR_PURPLE5 	0x9963C0FF
#define COLOR_DO 		0x88A2ECFF
#define COLOR_DO2 		0x88A2ECFF
#define COLOR_DO3 		0x6283E6FF
#define COLOR_DO4 		0x486FE1FF
#define COLOR_DO5 		0x3C65DFFF
#define SZARY           0xAFAFAFAA
#define RED             0xFF0000FF
#define ITEM_COLOR      0x8a5fe7aa
#define KREMOWY         0xFFBFFFAA
#define COLOR_LIGHTBLUE 0x33CCFFAA
#define ITEM_COLOR 		0x8a5fe7aa
#define COLOR_LIGHTORANGE 0xF7A26FFF
#define GREEN 			0x33AA33AA
#define COLOR_YELLOW    0xFFFF00AA

// CLR H-RP
#define CLR_BLACK 		0x000000FF
#define CLR_GRAY 		0xAFAFAFAA
#define CLR_WHITE 		0xFFFFFFFF
#define CLR_RED 		0xFF0000FF
#define CLR_DARKRED 	0xCF4028FF
#define CLR_ORANGE 		0xFFC973FF
#define CLR_DARKORANGE 	0xFDAE33FF
#define CLR_GREEN 		0x42B542FF
#define CLR_LIGHTGREEN 	0xA8EEA8FF
#define CLR_LIGHTBLUE 	0x1E90FFFF
#define CLR_YELLOW 		0xFFFF02FF
#define CLR_CYAN 		0x42D3FFFF
#define CLR_DARKCYAN 	0x59BDC6FF
#define CLR_PINK 		0xC2A2DAFF
#define CLR_LIGHTPINK 	0xFFC3FFFF
#define CLR_NIEBIESKI 	0x688CCEAA
#define CLR_ZOLTY 		0xFFFF00AA
#define CLR_KREMOWY 	0xF5DEB3AA
#define CLR_ROZOWY 		0xFFBFFFAA
//

stock bool:adminduty[MAX_PLAYERS];
stock bool:gmduty[MAX_PLAYERS];
stock bool:Logged[MAX_PLAYERS];

// Typy przedmiotów
#define ITEM_NONE        0 // bez funkcji
#define ITEM_WEAPON      1 // bronie //     (val1 = model, val2 = ammo)
#define ITEM_PHONE       2 // telefon //    (val1 = numer, val2 = bateria)
#define ITEM_WATCH       4 // zegarek //
#define ITEM_KANISTER    5 // kanister      (val1 = ilosc paliwa, val2 = rodzaj)
#define ITEM_CUBE        7 // kostka do gry //
#define ITEM_CIGGY       8 // fajki //      (val1 = iloœæ)
#define ITEM_LICENSE     9 // licencje //   (val1 = uid gracza, którego jest licencja, val2 = rodzaj licencji)
#define ITEM_SKATE      10 // rolki
#define ITEM_AMMO       11 // amunicja //   (val1 = model broni do ktorej jest ammo, val2 = ilosc do dodania przy uzyciu)
#define ITEM_FOOD       12 // jedzenie //   (val1 = hp ile daje, val2 = iloœæ)
#define ITEM_BANDANA    13 // bandana  //
#define ITEM_CLOTH      14 // ubranie  //   (val1 - id skina)
#define ITEM_TUNING     15 // tuning        (val1 - id komponentu)
#define ITEM_CONTAINER  17 // kontener  //  (val1 - pojemnoœæ w gramach)
#define ITEM_MEGAFONE   18 // megafon   //
#define ITEM_BEER       19 // piwo/wino //  (val1 = rodzaj)
#define ITEM_HANDCUFFS  20 // kajdanki  //
#define ITEM_ARMOR	21 // kamizelka //  (val1 = iloœæ armoru)
#define ITEM_AUDIO      22 // radio         (val3 = url do radia)
#define ITEM_ZWLOKI	23 // zw³oki	    
#define ITEM_NOKTOWIZOR	24 // Noktowizor    (val2 = bateria)
#define ITEM_SAMOCHOD	25 // Samochód //   (val1 = model)
#define ITEM_BUTELKA	26 // Butelka //    (val1 = Typ)
#define ITEM_CZESC	27 // Czeœæ do auta (val1 = Typ)
#define ITEM_PARAL	28 // Paralizator   (val1 = model, val2 = ammo)

#define ORD_TYP_VEH		1
#define ORD_TYP_ITEM	2

#define INVALID_BIZ_ID		0
#define INVALID_ORG_ID		0
#define INVALID_FRAC_ID		0
#define INVALID_ITEM_ID		0
#define INVALID_VEH_ID		0
#define INVALID_DOOR_ID		0
#define INVALID_ANIM_ID		0

#define BUSINESS_NONE			0
#define BUSINESS_GASTRONOMY     1
#define BUSINESS_CARDEALER      2
#define BUSINESS_WORKSHOP       3
#define BUSINESS_GYM           	4
#define BUSINESS_PRALNIA		5

#define ORGANISATION_NONE      	0
#define ORGANISATION_CRIME      1
#define ORGANISATION_RACE       2
#define ORGANISATION_FRAC	3

#define ORG_TYP_GANG			1
#define ORG_TYP_MAFIA			2

#define PICKUP_TYPE_NONE		0
#define PICKUP_TYPE_SHOP		1
#define PICKUP_TYPE_ORDER		2
#define PICKUP_TYPE_JOB			3
#define PICKUP_TYPE_BANK		4

/*#define SPOILERS           		0
#define CARMODTYPE_ROOF       		1
#define HOODS              		2
#define SIDESKIRTS         	3
#define CARMODTYPE_NITRO             	4
#define LAMPS               	5
#define CARMODTYPE_EXHAUST            	6
#define CARMODTYPE_WHEELS               7
#define STEREO               	8
#define HYDRAULICS              9
#define BULLBARS                10
#define REARBULLBARS           	11
#define FRONTBULLBARS           12
#define CARMODTYPE_FRONT_BUMPER      	13
#define REARBUMPERS            	14
#define VENTS                   15
#define FRONTSIGN              	16
#define PAINTJOBS               17*/

#define PRAWKO_A	1
#define PRAWKO_B	2
#define PRAWKO_C	3
#define PRAWKO_C_E	4
#define DOWOD		5
#define DOK_PRAWKO	6
#define DOK_METRYK	7
#define DOK_NIEKAR	8
#define DOK_BRON	9
#define BRON_KROT	10
#define BRON_AUTO	11
#define BRON_STAL	12

#define PORTFEL		1

#define ANIM_YO		1

#define LOG_TYPE_NONE 	0
#define LOG_TYPE_CHAT	1
#define LOG_TYPE_CMD	2
#define LOG_TYPE_VEH	3
#define LOG_TYPE_CHATB	4
#define LOG_TYPE_OFFER	5
#define LOG_TYPE_PAYBIZ	6
#define LOG_TYPE_DIALOG	7
#define LOG_TYPE_CREATE	8

#define KARA_SYSTEM	-1

#define AJ_NOLIMIT	999999999

#define PLACE_HEAD	0
#define PLACE_BODY	1
#define PLACE_HAND	2
#define PLACE_HEAD2	3
#define PLACE_ELSE	4

#define PANEL_DOOR_LEFT		1
#define PANEL_DOOR_RIGHT	2
#define PANEL_DOOR_BONNET	3
#define PANEL_DOOR_BOOT		4

#define PANEL_PANEL_FLP		5
#define PANEL_PANEL_FRP		6
#define PANEL_PANEL_RLP		7
#define PANEL_PANEL_RRP		8
#define PANEL_PANEL_WIND	9
#define PANEL_PANEL_FRONT	10
#define PANEL_PANEL_REAR	11

#define PANEL_TYRE_REAR_R	12
#define PANEL_TYRE_FRONT_R	13
#define PANEL_TYRE_REAR_L	14
#define PANEL_TYRE_FRONT_L	15

#define PANEL_LIGHT_FRONT_L	16
#define PANEL_LIGHT_2		17
#define PANEL_LIGHT_FRONT_R	18
#define PANEL_LIGHT_4		19


#define PRESSED(%0) (((newkeys & (%0)) == (%0)) && ((oldkeys & (%0)) != (%0)))
#define RELEASED(%0) (((newkeys & (%0)) != (%0)) && ((oldkeys & (%0)) == (%0)))

enum eBusiness {
	buss_uid, 
	cash, 
	desc[32], 
	buss_kind, 
	typed, 
	ooc
}

enum eOrganisation {
	org_uid, 
	cash, 
	desc[32], 
	typed, 
	typid, 
	ooc
}

enum Tramwaj {
	tUID,
	tName[64],
	Float:tX,
	Float:tY,
	Float:tZ,
	Float:zX,
	Float:zY,
	Float:zZ,
	tPrice,
	tTime
};

enum drr {
	Tuid,
	Float:TX,
	Float:TY,
	Float:TZ,
	TVW,
	TName[100],
	Text3D:Tingame
}

enum ePlayer {
	guid,
	player_uid,
	nick[32],
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
	phonenr,
	skin2,
	Float:health,
	adminlvl,
	ck,
	hours,
	minutes,
	gmlvl,
	ajreason[32],
	bank,
	hoteli,
	job,
	blockooc,
	noveh,
	sila,
	sztukawalki,
	LoggedIn,
	laslogin[126],
	run,
	drunklvl,
	bron,
	telsoundid,
	dom,
	domrank,
	audio,
	panor,
	akcent[10],
	globname[65],
	//----
	Text3D:opis,
	Text3D:tag,
	org,
   	orgrank,
	orgskin,
	biz,
	bizrank,
	bizskin,
	//----
	GP,
};

enum eUstawienia {
	Float:Spawn1[4],
 	Float:Spawn2[4],
 	Float:Spawn3[4],
	Float:Spawn4[4],
 	Spawn_INT,
 	Spawn_VW,
 	
 	Float:AJ_X,
 	Float:AJ_Y,
 	Float:AJ_Z,
 	AJ_INT,
	Float:FUEL_PRICE,
	Float:GAS_PRICE,
	Float:gas1[3],
	Float:energia_price,
	Float:carspawn[3]
};

enum eDoor
{
	door_uid,       // UID Drzwi
	uniq_name[32],	// Nazwa na drzwiach
	desc[32],       // Nazwa wyœwietlana
	closed,         // Zamkniete
	owner_type,     // Typy: 1.Frakcja 2.Organizacja 3.Biznes 4.Dom         5.Motel       6.Inne
	owner_id,       // ID:   1.ID frac 2.ID org      3.ID biz 4.UID gracza  5.ID motelu   6.Brak

	Float:inside_a, // Pos A w œrodku
	Float:inside_x, // Pos X w œrodku
	Float:inside_y, // Pos Y w œrodku
	Float:inside_z, // Pos Z w œrodku
	inside_int,     // Interior w œrodku
	inside_vw,      // VW w œrodku

	Float:outside_a,
	Float:outside_x,
	Float:outside_y,
	Float:outside_z,
	outside_int,
	outside_vw,
	entracefee,     // Koszt wstêpu

	pickup_id,      // ID pickupa
	audio[50],	// URL muzyki z internetu
	haveaudio,	// 1= Tak, 0=Nie
	playmusic,	// ID granej muzyki
	lights,		// Œwiat³o
	Text3D:textname,// ID 3D Textu przy wejœciu
	pickupUID,	// ID pickupa
	//Text3D:textout, // ID 3D Textu przy wyjœciu
};

enum eVehicles {
	vUID,       	// Uid
	vName[100],  	// Nazwa auta
	vModel,    	// Model
	Float:vX,   	// Pos X
	Float:vY,   	// Pos Y
	Float:vZ,   	// Pos Z
	Float:vAngle, 	// Pos A
	Float:vPos[3],	// Aktualna pozycja
	vColor1,    	// Kolor
	vColor2,    	// Kolor2
	vOwnerType, 	// Typ wspó³w³asciciela 1-Frakcja 2-Organizacja 3-Biznes 4-Gracz
	vOwner,     	// Wlasciciel           1-id frac 2-id org      3-id biz 4-uid gracza
	vLock,      	// Zamkniety
	Float:vFuel,	// Iloœæ paliwa
	vFuelType, 	// Rodzaj paliwa: 1-Paliwo    2-Gas
	Float:vDistance, // Przebieg
	Float:vHP, 	// HP
	vTow,   	// Choluje
	vID,        	// ID Stworzonego pojazdu
	panels,	
	doors,
	lights,
	tires,
	paintjob,
	Spawned,
	engine,
	plate[64]
}

enum eItems {
	iUID,
	iType,
	iName[32],
	iOwner,
	iValue1,
	iValue2,
	iPlace,
	Float:iPosX,
	Float:iPosY,
	Float:iPosZ,
	iWeight,
	iUsed,
	iReserved,
	iBelongTo,
	iVW,
	Text3D:i3DText,
	iValue3[60],
	ObjectGameID,
	ObjectItem,
}

enum gOffer {
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

enum ePick {
	pUID,
	pmodel,
	Float:ox,
	Float:oz,
	Float:oy,
	vw,
	psampid,
	pType,
}

enum eObjects {
	objUID,
	objModel,
	objVW,
	objByDoor,
	objGroup,

	Float:objX,
	Float:objY,
	Float:objZ,
	Float:objRotX,
	Float:objRotY,
	Float:objRotZ,

	Float:objGateX,
	Float:objGateY,
	Float:objGateZ,
	objOpenGate
}

enum gAnims {
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

enum eHotels {
	hoteluid,
	Float:inside_a,
	Float:inside_x,
	Float:inside_y,
	Float:inside_z,
	inside_int,
	Float:outside_a,
	Float:outside_x,
	Float:outside_y,
	Float:outside_z,
	outside_int,
	outside_vw,
}

// ---- Bussines & Organisations ---- //
stock Business[MAX_BIZ][eBusiness];
stock Org[MAX_ORG][eOrganisation];

// ---- More ---- //
stock Offer[MAX_PLAYERS][gOffer]; 
stock Anim[MAX_ANIM][gAnims];
stock Bus[MAX_BUS][Tramwaj];
stock TL[MAX_3D][drr];

// ---- Serwer Config ---- //
stock Float:Hotels[MAX_HOTEL][eHotels];
stock Ustawienia[eUstawienia];

// ---- Player Info ---- //
stock PlayerInfo[MAX_PLAYERS][ePlayer]; 

// ---- Systems ---- //
stock Pickups[MAX_PICK][ePick];
stock Object[MAX_OBJ][eObjects];
stock CarInfo[MAX_VEH][eVehicles];
stock ItemData[MAX_ITEMS][eItems];
stock DoorInfo[MAX_DOOR][eDoor];


/*
native UnderscoreToSpace(name[]);
native NickName(playerid);
native NickNameEx(playerid);
native NickSamp(playerid);
native NickNameDB(playerid);
native SendClientMessageEx(Float:radi, playerid, string[],col1,col2,col3,col4,col5);
native OdlegloscMiedzyGraczami(Float:radi, playerid, targetid);
native SetPlayerMoneyEx(playerid, money);
native SetPlayerHealthEx(playerid, Float:HP);
native MySQLCheck();
native GivePlayerHealthEx(playerid, Float:HP, bool:Max100HP = true);
native PreloadAnimLibraries(playerid);
native PlayerToPoint(Float:radi, playerid, Float:x, Float:y, Float:z);
native LoadTuning(vehicleid);
native SaveComponent(vehicleid, componentid);
native SavePaintjob(vehicleid, paintjobid);
native SavePaintjob(vehicleid, paintjobid);
native GetComponent(vehicleid, slot);
native RemoveVehiclePaintjob(vehicleid);
native GetComponentValue(componentid);
native GetComponentSlot(componentid);
native GetPlayerFraction(playerid);
native GetFractionName(playerid);
native IsFractionLeader(playerid,fracid);
native GetPlayerOrganisation(playerid);
native GetOrganisationName(playerid);
native IsOrganisationLeader(playerid,orgid);
native GetPlayerBusiness(playerid);
native GetBusinessName(playerid);
native IsBusinessLeader(playerid,bussid);
native IsABoat(carid);
native IsARower(carid);
native IsABike(carid);
native IsAPlane(carid);
native IsATir(carid);
native IsABus(carid);
native GetVehicleMaxFuel(model);
native fueltype(fueltyp);
native EscapePL(name[]);
native encode_lights(light1, light2, light3, light4);
native encode_tires(tires1, tires2, tires3, tires4);
native encode_panels(flp, frp, rlp, rrp, windshield, front_bumper, rear_bumper);
native encode_doors(bonnet, boot, driver_door, passenger_door, behind_driver_door, behind_passenger_door);
native biztype(biztypeEx);
native orgtype(orgtypeEx);
native name_add_tabs(names[]);
native GetItemTypeName(type);
native wordwrap(givenString[128]);
native MenOrWoman(whatid);
native YesOrNo(whatid);
native PreloadAnimLib(playerid, animlib[]);
native VehicleDriverID(vehicleid);
native IsVehicleInUse(vehicleid);
native SetPlayerInAdminJail(playerid, time, reason[]);
native GetXYInFrontOfPlayer(playerid, &Float:x, &Float:y, Float:distance);
native ShowInfo(playerid, info[]);
native NoPlayer(playerid);
native Info(playerid, caption[], info[]);
native GetPlayerIdWithName(const playername[]);
native NazwaBroni(gunid);
native serwerme(playerid, str[]);
native serwerdo(playerid, str[]);
native foreach(name, funcname);
native isnull(str[]);
native Createitem(playerid, Ilosc, Typ, Wartosc, Nazwa[], waga);
native JobName(whatid);
native CheckTextDrawString(const string[]);
native strtoupper(string[]);
native UseItem(itemid);
native GetDistancePointToPoint2(Float:x, Float:y, Float:x2, Float:y2);
native IsValidSkin(skinid);
native FracOrgBiz(id);
native fsdasdadsa(id, ex);
native ShowItems(playerid);
*/

stock ShowItems(playerid)
{
	new
		str[512],
		zmienna;
 	for(new i = 1; i < MAX_ITEMS; i++)
	{
		if(ItemData[i][iOwner] == PlayerInfo[playerid][player_uid] && ItemData[i][iPlace] == PLACE_PLAYER && ItemData[i][iUID] != 0)
		{
			if(ItemData[i][iUsed] == 1) format(str, sizeof(str), "%s{42B542}%d\t%s{FFFFFF}\n",str, ItemData[i][iUID], ItemData[i][iName]);
			else format(str, sizeof(str), "%s%d\t%s\n",str, ItemData[i][iUID], ItemData[i][iName]);
			zmienna++;
		}
	}
	if(zmienna != 0) return ShowPlayerDialog(playerid, DIALOG_ITEM, DIALOG_STYLE_LIST, "Twoje przedmioty:", str, "Okey", "Zamknij");
	else GameTextForPlayer(playerid, "~r~Nie posiadasz zadnego przedmiotu", 3000, 3);
	return 1;
}

stock fsdasdadsa(id, ex)
{
	new str[50];
	if(id == ORGANIZACJA) 	format(str, sizeof(str), "%s", Org[ex][desc]);
	if(id == BIZNES) 	format(str, sizeof(str), "%s", Business[ex][desc]);
	if(id == GRACZ) 	format(str, sizeof(str), "%s", SprawdzNick(CarInfo[ex][vOwner]));
	return str;
}

stock FracOrgBiz(id)
{
	new str[30];
	if(id == ORGANIZACJA) 	str = "Organizacja";
	if(id == BIZNES) 	str = "Biznes";
	if(id == GRACZ) 	str = "Gracz";
	return str;
}

stock IsValidSkin(skinid)
{
	if (skinid < 0 || skinid > 299) return 0;
	switch(skinid)
	{
		case 3, 4, 5, 6, 8, 42, 65, 74, 86, 119, 149, 208, 268, 273, 289: return 0;
	}
	return 1;
}
stock GetDistancePointToPoint2(Float:x, Float:y, Float:x2, Float:y2) return floatround(floatsqroot((x2-x)*(x2-x)+(y2-y)*(y2-y)));

stock UseItem(itemid)
{
	new str[5];
	if(ItemData[itemid][iUsed] == 0) str = "~w~";
	else if(ItemData[itemid][iUsed] == 1) str = "~p~";
	return str;
}
stock CheckTextDrawString(const string[])
{
	for(new znak = 0; znak < strlen(string); znak++)
	{
		if(string[znak] == '~')
		{
			if((string[znak+1] == 'r' || string[znak+1] == 'g' || string[znak+1] == 'b' || string[znak+1] == 'w' || string[znak+1] == 'l' || string[znak+1] == 'p' || string[znak+1] == 'n') && string[znak+2] == '~')
			{
				if(string[znak+2] == '~') znak += 2;
			}
			else return 0;
		}
	}
	return 1;
}

stock SetPlayerInAdminJail(playerid, playerid2, time, reason[])
{
	PlayerInfo[playerid][aj] = (time*60)+60;
	PlayerInfo[playerid][bw] = 0;

	GivePlayerHealthEx(playerid, 100.0, true);
	SetPlayerInterior(playerid, Ustawienia[AJ_INT]);
	SetPlayerPos(playerid, Ustawienia[AJ_X], Ustawienia[AJ_Y], Ustawienia[AJ_Z]);
	SetPlayerVirtualWorld(playerid, playerid);
	Warn("Admin Jail", playerid, playerid2, reason);

	strmid(PlayerInfo[playerid][ajreason], reason, 0, strlen(reason), 255);

	for(new i = 1; i < MAX_ITEMS; i++)
		if(ItemData[i][iOwner] == PlayerInfo[playerid][player_uid] && ItemData[i][iPlace] == PLACE_PLAYER && ItemData[i][iUID] != 0)
			ItemData[i][iUsed] = 0;
	ResetPlayerWeapons(playerid);
	SetPVarInt(playerid, "PlayerWeapon", 0);
	return 1;
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

stock PreloadAnimLib(playerid, animlib[]) return ApplyAnimation(playerid,animlib,"null",0.0,0,0,0,0,0);

stock MenOrWoman(whatid)
{
	new str[15];
	if(whatid == MEN) 		format(str, sizeof(str), "Mê¿czyzna");
	else if(whatid == WOMAN)	format(str, sizeof(str), "Kobieta");
	else 				format(str, sizeof(str), "Nie znany");
	return str;	
}

stock YesOrNo(whatid)
{
	new str[15];
	if(whatid == 1) 	format(str, sizeof(str), "Tak");
	else if(whatid == 0)	format(str, sizeof(str), "Nie");
	return str;
}

stock JobName(whatid)
{
	new str[18];
	if(whatid == P_KURIER) 		format(str, sizeof(str), "Kurier");
	else if(whatid == P_MECHANIK)	format(str, sizeof(str), "Mechanik");
	else if(whatid == P_KSIADZ)	format(str, sizeof(str), "Ksi¹dz");
	else if(whatid == P_NONE)	format(str, sizeof(str), "Brak");
	return str;
}

stock LicName(whatid)
{
	new str[25];
	if(whatid == PRAWKO_A) 		format(str, sizeof(str), "Prawo jazdy kat. A");
	else if(whatid == PRAWKO_B)	format(str, sizeof(str), "Prawo jazdy kat. B");
	else if(whatid == PRAWKO_C)	format(str, sizeof(str), "Prawo jazdy kat. C");
	else if(whatid == PRAWKO_C_E)	format(str, sizeof(str), "Prawo jazdy kat. C+E");
	else if(whatid == DOWOD)	format(str, sizeof(str), "Dowód osobisty");
	return str;
}

stock wordwrap(givenString[128])
{
	new temporalString[ 128 ];
	memcpy(temporalString, givenString, 0, 128 * 4);

	new comaPosition = strfind(temporalString, ",", true, 0),
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

stock GetItemTypeName(type)
{
	new typ[16];
	if(type == ITEM_NONE) 		format(typ, sizeof(typ), "Normalny");
	else if(type == ITEM_ARMOR) 	format(typ, sizeof(typ), "Kamizelka kuloodporna");
	else if(type == ITEM_WEAPON)	format(typ, sizeof(typ), "Broñ");
	else if(type == ITEM_BEER)	format(typ, sizeof(typ), "Piwo");
	else if(type == ITEM_MEGAFONE)	format(typ, sizeof(typ), "Megafon");
	else if(type == ITEM_PHONE) 	format(typ, sizeof(typ), "Telefon");
	else if(type == ITEM_WATCH) 	format(typ, sizeof(typ), "Zegarek");
	else if(type == ITEM_KANISTER)	format(typ, sizeof(typ), "Kanister");
	else if(type == ITEM_CUBE)	format(typ, sizeof(typ), "Kostka");
	else if(type == ITEM_CIGGY)	format(typ, sizeof(typ), "Papierosy");
	else if(type == ITEM_LICENSE) 	format(typ, sizeof(typ), "Licencja");
	else if(type == ITEM_SKATE)     format(typ, sizeof(typ), "Rolki");
	else if(type == ITEM_AMMO)      format(typ, sizeof(typ), "Amunicja");
	else if(type == ITEM_FOOD)      format(typ, sizeof(typ), "Jedzenie");
	else if(type == ITEM_BANDANA)   format(typ, sizeof(typ), "Maska");
	else if(type == ITEM_TUNING)    format(typ, sizeof(typ), "Tuning");
	else if(type == ITEM_CONTAINER) format(typ, sizeof(typ), "Kontener");
	else if(type == ITEM_AUDIO) 	format(typ, sizeof(typ), "Odtwarzacz");
	else if(type == ITEM_ZWLOKI) 	format(typ, sizeof(typ), "Zw³oki");
	else if(type == ITEM_CLOTH) 	format(typ, sizeof(typ), "Ubranie");
	else if(type == ITEM_NOKTOWIZOR) format(typ, sizeof(typ), "Noktowizor");
	else if(type == ITEM_BUTELKA) 	format(typ, sizeof(typ), "Butelka");
	else if(type == ITEM_CZESC)	format(typ, sizeof(typ), "Czeœæ do auta");
	else if(type == ITEM_PARAL)	format(typ, sizeof(typ), "Paralizator");
	else 				format(typ, sizeof(typ), "Nieznany");
	return typ;
}

stock name_add_tabs(names[])
{
	new ret[40];
	if(strlen(names) <= 8)	format(ret, sizeof(ret), "%s\t\t", names);
	else			format(ret, sizeof(ret), "%s\t", names);
	return ret;
}

stock orgtype(fueltyp)
{
	new ret[15];
	if(fueltyp == ORGANISATION_CRIME)	format(ret, sizeof(ret), "Kryminalna");
	else if(fueltyp == ORGANISATION_RACE)	format(ret, sizeof(ret), "Wyœcigowcy");
	else if(fueltyp == ORGANISATION_FRAC)	format(ret, sizeof(ret), "Frakcja");
	else if(fueltyp == ORGANISATION_NONE)	format(ret, sizeof(ret), "Brak");
	return ret;
}

stock biztype(fueltyp)
{
	new ret[15];
	if(fueltyp == BUSINESS_GASTRONOMY)	format(ret, sizeof(ret), "Gastronomiczny");
	else if(fueltyp == BUSINESS_CARDEALER)	format(ret, sizeof(ret), "Sprzedawca aut");
	else if(fueltyp == BUSINESS_WORKSHOP)	format(ret, sizeof(ret), "Warsztat");
	else if(fueltyp == BUSINESS_GYM)	format(ret, sizeof(ret), "Si³ownia");
	else if(fueltyp == BUSINESS_PRALNIA)	format(ret, sizeof(ret), "Pralnia");
	else if(fueltyp == BUSINESS_NONE)	format(ret, sizeof(ret), "Brak");
	return ret;
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


stock EscapePL(name[])
{
    for(new i = 0; name[i] != 0; i++)
    {
	    if(name[i] == 'œ') name[i] = 's';
	    else if(name[i] == 'ê') name[i] = 'e';
	    else if(name[i] == 'ó') name[i] = 'o';
	    else if(name[i] == '¹') name[i] = 'a';
	    else if(name[i] == '³') name[i] = 'l';
	    else if(name[i] == '¿') name[i] = 'z';
	    else if(name[i] == 'Ÿ') name[i] = 'z';
	    else if(name[i] == 'æ') name[i] = 'c';
	    else if(name[i] == 'ñ') name[i] = 'n';
    }
}

stock fueltype(fueltyp)
{
	new ret[10];
	if(fueltyp == BENZ)	format(ret, sizeof(ret), "Paliwo");
	else if(fueltyp == GAZ)	format(ret, sizeof(ret), "Gaz");
	else 			format(ret, sizeof(ret), "Nieznane");
	return ret;
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

stock UnderscoreToSpace(name[])
{
	new pos = strfind(name,"_", true);
	if( pos != -1 )
	name[pos] = ' ';
}

stock AntyUnderscoreToSpace(name[])
{
	new pos = strfind(name," ", true);
	if( pos != -1 )
	name[pos] = '_';
	return name;
}

stock strtoupper(string[])
{ 
	for(new l = 0; l < strlen(string); l++) 
		string[l] = toupper(string[l]);  
}

stock NickName(playerid)
{
	new playername[50];
	if(PlayerInfo[playerid][adminlvl] != 0 && adminduty[playerid] == true)
	{
		format(playername, sizeof(playername), "%s", PlayerInfo[playerid][globname]); 	
	}
	else if(PlayerInfo[playerid][gmlvl] >= 1 && gmduty[playerid] == true) 
	{
		new str[30];
		format(str, sizeof(str), "%s", CharCode(playerid));
		strtoupper(str);
		format(playername, sizeof(playername), "GameMaster %s", str); 
	}
	else if(GetPVarInt(playerid, "Maska") == 1) 
	{
		new str[30];
		format(str, sizeof(str), "%s", CharCode(playerid));
		strtoupper(str);
		format(playername, sizeof(playername), "Nieznajomy %s", str); 
	}
	else
	{
		GetPlayerName(playerid, playername, MAX_PLAYER_NAME);
		UnderscoreToSpace(playername);
	}
	return playername;
}

stock NickNameEx(playerid)
{
	new playername[MAX_PLAYER_NAME];
	GetPlayerName(playerid, playername, MAX_PLAYER_NAME);
	UnderscoreToSpace(playername);
	return playername;
}

stock NickSamp(playerid)
{
	new playername[MAX_PLAYER_NAME];
	GetPlayerName(playerid, playername, MAX_PLAYER_NAME);
	return playername;
}

stock SendClientMessageEx(Float:radi, playerid, string[], col1, col2, col3, col4, col5, echo=0)
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
	        		if(echo == 0)
	        		{
					GetPlayerPos(i, posx, posy, posz);
					tempposx = (oldposx -posx);
					tempposy = (oldposy -posy);
					tempposz = (oldposz -posz);
					if (((tempposx < radi/16) && (tempposx > -radi/16)) && ((tempposy < radi/16) && (tempposy > -radi/16)) && ((tempposz < radi/16) && (tempposz > -radi/16)))
						SendClientMessage(i, col1, string);
					else if (((tempposx < radi/8) && (tempposx > -radi/8)) && ((tempposy < radi/8) && (tempposy > -radi/8)) && ((tempposz < radi/8) && (tempposz > -radi/8)))
						SendClientMessage(i, col2, string);
					else if (((tempposx < radi/4) && (tempposx > -radi/4)) && ((tempposy < radi/4) && (tempposy > -radi/4)) && ((tempposz < radi/4) && (tempposz > -radi/4)))
						SendClientMessage(i, col3, string);
					else if (((tempposx < radi/2) && (tempposx > -radi/2)) && ((tempposy < radi/2) && (tempposy > -radi/2)) && ((tempposz < radi/2) && (tempposz > -radi/2)))
						SendClientMessage(i, col4, string);
					else if (((tempposx < radi) && (tempposx > -radi)) && ((tempposy < radi) && (tempposy > -radi)) && ((tempposz < radi) && (tempposz > -radi)))
						SendClientMessage(i, col5, string);

				}
					else if(echo == 1)
				{
					if(i != playerid)
					{
						GetPlayerPos(i, posx, posy, posz);
						tempposx = (oldposx -posx);
						tempposy = (oldposy -posy);
						tempposz = (oldposz -posz);
						if (((tempposx < radi/16) && (tempposx > -radi/16)) && ((tempposy < radi/16) && (tempposy > -radi/16)) && ((tempposz < radi/16) && (tempposz > -radi/16)))
							SendClientMessage(i, col1, string);
						else if (((tempposx < radi/8) && (tempposx > -radi/8)) && ((tempposy < radi/8) && (tempposy > -radi/8)) && ((tempposz < radi/8) && (tempposz > -radi/8)))
							SendClientMessage(i, col2, string);
						else if (((tempposx < radi/4) && (tempposx > -radi/4)) && ((tempposy < radi/4) && (tempposy > -radi/4)) && ((tempposz < radi/4) && (tempposz > -radi/4)))
							SendClientMessage(i, col3, string);
						else if (((tempposx < radi/2) && (tempposx > -radi/2)) && ((tempposy < radi/2) && (tempposy > -radi/2)) && ((tempposz < radi/2) && (tempposz > -radi/2)))
							SendClientMessage(i, col4, string);
						else if (((tempposx < radi) && (tempposx > -radi)) && ((tempposy < radi) && (tempposy > -radi)) && ((tempposz < radi) && (tempposz > -radi)))
							SendClientMessage(i, col5, string);
					}
				}
			}
		}
	}
	return 1;
}

stock SendClientMessageToAdmins(string1[])
{
	foreach(Player, playerid)
	    	if(Logged[playerid])
	        	if(PlayerInfo[playerid][adminlvl] > 0 && adminduty[playerid] == true)
				SendClientMessage(playerid, CLR_ORANGE, string1);
}

stock SendClientMessageToGMs(string1[])
{
	foreach(Player, playerid)
	    	if(Logged[playerid])
	        	if(PlayerInfo[playerid][gmlvl] > 0 && gmduty[playerid] == true)
				SendClientMessage(playerid, CLR_DARKCYAN, string1);
}

stock OdlegloscMiedzyGraczami(Float:radi, playerid, targetid)
{
	if(IsPlayerConnected(playerid)&&IsPlayerConnected(targetid))
	{
		new Float:posx, Float:posy, Float:posz;
		new Float:oldposx, Float:oldposy, Float:oldposz;
		new Float:tempposx, Float:tempposy, Float:tempposz;
		GetPlayerPos(playerid, oldposx, oldposy, oldposz);
		//radi = 2.0; //Trigger Radius
		GetPlayerPos(targetid, posx, posy, posz);
		tempposx = (oldposx -posx);
		tempposy = (oldposy -posy);
		tempposz = (oldposz -posz);
		//printf("DEBUG: X:%f Y:%f Z:%f",posx,posy,posz);
		if (((tempposx < radi) && (tempposx > -radi)) && ((tempposy < radi) && (tempposy > -radi)) && ((tempposz < radi) && (tempposz > -radi))) return 1;
	}
	return 0;
}

stock MySQLCheck() return mysql_refresh(REFRESH_GRANT);

stock SetPlayerHealthEx(playerid, Float:HP)
{
	SetPlayerHealth(playerid, HP);
	PlayerInfo[playerid][health] = HP;
	return 1;
}

stock SetPlayerMoneyEx(playerid, money)
{
	SetPlayerMoney(playerid, money);
	PlayerInfo[playerid][cash] = money;
	return 1;
}

stock GivePlayerHealthEx(playerid, Float:HP, bool:Max100HP = true)
{
	new Float:pHealth;
	new str[126];
	GetPlayerHealth(playerid, pHealth);
	if(Max100HP == true && pHealth + HP > 100.0)
	{
		SetPlayerHealth(playerid, 100);
		PlayerInfo[playerid][health]=100;
		format(str, sizeof(str), "%s (%d)", NickName(playerid), playerid);
		Update3DTextLabelText(PlayerInfo[playerid][tag], 0x33AA33FF, str);
		SetTimerEx("Nicki", 3000, 0, "u", playerid);
	}
	else
	{
		SetPlayerHealth(playerid, pHealth + HP);
		PlayerInfo[playerid][health]+=HP;
		format(str, sizeof(str), "%s (%d)", NickName(playerid), playerid);
		Update3DTextLabelText(PlayerInfo[playerid][tag], 0x33AA33FF, str);
		SetTimerEx("Nicki", 3000, 0, "u", playerid);
	}
	return 1;
}

stock PlayerToPoint(Float:radi, playerid, Float:x, Float:y, Float:z)
{
	if(IsPlayerConnected(playerid))
	{
		new Float:oldposx, Float:oldposy, Float:oldposz;
		new Float:tempposx, Float:tempposy, Float:tempposz;
		GetPlayerPos(playerid, oldposx, oldposy, oldposz);
		tempposx = (oldposx -x);
		tempposy = (oldposy -y);
		tempposz = (oldposz -z);
		if (((tempposx < radi) && (tempposx > -radi)) && ((tempposy < radi) && (tempposy > -radi)) && ((tempposz < radi) && (tempposz > -radi)))
			return 1;
	}
	return 0;
}

stock NazwyPojazdow[212][] =
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

//--------------------------------------------
#define veh_typ_4	1
#define veh_typ_2	2
#define veh_typ_race	3
#define veh_typ_ciezar	4
#define veh_typ_lowrid	5
#define veh_typ_pickup	6
#define veh_typ_bike	7
#define veh_typ_ex	8

enum Pojazd{veh_model, veh_cena, veh_typ}

stock VehPrice[][Pojazd] = 
{
	{404, 5000, veh_typ_4},
	{479, 17000, veh_typ_4},
	{466, 24000, veh_typ_4},
	{492, 26000, veh_typ_4},
	{540, 28000, veh_typ_4},
	{418, 30000, veh_typ_4},
	{566, 30000, veh_typ_4},
	{400, 34000, veh_typ_4},
	{445, 32000, veh_typ_4},
	{467, 33000, veh_typ_4},
	{458, 34000, veh_typ_4},
	{516, 35000, veh_typ_4},
	{426, 40000, veh_typ_4},
	{547, 41000, veh_typ_4},
	{507, 47000, veh_typ_4},
	{561, 53000, veh_typ_4},
	{405, 53000, veh_typ_4},
	{579, 75000, veh_typ_4},
	{412, 76000, veh_typ_4},
	{551, 80000, veh_typ_4},
	{580, 88000, veh_typ_4},
	{542, 6200, veh_typ_2},
	{410, 8200, veh_typ_2},
	{549, 11000, veh_typ_2},
	{439, 27000, veh_typ_2},
	{475, 28000, veh_typ_2},
	{496, 28000, veh_typ_2},
	{491, 33000, veh_typ_2},
	{419, 34000, veh_typ_2},
	{589, 36000, veh_typ_2},
	{517, 40000, veh_typ_2},
	{518, 43000, veh_typ_2},
	{526, 44000, veh_typ_2},
	{533, 54000, veh_typ_2},
	{489, 60000, veh_typ_2},
	{562, 69000, veh_typ_2},
	{474, 79000, veh_typ_2},
	{555, 87000, veh_typ_2},
	{500, 99000, veh_typ_2},
	{545, 100000, veh_typ_2},
	{480, 225000, veh_typ_2},	
	{509, 530, veh_typ_bike},
	{481, 1000, veh_typ_bike},
	{510, 1200, veh_typ_bike},
	{462, 1500, veh_typ_bike},
	{463, 37000, veh_typ_bike},
	{586, 37000, veh_typ_bike},
	{461, 40000, veh_typ_bike},
	{581, 45000, veh_typ_bike},
	{521, 110000, veh_typ_bike},
	{457, 10000, veh_typ_ex},
	{583, 13000, veh_typ_ex},
	{530, 14000, veh_typ_ex},
	{483, 23000, veh_typ_ex},
	{574, 24000, veh_typ_ex},
	{471, 40000, veh_typ_ex},
	{552, 43000, veh_typ_ex},
	{508, 76000, veh_typ_ex},
	{442, 80000, veh_typ_ex},
	{424, 101000, veh_typ_ex},
	{434, 130000, veh_typ_ex},
	{524, 170000, veh_typ_ex},
	{431, 155000, veh_typ_ex},
	{455, 200000, veh_typ_ex},
	{574, 230000, veh_typ_ex},
	{574, 250000, veh_typ_ex},
	{478, 6400, veh_typ_pickup},
	{543, 15000, veh_typ_pickup},
	{478, 16000, veh_typ_pickup},
	{543, 15000, veh_typ_pickup},
	{422, 16000, veh_typ_pickup},
	{600, 20000, veh_typ_pickup},
	{554, 6400, veh_typ_pickup},
	{412, 25000, veh_typ_lowrid},
	{534, 30000, veh_typ_lowrid},
	{562, 37000, veh_typ_lowrid},
	{576, 46000, veh_typ_lowrid},
	{575, 88000, veh_typ_lowrid},
	{535, 130000, veh_typ_lowrid},
	{498, 21000, veh_typ_ciezar},
	{414, 27000, veh_typ_ciezar},
	{499, 30000, veh_typ_ciezar},
	{456, 31000, veh_typ_ciezar},
	{413, 21000, veh_typ_ciezar},
	{440, 56000, veh_typ_ciezar},
	{482, 79000, veh_typ_ciezar},
	{498, 125000, veh_typ_ciezar},
	{578, 200000, veh_typ_ciezar},
	{565, 57000, veh_typ_race},
	{587, 89000, veh_typ_race},
	{402, 123000, veh_typ_race},
	{558, 134000, veh_typ_race},
	{559, 139000, veh_typ_race},
	{602, 180000, veh_typ_race},
	{477, 789000, veh_typ_race},
	{429, 845000, veh_typ_race},
	{415, 950000, veh_typ_race},
	{506, 1000000, veh_typ_race},
	{451, 1250000, veh_typ_race},
	{411, 1600000, veh_typ_race}
};
//--------------------------------------------

#define TYP_FRAC_ONLY		1
#define TYP_FRAC_ORG		2
#define TYP_ORG_ONLY_CRIME	3
#define TYP_FRAC_ONLY_PD	4
#define TYP_ALL			5

enum Weapon {
	weap_id, 
	weap_cena, 
	weap_name[36], 
	weap_typ, 
	weap_ammo
}

stock Bronie[][Weapon] =
{
	{3, 300, "Pa³ka", 	TYP_FRAC_ONLY_PD, 	1},
	{4, 700, "Nó¿", 	TYP_ORG_ONLY_CRIME, 	1},
	{5, 500, "Basket Ball", TYP_ORG_ONLY_CRIME, 	1},
	{22, 700, "9mm", 	TYP_FRAC_ORG, 		64},
	{24, 900, "Deagle", 	TYP_FRAC_ORG, 		64},
	{25, 1100, "Shotgun", 	TYP_FRAC_ORG, 		30},
	{28, 1500, "Uzi", 	TYP_ORG_ONLY_CRIME, 	120},
	{31, 2000, "M4",	TYP_FRAC_ONLY_PD, 	50},
	{34, 3500, "Snajperka", TYP_ORG_ONLY_CRIME, 	30},
	{8, 200, "Katana", 	TYP_ORG_ONLY_CRIME, 	1}
};

//--------------------------------------------
enum Weap {
	weapon_id, 
	Float:posX, 
	Float:posY,
	Float:posZ,
	Float:posrX,
	Float:posrY,
	Float:posrZ,
	body
}

stock Bron[][Weap] =
{
	{30, -0.1, -0.17, 0.09, 0.0, 50.0, 0.0, 1}, 	// AK-47
	{31, -0.1, -0.17, 0.09, 0.0, 50.0, 0.0, 1}, 	// M4
	{29, -0.1, -0.17, 0.09, 0.0, 50.0, 0.0, 1}, 	// MP5
	{34, -0.1, -0.17, 0.09, 0.0, 50.0, 0.0, 1}, 	// Sniper
	{25, -0.1, -0.17, 0.09, 0.0, 50.0, 0.0, 1}, 	// Shotgun
	{5, -0.1, -0.11, 0.2, 0.0, 130.0, -50.0, 1}, 	// Basket Ball
	{22, 0.05, 0.0, 0.15, -90.0, 370.0, -0.0, 8}, 	// 9mm
	{23, 0.05, 0.0, 0.15, -90.0, 370.0, -0.0, 8}, 	// 9mm t³umik
	{4, 0.1, -0.10, -0.15, 0.0, 90.0, 90.0, 7}, 	// Nó¿
	{3, 0.1, -0.10, -0.15, 10.0, 90.0, 90.0, 7}, 	// Pa³ka
	{24, 0.05, 0.0, 0.15, -90.0, 370.0, -0.0, 8},	// Deagle
	{8, 0.2, -0.15, -0.2, 0.0, -60.0, 0.0, 1}, 	// Katana
	{6, -0.1, -0.11, 0.2, 0.0, 130.0, -70.0, 1}, 	// £opata
	{26, 0.25, -0.13, -0.19, 180.0, 150.0, 0.0, 1},	// Combat Shotgun
	{28, 0.05, -0.05, 0.13, -90.0, -40.0, 0.0, 8},	// Uzi
	{32, 0.05, -0.05, 0.13, -90.0, -40.0, 0.0, 8},	// Tec 9
	{43, 0.1, 0.13, -0.1, 90.0, 140.0, 0.0, 1},	// Aparat
	{46, 0.06, -0.17, -0.0, 0.0, 90.0, 0.0, 1}	// Parachute
};

//--------------------------------------------
enum Jedzenie {
	jedz_uid, 
	jedz_cena, 
	jedz_name[36], 
	jedz_add, 
	jedz_anim
}

stock Jedz[][Jedzenie] =
{
	{1, 2, "P¹czek", 		30, 0},
	{2, 6, "Pizza Large", 		60, 0},
	{3, 4, "Pizza Medium", 		40, 0},
	{4, 3, "Pizza Small", 		30, 0},
	{5, 6, "Hamburger",		60, 0},
	{6, 6, "Cheesburger",		60, 0},
	{7, 3, "Woda", 			25, 23},
	{8, 4, "Sprunk", 		25, 23},
	{9, 5, "Piwo", 			0,  20},
	{10, 10, "Wino", 		15, 22}
};
//--------------------------------------------

#define PANEL_PANEL_FLP		5
#define PANEL_PANEL_FRP		6
#define PANEL_PANEL_RLP		7
#define PANEL_PANEL_RRP		8
#define PANEL_PANEL_WIND	9
#define PANEL_PANEL_FRONT	10
#define PANEL_PANEL_REAR	11

#define PANEL_TYRE_REAR_R	12
#define PANEL_TYRE_FRONT_R	13
#define PANEL_TYRE_REAR_L	14
#define PANEL_TYRE_FRONT_L	15

#define PANEL_LIGHT_FRONT_L	16
#define PANEL_LIGHT_2		17
#define PANEL_LIGHT_FRONT_R	18
#define PANEL_LIGHT_4		19

enum Napraw {
	nap_uid, 
	nap_cena, 
	nap_name[36], 
	nap_typ
}

stock Naprawa[][Napraw] =
{
	{1, 80, "Lewe Drzwi", 		PANEL_DOOR_LEFT},
	{2, 80, "Prawe Drzwi", 		PANEL_DOOR_RIGHT},
	{3, 50, "Bagaznik", 		PANEL_DOOR_BONNET},
	{4, 30, "Maska", 		PANEL_DOOR_BOOT}
};
//--------------------------------------------
#define SKIN_MEN	1
#define SKIN_WOMEN	2

enum Ubranie {
	skin_model,
	skin_plec, 
	skin_cena
}

stock Ciuch[][Ubranie] =
{
 {1, SKIN_MEN, 50},
 {2, SKIN_MEN, 45},
 {7, SKIN_MEN, 24},
 {14, SKIN_MEN, 110},
 {15, SKIN_MEN, 70},
 {16, SKIN_MEN, 50},
 {17, SKIN_MEN, 105},
 {18, SKIN_MEN, 90},
 {19, SKIN_MEN, 25},
 {20, SKIN_MEN, 30},
 {21, SKIN_MEN, 69},
 {22, SKIN_MEN, 89},
 {23, SKIN_MEN, 95},
 {24, SKIN_MEN, 120},
 {25, SKIN_MEN, 70},
 {26, SKIN_MEN, 65},
 {27, SKIN_MEN, 150},
 {28, SKIN_MEN, 135},
 {29, SKIN_MEN, 130},
 {30, SKIN_MEN, 145},
 {32, SKIN_MEN, 140},
 {33, SKIN_MEN, 50},
 {34, SKIN_MEN, 35},
 {46, SKIN_MEN, 60},
 {47, SKIN_MEN, 55},
 {48, SKIN_MEN, 99},
 {49, SKIN_MEN, 66},
 {50, SKIN_MEN, 45},
 {51, SKIN_MEN, 35},
 {52, SKIN_MEN, 50},
 {57, SKIN_MEN, 70},
 {58, SKIN_MEN, 55},
 {59, SKIN_MEN, 25},
 {60, SKIN_MEN, 45},
 {66, SKIN_MEN, 60},
 {67, SKIN_MEN, 80},
 {68, SKIN_MEN, 45},
 {68, SKIN_MEN, 55},
 {72, SKIN_MEN, 35},
 {73, SKIN_MEN, 67},
 {78, SKIN_MEN, 90},
 {79, SKIN_MEN, 56},
 {83, SKIN_MEN, 50},
 {95, SKIN_MEN, 60},
 {98, SKIN_MEN, 25},
 {100, SKIN_MEN, 35},
 {101, SKIN_MEN, 45},
/* {102, SKIN_MEN},
 {103, SKIN_MEN},
 {104, SKIN_MEN},
 {105, SKIN_MEN},
 {106, SKIN_MEN},
 {107, SKIN_MEN},
 {108, SKIN_MEN},
 {109, SKIN_MEN},
 {110, SKIN_MEN},*/
 {111, SKIN_MEN, 25},
 {112, SKIN_MEN, 50},
 {113, SKIN_MEN, 70},
/* {114, SKIN_MEN},
 {115, SKIN_MEN},
 {115, SKIN_MEN},
 {116, SKIN_MEN},
 {117, SKIN_MEN},
 {118, SKIN_MEN},
 {119, SKIN_MEN},
 {119, SKIN_MEN},
 {120, SKIN_MEN},
 {121, SKIN_MEN},
 {122, SKIN_MEN},
 {123, SKIN_MEN},
 {124, SKIN_MEN},
 {125, SKIN_MEN},
 {126, SKIN_MEN},
 {127, SKIN_MEN},*/
 {128, SKIN_MEN, 55},
 {133, SKIN_MEN, 45},
 {134, SKIN_MEN, 66},
 {135, SKIN_MEN, 50},
 {136, SKIN_MEN, 45},
 {137, SKIN_MEN, 80},
 {142, SKIN_MEN, 75},
 {143, SKIN_MEN, 45},
 {147, SKIN_MEN, 66},
 {153, SKIN_MEN, 65},
 {154, SKIN_MEN, 45},
 {155, SKIN_MEN, 90},
 {159, SKIN_MEN, 40},
 {161, SKIN_MEN, 45},
/* {173, SKIN_MEN},
 {174, SKIN_MEN},
 {175, SKIN_MEN},*/
 {176, SKIN_MEN, 60},
 {177, SKIN_MEN, 35},
 {179, SKIN_MEN, 45},
 {180, SKIN_MEN, 70},
 {181, SKIN_MEN, 56},
 {182, SKIN_MEN, 90},
 {183, SKIN_MEN, 45},
 {184, SKIN_MEN, 55},
 {185, SKIN_MEN, 34},
 {186, SKIN_MEN, 45},
 {187, SKIN_MEN, 29},
 {188, SKIN_MEN, 99},
 {189, SKIN_MEN, 67},
 {202, SKIN_MEN, 80},
 {206, SKIN_MEN, 45},
 {217, SKIN_MEN, 55},
 {220, SKIN_MEN, 35},
 {221, SKIN_MEN, 57},
 {222, SKIN_MEN, 45},
 {227, SKIN_MEN, 70},
 {228, SKIN_MEN, 50},
 {229, SKIN_MEN, 70},
 {230, SKIN_MEN, 20},
 {234, SKIN_MEN, 80},
 {235, SKIN_MEN, 52},
 {236, SKIN_MEN, 45},
 {239, SKIN_MEN, 50},
 {240, SKIN_MEN, 38},
 {241, SKIN_MEN, 40},
 {242, SKIN_MEN, 45},
 {247, SKIN_MEN, 32},
 {248, SKIN_MEN, 33},
 {249, SKIN_MEN, 60},
 {250, SKIN_MEN, 45},
 {253, SKIN_MEN, 70},
 {240, SKIN_MEN, 90},
 {251, SKIN_MEN, 45},
 {253, SKIN_MEN, 28},
 {254, SKIN_MEN, 45},
 {258, SKIN_MEN, 45},
 {259, SKIN_MEN, 70},
 {260, SKIN_MEN, 45},
 {261, SKIN_MEN, 25},
 {259, SKIN_MEN, 100},
 {258, SKIN_MEN, 45},
 {262, SKIN_MEN, 25},
/* {269, SKIN_MEN},
 {270, SKIN_MEN},
 {271, SKIN_MEN},*/
 {272, SKIN_MEN, 60},
 {290, SKIN_MEN, 120},
 {291, SKIN_MEN, 150},
 {292, SKIN_MEN, 160},
 {293, SKIN_MEN, 120},
 {295, SKIN_MEN, 150},
 {296, SKIN_MEN, 135},
 {297, SKIN_MEN, 140},
 {299, SKIN_MEN, 150},
{9, SKIN_WOMEN, 55},
{10, SKIN_WOMEN, 30},
{11, SKIN_WOMEN, 90},
{12, SKIN_WOMEN, 50},
//{13, SKIN_WOMEN},
{38, SKIN_WOMEN, 55},
{39, SKIN_WOMEN, 70},
{40, SKIN_WOMEN, 68},
{41, SKIN_WOMEN, 90},
{53, SKIN_WOMEN, 35},
{54, SKIN_WOMEN, 40},
{55, SKIN_WOMEN, 35},
{56, SKIN_WOMEN, 69},
{63, SKIN_WOMEN, 79},
{64, SKIN_WOMEN, 69},
{69, SKIN_WOMEN, 59},
{75, SKIN_WOMEN, 55},
{76, SKIN_WOMEN, 39},
{77, SKIN_WOMEN, 25},
{85, SKIN_WOMEN, 99},
{86, SKIN_WOMEN, 102},
{87, SKIN_WOMEN, 78},
{88, SKIN_WOMEN, 56},
{89, SKIN_WOMEN, 30},
{90, SKIN_WOMEN, 49},
{91, SKIN_WOMEN, 39},
{92, SKIN_WOMEN, 78},
{93, SKIN_WOMEN, 75},
{129, SKIN_WOMEN, 30},
{131, SKIN_WOMEN, 29},
{138, SKIN_WOMEN, 31},
{139, SKIN_WOMEN, 55},
{140, SKIN_WOMEN, 59},
{141, SKIN_WOMEN, 45},
{145, SKIN_WOMEN, 31},
{148, SKIN_WOMEN, 35},
{150, SKIN_WOMEN, 99},
{151, SKIN_WOMEN, 67},
{152, SKIN_WOMEN, 65},
{157, SKIN_WOMEN, 56},
{169, SKIN_WOMEN, 77},
{172, SKIN_WOMEN, 70},
{178, SKIN_WOMEN, 55},
{190, SKIN_WOMEN, 70},
{191, SKIN_WOMEN, 55},
{192, SKIN_WOMEN, 35},
{193, SKIN_WOMEN, 45},
{194, SKIN_WOMEN, 60},
//{195, SKIN_WOMEN},
{196, SKIN_WOMEN, 30},
{197, SKIN_WOMEN, 30},
{198, SKIN_WOMEN, 29},
{199, SKIN_WOMEN, 35},
{201, SKIN_WOMEN, 65},
{205, SKIN_WOMEN, 56},
{207, SKIN_WOMEN, 57},
{211, SKIN_WOMEN, 70},
{214, SKIN_WOMEN, 50},
{215, SKIN_WOMEN, 35},
{216, SKIN_WOMEN, 30},
{218, SKIN_WOMEN, 35},
{219, SKIN_WOMEN, 60},
{224, SKIN_WOMEN, 50},
{225, SKIN_WOMEN, 55},
{226, SKIN_WOMEN, 70},
{231, SKIN_WOMEN, 25},
{232, SKIN_WOMEN, 32},
{233, SKIN_WOMEN, 35},
{237, SKIN_WOMEN, 50},
{238, SKIN_WOMEN, 45},
{244, SKIN_WOMEN, 60},
{245, SKIN_WOMEN, 35},
{246, SKIN_WOMEN, 60},
{251, SKIN_WOMEN, 75},
{256, SKIN_WOMEN, 35},
{257, SKIN_WOMEN, 80},
{263, SKIN_WOMEN, 50},
{298, SKIN_WOMEN, 110}
};

/*stock Componentes[][NazwyKomp] = 
{
	{"Pro", 								900, 				CARMODTYPE_SPOILER},
	{"Win", 								750, 				CARMODTYPE_SPOILER},
	{"Drag", 								800, 				CARMODTYPE_SPOILER},
	{"Alpha", 								600, 				CARMODTYPE_SPOILER},
	{"Champ Scoop", 							600, 				CARMODTYPE_HOOD},
	{"Fury Scoop", 								800, 				CARMODTYPE_HOOD},
	{"Roof Scoop", 								180, 				CARMODTYPE_ROOF},
	{"Sideskirt", 								400, 				SIDESKIRTS},
	{"Nitro 2x", 								500, 				CARMODTYPE_NITRO},
	{"Nitro 5x", 								1000, 				CARMODTYPE_NITRO},
	{"Nitro 10x", 								2000, 				CARMODTYPE_NITRO},
	{"Race Scoop", 								1300, 				CARMODTYPE_HOOD},
	{"Worx Scoop", 								1250, 				CARMODTYPE_HOOD},
	{"Round Fog", 								650, 				LAMPS},
	{"Champ", 								1600, 				CARMODTYPE_SPOILER},
	{"Race", 								1580, 				CARMODTYPE_SPOILER},
	{"Worx", 								1400, 				CARMODTYPE_SPOILER},
	{"Sideskirt", 								400, 				SIDESKIRTS},
	{"Upswept", 								800, 				CARMODTYPE_EXHAUST},
	{"Twin", 								600, 				CARMODTYPE_EXHAUST},
	{"Large", 								500, 				CARMODTYPE_EXHAUST},
	{"Medium", 								300, 				CARMODTYPE_EXHAUST},
	{"Small", 								350, 				CARMODTYPE_EXHAUST},
	{"Fury", 								500, 				CARMODTYPE_SPOILER},
	{"Square Fog", 								500, 				LAMPS},
	{"Off Road", 								1200, 				CARMODTYPE_WHEELS},
	{"Alien", 								900, 				SIDESKIRTS},
	{"Alien", 								900, 				SIDESKIRTS},
	{"Alien", 								1700, 				CARMODTYPE_EXHAUST},
	{"X-Flow", 								1300, 				CARMODTYPE_EXHAUST},
	{"X-Flow", 								750, 				SIDESKIRTS},
	{"X-Flow", 								750, 				SIDESKIRTS},
	{"Alien Roof", 								800, 				CARMODTYPE_ROOF},
	{"X-Flow Roof", 							600, 				CARMODTYPE_ROOF},
	{"Alien", 								1700, 				CARMODTYPE_EXHAUST},
	{"X-Flow Roof", 							600, 				CARMODTYPE_ROOF},
	{"Alien", 								900, 				SIDESKIRTS},
	{"X-Flow", 								1300, 				CARMODTYPE_EXHAUST},
	{"Alien Roof", 								800, 				CARMODTYPE_ROOF},
	{"X-Flow", 								750, 				SIDESKIRTS},
	{"Alien", 								900, 				SIDESKIRTS},
	{"X-Flow", 								750, 				SIDESKIRTS},
	{"Chrome", 								900, 				SIDESKIRTS},
	{"Slamin", 								1300, 				CARMODTYPE_EXHAUST},
	{"Chrome", 								1700, 				CARMODTYPE_EXHAUST},
	{"X-Flow", 								1300, 				CARMODTYPE_EXHAUST},
	{"Alien", 								1700, 				CARMODTYPE_EXHAUST},
	{"Alien", 								900, 				SIDESKIRTS},
	{"X-Flow", 								750, 				SIDESKIRTS},
	{"Alien", 								1400, 				CARMODTYPE_SPOILER},
	{"X-Flow", 								1000, 				CARMODTYPE_SPOILER},
	{"Alien", 								900, 				SIDESKIRTS},
	{"X-Flow", 								750, 				SIDESKIRTS},
	{"X-Flow", 								600, 				CARMODTYPE_ROOF},
	{"Alien", 								800, 				CARMODTYPE_ROOF},
	{"Alien", 								800, 				CARMODTYPE_ROOF},
	{"Alien", 								900, 				SIDESKIRTS},
	{"X-Flow", 								750, 				SIDESKIRTS},
	{"Alien", 								1400, 				CARMODTYPE_SPOILER},
	{"X-Flow", 								1300, 				CARMODTYPE_EXHAUST},
	{"X-Flow", 								1000, 				CARMODTYPE_SPOILER},
	{"X-Flow", 								600, 				CARMODTYPE_ROOF},
	{"Alien", 								900, 				SIDESKIRTS},
	{"X-Flow", 								750, 				SIDESKIRTS},
	{"Alien", 								1700, 				CARMODTYPE_EXHAUST},
	{"Alien", 								1700, 				CARMODTYPE_EXHAUST},
	{"X-Flow", 								1300, 				CARMODTYPE_EXHAUST},
	{"Alien", 								800, 				CARMODTYPE_ROOF},
	{"X-Flow", 								600, 				CARMODTYPE_ROOF},
	{"Alien", 								900, 				SIDESKIRTS},
	{"X-Flow", 								750, 				SIDESKIRTS},
	{"Alien", 								900, 				SIDESKIRTS},
	{"X-Flow", 								750, 				SIDESKIRTS},
	{"Shadow", 								700, 				CARMODTYPE_WHEELS},
	{"Mega", 								1030, 				CARMODTYPE_WHEELS},
	{"Rimshine", 								1800, 				CARMODTYPE_WHEELS},
	{"Wires", 								1560,	 			CARMODTYPE_WHEELS},
	{"Classic", 								1650, 				CARMODTYPE_WHEELS},
	{"Twist", 								1900, 				CARMODTYPE_WHEELS},
	{"Cutter", 								1100, 				CARMODTYPE_WHEELS},
	{"Switch", 								2100, 				CARMODTYPE_WHEELS},
	{"Grove", 								1230, 				CARMODTYPE_WHEELS},
	{"Import", 								1050, 				CARMODTYPE_WHEELS},
	{"Dollar", 								1760, 				CARMODTYPE_WHEELS},
	{"Trancer", 								1350, 				CARMODTYPE_WHEELS},
	{"Atomic", 								1550, 				CARMODTYPE_WHEELS},
	{"Estereo", 								350, 				STEREO},
	{"Hidraulica", 								1600, 				HYDRAULICS},
	{"Alien", 								800, 				CARMODTYPE_ROOF},
	{"X-Flow", 								1300, 				CARMODTYPE_EXHAUST},
	{"Alien", 								900, 				SIDESKIRTS},
	{"X-Flow",	 							600, 				CARMODTYPE_ROOF},
	{"Alien", 								1300,		 		CARMODTYPE_EXHAUST},
	{"X-Flow", 								750, 				SIDESKIRTS},
	{"Alien", 								900, 				SIDESKIRTS},
	{"X-Flow", 								750,	 			SIDESKIRTS},
	{"Ahab", 								1700, 				CARMODTYPE_WHEELS},
	{"Virtual",								850, 				CARMODTYPE_WHEELS},
	{"Access", 								1200, 				CARMODTYPE_WHEELS},
	{"Chrome", 								900, 				SIDESKIRTS},
	{"Chrome Grill", 							1200, 				BULLBARS},
	{"Chrome Flames", 							1700, 				SIDESKIRTS},
	{"Chrome Strip", 							1400, 				SIDESKIRTS},
	{"Convertible", 							1300, 				CARMODTYPE_ROOF},
	{"Chrome", 								1700, 				CARMODTYPE_EXHAUST},
	{"Slamin", 								1300, 				CARMODTYPE_EXHAUST},
	{"Chrome Arches", 							1500, 				SIDESKIRTS},
	{"Chrome Strip", 							1300, 				SIDESKIRTS},
	{"Chrome Strip", 							1300, 				SIDESKIRTS},
	{"Chrome", 								2180, 				REARBULLBARS},
	{"Slamin", 								2100, 				REARBULLBARS},
	{"Little Sign 1",					 		1000, 				FRONTSIGN},
	{"Little Sign 2", 							1200, 				FRONTSIGN},
	{"Chrome", 								1700, 				CARMODTYPE_EXHAUST},
	{"Slamin", 								1300, 				CARMODTYPE_EXHAUST},
	{"Chrome", 								2200, 				FRONTBULLBARS},
	{"Slamin", 								2100, 				FRONTBULLBARS},
	{"Chrome", 								1800, 				CARMODTYPE_FRONT_BUMPER},
	{"Chrome Trim", 							590, 				SIDESKIRTS},
	{"Wheelcovers", 							750, 				SIDESKIRTS},
	{"Chrome Trim", 							590, 				SIDESKIRTS},
 	{"Wheelcovers", 							750, 				SIDESKIRTS},
 	{"Chrome Flames", 							1700, 				SIDESKIRTS},
 	{"Bullbar Chrome Bars", 						1300,			 	BULLBARS},
 	{"Chrome Arches", 							1500, 				SIDESKIRTS},
	{"Bullbar Chrome Lights", 						1000, 				BULLBARS},
	{"Chrome", 								1700, 				CARMODTYPE_EXHAUST},
	{"Slamin", 								1300, 				CARMODTYPE_EXHAUST},
	{"Vinyl Hardtop", 							3400, 				CARMODTYPE_ROOF},
	{"Chrome", 								1700, 				CARMODTYPE_EXHAUST},
	{"Hardtop", 								3000, 				CARMODTYPE_ROOF},
	{"Softtop", 								3300, 				CARMODTYPE_ROOF},
	{"Slamin", 								1300, 				CARMODTYPE_EXHAUST},
	{"Chrome Strip", 							1300, 				SIDESKIRTS},
 	{"Chrome Strip", 							1300, 				SIDESKIRTS},
	{"Slamin", 								1300, 				CARMODTYPE_EXHAUST},
	{"Chrome", 								1700, 				CARMODTYPE_EXHAUST},
	{"Chrome Strip", 							1300, 				SIDESKIRTS},
	{"Alien", 								1400, 				CARMODTYPE_SPOILER},
	{"X-Flow", 								1000,		 		CARMODTYPE_SPOILER},
	{"X-Flow", 								1800, 				REARBUMPERS},
	{"Alien", 								2200, 				REARBUMPERS},
	{"Oval", 								900, 				VENTS},
	{"Oval", 								900, 				VENTS},
	{"Square", 								600, 				VENTS},
	{"Square", 								600, 				VENTS},
	{"X-Flow", 								1400, 				CARMODTYPE_SPOILER},
	{"Alien", 								1000, 				CARMODTYPE_SPOILER},
	{"X-Flow", 								1800, 				REARBUMPERS},
	{"Alien", 								2200, 				REARBUMPERS},
	{"Alien", 								2200, 				REARBUMPERS},
	{"X-Flow",	 							1800, 				REARBUMPERS},
	{"X-Flow", 								1800, 				CARMODTYPE_FRONT_BUMPER},
	{"Alien", 								1800, 				CARMODTYPE_FRONT_BUMPER},
	{"Alien", 								2200, 				REARBUMPERS},
	{"Alien", 								2200, 				CARMODTYPE_FRONT_BUMPER},
	{"X-Flow",	 							1800, 				REARBUMPERS},
	{"X-Flow", 								1800, 				CARMODTYPE_FRONT_BUMPER},
	{"X-Flow", 								1000, 				CARMODTYPE_SPOILER},
	{"Alien", 								2200, 				REARBUMPERS},
	{"Alien", 								2200, 				CARMODTYPE_FRONT_BUMPER},
	{"X-Flow", 								1800, 				REARBUMPERS},
	{"Alien", 								1400, 				CARMODTYPE_SPOILER},
	{"X-Flow", 								1000, 				CARMODTYPE_SPOILER},
	{"Alien", 								1400, 				CARMODTYPE_SPOILER},
	{"X-Flow", 								1800, 				CARMODTYPE_FRONT_BUMPER},
	{"Alien", 								2200, 				CARMODTYPE_FRONT_BUMPER},
	{"X-Flow", 								1800, 				REARBUMPERS},
	{"Alien", 								1800, 				REARBUMPERS},
	{"Alien", 								1800, 				CARMODTYPE_FRONT_BUMPER},
	{"X-Flow", 								1800, 				CARMODTYPE_FRONT_BUMPER},
	{"Alien", 								2200, 				CARMODTYPE_FRONT_BUMPER},
	{"X-Flow", 								1800, 				CARMODTYPE_FRONT_BUMPER},
	{"X-Flow", 								1800, 				CARMODTYPE_FRONT_BUMPER},
	{"Chrome", 								2200, 				CARMODTYPE_FRONT_BUMPER},
	{"Slamin", 								1800, 				REARBUMPERS},
	{"Chrome", 								2200, 				CARMODTYPE_FRONT_BUMPER},
	{"Slamin", 								1800, 				REARBUMPERS},
	{"Slamin", 								1800, 				REARBUMPERS},
	{"Chrome", 								2200, 				CARMODTYPE_FRONT_BUMPER},
	{"Chrome", 								2200, 				REARBUMPERS},
	{"Slamin", 								1800, 				CARMODTYPE_FRONT_BUMPER},
	{"Chrome", 								2200, 				CARMODTYPE_FRONT_BUMPER},
	{"Slamin", 								1800, 				REARBUMPERS},
	{"Chrome", 								2200, 				REARBUMPERS},
	{"Slamin", 								1800, 				CARMODTYPE_FRONT_BUMPER},
	{"Slamin", 								1800, 				REARBUMPERS},
	{"Chrome", 								2200, 				REARBUMPERS},
	{"Slamin", 								1300, 				CARMODTYPE_FRONT_BUMPER},
	{"Chrome", 								1200, 				CARMODTYPE_FRONT_BUMPER},
	{"Slamin", 								1300,	 			CARMODTYPE_FRONT_BUMPER},
	{"Chrome", 								2200, 				CARMODTYPE_FRONT_BUMPER},
	{"Chrome", 								2200, 				REARBUMPERS},
	{"Slamin", 								1300, 				REARBUMPERS}
};

stock CarMods[][15] = 
{
	{400, 1018, 1019, 1020, 1021, 1013, 1024, 0,    0,    0,    0,    0,    0,    0,    0},     //Landstalker
	{401, 1001, 1003, 1004, 1005, 1006, 1013, 1019, 1020, 1007, 1017, 1142, 1143, 1144, 1145},  //Bravura
	{404, 1019, 1020, 1021, 1013, 1007, 1017, 1000, 1002, 1016, 0,    0,    0,    0,    0},     //Perenial
	{405, 1018, 1019, 1020, 1021, 1000, 1001, 1014, 1023, 0,    0,    0,    0,    0,    0},     //Sentinel
	{410, 1019, 1020, 1021, 1013, 1024, 1001, 1003, 1023, 1007, 1017, 0,    0,    0,    0},     //Manana
	{415, 1018, 1019, 1001, 1003, 1023, 1007, 1017, 0,    0,    0,    0,    0,    0,    0},     //Cheetah
	{418, 1020, 1021, 1006, 1002, 1016, 0,    0,    0,    0,    0,    0,    0,    0,    0},     //Moonbeam
	{420, 1004, 1005, 1019, 1021, 1001, 1003, 0,    0,    0,    0,    0,    0,    0,    0},     //Taxi
	{421, 1018, 1019, 1020, 1021, 1000, 1014, 1016, 1023, 0,    0,    0,    0,    0,    0},     //Washington
	{422, 1013, 1019, 1020, 1021, 1007, 1017, 0,    0,    0,    0,    0,    0,    0,    0},     //Bobcat
	{426, 1004, 1005, 1019, 1021, 1001, 1003, 1006, 0,    0,    0,    0,    0,    0,    0},     //Premier
	{436, 1019, 1020, 1021, 1022, 1006, 1013, 1001, 1003, 1007, 1017, 0,    0,    0,    0},     //Previon
	{439, 1142, 1143, 1144, 1145, 1013, 1001, 1003, 1023, 1007, 1017, 0,    0,    0,    0},     //Stallion
	{477, 1018, 1019, 1020, 1021, 1006, 1007, 1017, 0,    0,    0,    0,    0,    0,    0},     //ZR-350
	{478, 1004, 1005, 1012, 1020, 1021, 1022, 1013, 1024, 0,    0,    0,    0,    0,    0},     //Walton
	{489, 1004, 1005, 1018, 1019, 1020, 1013, 1024, 1006, 1000, 1002, 1016, 0,    0,    0},     //Rancher
	{491, 1142, 1143, 1144, 1145, 1018, 1019, 1020, 1021, 1003, 1014, 1023, 1007, 1017, 0},     //Virgo
	{492, 1004, 1005, 1000, 1006, 1016, 0,    0,    0,    0,    0,    0,    0,    0,    0},     //Greenwood
	{496, 1001, 1002, 1003, 1006, 1011, 1019, 1020, 1023, 1007, 1017, 1142, 1143, 0,    0},     //Blista Compact
	{500, 1019, 1020, 1021, 1013, 1024, 0,    0,    0,    0,    0,    0,    0,    0,    0},     //Mesa
	{516, 1004, 1018, 1019, 1020, 1021, 1000, 1002, 1015, 1016, 1007, 1017, 0,    0,    0},     //Nebula
	{517, 1007, 1017, 1142, 1143, 1144, 1145, 1018, 1019, 1020, 1002, 1003, 1016, 1023, 0},     //Majestic
	{518, 1001, 1005, 1006, 1013, 1018, 1020, 1023, 1142, 1143, 1144, 1145, 0,    0,    0},     //Buccaneer
	{527, 1018, 1020, 1021, 1001, 1014, 1015, 1007, 1017, 0,    0,    0,    0,    0,    0},     //Cadrona
	{529, 1011, 1012, 1018, 1019, 1020, 1006, 1001, 1003, 1023, 1007, 1017, 0,    0,    0},     //Willard
	{534, 1100, 1101, 1106, 1122, 1123, 1124, 1125, 1126, 1127, 1178, 1179, 1180, 1185, 0},     //Remington
	{535, 1109, 1110, 1111, 1112, 1113, 1114, 1115, 1116, 1117, 1118, 1119, 1120, 1121, 0},     //Slamvan
	{536, 1103, 1104, 1105, 1107, 1108, 1128, 1181, 1182, 1183, 1184, 0,    0,    0,    0},     //Blade
	{540, 1004, 1142, 1143, 1144, 1145, 1018, 1019, 1020, 1006, 1024, 1001, 1023, 1007, 1017},  //Vincent
	{542, 1018, 1019, 1020, 1021, 1014, 1015, 1144, 1145, 0,    0,    0,    0,    0,    0},     //Clover
	{546, 1004, 1142, 1143, 1144, 1145, 1018, 1019, 1006, 1024, 1001, 1002, 1023, 1007, 1017},  //Intruder
	{547, 1142, 1143, 1018, 1019, 1020, 1021, 1000, 1003, 1016, 0,    0,    0,    0,    0},     //Primo
	{549, 1011, 1012, 1142, 1143, 1144, 1145, 1018, 1019, 1020, 1001, 1003, 1023, 1007, 1017},  //Tampa
	{550, 1004, 1005, 1142, 1143, 1144, 1145, 1018, 1019, 1020, 1001, 1003, 1023, 1007, 1017},  //Sunrise
	{551, 1005, 1006, 1018, 1019, 1020, 1021, 1002, 1003, 1016, 1023, 0,    0,    0,    0},     //Merit
	{558, 1088, 1089, 1090, 1091, 1092, 1093, 1094, 1095, 1163, 1164, 1165, 1168, 0,    0},     //Uranus
    	{559, 1065, 1066, 1067, 1068, 1069, 1070, 1071, 1072, 1158, 1159, 1160, 1161, 1162, 1173},  //Jester
	{560, 1026, 1027, 1028, 1029, 1030, 1031, 1032, 1033, 1138, 1139, 1140, 1141, 1169, 1170},  //Sultan
	{561, 1055, 1056, 1057, 1058, 1059, 1060, 1061, 1062, 1063, 1064, 1154, 1155, 1156, 1157},  //Stratum
	{562, 1034, 1035, 1036, 1037, 1038, 1039, 1040, 1041, 1146, 1147, 1148, 1149, 1171, 1172},  //Elegy
	{565, 1045, 1046, 1047, 1048, 1049, 1050, 1051, 1052, 1053, 1054, 1150, 1151, 1152, 1153},  //Flash
    	{567, 1102, 1129, 1130, 1131, 1132, 1133, 1186, 1187, 1188, 1189, 0,    0,    0,    0},     //Savanna
	{575, 1042, 1043, 1044, 1099, 1074, 1075, 1076, 1077, 0,    0,    0,    0,    0,    0},     //Broadway
	{576, 1134, 1135, 1136, 1137, 1190, 1191, 1192, 1193, 0,    0,    0,    0,    0,    0},     //Tornado
	{580, 1018, 1020, 1001, 1006, 1023, 1007, 1017, 0,    0,    0,    0,    0,    0,    0},     //Stafford
	{585, 1142, 1143, 1144, 1145, 1018, 1019, 1020, 1013, 1006, 1001, 1003, 1023, 1007, 1017},  //Emperor
	{589, 1004, 1005, 1144, 1145, 1018, 1020, 1013, 1024, 1006, 1000, 1016, 1007, 1017, 0},     //Club
	{600, 1004, 1005, 1018, 1020, 1022, 1006, 1013, 1007, 1017, 0,    0,    0,    0,    0},     //Picador
	{603, 1142, 1143, 1144, 1145, 1018, 1019, 1020, 1013, 1001, 1006, 1023, 1007, 1017, 0}      //Phoenix
};

stock SimilarComponents[][2] = 
{
	{1007, 1017},
	{1026, 1027},
	{1030, 1031},
	{1036, 1040},
	{1039, 1041},
	{1042, 1099},
	{1047, 1051},
	{1048, 1052},
	{1056, 1062},
	{1057, 1063},
	{1069, 1071},
	{1070, 1072},
	{1090, 1094},
	{1093, 1095},
	{1106, 1124},
	{1107, 1108},
	{1118, 1120},
	{1119, 1121},
	{1122, 1101},
	{1133, 1102},
	{1143, 1142},
	{1145, 1144}
};
*/
stock GetPlayerFraction(playerid)
{
    return PlayerInfo[playerid][frac];
}
stock GetFractionName(playerid)
{
    return Faction[GetPlayerFraction(playerid)][desc];
}
stock IsFractionLeader(playerid,fracid)
{
    if(GetPlayerFraction(playerid) == fracid)
        if(PlayerInfo[playerid][fracrank] == 255)
            return 1;
    return 0;
}

stock GetPlayerOrganisation(playerid)
{
    return PlayerInfo[playerid][org];
}
stock GetOrganisationName(playerid)
{
    return Org[GetPlayerOrganisation(playerid)][desc];
}
stock IsOrganisationLeader(playerid,orgid)
{
    if(GetPlayerOrganisation(playerid) == orgid)
        if(PlayerInfo[playerid][orgrank] == 255)
            return 1;
    return 0;
}

stock GetPlayerBusiness(playerid)
{
    return PlayerInfo[playerid][biz];
}
stock GetBusinessName(playerid)
{
    return Business[GetPlayerBusiness(playerid)][desc];
}
stock IsBusinessLeader(playerid,bizid)
{
    if(GetPlayerBusiness(playerid) == bizid)
        if(PlayerInfo[playerid][bizrank] == 255)
            return 1;
    return 0;
}
stock IsABoat(carid)
{
	new model = GetVehicleModel(carid);
	switch(model)
	{
		case 430,446,452,453,454,472,473,484,493,595: return 1;
		default: return 0;
	}
	return 1;
}
stock IsABike(carid)//Kategoria A
{
	new model = GetVehicleModel(carid);
	switch(model)
	{
		case 521,522,581,586,448,461,462,463,468,471: return 1;
		default: return 0;
	}
	return 1;
}
stock IsARower(carid)
{
	new model = GetVehicleModel(carid);
	switch(model)
	{
		case 481,509,510: return 1;
		default: return 0;
	}
	return 1;
}
stock IsAPlane(carid)
{
	new model = GetVehicleModel(carid);
	switch(model)
	{
		case 460,464,476,511,513,519,520,539,593,417,425,447,465: return 1;
		case 469,487,488,497,501,548,563,592,577,553: return 1;
		default: return 0;
	}
	return 1;
}
stock IsATir(carid)//Kategoria C+E
{
	new model = GetVehicleModel(carid);
	switch(model)
	{
		case 524,578,455,403,443,514,515,408,499,498,609,414,456: return 1;
		case 406,407,416,427,428,433,486,532,544,573: return 1;
		default: return 0;
	}
	return 1;
}
stock IsABus(carid)
{ //Kategoria D+E
	new model = GetVehicleModel(carid);
	switch(model){
	    case 431:return 1;
	    case 437:return 1;
	   	default: return 0;

	}
	return 1;
}
stock PreloadAnimLibraries(playerid) // By Ziomal
{
	static AnimLibraries[][] =
	{
		"AIRPORT","Attractors","BAR","BASEBALL","BD_FIRE","BEACH","benchpress",
		"BF_injection","BIKED","BIKEH","BIKELEAP","BIKES","BIKEV","BIKE_DBZ","BMX",
		"BOMBER","BOX","BSKTBALL","BUDDY","BUS","CAMERA","CAR","CARRY","CAR_CHAT",
		"CASINO","CHAINSAW","CHOPPA","CLOTHES","COACH","COLT45","COP_AMBIENT",
		"COP_DVBYZ","CRACK","CRIB","DAM_JUMP","DANCING","DEALER","DILDO","DODGE",
		"DOZER","DRIVEBYS","FAT","FIGHT_B","FIGHT_C","FIGHT_D","FIGHT_E","FINALE",
		"FINALE2","FLAME","Flowers","FOOD","Freeweights","GANGS","GHANDS",
		"GHETTO_DB","goggles","GRAFFITI","GRAVEYARD","GRENADE","GYMNASIUM",
		"HAIRCUTS","HEIST9","INT_HOUSE","INT_OFFICE","INT_SHOP","JST_BUISNESS",
		"KART","KISSING","KNIFE","LAPDAN1","LAPDAN2","LAPDAN3","LOWRIDER",
		"MD_CHASE","MD_END","MEDIC","MISC","MTB","MUSCULAR","NEVADA","ON_LOOKERS",
		"OTB","PARACHUTE","PARK","PAULNMAC","ped","PLAYER_DVBYS","PLAYIDLES",
		"POLICE","POOL","POOR","PYTHON","QUAD","QUAD_DBZ","RAPPING","RIFLE","RIOT",
		"ROB_BANK","ROCKET","RUSTLER","RYDER","SCRATCHING","SHAMAL","SHOP",
		"SHOTGUN","SILENCED","SKATE","SMOKING","SNIPER","SPRAYCAN","STRIP",
		"SUNBATHE","SWAT","SWEET","SWIM","SWORD","TANK","TATTOOS","TEC","TRAIN",
		"TRUCK","UZI","VAN","VENDING","VORTEX","WAYFARER","WEAPONS","WUZI"
	};

	for(new l; l < sizeof(AnimLibraries); l++)
		ApplyAnimation(playerid, AnimLibraries[l], "null", 0.0, 0, 0, 0, 0, 0);
		
	return 1;
}
stock NickNameDB(idgracza) return PlayerInfo[idgracza][globname];

stock Float:GetXYInFrontOfPlayer(playerid, &Float:x, &Float:y, Float:distance)
{
    new Float:a;
    GetPlayerPos(playerid, x, y, a);
    if (IsPlayerInAnyVehicle(playerid)) GetVehicleZAngle(GetPlayerVehicleID(playerid), a); else GetPlayerFacingAngle(playerid, a);
    x += (distance * floatsin(-a, degrees)); y += (distance * floatcos(-a, degrees));
    return a;
}

stock ObjectModel[48] =
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

stock GetPlayerIdWithName(const playername[])
{
  	foreach(Player, C) if(!strcmp(NickName(C), playername)) return C;
  	return -1;
}

stock NazwaBroni(id)
{
	new gunname[32];
	GetWeaponName(id,gunname,sizeof(gunname));
	return gunname;
}