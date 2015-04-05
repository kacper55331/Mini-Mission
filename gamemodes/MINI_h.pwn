#define IN_NAME 			"Mini-Mission"
#define IN_BAZA       		"connect.txt"

#include <a_samp>
#include <all>
#include <foreach>
#include <socket>

#include "MINI_makro.pwn"

// ----------------------------------------------------------------------------------------------------
// Constants
// ----------------------------------------------------------------------------------------------------

#undef  MAX_PLAYERS
#undef  MAX_PLAYER_NAME
#undef  MAX_OBJECTS
#undef  MAX_3DTEXT_PLAYER
#undef  MAX_PICKUPS
#undef  MAX_VEHICLES

#define MAX_PLAYERS			32		//                                          500
#define MAX_ANIMS			170     // Maks iloœæ animacji
#define MAX_OBJECTS			100		// Maks iloœæ obiektów per game z funkcj¹
#define MAX_3DTEXT			100		// Maks iloœæ 3dtextów per game
#define MAX_PICKUPS         200     // Maks iloœæ pickupów per game
#define MAX_VEHICLES        500		// Maks iloœæ pojazdów
#define MAX_TEAM            2+1     // Maks iloœæ teamów
#define MAX_SPAWN           30
#define MAX_CHECKPOINT      100
#define MAX_LANG            3
#define MAX_RESULT          10
#define MAX_SKINS           100
#define MAX_MAPICON         200

#define MAX_PLAYER_NAME		24

#define INVALID_GAME_ID     0

// ----------------------------------------------------------------------------------------------------
// Macros
// ----------------------------------------------------------------------------------------------------

#define IN_PREF             ""

#define Player(%1,%2)		PlayerData[%1][%2]
#define Setting(%1)         SettingData[%1]
#define Game(%1)            GameData[%1]
#define Anim(%1,%2)         AnimData[%1][%2]
#define Team(%1,%2)			TeamData[%1][%2]
#define Vehicle(%1,%2)		VehicleData[%1][%2]
#define Object(%1,%2)       ObjectData[%1][%2]
#define Race(%1,%2) 		RaceData[%1][%2]
#define Klan(%1,%2) 		KlanData[%1][%2]
#define Pickup(%1,%2) 		PickupData[%1][%2]
#define Lang(%1,%2) 		LangData[%1][%2]
#define Text(%1,%2)         TextData[%1][%2]
#define Skin(%1,%2)         SkinData[%1][%2]
#define Map(%1,%2)          MapData[%1][%2]

#define ShowInfo(%1,%2)		Dialog::Output(%1, 999, DIALOG_STYLE_MSGBOX, IN_HEAD" "white"» "grey"Informacja", %2, "Okey", "")
#define ShowList(%1,%2)		Dialog::Output(%1, 999, DIALOG_STYLE_LIST, IN_HEAD, %2, "Okey", "")
#define ShowCMD(%1,%2)      SendClientMessage(%1, CLR_GRAY, %2)
#define DIN(%1,%2) 			strcmp(%1, %2, true) == 0
//strfind(%1, %2, true) != -1

#define TEXT_LOGIN  		white"Witaj na {228D22}"IN_NAME".\n"white"Aby rozpocz¹æ grê na serwerze wpisz has³o podane przy rejestracji i zaloguj siê."
#define TEXT_REGISTER       white"Witaj na {228D22}"IN_NAME".\n"white"Aby rozpocz¹æ grê na serwerze zarejestruj siê."

#if !defined TextDrawSetPreviewRot
    #error Version 0.3x or higher of SA:MP Server requiered
#endif

#define player_nick_def     0xAAAAAAFF
#define player_nick_prem    0xE6D265FF
#define player_nick_red     0xFF0000FF

#define team_none       0 // Default
#define team_red        1 // Atak
#define team_blue       2 // Obrona

#define team_color_none     0xFFFFFFAA
#define team_color_dm       0x9F9D94AA

#define lang_pl           	0
#define lang_eng            1
#define lang_de             2

#define top_none            0
#define top_race            1
#define top_kills_game      2
#define top_kills_round     3
#define top_deaths_game     4
#define top_spado           5

#define game_type_none		0 //
#define game_type_tdm		1 //
#define game_type_vehicle	2 //
#define game_type_dm        3 // Deathmatch
#define game_type_spado     4
#define game_type_race      5 //
#define game_type_capture   6
#define game_type_dd        7
#define game_type_stunt     8
#define game_type_bomb      9
#define game_type_hay       10

#define respawn_time        10.0
#define bomb_time           5

// ----------------------------------------------------------------------------------------------------
// Enumerations
// ----------------------------------------------------------------------------------------------------

enum ePlayers {
		   player_guid, player_gname[ 120 ],	// GUID
	       player_uid,							// UID
	  bool:player_logged, bool:player_spawned, bool:player_freezed, bool:player_death, // Zalogowany
	 Float:player_position[ 4 ], player_int, player_vw, // Pozycja gracza
	 Float:player_hp, Float:player_armour,
		   player_visits, player_timehere[ 2 ], // Wizyty na serwerze [ 0 ] - czas ogolnie, [ 1 ] - czas teraz
		   player_cash,           				// Kasa, punkty
		   player_option, player_adminlvl, player_premium_option, // Opcje, admin level
		   player_premium,
		   player_block,                        // Blokady
		   player_skin,
		   player_lang,
		   player_lvl,
		   player_exp, player_c_exp,
		   
		   player_screen,
		   
		   player_kills, player_kills_round, player_kills_game,
		   player_deaths, player_deaths_game,
		   
		   player_weapon[ 13 ],

	 Float:player_respawn,
	 Float:player_veh_dist,
	 
	 Float:player_nitro,
		   player_nitro_timer,
		   player_nitro_object,

		   player_afktime[ 3 ],                 // Czas AFK [ 0 ] - ogolnie, [ 1 ] - aktualnie, [ 2 ] - czas podczas wizyty
	 
		   player_team,                         // Dru¿yna gracza
		   player_connect_audio,                // Muzyka przy po³¹czeniu
		   player_last_shooter,
		   
	  bool:player_aim,
	  bool:player_crouch,
	  bool:player_anim,                         // Gracz uzywa animacji
	  bool:player_audio,                        // Za³adowany audio plugin
	  bool:player_ready,
	  bool:player_play,
	  bool:player_record_td,

		   player_aim_object,
		   player_fp_object,
		   player_neon_object[ 2 ],

		   player_achiv,
		   player_spec,
		   player_spawn_time,
		   
	  bool:player_plante,
	  	   player_bomb_sound,
	  	   
	  bool:player_friends[ MAX_PLAYERS ],
	#if STREAMER
    Text3D:player_tag[ MAX_PLAYERS ],         // Tag nicku
    Text3D:player_pick_tag[ MAX_PICKUPS ],
	#else
PlayerText3D:player_tag[ MAX_PLAYERS ],         // Tag nicku
PlayerText3D:player_pick_tag[ MAX_PICKUPS ],
	#endif
		   player_color,                        // Kolor nicku
		   
		   player_dialog,                       // Dialog gracza
		   player_ip[ 18 ],                     // IP gracza

		   player_cam_timer,                    // Timer do kamery przy logowaniu
		   player_audio_timer,
		   player_premium_timer,
		   player_friends_timer,
		   player_shoot_timer[ 2 ],
		   player_achiv_timer,
		   player_spec_timer,

		   player_selected_object,
		   player_edit,
	 Float:player_obj_pos[ 6 ],
		   
		   player_race,
		   player_race_time[ MAX_CHECKPOINT ],
		   player_vehicle,
		   player_pickup,
		   
		   player_record,
		   
	#if bots
		   player_bot,
	#endif
		   
		   player_cam,                          // Aktualna kamera przy logowaniu
		   player_dark,                         // Typ œciemnienia ekranu
		   
PlayerText:player_td_celownik[ 2 ],       		// Celownik po trafieniu
PlayerText:player_td_respawn,
PlayerText:player_td_wyniki,
PlayerText:player_td_friend,
PlayerText:player_td_shoot,
PlayerText:player_td_record[ 2 ],
PlayerText:player_td_achiv,
}

enum eSettings {
	       setting_globtimer,                   // Timer co 1s
	       setting_opttimer,                    // Timer co 100ms
	       setting_mysql,                       // Po³¹czenie z MySQL

	       setting_weather,                     // Pogoda na serwerze
	  bool:setting_debug,
	       
	       setting_game,                        // UID rozgrywki
	       setting_lgame,                       // UID osatniej rozgrywki
	       setting_timer_game,                  // Timer dot. startu rozgrywki
	       setting_next,                        // UID nastêpnej rozgrywki

	  Text:setting_td_box[ 2 ],                 // TD panoramiki
	  Text:setting_td_time[ 4 ],                // TD odliczania
	  Text:setting_td_game_name,                // TD nazwy moda
	  Text:setting_td_record[ 2 ],              // TD top 5
	  Text:setting_td_left[ MAX_RESULT ],       // TD w prawym rogu top
	  Text:setting_td_achiv[ 2 ],               // TD achievment
	  Text:setting_td_black,

	    // Pozycja pocz¹tkowa
	 Float:setting_pos[ 4 ],
		   setting_int,
		   setting_url[ 64 ],
}

enum eAnims {
	       anim_uid,                            // UID animacji
	       anim_name[ 45 ],                     // Nazwa
	       anim_animlib[ 45 ],                  // Biblioteka
	       anim_animname[ 45 ],                 // Nazwa w bibliotece
	 Float:anim_speed,                          // Prêdkoœæ
	       anim_opt[ 5 ],                       // Parametry
}

enum eGame {
	       game_name[ 32+1 ],                     // Nazwa rozgrywki
	       game_time,                           // Czas do koñca
	       game_minimum,
	       game_typ,                            // Typ rozgrywki
	 Float:game_hp,
	       
	       game_model,
	       game_vehID,                          // ID auta
	       game_kills,
	       
	       game_weapon[ 4 ],
	       
	       game_idx,

	  bool:game_bomb,
		   game_progress,
		   game_bomb_player,
		   game_plante,
		   game_bomb_countdown,
		   
     Float:game_bomb_pos[ 3 ],
     	   game_bomb_pick,

	       game_race_max,
	       game_countdown,
	       game_time_start,
	       game_players,
	       
	       game_sound[ 126 ],
	       
	       game_race,

	 Float:game_marker_pos[ 3 ],                // Pozycja celu, do którego trzeba dotrzeæ.

	 Float:game_camera[ 6 ],
	       game_camera_int,
	  bool:game_started,
}

enum eTeam {
	       team_name[ 32+1 ],                     // Nazwa teamu
	       
	 Float:team_spawn_pos_x[ MAX_SPAWN ],
	 Float:team_spawn_pos_y[ MAX_SPAWN ],
	 Float:team_spawn_pos_z[ MAX_SPAWN ],
	 Float:team_spawn_pos_a[ MAX_SPAWN ],
	       team_spawn_int[ MAX_SPAWN ],
	       team_spawn_max,
	       team_color,

	       team_points,                         // Pkt teamu
	       team_players,
	       
	       team_dead,
	       team_kills,
}

enum eVehicles {
	       vehicle_uid,
	       
	       vehicle_model,
	 Float:vehicle_pos[ 4 ],
	       vehicle_team,
	 
	       vehicle_carid,
	  bool:vehicle_ac,
     Float:vehicle_hp,
}

enum eObjects {
	       obj_uid,
	       
		   obj_model,
	 Float:obj_pos[ 3 ],
	 Float:obj_rot[ 3 ],
	 Float:obj_pos_gate[ 3 ],
	 Float:obj_pos_rgate[ 3 ],
		   obj_owner,

	       obj_objID,
}

enum eRace {
	       race_uid,
	 Float:race_pos[ 3 ],
	 
	       race_player[ MAX_PLAYERS ],
	       race_idx,
}

enum eKlan {
	       klan_uid,
	       klan_rank,
	       klan_ranklvl,
	       
	       klan_name[ 32+1 ],
	       klan_color,
	       klan_tag[ 5+1 ],
	       klan_rankname[ 32+1 ],
	       
	       klan_lvl,
	       klan_exp,
	       klan_kills,
	       klan_deaths,
}

enum eAdminLvl {
	       admin_color,                    		// Kolor
	       admin_tag[ 4+1 ],                    	// TAG rangi
	       admin_name[ 32+1 ],                    // Nazwa rangi
}

enum ePickup {
	       pick_uid,
	       pick_game,
	       pick_model,
	       pick_type,
	 Float:pick_pos[ 3 ],
	       
	       pick_func,
	       
	       pick_pickID,
	       pick_mapID,
	#if !STREAMER
	Text3D:pick_textID,
	#endif
}

enum eMapIcon {
	       map_ID,
	       map_type,
	 Float:map_pos[ 3 ],
}

enum eText {
	       text_uid,
	       text_game,
	       text_text[ 256 ],
	 Float:text_pos[ 3 ],
	       
	Text3D:text_textID,
	#if bots
 	 Float:text_pos_a,
	       text_botID,
	       text_bot_tID,
	       text_bot_uid,
	       text_bot_name[ MAX_PLAYER_NAME ],
	#endif
}

enum eLang {
	       lang_spawn[ 60 ],
	       lang_started[ 120 ],
	       lang_respawn[ 16 ],
	       lang_sec[ 10 ],
	       lang_seco[ 10 ],
	       lang_second[ 10 ],
	       lang_time[ 5 ],
	       lang_end[ 16 ],
	       lang_result[ 10 ],
	       lang_kill[ 10 ],
	       lang_death[ 10 ],
	       lang_curr_time[ 20 ],
	       lang_start[ 10 ],

	       lang_logged[ 32 ],
	       lang_premium[ 38 ],
	       lang_premium_end[ 38 ],
	       lang_login_glob[ 126 ],
	       lang_login_nglob[ 126 ],
	       
	       lang_money[ 10 ],
	       
	       lang_countdown_start[ 32 ],
	       lang_game_started[ 64 ],
	       
	       lang_dd_out[ 32 ],
	       
	       lang_kill_by[ 32 ],
	       lang_kill_myself[ 32 ],
	       
	       lang_set[ 32 ],
	       lang_set_head[ 32 ],
	       lang_set_panor[ 16 ],
	       lang_set_message[ 32 ],
	       lang_set_shoot[ 32 ],
	       lang_set_shoot_s[ 16 ],
	       lang_set_nitro[ 16 ],
	       lang_set_neon[ 16 ],
	       
	       lang_fp_error[ 64 ],
	       
	       lang_to_end[ 8 ],
	       
	       lang_vehicle_info[ 32 ],
	       lang_vehicle_binfo[ 32 ],
	       lang_vehicle_win[ 32 ],
	       lang_vehicle_lose[ 32 ],
	       
	       lang_select[ 8 ],
	       lang_cancel[ 8 ],
	       lang_back[ 8 ],
	       
	       lang_left[ 8 ],
	       lang_right[ 8 ],
	       
	       lang_shoot[ 16 ],
	       
	       lang_prem[ 20 ],
	       lang_newbie[ 15 ],
	       lang_friend[ 15 ],
}

enum eSkins {
	       skin_uid,
	       skin_model,
	       skin_resp,
	       skin_cash,
}

// ----------------------------------------------------------------------------------------------------
// Variables
// ----------------------------------------------------------------------------------------------------

stock
		   VehicleData[ MAX_VEHICLES ][ eVehicles ],
		   SettingData[ eSettings ],
		   
	       PlayerData[ MAX_PLAYERS ][ ePlayers ],
		   ObjectData[ MAX_OBJECTS ][ eObjects ],
		   PickupData[ MAX_PICKUPS ][ ePickup ],

		   RaceData[ MAX_CHECKPOINT ][ eRace ],
		   KlanData[ MAX_PLAYERS ][ eKlan ],
		   LangData[ MAX_PLAYERS ][ eLang ],
		   TextData[ MAX_3DTEXT ][ eText ],
		   SkinData[ MAX_SKINS ][ eSkins ],
		   AnimData[ MAX_ANIMS ][ eAnims ],
		   TeamData[ MAX_TEAM ][ eTeam ],
	       GameData[ eGame ],
	       
		   MapData[ MAX_MAPICON ][ eMapIcon ];

stock const Weathers[ 17 ] = {
	 1,   2,  3,  4,  5,  7,
	 8,   9, 10, 11, 12, 13,
	 14, 15, 17, 18
};

stock GameName[ ][ ][ ] = {
	{"None", "N/A"},
	{"Team Death Match", "TDM"},
	{"Eskorta", "AD"},
	{"Death Match", "DM"},
	{"Skoki spadochronowe", "N/A"},
	{"Race", "Race"},
	{"Domination", "CTF"},
	{"Demolition Derby", "DD"},
	{"Stunt", "Stunt"},
	{"Search and Destroy", "SaD"},
	{"Hay", "Hay"}
};

stock const AdminLvl[ ][ eAdminLvl ] = {
	{0, "N/A", "N/A"}, 						// 0
	{0x6495EDFF, "", "Support"}, 			// 1
	{0x008000FF, "GM", "GameMaster"}, 			// 2
	{0x4B0082FF, "GA", "Game Assistant"}, 			// 3
	{0xFF4D4DFF, "", "Administrator"}, 			// 4
	{0x8B1A1AFF, "", "G³ówny Administrator"}, 			// 5
	{0xFF0000FF, "", "Skrypter"} 		// 6
};

stock const RacePlace[ ][ ] = {
	{"N/A"},
	{"1st"},
	{"2nd"},
	{"3rd"}
};

stock const Lang[ ][ ][ ] = {
	{"Polski", "PL",
		"Zaloguj siê", "WyjdŸ", "{68AB5C}Witaj na {497840}"IN_NAME".\n{68AB5C}Aby rozpocz¹æ grê na serwerze wpisz has³o(podane przy rejestracji) i zaloguj siê.",
		"{68AB5C}Witaj na {497840}"IN_NAME".\n{68AB5C}Aby rozpocz¹æ grê na serwerze zarejestruj siê."
	},
	{"English", "EN",
		"Log In", "Exit", white"Welcome to {228D22}"IN_NAME".\n"white"To start the game on the server, type the password(that you specified during the registration) and login.",
		white"Welcome to {228D22}"IN_NAME".\n"white"To start the game on the server register."
	},
	{"Deutsch", "DE",
		"Einloggen", "Exit", white"Willkommen bei {228D22}"IN_NAME".\n"white"Um das Spiel auf dem Server zu starten, geben Sie das Passwort, die Sie bei der Registrierung und Anmeldung angegeben.",
		white"Willkommen bei {228D22}"IN_NAME".\n"white"Um das Spiel auf dem Server Register zu starten."
	}
};

stock const AchivData[ ][ 2 ] = {
	{1, 50},
	{2, 50},
	{4, 50},
	{8, 50},
	{16, 50},
	{32, 100},
	{64, 50}
};

stock const AchivDataName[ ][ ][ ] = {
	{"Pierwsze logowanie", "First logged", "Achtung"},
	{"Pierwsza œmierc", "First dead", "Achtung"},
	{"Pierwsza krew", "First blood", "Achtung"},
	{"Wygrana w wyœcigu", "Win race", "Achtung"},
	{"Rejestracja", "Register", "Achtung"},
	{"Przegrane 20h", "", ""},
	{"100 wizyt", "", ""}
};

stock const BodyParts[ ][ ][ ] = {
	{"-", "-", "-", "tu³ów", "krocze", "lewe ramie", "prawe ramie", "lewa noge", "praw¹ nogê", "g³owê"},
	{"-", "-", "-", "torso", "gain", "left arm", "right arm", "left leg", "right leg", "head"},
	{"-", "-", "-", "Torso", "Hodengegend", "linken Arm", "rechten Arm", "linken Bein", "rechten Bein", "Kopf"}
};

stock const BodyPartExp[ ] = {
	10, 10, 10, 30, 25,
	20, 20, 20, 20, 50
};

stock const Levels[ ] = {
	0,
	20,
	50,
	100,
	175,
	300,
	500,
	800,
	1100,
	1500,
	2000,
	2700,
	3400,
	4200
};

stock const LevelName[ ][ ][ ] = {
	{"Noworodek", "N/A", "N/A"},
	{"Niemowle", "Newbie", "Frajer"},
	{"Dzieciak", "Newbie", "Frajer"},
	{"Maciek z Klanu", "Newbie", "Frajer"},
	{"Szczeniak", "Newbie", "Frajer"},
	{"Ba³wan", "Newbie", "Frajer"},
	{"M³otek", "Newbie", "Frajer"},
	{"G³uchy", "Newbie", "Frajer"},
	{"Polak", "Newbie", "Frajer"},
	{"¯ó³todziub", "Newbie", "Frajer"},
	{"Ciamajda", "Newbie", "Frajer"},
	{"Beginner", "Beginner", "Frajer"},
	{"Killer", "Killer", "Frajer"},
	{"Amstaff", "Newbie", "Frajer"},
	{"Oprych", "Newbie", "Frajer"},
	{"Pitbull", "Pitbull", "Frajer"},
	{"Indiana Jones", "Newbie", "Frajer"},
	{"Kozak", "Newbie", "Frajer"},
	{"Diler", "Dealer", "Frajer"},
	{"Biskup", "Newbie", "Frajer"},
	{"Degustator", "Newbie", "Frajer"},
	{"WiedŸma", "Newbie", "Frajer"},
	{"Figlarz", "Newbie", "Frajer"},
	{"Z³odziej", "Newbie", "Frajer"},
	{"Klubowicz", "Newbie", "Frajer"},
	{"Figo Fago", "Newbie", "Frajer"},
	{"Bokser", "Newbie", "Frajer"},
	{"Anio³ek Charliego", "Newbie", "Frajer"},
	{"No lifer", "No life", "Frajer"},
	{"Beton", "Newbie", "Frajer"},
	{"Jamnik", "Newbie", "Frajer"},
	{"Poszukiwacz", "Newbie", "Frajer"},
	{"Matrix", "Matrix", "Matrix"},
	{"Doœwiadczony Zabójca", "Newbie", "Frajer"},
	{"Grajek", "Newbie", "Frajer"},
	{"GrajkoMan", "Newbie", "Frajer"},
	{"TurboGrajkoMan", "Newbie", "Frajer"},
	{"Assasin", "Assasin", "Frajer"},
	{"Bull dog", "Newbie", "Frajer"},
	{"Król Julian", "Newbie", "Frajer"},
	{"Joker", "Newbie", "Frajer"},
	{"Hacker", "Hacker", "Frajer"},
	{"Niewidomy", "Newbie", "Frajer"},
	{"Lagger", "Newbie", "Frajer"},
	{"Badboy", "Newbie", "Frajer"},
	{"Myœliwy", "Newbie", "Frajer"},
	{"Egzorcysta", "Newbie", "Frajer"},
	{"Pedobear", "Newbie", "Frajer"},
	{"W³adca", "Newbie", "Frajer"},
	{"Pan ¿ycia i œmierci", "Newbie", "Frajer"},
	{"Szatan", "Satan", "Frajer"},
	{"Istny diabe³", "Newbie", "Frajer"},
	{"Anio³", "Angel", "Frajer"},
	{"Upad³y Anio³", "Newbie", "Frajer"},
	{"Cziter", "Cheater", "Frajer"},
	{"Tygrys", "Tiger", "Frajer"},
	{"Zbawiciel", "Newbie", "Frajer"},
	{"Demon", "Demon", "Frajer"},
	{"Chuck Norris", "Chuck Norris", "Chuck Norris"},
	{"Bóg", "God", "Frajer"}
};

// ----------------------------------------------------------------------------------------------------
// Includes
// ----------------------------------------------------------------------------------------------------

#include <a_mysql>
#include <a_http>
#include <a_audio>
#include <sscanf2>
#include <md5>
#include <DOF2>
#include <zcmd>
#include <jFader>
//#include <TD_ShowAndHide>
#if bots
	#include <FCNPC>
#endif
#if mapandreas
	#include <mapandreas>
#endif
#if STREAMER
	#include <streamer>
#endif

#include "MINI_init.pwn"
#include "MINI_mysql.pwn"
#include "MINI_anims.pwn"
#include "MINI_audio.pwn"
#include "MINI_achiv.pwn"
#include "MINI_cmd.pwn"
#include "MINI_objects.pwn"
#include "MINI_pickups.pwn"
#include "MINI_text.pwn"
#include "MINI_klan.pwn"
#include "MINI_skin.pwn"
#include "MINI_admin.pwn"
#include "MINI_friends.pwn"
