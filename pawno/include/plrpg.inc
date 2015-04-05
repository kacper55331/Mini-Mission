/* -------------------------- PL:RPG --------------------------- 
   Copyright by Kacper Michiewicz
   ---------------------------------------------------------- */
   
#include <a_samp>
#include <a_angles>
#include <a_audio> 
#include <a_mysql>
#include <sscanf2>
#include <foreach>
#include <onplayershoot>
#include <progressbar>
#include <streamer>
#include <md5>
#include <zcmd>
#include <dudb>

#define INVALID_PLAYER_TEAM     0
#define INVALID_PLAYER_LANG     0
#define INVALID_PLAYER_UID      0
#define INVALID_GANG_ID         0

#define LANG_ANG        1
#define LANG_PL         2

#define TEAM_CYWIL      1
#define TEAM_DRUGDIL    2
#define TEAM_ARMDIL     3
#define TEAM_BITCH      4
#define TEAM_PILOT      5
#define TEAM_TAXIDRI    6
#define TEAM_KURIER     7
#define TEAM_MECHANIK   8
#define TEAM_PRISONPD   9
#define TEAM_FBI        10
#define TEAM_SWAT       11
#define TEAM_POLICE     12
#define TEAM_OFFICER    13

#define VEH_TYPE_NONE     0
#define VEH_TYPE_PLAYER   1
#define VEH_TYPE_TEAM     2

#define IN_NAME         "Polish RPG"
#define IN_BAZA         "connect.ini"

#define TEXT_LOGIN  "{FFFFFF}Witaj na serwerze {008000}"IN_NAME".\n{FFFFFF}Aby siê zalogowaæ wpisz poni¿ej swoje has³o."
#define TEXT_REG    "{FFFFFF}Witaj na serwerze {008000}"IN_NAME".\n{FFFFFF}Aby siê zarejestrowaæ wciœnij zarejestruj."

#define FuncPub::%1(%2) 	  forward %1(%2);public %1(%2)
						
#define Cmd::Input->%1(%2)  cmd(%1,%2)
#define Chat::Output        SendClientMessage
#define Dialog::Output      ShowPlayerDialog

#define MAX_HOUSE     200
#define MAX_GANGS     100

#define BEZOWY        0xFFFFADAA
#define BIALY         0xFFFFFFFF
#define BLEKITNY      0x33CCFFAA
#define BORDOWY       0x99001FAA
#define BRAZOWY       0x997A00AA
#define DARK_ZIELONY  0x336633AA
#define CZARNY        0x000000AA
#define CZERWONY      0xFF0000AA
#define FIOLETOWY     0xC2A2DAAA
#define FIOLETOWY2    0xE0EA64AA
#define NIEBIESKI     0x0000FFAA
#define POMARANCZOWY  0xFF8000AA
#define CIEMNYW 	    0xFFA448FF
#define ROZOWY        0xFF66CCAA
#define SZARY         0xB0B0B0AA
#define ZIELONY       0x00CC00AA
#define ZOLTY         0xFFFF00AA
#define RED           0xFF0000AA
#define LCZERWONY     0xFF6347AA
#define COLOR_RED     0xFF0000AA
#define NIEBIESKI1    0x0066FFFF
#define ME      	    0xC2A2DAAA
#define ZIELONKAWY    0x9CE882FF
#define DO            0x6C6CB7FF
#define NIEBIESKI2    0x1A79D9FF
#define RO 			      0x6262FFFF
#define BO 			      0x3287CDFF
#define OO 			      0xFFFF00AA
#define ADM 		      0x0279FFFF
#define COLOR_FADE1   0xE6E6E6E6
#define COLOR_FADE2   0xC8C8C8C8
#define COLOR_FADE3   0xAAAAAAAA
#define COLOR_FADE4   0x8C8C8C8C
#define COLOR_FADE5   0x6E6E6E6E

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

new Vehicles[212][]=
{
	"Landstalker", "Bravura", "Buffalo", "Linerunner", "Pereniel", "Sentinel", "Dumper", "Firetruck", "Trashmaster", "Stretch", "Manana",
	"Infernus", "Voodoo", "Pony", "Mule", "Cheetah", "Ambulance", "Leviathan", "Moonbeam", "Esperanto", "Taxi", "Washington", "Bobcat",
	"Mr Whoopee", "BF Injection", "Hunter", "Premier", "Enforcer", "Securicar", "Banshee", "Predator", "Bus", "Rhino", "Barracks",
	"Hotknife", "Trailer", "Previon", "Coach", "Cabbie", "Stallion", "Rumpo", "RC Bandit", "Romero", "Packer", "Monster", "Admiral",
	"Squalo", "Seasparrow", "Pizzaboy", "Tram", "Trailer", "Turismo", "Speeder", "Reefer", "Tropic", "Flatbed", "Yankee", "Caddy",
	"Solair", "Berkley's RC Van", "Skimmer", "PCJ-600", "Faggio", "Harley", "RC Baron", "RC Raider", "Glendale", "Oceanic",
	"Sanchez", "Sparrow", "Patriot", "Quad", "Coastguard", "Dinghy", "Hermes", "Sabre", "Rustler", "ZR3 50", "Walton", "Regina",
	"Comet", "BMX", "Burrito", "Camper", "Marquis", "Baggage", "Dozer", "Maverick", "News Chopper", "Rancher", "FBI Rancher",
	"Virgo", "Greenwood", "Jetmax", "Hotring", "Sandking", "Blista Compact", "Police Maverick", "Boxville", "Benson", "Mesa",
	"RC Goblin", "Hotring Racer", "Hotring Racer", "Bloodring Banger", "Rancher", "Super GT", "Elegant", "Journey", "Bike",
	"Mountain Bike", "Beagle", "Cropdust", "Stunt", "Tanker", "RoadTrain", "Nebula", "Majestic", "Buccaneer", "Shamal", "Hydra",
	"FCR-900", "NRG-500", "HPV1000", "Cement Truck", "Tow Truck", "Fortune", "Cadrona", "FBI Truck", "Willard", "Forklift", "Traktor",
	"Combine", "Feltzer", "Remington", "Slamvan", "Blade", "Freight", "Streak", "Vortex", "Vincent", "Bullet", "Clover", "Sadler",
	"Firetruck", "Hustler", "Intruder", "Primo", "Cargobob", "Tampa", "Sunrise", "Merit", "Utility", "Nevada", "Yosemite", "Windsor",
	"Monster", "Monster", "Uranus", "Jester", "Sultan", "Stratum", "Elegy", "Raindance", "RC Tiger", "Flash", "Tahoma", "Savanna",
	"Bandito", "Freight", "Trailer", "Kart", "Mower", "Duneride", "Sweeper", "Broadway", "Tornado", "AT-400", "DFT-30", "Huntley",
	"Stafford", "BF-400", "Newsvan", "Tug", "Trailer", "Emperor", "Wayfarer", "Euros", "Hotdog", "Club", "Trailer", "Trailer",
	"Andromeda", "Dodo", "RC Cam", "Launch", "Radiowoz", "Radiowoz", "Radiowoz", "Radiowoz", "Picador", "S.W.A.T. Van",
	"Alpha", "Phoenix", "Glendale", "Sadler", "Luggage Trailer", "Luggage Trailer", "Stair Trailer", "Boxville", "Farm Plow", "Utility Trailer"
};

new MonthNames[13][13] = {
  {""},
  {"Styczeñ"},
  {"Luty"},
  {"Marzec"},
  {"Kwiecieñ"},
  {"Maj"},
  {"Czerwiec"},
  {"Lipiec"},
  {"Sierpieñ"},
  {"Wrzesieñ"},
  {"PaŸdziernik"},
  {"Listopad"},
  {"Grudzieñ"}
};

stock DTime(d)
{
  new t[10];
  if(d == 1) t = "dzieñ";
  else t = "dni";
  return t;
}

stock HTime(h)
{
  new t[15];
  switch(h)
  {
    case 0, 5..21: t = "godzin";
    case 1: t = "godzina";
    case 2..4, 22..24: t = "godziny";
  }
  return t;
}

stock MTime(M)
{
  new t[15];
  switch(M)
  {
    case 0, 5..21, 25..60: t = "minut";
    case 1: t = "minuta";
    case 2..4, 22..24: t = "minuty";
  }
  return t;
}

stock STime(s)
{
  new t[15];
  switch(s)
  {
    case 0, 5..21, 25..60: t = "sekund";
    case 1: t = "sekunda";
    case 2..4, 22..24: t = "sekundy";
  }
  return t;
}

stock FullTime(sekundy,&dni,&godziny,&minuty,&sek)  // By Terminator3
{ 
  if(sekundy<60) 
  { 
    sek=sekundy; 
    return 1; 
  } 
  while(sekundy >= 86400) 
  { 
    dni+=1; 
    sekundy-=86400; 
  } 
  if(sekundy==0) return 1; 
  while(sekundy>=3600) 
  { 
    godziny+=1; 
    sekundy-=3600; 
  } 
  if(sekundy==0) return 1; 
  while(sekundy >= 60) 
  { 
    minuty+=1; 
    sekundy-=60; 
  } 
  sek=sekundy; 
  return 1;
}

stock YesOrNo(whatid)
{
	new str[15];
	if(whatid == 1) 	format(str, sizeof(str), "Tak");
	else if(whatid == 0)	format(str, sizeof(str), "Nie");
	return str;
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

new Float:PoliceSpawns[][4] = {
{1568.2250,-1693.5483,5.8906,177.0983},
{-1604.8442,732.9442,-5.2344,37.6041},
{2343.4553,2455.5994,14.9688,96.5022}
};

new Float:Spawns[][4] = {
{1751.1097,-2106.4529,13.5469,183.1979}, // El-Corona - Outside random house
{2652.6418,-1989.9175,13.9988,182.7107}, // Random house in willowfield - near playa de seville and stadium
{2489.5225,-1957.9258,13.5881,2.3440}, // Hotel in willowfield - near cluckin bell
{2689.5203,-1695.9354,10.0517,39.5312}, // Outside stadium - lots of cars
{2770.5393,-1628.3069,12.1775,4.9637}, // South in east beach - north of stadium - carparks nearby
{2807.9282,-1176.8883,25.3805,173.6018}, // North in east beach - near apartments
{2552.5417,-958.0850,82.6345,280.2542}, // Random house north of Las Colinas
{2232.1309,-1159.5679,25.8906,103.2939}, // Jefferson motel
{2388.1003,-1279.8933,25.1291,94.3321}, // House south of pig pen
{2481.1885,-1536.7186,24.1467,273.4944}, // East LS - near clucking bell and car wash
{2495.0720,-1687.5278,13.5150,359.6696}, // Outside CJ's house - lots of cars nearby
{2306.8252,-1675.4340,13.9221,2.6271}, // House in ganton - lots of cars nearby
{2191.8403,-1455.8251,25.5391,267.9925}, // House in south jefferson - lots of cars nearby
{1830.1359,-1092.1849,23.8656,94.0113}, // Mulholland intersection carpark
{2015.3630,-1717.2535,13.5547,93.3655}, // Idlewood house
{1654.7091,-1656.8516,22.5156,177.9729}, // Right next to PD
{1219.0851,-1812.8058,16.5938,190.0045}, // Conference Center
{1508.6849,-1059.0846,25.0625,1.8058}, // Across the street of BANK - lots of cars in intersection carpark
{1421.0819,-885.3383,50.6531,3.6516}, // Outside house in vinewood
{1133.8237,-1272.1558,13.5469,192.4113}, // Near hospital
{1235.2196,-1608.6111,13.5469,181.2655}, // Backalley west of mainstreet
{590.4648,-1252.2269,18.2116,25.0473}, // Outside "BAnk of San Andreas"
{842.5260,-1007.7679,28.4185,213.9953}, // North of Graveyard
{911.9332,-1232.6490,16.9766,5.2999}, // LS Film Studio
{477.6021,-1496.6207,20.4345,266.9252}, // Rodeo Place
{255.4621,-1366.3256,53.1094,312.0852}, // Outside propery in richman
{281.5446,-1261.4562,73.9319,305.0017}, // Another richman property
{790.1918,-839.8533,60.6328,191.9514}, // Mulholland house
{1299.1859,-801.4249,84.1406,269.5274}, // Maddoggs
{1240.3170,-2036.6886,59.9575,276.4659}, // Verdant Bluffs
{2215.5181,-2627.8174,13.5469,273.7786}, // Ocean docks 1
{2509.4346,-2637.6543,13.6453,358.3565}, // Ocean Docks spawn 2
{1435.8024,2662.3647,11.3926,1.1650}, //  Northern train station
{1457.4762,2773.4868,10.8203,272.2754}, //  Northern golf club
{1739.6390,2803.0569,14.2735,285.3929}, //  Northern housing estate 1
{1870.3096,2785.2471,14.2734,42.3102}, //  Northern housing estate 2
{1959.7142,2754.6863,10.8203,181.4731}, //  Northern house 1
{2314.2556,2759.4504,10.8203,93.2711}, //  Northern industrial estate 1
{2216.5674,2715.0334,10.8130,267.6540}, //  Northern industrial estate 2
{2101.4192,2678.7874,10.8130,92.0607}, //  Northern near railway line
{1951.1090,2660.3877,10.8203,180.8461}, //  Northern house 2
{1666.6949,2604.9861,10.8203,179.8495}, //  Northern house 3
{2808.3367,2421.5107,11.0625,136.2060}, //  Northern shopping centre
{2633.3203,2349.7061,10.6719,178.7175}, //  V-Rock
{2606.6348,2161.7490,10.8203,88.7508}, //  South V-Rock
{2616.5286,2100.6226,10.8158,177.7834}, //  North Ammunation 1
{2491.8816,2397.9370,10.8203,266.6003}, //  North carpark 1
{2531.7891,2530.3223,21.8750,91.6686}, //  North carpark 2
{2340.6677,2530.4324,10.8203,177.8630}, //  North Pizza Stack
{2097.6855,2491.3313,14.8390,181.8117}, //  Emerald Isle
{1893.1000,2423.2412,11.1782,269.4385}, //  Souvenir shop
{1698.9330,2241.8320,10.8203,357.8584}, //  Northern casino
{1479.4559,2249.0769,11.0234,306.3790}, //  Baseball stadium 1
{1298.1548,2083.4016,10.8127,256.7034}, //  Baseball stadium 2
{1117.8785,2304.1514,10.8203,81.5490}, //  North carparks
{1108.9878,1705.8639,10.8203,0.6785}, //  Dirtring racing 1
{1423.9780,1034.4188,10.8203,90.9590}, //  Sumo
{1537.4377,752.0641,11.0234,271.6893}, //  Church
{1917.9590,702.6984,11.1328,359.2682}, //  Southern housing estate
{2089.4785,658.0414,11.2707,357.3572}, //  Southern house 1
{2489.8286,928.3251,10.8280,67.2245}, //  Wedding chapel
{2697.4717,856.4916,9.8360,267.0983}, //  Southern construction site
{2845.6104,1288.1444,11.3906,3.6506}, //  Southern train station
{2437.9370,1293.1442,10.8203,86.3830}, //  Wedding chapel (near Pyramid)
{2299.5430,1451.4177,10.8203,269.1287}, //  Carpark (near Pyramid)
{2214.3008,2041.9165,10.8203,268.7626}, //  Central parking lot
{2005.9174,2152.0835,10.8203,270.1372}, //  Central motel
{2222.1042,1837.4220,10.8203,88.6461}, //  Clowns Pocket
{2025.6753,1916.4363,12.3382,272.5852}, //  The Visage
{2087.9902,1516.5336,10.8203,48.9300}, //  Royal Casino
{2172.1624,1398.7496,11.0625,91.3783}, //  Auto Bahn
{2139.1841,987.7975,10.8203,0.2315}, //  Come-a-lot
{1860.9672,1030.2910,10.8203,271.6988}, //  Behind 4 Dragons
{1673.2345,1316.1067,10.8203,177.7294}, //  Airport carpark
{1412.6187,2000.0596,14.7396,271.3568}, //  South baseball stadium houses
{-2723.4639,-314.8138,7.1839,43.5562},  // golf course spawn
{-2694.5344,64.5550,4.3359,95.0190},  // in front of a house
{-2458.2000,134.5419,35.1719,303.9446},  // hotel
{-2796.6589,219.5733,7.1875,88.8288},  // house
{-2706.5261,397.7129,4.3672,179.8611},  // park
{-2866.7683,691.9363,23.4989,286.3060},  // house
{-2764.9543,785.6434,52.7813,357.6817},  // donut shop
{-2660.9402,883.2115,79.7738,357.4440},  // house
{-2861.0796,1047.7109,33.6068,188.2750}, //  parking lot
{-2629.2009,1383.1367,7.1833,179.7006},  // parking lot at the bridge
{-2079.6802,1430.0189,7.1016,177.6486},  // pier
{-1660.2294,1382.6698,9.8047,136.2952}, //  pier 69
{-1674.1964,430.3246,7.1797,226.1357},  // gas station]
{-1954.9982,141.8080,27.1747,277.7342},  // train station
{-1956.1447,287.1091,35.4688,90.4465},  // car shop
{-1888.1117,615.7245,35.1719,128.4498},  // random
{-1922.5566,886.8939,35.3359,272.1293},  // random
{-1983.3458,1117.0645,53.1243,271.2390},  // church
{-2417.6458,970.1491,45.2969,269.3676},  // gas station
{-2108.0171,902.8030,76.5792,5.7139},  // house
{-2097.5664,658.0771,52.3672,270.4487},  // random
{-2263.6650,393.7423,34.7708,136.4152},  // random
{-2287.5027,149.1875,35.3125,266.3989},  // baseball parking lot
{-2039.3571,-97.7205,35.1641,7.4744},  // driving school
{-1867.5022,-141.9203,11.8984,22.4499},  // factory
{-1537.8992,116.0441,17.3226,120.8537},  // docks ship
{-1708.4763,7.0187,3.5489,319.3260},  // docks hangar
{-1427.0858,-288.9430,14.1484,137.0812},  // airport
{-2173.0654,-392.7444,35.3359,237.0159},  // stadium
{-2320.5286,-180.3870,35.3135,179.6980},  // burger shot
{-2930.0049,487.2518,4.9141,3.8258}  // harbor
};

// -- Player -- //
new
    bool:Logged[MAX_PLAYERS];

// -- Player - Enum -- //
enum ePlayer {
	player_uid,
	player_name[MAX_PLAYER_NAME],
	player_pass[64],
	player_ip[30],
	player_team,
	player_lang,
	player_score,
	player_cash,
	player_timehere,
	player_kills,
	player_death,
	player_admin,
	player_prison,
	player_bank,
	player_visits,
	player_wanted,
	//
	player_gang,
	player_gangrank,
	player_gangskin,
	
	Text3D:player_tag,
}
new Player[MAX_PLAYERS][ePlayer];

// -- Veh -- //
new 
    Iterator:Vehicle<MAX_VEHICLES>;
    
// -- Veh - Enum -- //
enum eVehicle {
  veh_uid,
  veh_model,
  Float:veh_hp,
  Float:veh_posX,
  Float:veh_posY,
  Float:veh_posZ,
  Float:veh_posA,
  veh_ownerType,
  veh_owner,
  veh_fuel,
  veh_color1,
  veh_color2,
  veh_plate[32],
  //
  veh_id,
}
new Veh[MAX_VEHICLES][eVehicle];

// -- House - Enum -- //
enum eHouse {
  house_uid,
  house_name[64],
  Float:house_inPosX,
  Float:house_inPosY,
  Float:house_inPosZ,
  house_inPosInt,
  Float:house_outPosX,
  Float:house_outPosY,
  Float:house_outPosZ,
  house_owner,
  //
  house_price,
  house_close,
  //
//  house_audio[64],
  //
  house_pickup,
  Text3D:house_tag,
}
new House[MAX_HOUSE][eHouse];  

enum eGang {
    gang_uid,
    gang_name[64],
    gang_cash,
    gang_skin,
    gang_color,
}
new Gang[MAX_GANGS][eGang];    
