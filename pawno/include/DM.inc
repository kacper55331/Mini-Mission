#include <a_samp>
#include <zcmd>
#include <DUDB>
#include <a_audio>
#include <sscanf2>
#include <td>

#define foreach(%1) 		for(new %1 = 0; %1 < GetMaxPlayers(); %1++) if(IsPlayerConnected(%1)&&!IsPlayerNPC(%1))
#define foreachEx(%2,%1) 	for(new %2 = 0; %2 < %1; %2++)
#define FuncPub::%1(%2) 	forward %1(%2);public %1(%2)

#undef  MAX_PLAYERS
#define MAX_PLAYERS 		30

#define CLR_BLACK 		0x000000FF
#define CLR_GREY 		0xAFAFAFAA
#define CLR_WHITE 		0xFFFFFFFF
#define CLR_RED 		0xFF0000FF
#define CLR_DARKRED 		0xCF4028FF
#define CLR_ORANGE 		0xFFC973FF
#define CLR_DARKORANGE 		0xFDAE33FF
#define CLR_GREEN 		0x42B542FF
#define CLR_LIGHTGREEN 		0xA8EEA8FF
#define CLR_LIGHTBLUE 		0x1E90FFFF
#define CLR_YELLOW 		0xFFFF02FF
#define CLR_CYAN 		0x42D3FFFF
#define CLR_DARKCYAN 		0x59BDC6FF
#define CLR_PINK 		0xC2A2DAFF
#define CLR_LIGHTPINK 		0xFFC3FFFF
#define CLR_NIEBIESKI 		0x688CCEAA
#define CLR_ZOLTY 		0xFFFF00AA
#define CLR_KREMOWY 		0xF5DEB3AA
#define CLR_ROZOWY 		0xFFBFFFAA

#pragma unused 			ret_memcpy

stock NickName(playerid)
{
	new playername[MAX_PLAYER_NAME];
	GetPlayerName(playerid, playername, MAX_PLAYER_NAME);
	return playername;
}

ReturnIP(playerid)
{
	new ip[30];
	GetPlayerIp(playerid, ip, 30);
	return ip;
}

stock SendClientMessageToAdmins(color, const message[])
{
	foreach(a)
	{
		if(IsPlayerAdmin(a))
			SendClientMessage(a, color, message);
	}
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
enum ePlayer
{
	pass[30],
	Text3D:opis,
	cash,
	skin,
	adminjail,
	smierci,
	samobojstw,
	mute,
	bank,
	score,
}
stock PlayerData[MAX_PLAYERS][ePlayer];

stock Float:GetXYInFrontOfPlayer(playerid, &Float:x, &Float:y, Float:distance)
{
    new Float:a;
    GetPlayerPos(playerid, x, y, a);
    if (IsPlayerInAnyVehicle(playerid)) GetVehicleZAngle(GetPlayerVehicleID(playerid), a); else GetPlayerFacingAngle(playerid, a);
    x += (distance * floatsin(-a, degrees)); y += (distance * floatcos(-a, degrees));
    return a;
}
