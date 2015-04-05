/*
 - Dodatki do obrony
 - syst. przedmiotów
 - "patrząc optymistycznie"
 - gra hay
 - syst. przyjaciół połączony z IPB
 - /stworz | /edytuj
 - DM: hunter na końcu
 - DM: HP na ziemi po zabiciu
 - all: losowanie następnej mapy | TextDraw
 - tabela wyników na koniec | TextDraw
 - tabela z wyborem drużyny | TextDraw
 - system leveli | TextDraw
 - Podgląd profilu, gdy gracz jest w poczekalni i się na niego naceluje. | TextDraw
*/
#define Debug 				1
#define Forum               1 // 1 - ipb | 0 - mybb
#define mapandreas          0
#define bots                1
#define STREAMER            1

#define IN_VERSION    		"0.0.1"
#define today   			"15072014"

#include "MINI_h.pwn"

main()
{
	print("								");
	print("#############################");
 	print("								");
	print("   "IN_NAME"					");
	print("   Kacper Michewicz			");
	print("   2014						");
	print("   © All right reserved		");
	print("								");
	print("#############################");
	print("								");
}

public OnGameModeInit()
{
    new count = GetTickCount();
    MySQL_Connect();
    
	#if Debug
		SetGameModeText("DBG: v"IN_VERSION", build: "today);
	#else
	    SetGameModeText("v"IN_VERSION", build: "today);
	#endif
	AllowInteriorWeapons(true); 		// Bronie w interiorach
	EnableStuntBonusForAll(false); 		// Kasa za stunty
	ShowNameTags(false);				// Nametagi
	DisableInteriorEnterExits(); 		// Strzałki do domyślnych interiorów GTA
	ManualVehicleEngineAndLights(); 	// Światła i silnik wyłączony domyślnie
	UsePlayerPedAnims();                // Bieganie jak Carl Johnson!
	FadeInit();                         // Ładowanie zaciemnienia ekranu
	SetTeamCount(2);
	#if mapandreas
		MapAndreas_Init(MAP_ANDREAS_MODE_FULL);// Ładowanie pluginu MapAndreas
	#endif

	print("## Rozpoczynam wczytywanie danych!");
	if(mysql_ping() == -1)
	{
	    SendRconCommand("mapname ~MySQL Error~");
        print("[MySQL Error]: Brak połączenia z bazą danych!");
		return 1;
	}
	else print("# Połączono z bazą danych!");
	LoadSetting();
	//FCNPC_SetUpdateRate(80);
	Streamer_MaxItems(STREAMER_TYPE_OBJECT, 50000);
	Setting(setting_globtimer)	= SetTimer("GlobalTimer", 1000, 1);
	Setting(setting_opttimer)	= SetTimer("OptTimer", 100, 1);
	LoadObjects(Setting(setting_game));
	LoadPickups(Setting(setting_game));
	LoadText(Setting(setting_game));
	LoadSkins();
	//LoadAnims();
	LoadTextDraws();
	SetTimer("LoadRandomGame", 5000, false);
	new Float:czas = floatdiv(GetTickCount() - count, 1000);
	printf("## Dane wczytane pomyślnie! | Czas wykonywania: %.2f %s %s %s %s %s",
		czas,
		dli(floatval(czas), "sekunde", "sekundy", "sekund")
	);
	for(new i; i < MAX_PLAYERS; i++) ClearData(i);
	
	new str[ 64 ];
	format(str, sizeof str, "UPDATE `mini_info` SET `max` = '%d', `online` = '0', `map` = '0', `played` = '0'", GetMaxPlayers());
	mysql_query(str);
	return 1;
}

stock dlix(playerid, x)
{
	new str[ 10 ];
    if(x == 1) format(str, sizeof str, Lang(playerid, lang_sec));
    else if(x%10 > 1 && x%10<5 && !(x%100 >= 10 && x%100 <= 21)) format(str, sizeof str, Lang(playerid, lang_seco));
    else format(str, sizeof str, Lang(playerid, lang_second));
    return str;
}

public OnGameModeExit()
{
	#if Debug
	    print("OnGameModeExit()");
	#endif
    DOF2_Exit();
    FadeExit();
	#if mapandreas
		MapAndreas_Unload();
	#endif
	KillTimer(Setting(setting_globtimer));
	KillTimer(Setting(setting_opttimer));
	return 1;
}

public OnPlayerConnect(playerid)
{
	if(MAX_PLAYERS < playerid) return Kick(playerid);

    FadePlayerConnect(playerid);

	#if bots
		if(IsPlayerNPC(playerid))
   			return 1;
		else if(!IsPlayerNPC(playerid) && Player(playerid, player_bot))
		    return Kick(playerid);
	#endif
	#if Debug
	    printf("OnPlayerConnect(%d)", playerid);
	#endif

 	SetTimerEx("Clear", 100, 0, "d", playerid);
 	
	Player(playerid, player_cam_timer) = SetTimerEx("TimerCameraChange", 10000, true, "d", playerid);
	Player(playerid, player_audio_timer) = SetTimerEx("CheckAudioPlugin", 10000, false, "d", playerid);
	GetPlayerIp(playerid, Player(playerid, player_ip), 18);

	TextDrawShowForPlayer(playerid, Setting(setting_td_box)[ 0 ]);
	TextDrawShowForPlayer(playerid, Setting(setting_td_box)[ 1 ]);
	
	FadeColorForPlayer(playerid, 0, 0, 0, 255, 0, 0, 0, 255, 15, 0); // Ściemnienie
	Player(playerid, player_dark) = dark_login;
	new string[ 256 ];
	
	mysql_query("UPDATE `mini_info` SET `online` = `online` + 1");
	
	mysql_query("SELECT 1 FROM `mini_top_players` WHERE `date` = CURDATE()");
	mysql_store_result();
	new num = mysql_num_rows();
	mysql_free_result();
	
	if(num)
	{
		mysql_query("UPDATE `mini_top_players` SET `value` = (SELECT `online` FROM `mini_info`), `time` = UNIX_TIMESTAMP() WHERE `value` > '(SELECT `online` FROM `mini_info`)' AND `date` = CURDATE()");
	}
	else
	{
	    mysql_query("INSERT INTO `mini_top_players` (value, time, date) VALUES ((SELECT `online` FROM `mini_info`), UNIX_TIMESTAMP(), CURDATE())");
	}
	
/*	format(string, sizeof string,
		"INSERT OR REPLACE `mini_top_players` SET `value` = ((SELECT `online` FROM `mini_info`) as v), `time` = UNIX_TIMESTEMP() WHERE `date` = CURDATE() AND `v` < `value`");
		//`mini_top_players` SET `value` = (SELECT `online` FROM `mini_info`), `time` = UNIX_TIMESTAMP() WHERE `date` = CURDATE()
		
		INSERT INTO `mini_top_players`
  (value, time, date)
VALUES
  ((SELECT `online` FROM `mini_info`), UNIX_TIMESTAMP(), CURDATE())
ON DUPLICATE KEY UPDATE
  value     = IF(value < VALUES((SELECT `online` FROM `mini_info`)), VALUES((SELECT `online` FROM `mini_info`)), value),
  time = VALUES(time),
date = VALUES(date)

	mysql_query("INSERT OR REPLACE `mini_top_players` SET `value`*/
	#if Forum
		format(string, sizeof string,
		    "SELECT `language` FROM `"IN_PREF"members` WHERE `name` = '%s'",
		    NickSamp(playerid)
		);
	#else
		format(string, sizeof string,
		    "SELECT `language` FROM `"IN_PREF"users` WHERE `username` = '%s'",
		    NickSamp(playerid)
		);
	#endif
	mysql_query(string);
   	mysql_store_result();
    if(mysql_num_rows())
    {
        new lang;
        #if Forum
			lang = mysql_fetch_int();
			switch(lang)
			{
			    case 1: lang = lang_eng;
			    case 2: lang = lang_pl;
			    case 3: lang = lang_de;
			    default: lang = lang_pl;
			}
		#else
		    new buffer[ 64 ];
		    mysql_fetch_row(buffer);
			if(DIN(buffer, "english"))
			    lang_eng;
			else
			    lang_pl;
		#endif
		
        mysql_free_result();
        
	    Player(playerid, player_lang) = lang;
		new header[ 126 ];
		format(header, sizeof header, IN_HEAD" "white"» "grey"%s", Lang[ Player(playerid, player_lang) ][ 2 ]);
	    Dialog::Output(playerid, 2, DIALOG_STYLE_PASSWORD, header, Lang[ Player(playerid, player_lang) ][ 4 ], Lang[ Player(playerid, player_lang) ][ 2 ], Lang[ Player(playerid, player_lang) ][ 3 ]);
	}
	else
	{
	    mysql_free_result();
		format(string, sizeof string,
		    "SELECT `lang` FROM `mini_players` WHERE `name` = '%s'",
		    NickSamp(playerid)
		);
		mysql_query(string);
	   	mysql_store_result();
	    if(mysql_num_rows())
	    {
	        Player(playerid, player_lang) = mysql_fetch_int();
	        
			new header[ 126 ];
			format(header, sizeof header, IN_HEAD" "white"» "grey"%s", Lang[ Player(playerid, player_lang) ][ 2 ]);
		    Dialog::Output(playerid, 2, DIALOG_STYLE_PASSWORD, header, Lang[ Player(playerid, player_lang) ][ 4 ], Lang[ Player(playerid, player_lang) ][ 2 ], Lang[ Player(playerid, player_lang) ][ 3 ]);
		}
		else
		{
			new buffer[ 512 ];
			for(new i; i != sizeof Lang; i++)
			{
			    format(buffer, sizeof buffer, "%s"white"%s:\n%s\n\n", buffer, Lang[ i ][ 0 ], Lang[ i ][ 5 ]);
			}
	    	Dialog::Output(playerid, 8, DIALOG_STYLE_PASSWORD, IN_HEAD" "white"» "grey"Sign up/Zarejestruj się", buffer, "Zarejestruj", "Wyjdź");
		}
		mysql_free_result();
	}
	return 1;
}

FuncPub::Clear(playerid)
{
	Player(playerid, player_connect_audio) = PlayAudioStreamForPlayer(playerid, Setting(setting_url));
	for(new i = 0 ; i <= 100 ; i++)
		Chat::Output(playerid, 0, " ");
	return 1;
}

FuncPub::ClearData(playerid)
{
	Player(playerid, player_selected_object) 	= INVALID_OBJECT_ID;
	Player(playerid, player_last_shooter) 		= INVALID_PLAYER_ID;
	Player(playerid, player_spec) 				= INVALID_PLAYER_ID;
	Player(playerid, player_pickup) 			= -1;
	#if STREAMER
		for(new pickid; pickid < MAX_PICKUPS; pickid++) Player(playerid, player_pick_tag)[ pickid ] = Text3D:INVALID_3DTEXT_ID;
		for(new x; x < MAX_PLAYERS; x++) Player(playerid, player_tag)[ x ] = Text3D:INVALID_3DTEXT_ID;
	#else
		for(new pickid; pickid < MAX_PICKUPS; pickid++) Player(playerid, player_pick_tag)[ pickid ] = PlayerText3D:INVALID_3DTEXT_ID;
		for(new x; x < MAX_PLAYERS; x++) Player(playerid, player_tag)[ x ] = PlayerText3D:INVALID_3DTEXT_ID;
	#endif
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	#if Debug
	    printf("OnPlayerDisconnect(%d, %d)", playerid, reason);
	#endif
	#if STREAMER
	if(Player(playerid, player_tag)[ playerid ] != Text3D:INVALID_3DTEXT_ID)
 	#else
	if(Player(playerid, player_tag)[ playerid ] != PlayerText3D:INVALID_3DTEXT_ID)
	#endif
	{
	    foreach(Player, i)
	    {
			#if STREAMER
			if(Player(i, player_tag)[ playerid ] == Text3D:INVALID_3DTEXT_ID) continue;
		 	#else
	        if(Player(i, player_tag)[ playerid ] == PlayerText3D:INVALID_3DTEXT_ID) continue;
	        #endif
	        
	        #if STREAMER
				DestroyDynamic3DTextLabel(Player(i, player_tag)[ playerid ]);
			#else
				DeletePlayer3DTextLabel(i, Player(i, player_tag)[ playerid ]);
			#endif
		}
	}
    if(Player(playerid, player_cam_timer))
		KillTimer(Player(playerid, player_cam_timer));
    if(Player(playerid, player_premium_timer))
		KillTimer(Player(playerid, player_premium_timer));
    if(Player(playerid, player_audio_timer))
		KillTimer(Player(playerid, player_audio_timer));
	if(Player(playerid, player_friends_timer))
	    KillTimer(Player(playerid, player_friends_timer));
	if(Player(playerid, player_shoot_timer)[ 0 ])
	    KillTimer(Player(playerid, player_shoot_timer)[ 0 ]);
	if(Player(playerid, player_shoot_timer)[ 1 ])
	    KillTimer(Player(playerid, player_shoot_timer)[ 1 ]);
	if(Player(playerid, player_achiv_timer))
	    KillTimer(Player(playerid, player_achiv_timer));

	mysql_query("UPDATE `mini_info` SET `online` = `online` - 1");
	new string[ 200 ];
    if(!IsPlayerNPC(playerid))
    {
		format(string, sizeof string,
			"INSERT INTO `mini_connect` VALUES (NULL, '%d', UNIX_TIMESTAMP(), '%d', '%s', '%d', '%d')",
			Player(playerid, player_uid),
			_:Player(playerid, player_logged),
			Player(playerid, player_ip),
			Player(playerid, player_timehere)[ 1 ],
			Player(playerid, player_afktime)[ 2 ]
		);
    	mysql_query(string);
    }

    if(!Player(playerid, player_logged)) return 1;
    if(IsPlayerNPC(playerid)) return 1;
    
    OnPlayerLoginOut(playerid);
	return 1;
}

public OnPlayerText(playerid, text[])
{
	if(!text[ 0 ]) return false;

	new result[ 128 ];
    if(text[0] == '@' && Player(playerid, player_adminlvl))
	{
	    text[ 1 ] = toupper(text[ 1 ]);
		if(isnull(AdminLvl[ Player(playerid, player_adminlvl) ][ admin_tag ]))
			format(result, sizeof result,
				"%s (%d)"white": %s",
				NickName(playerid),
				playerid,
				text[ 1 ]
			);
		else
			format(result, sizeof result,
				"[%s] %s (%d)"white": %s",
				AdminLvl[ Player(playerid, player_adminlvl) ][ admin_tag ],
				NickName(playerid),
				playerid,
				text[ 1 ]
			);
			
		foreach(Player, i)
		{
		    if(!Player(i, player_adminlvl)) continue;
		    
			Chat::Output(i, AdminLvl[ Player(playerid, player_adminlvl) ][ admin_color ], result); // TODO
		}
	}
	else if(text[0] == '!' && Game(game_typ) == game_type_tdm && Player(playerid, player_play))
	{
	    text[ 1 ] = toupper(text[ 1 ]);
	    foreach(Player, i)
		{
		    if(!Player(i, player_play)) continue;
		    if(Player(playerid, player_team) != Player(i, player_team)) continue;
		    
            if(Player(playerid, player_lang) == Player(i, player_lang))
	    		format(result, sizeof result, "[Team Chat] %s | %s (%d): %s", Team(Player(playerid, player_team), team_name), NickName(playerid), playerid, text[ 1 ]);
			else
	    		format(result, sizeof result, "%s | [Team Chat] %s | %s (%d): %s", Lang[ Player(playerid, player_lang) ][ 1 ], Team(Player(playerid, player_team), team_name), NickName(playerid), playerid, text[ 1 ]);
			Chat::Output(i, CarColHex[ Team(Player(i, player_team), team_color) ], result);
		}
	}
	else if(text[0] == '#' && Klan(playerid, klan_uid))
	{
	    text[ 1 ] = toupper(text[ 1 ]);
	    format(result, sizeof result, "[Klan Chat] %s | %s (%d): %s", Klan(playerid, klan_name), NickName(playerid), playerid, text[ 1 ]);
	    foreach(Player, i)
		{
		    if(Klan(playerid, klan_uid) != Klan(i, klan_uid)) continue;

			Chat::Output(i, Klan(i, klan_color), result);
		}
	}
	else
	{
	    text[ 0 ] = toupper(text[ 0 ]);
	    if(Klan(playerid, klan_uid))
	    {
	        foreach(Player, i)
	        {
	            if(Player(playerid, player_lang) == Player(i, player_lang))
					format(result, sizeof result, "[%s]%s | %s (%d): "white"%s", Klan(playerid, klan_tag), Klan(playerid, klan_name), NickName(playerid), playerid, text);
				else
					format(result, sizeof result, "%s | [%s]%s | %s (%d): "white"%s", Lang[ Player(playerid, player_lang) ][ 1 ], Klan(playerid, klan_tag), Klan(playerid, klan_name), NickName(playerid), playerid, text);
	    	    Chat::Output(i, Klan(playerid, klan_color), result);
	    	}
		}
	    else
	    {
	        foreach(Player, i)
	        {
	            if(Player(playerid, player_lang) == Player(i, player_lang))
					format(result, sizeof result, "%s (%d): "white"%s", NickName(playerid), playerid, text);
				else
					format(result, sizeof result, "%s | %s (%d): "white"%s", Lang[ Player(playerid, player_lang) ][ 1 ], NickName(playerid), playerid, text);
				Chat::Output(i, GetPlayerColor(playerid), result);
			}
		}
    }
    return 0;
}

public OnPlayerSpawn(playerid)
{
	#if bots
		if(IsPlayerNPC(playerid))
			return 1;
	#endif
 	
	#if Debug
	    printf("OnPlayerSpawn(%d)", playerid);
	#endif

 	if(Player(playerid, player_death))
 	{
		TextDrawShowForPlayer(playerid, Setting(setting_td_box)[ 0 ]);
		TextDrawShowForPlayer(playerid, Setting(setting_td_box)[ 1 ]);
		PlayerTextDrawShow(playerid, Player(playerid, player_td_respawn));
		
		if(Game(game_typ) == game_type_race) Player(playerid, player_respawn) = respawn_time/2;
		else Player(playerid, player_respawn) = respawn_time;

		if(Game(game_camera)[ 0 ] != 0.0 && Game(game_camera)[ 1 ] != 0.0 && Game(game_camera)[ 2 ] != 0.0)
			SetPlayerCameraPos(playerid, Game(game_camera)[ 0 ], Game(game_camera)[ 1 ], Game(game_camera)[ 2 ]);
		if(Game(game_camera)[ 3 ] != 0.0 && Game(game_camera)[ 4 ] != 0.0 && Game(game_camera)[ 5 ] != 0.0)
			SetPlayerCameraLookAt(playerid, Game(game_camera)[ 3 ], Game(game_camera)[ 4 ], Game(game_camera)[ 5 ]);
        SetPlayerInterior(playerid, Game(game_camera_int));
 	    return 1;
 	}
	if(Game(game_started) && !Player(playerid, player_ready) && Game(game_countdown) > 60 && Game(game_typ) != game_type_hay)
		SendClientMessage(playerid, -1, Lang(playerid, lang_spawn));

	KillTimer(Player(playerid, player_cam_timer));
	DisablePlayerCheckpoint(playerid);
	CheckAudioPlugin(playerid);
	SetPlayerSkin(playerid, Player(playerid, player_skin));
	
	if(Setting(setting_game) == INVALID_GAME_ID || !Player(playerid, player_ready))
	{
		SetPlayerPos(playerid, Setting(setting_pos)[ 0 ], Setting(setting_pos)[ 1 ], Setting(setting_pos)[ 2 ]);
		SetPlayerFacingAngle(playerid, Setting(setting_pos)[ 3 ]);
		SetPlayerInterior(playerid, Setting(setting_int));
		SetPlayerVirtualWorld(playerid, Player(playerid, player_vw) = 0);
		ResetPlayerWeaponsEx(playerid);
		
		Player(playerid, player_color) = team_color_none;
		GivePlayerWeaponEx(playerid, 30, 9999);
		
		SetPlayerHealth(playerid, Player(playerid, player_hp) = 99999999999.0);
		SetPlayerScore(playerid, Player(playerid, player_kills));
		Player(playerid, player_play) = false;
		if(Player(playerid, player_connect_audio))
		{
		    if(Audio_IsClientConnected(playerid))
		    {
		        Audio_Stop(playerid, Player(playerid, player_connect_audio));
		    	StopAudioStreamForPlayer(playerid);
			}
			else StopAudioStreamForPlayer(playerid);
	    	Player(playerid, player_connect_audio) = 0;
		}
		if(!Player(playerid, player_connect_audio))
		{
			if(Audio_IsClientConnected(playerid))
				Player(playerid, player_connect_audio) = Audio_PlayStreamed(playerid, Setting(setting_url));
			else
				Player(playerid, player_connect_audio) = PlayAudioStreamForPlayer(playerid, Setting(setting_url));
		}
	}
	else
	{
	    if(Player(playerid, player_team))
			Player(playerid, player_color) = CarColHex[ Team(Player(playerid, player_team), team_color) ];
	    else 
	        Player(playerid, player_color) = team_color_dm;

		if(Player(playerid, player_connect_audio))
		{
		    if(Audio_IsClientConnected(playerid))
		        Audio_Stop(playerid, Player(playerid, player_connect_audio));
		    StopAudioStreamForPlayer(playerid);
	    	Player(playerid, player_connect_audio) = 0;
    	}

		Player(playerid, player_spawn_time) = gettime();
	    LoadGame(playerid);
	    SetPlayerVirtualWorld(playerid, Player(playerid, player_vw) = Setting(setting_game));

		SetPlayerHealth(playerid, Player(playerid, player_hp) = Game(game_hp));
		SetPlayerScore(playerid, Player(playerid, player_kills_game));
	}
	
	TextDrawShowForPlayer(playerid, Setting(setting_td_time)[ 1 ]);
	TextDrawHideForPlayer(playerid, Setting(setting_td_time)[ 2 ]);
	TextDrawHideForPlayer(playerid, Setting(setting_td_time)[ 0 ]);
	TextDrawHideForPlayer(playerid, Setting(setting_td_time)[ 3 ]);
	
	if(Player(playerid, player_team) == team_blue)
		TextDrawShowForPlayer(playerid, Setting(setting_td_time)[ 2 ]);
	else if(Player(playerid, player_team) == team_red)
		TextDrawShowForPlayer(playerid, Setting(setting_td_time)[ 0 ]);
	else
	    TextDrawShowForPlayer(playerid, Setting(setting_td_time)[ 3 ]);
	    
	TextDrawShowForPlayer(playerid, Setting(setting_td_game_name));
 	SetPlayerColor(playerid, Player(playerid, player_color));
 	UpdatePlayerNick(playerid);
 	
	Player(playerid, player_spawned) = true;
	Player(playerid, player_last_shooter) = INVALID_PLAYER_ID;
	if(!(Player(playerid, player_option) & option_panor))
	{
		TextDrawHideForPlayer(playerid, Setting(setting_td_box)[ 0 ]);
		TextDrawHideForPlayer(playerid, Setting(setting_td_box)[ 1 ]);
	}
	if(Game(game_started))
	{
		if(Player(playerid, player_option) & option_fp)
		{
		    DestroyObject(Player(playerid, player_fp_object));
			Player(playerid, player_fp_object) = CreateObject(playerid, 19300, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
			AttachObjectToPlayer(Player(playerid, player_fp_object), playerid, 0.0, 0.15, 0.65, 0.0, 0.0, 0.0);
			AttachCameraToObject(playerid, Player(playerid, player_fp_object));
		}
		else
		    SetCameraBehindPlayer(playerid);
	}
	return 1;
}

FuncPub::LoadGame(playerid)
{
	#if Debug
	    printf("LoadGame(%d)", playerid);
	#endif
	if(!Game(game_started))
		FreezePlayer(playerid);
	else
	    UnFreeze(playerid);
		
	if(!Team(Player(playerid, player_team), team_spawn_max))
    {
        SendClientMessage(playerid, -1, "Nie możesz dołączyć do tej rozgrywki!");
        ToSpawn(playerid);
        return 1;
    }
	if(Game(game_typ) == game_type_race || Game(game_typ) == game_type_dd)
	{
		new carid,
			color = random(120);
	    if((Player(playerid, player_race)-1) > 0)
	    {
	        // Respawn na przed ostatni czekpoint
			carid = CreateVehicle(Game(game_model),
				Race((Player(playerid, player_race)-1), race_pos)[ 0 ],
				Race((Player(playerid, player_race)-1), race_pos)[ 1 ],
				Race((Player(playerid, player_race)-1), race_pos)[ 2 ],
				0.0,
				color,
				color,
				-1
			);
			Vehicle(carid, vehicle_pos)[ 0 ] = Race((Player(playerid, player_race)-1), race_pos)[ 0 ];
			Vehicle(carid, vehicle_pos)[ 1 ] = Race((Player(playerid, player_race)-1), race_pos)[ 1 ];
			Vehicle(carid, vehicle_pos)[ 2 ] = Race((Player(playerid, player_race)-1), race_pos)[ 2 ];
			Vehicle(carid, vehicle_pos)[ 3 ] = 0.0;
	    }
	    else
	    {
		    Game(game_idx)++;
		    if(Team(Player(playerid, player_team), team_spawn_max) == Game(game_idx))
				Game(game_idx) = 0;
				
			/*Game(game_idx)--;
			if(!Game(game_idx))
				Game(game_idx) = Team(Player(playerid, player_team), team_spawn_max);*/
				
		    Player(playerid, player_race) = 0;

			carid = CreateVehicle(Game(game_model),
				Team(Player(playerid, player_team), team_spawn_pos_x)[ Game(game_idx) ],
				Team(Player(playerid, player_team), team_spawn_pos_y)[ Game(game_idx) ],
				Team(Player(playerid, player_team), team_spawn_pos_z)[ Game(game_idx) ],
				Team(Player(playerid, player_team), team_spawn_pos_a)[ Game(game_idx) ],
				color,
				color,
				-1
			);

			Vehicle(carid, vehicle_pos)[ 0 ] = Team(Player(playerid, player_team), team_spawn_pos_x)[ Game(game_idx) ];
			Vehicle(carid, vehicle_pos)[ 1 ] = Team(Player(playerid, player_team), team_spawn_pos_y)[ Game(game_idx) ];
			Vehicle(carid, vehicle_pos)[ 2 ] = Team(Player(playerid, player_team), team_spawn_pos_z)[ Game(game_idx) ];
			Vehicle(carid, vehicle_pos)[ 3 ] = Team(Player(playerid, player_team), team_spawn_pos_a)[ Game(game_idx) ];
		}
		Player(playerid, player_vehicle) = Vehicle(carid, vehicle_carid) = carid;
		LinkVehicleToInterior(Vehicle(carid, vehicle_carid), Team(Player(playerid, player_team), team_spawn_int)[ Game(game_idx) ]);
		SetVehicleVirtualWorld(Vehicle(carid, vehicle_carid), Setting(setting_game));
		OnVehicleSpawn(carid);

		SetPlayerPos(playerid, Team(Player(playerid, player_team), team_spawn_pos_x)[ Game(game_idx) ], Team(Player(playerid, player_team), team_spawn_pos_y)[ Game(game_idx) ], Team(Player(playerid, player_team), team_spawn_pos_z)[ Game(game_idx) ]);
		SetPlayerFacingAngle(playerid, Team(Player(playerid, player_team), team_spawn_pos_a)[ Game(game_idx) ]);
		SetPlayerInterior(playerid, Team(Player(playerid, player_team), team_spawn_int)[ Game(game_idx) ]);
		SetTimerEx("PutToVehicle", 1000, false, "dd", playerid, Player(playerid, player_vehicle));
        if(!Game(game_started))
        {
            SetVehicleParamsEx(Player(playerid, player_vehicle), 0, 0, 0, 0, 0, 0, 0);
			SetTimerEx("SetCamera", 1000, false, "d", playerid);
		}
	}
	else
	{
		new rand = random(Team(Player(playerid, player_team), team_spawn_max));

		SetPlayerPos(playerid, Team(Player(playerid, player_team), team_spawn_pos_x)[ rand ], Team(Player(playerid, player_team), team_spawn_pos_y)[ rand ], Team(Player(playerid, player_team), team_spawn_pos_z)[ rand ]);
		SetPlayerFacingAngle(playerid, Team(Player(playerid, player_team), team_spawn_pos_a)[ rand ]);
		SetPlayerInterior(playerid, Team(Player(playerid, player_team), team_spawn_int)[ rand ]);
	}

	for(new i; i != sizeof Game(game_weapon); i++)
	{
	    if(!Game(game_weapon)[ i ]) continue;
	    GivePlayerWeaponEx(playerid, Game(game_weapon)[ i ], 300);
	}
	
	if(Game(game_typ) == game_type_spado)
	{
	    GivePlayerWeaponEx(playerid, 46, 5);
		SetPlayerCheckpoint(playerid, Game(game_marker_pos)[ 0 ], Game(game_marker_pos)[ 1 ], Game(game_marker_pos)[ 2 ], 10.0);
	}
	else if(Game(game_typ) == game_type_race)
	{
	    ShowPlayerRecord(playerid);
	}
	
	Player(playerid, player_play) = true;
	if(!(DIN(Game(game_sound), "NULL")))
	{
	    new id;
	    if(sscanf(Game(game_sound), "d", id))
	    {
	        if(Audio_IsClientConnected(playerid))
                Player(playerid, player_connect_audio) = Audio_PlayStreamed(playerid, Game(game_sound), .loop=true);
	        else
	            Player(playerid, player_connect_audio) = PlayAudioStreamForPlayer(playerid, Game(game_sound));
	    }
	    else
	    {
	        if(Audio_IsClientConnected(playerid))
	            Player(playerid, player_connect_audio) = Audio_Play(playerid, id, .loop=true);
	    }
	}

	if(Game(game_started)) return 1;
	new count[ 2 ];
	foreach(Player, i)
	{
	    if(Player(i, player_play)) count[ 0 ]++;
	    if(Player(i, player_ready)) count[ 1 ]++;
	}
	if(count[ 0 ] == count[ 1 ] && Setting(setting_timer_game))
	{
	 	if(Game(game_countdown) > 10) Game(game_countdown) = 10;
		SendClientMessageToAll(-1, Lang(playerid, lang_countdown_start));
	}
	return 1;
}

FuncPub::PutToVehicle(playerid, carid)
{
    PutPlayerInVehicle(playerid, carid, 0);
	return 1;
}

FuncPub::SetCamera(playerid)
{
	if(Game(game_camera)[ 0 ] != 0.0 && Game(game_camera)[ 1 ] != 0.0 && Game(game_camera)[ 2 ] != 0.0)
		SetPlayerCameraPos(playerid, Game(game_camera)[ 0 ], Game(game_camera)[ 1 ], Game(game_camera)[ 2 ]);
	if(Game(game_camera)[ 3 ] != 0.0 && Game(game_camera)[ 4 ] != 0.0 && Game(game_camera)[ 5 ] != 0.0)
		SetPlayerCameraLookAt(playerid, Game(game_camera)[ 3 ], Game(game_camera)[ 4 ], Game(game_camera)[ 5 ]);
	return 1;
}

public OnPlayerUpdate(playerid)
{
	if(!Player(playerid, player_spawned) || !Player(playerid, player_logged) || IsPlayerNPC(playerid))
        return 0;

	if(Player(playerid, player_afktime)[ 0 ] > 4)
	{
		Player(playerid, player_afktime)[ 0 ] = 0;
		UpdatePlayerNick(playerid);
	}
	
	if(GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_DUCK && !Player(playerid, player_crouch))
	{
		Player(playerid, player_crouch) = true;

		if(Player(playerid, player_aim))
		{
			AttachObjectToPlayer(Player(playerid, player_aim_object), playerid, (Player(playerid, player_option) & option_hand) ? (-0.5) : (0.5), -0.92, 0.3, 0.0, 0.0, 0.0);
			AttachCameraToObject(playerid, Player(playerid, player_aim_object));
		}
	}
	else if(GetPlayerSpecialAction(playerid) != SPECIAL_ACTION_DUCK && Player(playerid, player_crouch))
	{
		Player(playerid, player_crouch) = false;

		if(Player(playerid, player_aim))
		{
			AttachObjectToPlayer(Player(playerid, player_aim_object), playerid, (Player(playerid, player_option) & option_hand) ? (-0.5) : (0.5), -0.92, 0.6, 0.0, 0.0, 0.0);
			AttachCameraToObject(playerid, Player(playerid, player_aim_object));
		}
	}
	new victimid = GetPlayerTargetPlayer(playerid);
	if(victimid != INVALID_PLAYER_ID && !Player(playerid, player_play))
	{
		if(Player(playerid, player_spec) == INVALID_PLAYER_ID)
			Player(playerid, player_spec) = victimid;
		else if(Player(playerid, player_spec) != victimid)
		{
		    KillTimer(Player(playerid, player_spec_timer));
		    Player(playerid, player_spec_timer) = 0;
		    Player(playerid, player_spec) = victimid;
		}
			
		if(!Player(playerid, player_spec_timer))
  			Player(playerid, player_spec_timer) = SetTimerEx("Spec", 500, false, "dd", playerid, victimid);
	}
	else
	{
	    if(Player(playerid, player_spec) != INVALID_PLAYER_ID)
	    	Player(playerid, player_spec) = INVALID_PLAYER_ID;
	    if(Player(playerid, player_spec_timer))
	    {
		    KillTimer(Player(playerid, player_spec_timer));
		    Player(playerid, player_spec_timer) = 0;
	    	PlayerTextDrawHide(playerid, Player(playerid, player_td_wyniki));
	    }
	}
	Skin_OnPlayerUpdate(playerid);
	return 1;
}

FuncPub::Spec(playerid, victimid)
{
	new string[ 126 ],
		timeStr[ 45 ],
		timeStr2[ 45 ];
	FullTimeExtra(Player(victimid, player_timehere)[ 0 ], timeStr);
	FullTimeExtra(Player(victimid, player_timehere)[ 1 ], timeStr2);
	format(string, sizeof string, "~y~Nickname: ~w~%s~n~", NickName(victimid));
	if(Player(victimid, player_guid) != -1 && !isnull(Player(victimid, player_gname)))
		format(string, sizeof string, "~y~Globname: ~w~%s~n~", string, Player(victimid, player_gname));
	format(string, sizeof string, "%s~y~Czas gry: ~w~%s~n~", string, timeStr);
	if(Player(victimid, player_timehere)[ 1 ])
		format(string, sizeof string, "%s~y~Gra od: ~w~%s~n~", string, timeStr2);
	if(Klan(victimid, klan_uid))
	{
	    if(Klan(victimid, klan_uid) == Klan(playerid, klan_uid))
			format(string, sizeof string, "%s~y~Klan: ~g~%s~n~", string, Klan(victimid, klan_tag));
	    else if(Klan(victimid, klan_uid) != Klan(playerid, klan_uid))
			format(string, sizeof string, "%s~y~Klan: ~r~%s~n~", string, Klan(victimid, klan_tag));
	    else if(!Klan(playerid, klan_uid))
			format(string, sizeof string, "%s~y~Klan: ~w~%s~n~", string, Klan(victimid, klan_tag));
	}
	strdel(string, strlen(string)-3, strlen(string));
	PlayerTextDrawSetString(playerid, Player(playerid, player_td_wyniki), string);
	PlayerTextDrawShow(playerid, Player(playerid, player_td_wyniki));
	return 1;
}

/*
 * OnPlayerGiveDamage(playerid, damagedid, Float: amount, weaponid)
 * playerid = strzelający
 * damagedid = postrzelony
 * amount = ilość HP
 * weaponid = ID użytej broni
 */
/*public OnPlayerGiveDamage(playerid, damagedid, Float: amount, weaponid, bodypart)
{
	return 1;
}*/

/*
 * OnPlayerTakeDamage(playerid, issuerid, Float:amount, weaponid)
 * playerid = postrzelony
 * issuerid = strzelający
 * amount = ilość HP
 * weaponid = ID użytej broni
 */

public OnPlayerTakeDamage(playerid, issuerid, Float:amount, weaponid, bodypart)
{
	if(issuerid == INVALID_PLAYER_ID) return 1;
    Player(playerid, player_last_shooter) = issuerid;

	new amo = floatval(amount);

   	PlayerTextDrawShow(issuerid, Player(issuerid, player_td_celownik)[ 0 ]);
    PlayerTextDrawShow(issuerid, Player(issuerid, player_td_celownik)[ 1 ]);
    if(Player(issuerid, player_shoot_timer)[ 0 ])
		KillTimer(Player(issuerid, player_shoot_timer)[ 0 ]);
    Player(issuerid, player_shoot_timer)[ 0 ] = SetTimerEx("HideCelownik", amo*100, false, "d", issuerid);

    if(bodypart == 9)
		Player(playerid, player_hp) 		= 0.0;
	else
		Player(playerid, player_hp) 		-= amount;
    SetPlayerHealth(playerid, Player(playerid, player_hp));
    
	if(GetPlayerTeam(playerid) != GetPlayerTeam(issuerid) && GetPlayerTeam(playerid))
	{
		if(!Player(playerid, player_hp))
		{
			new string[ 126 ],
				exp;
			format(string, sizeof string, "%s~n~", NickName(playerid));
		    if(bodypart != 0 && bodypart != 1 && bodypart != 2)
		    {
		        new shoot[ 64 ];
		        format(shoot, sizeof shoot, BodyParts[ Player(playerid, player_lang) ][ bodypart ]);
		        EscapePL(shoot);
			    format(string, sizeof string, "%s%s %s~n~", string, Lang(playerid, lang_shoot), shoot);
		    }
		    exp = 30 + BodyPartExp[ bodypart ];
		    format(string, sizeof string, "%s~y~~h~+%d exp", string, exp);

		    if(Klan(playerid, klan_uid) != Klan(issuerid, klan_uid) && Klan(playerid, klan_uid) && Klan(issuerid, klan_uid))
		    {
		        new cexp = random(20) + 10;
		        format(string, sizeof string,
					"%s~n~~w~Zabicie gracza z %s~n~~y~~h~+%d exp",
					string,
					Klan(issuerid, klan_tag),
					cexp
				);
				GiveKlanExp(Klan(issuerid, klan_uid), cexp);
				exp += cexp;
		    }

		    Player(playerid, player_hp) = 0.0;
		    GivePlayerExp(playerid, exp);
		    Player(playerid, player_c_exp) += exp;

		    PlayerTextDrawSetString(issuerid, Player(issuerid, player_td_shoot), string);
		    PlayerTextDrawShow(issuerid, Player(issuerid, player_td_shoot));
		    if(Player(issuerid, player_shoot_timer)[ 1 ])
				KillTimer(Player(issuerid, player_shoot_timer)[ 1 ]);
		    Player(issuerid, player_shoot_timer)[ 1 ] = SetTimerEx("HideCelownikEx", 3000, false, "d", issuerid);
		    PlayerPlaySound(issuerid, 1147, 0.0, 0.0, 0.0);
			return 1;
		}
	}
    PlayerPlaySound(issuerid, 1149, 0.0, 0.0, 0.0);

	if((Player(playerid, player_screen) + (amo/10)+1) < 15)
		Player(playerid, player_screen) += (amo/10)+1;
	else
	    Player(playerid, player_screen) = 15;

	if(Player(playerid, player_screen))
	    Player(playerid, player_color) 	= player_nick_red;

    UpdatePlayerNick(playerid);
	return 1;
}

public OnPlayerWeaponShot(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ)
{
	if(IsPlayerNPC(playerid))
		return true;

//	if(!Player(playerid, player_play))
//		return false;
		
//	if(!Game(game_started))
//		return false;

	if(hittype == BULLET_HIT_TYPE_PLAYER)
	{
		if(gettime() - Player(hitid, player_spawn_time) < 5)
		    return false;
	}
	if(weaponid != Player(playerid, player_weapon)[ GetWeaponSlot(GetPlayerWeapon(playerid)) ])
	    return false;
	return true;
}

FuncPub::HideCelownik(playerid)
{
    PlayerTextDrawHide(playerid, Player(playerid, player_td_celownik)[ 0 ]);
    PlayerTextDrawHide(playerid, Player(playerid, player_td_celownik)[ 1 ]);
    Player(playerid, player_shoot_timer)[ 0 ] = 0;
	return 1;
}

FuncPub::HideCelownikEx(playerid)
{
    //SHOW_HIDE_PTD(Player(playerid, player_td_shoot), 0.1, 1.0, 0.02, 50, true, playerid, 0xFFFFFFFF);
    PlayerTextDrawHide(playerid, Player(playerid, player_td_shoot));
    Player(playerid, player_shoot_timer)[ 1 ] = 0;
	return 1;
}

FuncPub::UpdatePlayerNick(playerid)
{
	new playernick[ 64 + MAX_PLAYER_NAME ],
		opis[ 64 ],
		opis_name[ 4 ][ 18 ];

	foreach(Character, i)
	{
	    #if STREAMER
			if(Player(i, player_tag)[ playerid ] == Text3D:INVALID_3DTEXT_ID) continue;
	    #else
			if(Player(i, player_tag)[ playerid ] == PlayerText3D:INVALID_3DTEXT_ID) continue;
		#endif
		
    	set(opis_name[ 0 ], Lang[ Player(playerid, player_lang) ][ 1 ]);

	    if(Player(playerid, player_premium))
	        set(opis_name[ 1 ], Lang(i, lang_prem));
	    if(Player(playerid, player_timehere)[ 0 ] < 7200)
	        set(opis_name[ 2 ], Lang(i, lang_newbie));
	    if(Player(playerid, player_friends)[ i ])
	        set(opis_name[ 3 ], Lang(i, lang_friend));

		if(Player(playerid, player_afktime)[ 0 ] > 5)
		{
		    ReturnTime(Player(playerid, player_afktime)[ 0 ], opis, sizeof opis);
		    format(opis, sizeof opis, "AFK: %s, ", opis);
		}
		else
		{
			for(new x; x < sizeof opis_name; x++)
			{
			    if(isnull(opis_name[ x ])) continue;
			    format(opis, sizeof opis, "%s%s, ", opis, opis_name[ x ]);
			}
		}
		if(!isnull(opis))
		{
			opis[ strlen(opis) - 2 ] = ')';
			if(Player(playerid, player_premium))
				format(opis, sizeof opis, "\n{%06x}(%s", player_nick_prem >>> 8, opis);
			else
			    format(opis, sizeof opis, "\n(%s", opis);
		}

		#if bots
		    if(IsPlayerNPC(playerid) && Player(playerid, player_bot) != INVALID_PLAYER_ID)
		    {
				if(Klan(playerid, klan_uid))
					format(playernick, sizeof playernick, "{%06x}%s\n{%06x}%s%s", Klan(playerid, klan_color) >>> 8, Klan(playerid, klan_name), Player(playerid, player_color) >>> 8, Text(Player(playerid, player_bot), text_bot_name), opis);
				else
		        	format(playernick, sizeof playernick, "%s%s", Text(Player(playerid, player_bot), text_bot_name), opis);
		    }
		    else
		    {
				if(Klan(playerid, klan_uid))
					format(playernick, sizeof playernick, "{%06x}%s\n{%06x}%s (%d)%s", Klan(playerid, klan_color) >>> 8, Klan(playerid, klan_name), Player(playerid, player_color) >>> 8, NickName(playerid), playerid, opis);
			    else
					format(playernick, sizeof playernick, "%s (%d)%s", NickName(playerid), playerid, opis);
			}
		#else
			if(Klan(playerid, klan_uid))
				format(playernick, sizeof playernick, "{%06x}%s\n{%06x}%s (%d)%s", Klan(playerid, klan_color) >>> 8, Klan(playerid, klan_name), Player(playerid, player_color) >>> 8, NickName(playerid), playerid, opis);
		    else
				format(playernick, sizeof playernick, "%s (%d)%s", NickName(playerid), playerid, opis);
		#endif
		#if STREAMER
		    UpdateDynamic3DTextLabelText(Player(i, player_tag)[ playerid ], Player(playerid, player_color), playernick);
		#else
			UpdatePlayer3DTextLabelText(i, Player(i, player_tag)[ playerid ], Player(playerid, player_color), playernick);
		#endif
	}
	return 1;
}

public OnVehicleDeath(vehicleid, killerid)
{
    if(Game(game_typ) == game_type_tdm)
    {
    	Team(Player(killerid, player_team), team_points)++;
	}
	else if(Game(game_typ) == game_type_dd)
	{
	    foreach(Player, i)
	    {
	        if(Player(i, player_vehicle) == vehicleid)
	        {
	            ToSpawn(i);
	            SendClientMessage(i, -1, Lang(i, lang_dd_out));
	            // Odpadłeś
	        }
	    }
	}
	else if(Game(game_typ) == game_type_race)
	{
	    foreach(Player, i)
	    {
	        if(Player(i, player_vehicle) == vehicleid)
	        {
	    		Player(i, player_death) = true;
			}
		}
		DestroyVehicle(vehicleid);
	}
	return 1;
}

#if STREAMER
	FuncPub::End_TD(Text3D:id)
	{
		DestroyDynamic3DTextLabel(id);
		return 1;
	}
#else
	FuncPub::End_TD(playerid, PlayerText3D:id)
	{
	    DeletePlayer3DTextLabel(playerid, id);
		return 1;
	}
#endif

public OnPlayerDeath(playerid, killerid, reason)
{
    SendDeathMessage(killerid, playerid, reason);
    
    Player(playerid, player_spawned) = false;
    Player(playerid, player_death) = true;

	new string[ 100 ],
		Float:pos[ 3 ],
		vw = GetPlayerVirtualWorld(playerid);
	GetPlayerPos(playerid, pos[ 0 ], pos[ 1 ], pos[ 2 ]);
	foreach(Player, i)
	{
	    if(killerid != INVALID_PLAYER_ID)
			format(string, sizeof string, "%s(%d)\n%s\n%s(%d)", NickName(playerid), playerid, Lang(i, lang_kill_by), NickName(killerid), killerid);
		else
		    format(string, sizeof string, "%s(%d)\n%s", NickName(playerid), playerid, Lang(i, lang_kill_myself));
		#if STREAMER
        	new Text3D:End = CreateDynamic3DTextLabel(string, BIALY, pos[ 0 ], pos[ 1 ], pos[ 2 ] + 0.5, 50.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, .worldid = vw, .playerid = i);
			SetTimerEx("End_TD", 10000, false, "i", _:End);
		#else
			new PlayerText3D:End = CreatePlayer3DTextLabel(i, string, BIALY, pos[ 0 ], pos[ 1 ], pos[ 2 ] + 0.5, 50, vw, 1);
			SetTimerEx("End_TD", 10000, false, "ii", i, _:End);
		#endif
	}

    
    if(killerid != INVALID_PLAYER_ID)
    {
	    Game(game_kills)++;
		Player(killerid, player_kills)++;
		Player(killerid, player_kills_round)++;

        MakePoints(playerid, killerid);
 	}
 	else
 	{
        // samobójstwo
        new victimid = Player(playerid, player_last_shooter);
        if(victimid != INVALID_PLAYER_ID)
        {
            MakePoints(playerid, victimid);
        }
    }
	Player(playerid, player_deaths_game)++;
    Player(playerid, player_deaths)++;
    
    new mapid = CreateDynamicMapIcon(pos[ 0 ], pos[ 1 ], pos[ 2 ], 21, BIALY, vw);
    Map(mapid, map_ID) = mapid;
    Map(mapid, map_type) = 21;
    Map(mapid, map_pos)[ 0 ] = pos[ 0 ];
    Map(mapid, map_pos)[ 1 ] = pos[ 1 ];
    Map(mapid, map_pos)[ 2 ] = pos[ 2 ];
    
    new pickid = CreateDynamicPickup(1240, 19, pos[ 0 ], pos[ 1 ], pos[ 2 ], vw);
	Pickup(pickid, pick_model) = 1240;
	Pickup(pickid, pick_type) = 19;
	Pickup(pickid, pick_game) = Setting(setting_game);
	Pickup(pickid, pick_pos)[ 0 ] = pos[ 0 ];
	Pickup(pickid, pick_pos)[ 1 ] = pos[ 1 ];
	Pickup(pickid, pick_pos)[ 2 ] = pos[ 2 ];
	Pickup(pickid, pick_func) = pick_func_health;
	Pickup(pickid, pick_pickID) = pickid;
	Pickup(pickid, pick_mapID) = mapid;
	
	string = ".= HP =.";
	#if STREAMER
		if(Player(playerid, player_pick_tag)[ pickid ] == Text3D:INVALID_3DTEXT_ID)
        	Player(playerid, player_pick_tag)[ pickid ] = CreateDynamic3DTextLabel(string, COLOR_PURPLE, Pickup(pickid, pick_pos)[ 0 ], Pickup(pickid, pick_pos)[ 1 ], Pickup(pickid, pick_pos)[ 2 ], 20.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, .playerid = playerid);
		else
		    UpdateDynamic3DTextLabelText(Player(playerid, player_pick_tag)[ pickid ], COLOR_PURPLE, string);
	#else
		if(Player(playerid, player_pick_tag)[ pickid ] == PlayerText3D:INVALID_3DTEXT_ID)
        	Player(playerid, player_pick_tag)[ pickid ] = CreatePlayer3DTextLabel(playerid, string, COLOR_PURPLE, Pickup(pickid, pick_pos)[ 0 ], Pickup(pickid, pick_pos)[ 1 ], Pickup(pickid, pick_pos)[ 2 ], 20.0);
		else
		    UpdatePlayer3DTextLabelText(playerid, Player(playerid, player_pick_tag)[ pickid ], COLOR_PURPLE, string);
	#endif

	new Float:r;
	r = AddRecord(playerid, top_kills_round, Player(playerid, player_kills_round));
	if(r)
    {
        // info
    }

    r = AddRecord(playerid, top_deaths_game, Player(playerid, player_deaths_game));
    if(r)
    {
        // info
    }
    Player(playerid, player_kills_round) = 0;
	return 1;
}

FuncPub::MakePoints(playerid, killerid)
{
	if(killerid == INVALID_PLAYER_ID) return 1;
	if(!IsPlayerConnected(killerid)) return 1;
	
 	if(Game(game_typ) == game_type_tdm)
 	{
	    if(Player(playerid, player_team) != Player(killerid, player_team))
	    	Team(Player(killerid, player_team), team_points)++;
	    else
	    {
	        // Zabicie swojego
		}
	}
 	if(Game(game_typ) == game_type_tdm || Game(game_typ) == game_type_vehicle || Game(game_typ) == game_type_dm)
 	{
	    new soundid = 0,
			string[ 100 ];
 	    if(Game(game_kills) == 1)
 	    {
		    foreach(Player, i)
		    {
		        if(!Player(playerid, player_play)) continue;

		        if(Audio_IsClientConnected(i))
					Audio_Play(i, kill_firstblood_sound);
			}
 	    }
        switch(Player(killerid, player_kills_round))
	    {
		    case 2: format(string, sizeof string, "~n~~n~~n~~n~~n~~n~~r~%s is on a ~b~double kill!", NickName(killerid)), soundid = kill_doublekill_sound;
		    case 3: format(string, sizeof string, "~n~~n~~n~~n~~n~~n~~y~%s is on a ~r~killing spree!", NickName(killerid)), soundid = kill_killingspree_sound;
		    case 4: format(string, sizeof string, "~n~~n~~n~~n~~n~~n~~g~%s is on a ~b~mmmmmonster kill!", NickName(killerid)), soundid = kill_monsterkill_sound;
		    case 5: format(string, sizeof string, "~n~~n~~n~~n~~n~~n~~r~%s is ~p~dominating!", NickName(killerid)), soundid = kill_dominating_sound;
		    case 6: format(string, sizeof string, "~n~~n~~n~~n~~n~~n~~p~%s is ~y~unstopable!", NickName(killerid)), soundid = kill_unstopable_sound;
		    case 7: format(string, sizeof string, "~n~~n~~n~~n~~n~~n~%s is annihilating!", NickName(killerid)), soundid = kill_ludicrouskill_sound;
		    case 10: format(string,sizeof string, "~n~~n~~n~~n~~n~~n~%s is GodLike!", NickName(killerid)), soundid = kill_godlike_sound;
	    }
	    if(soundid)
	    {
		    foreach(Player, i)
		    {
		        if(!Player(i, player_ready)) continue;
		        if(!Player(i, player_play)) continue;
		        if(!Player(i, player_logged)) continue;

				GameTextForPlayer(i, string, 4000, 5);

				if(Audio_IsClientConnected(i))
					Audio_Play(i, soundid);
			}
	    }
	    SetPlayerScore(killerid, Player(killerid, player_kills_game));
 	}
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    #define dialogid	Player(playerid, player_dialog)

	if(Audio_IsClientConnected(playerid))
	{
		if(response) Audio_Play(playerid, gui_button1_sound);
		else Audio_Play(playerid, gui_button2_sound);
	}
	else
	{
		if(response) PlayerPlaySound(playerid, 1083, 0.0, 0.0, 0.0);
		else PlayerPlaySound(playerid, 1084, 0.0, 0.0, 0.0);
	}

	#if Debug
	    if(dialogid != 999 && dialogid != cellmin && dialogid != 2 && dialogid != 8)
			printf("OnDialogResponse(%d, %d, %d, %d, %s)", playerid, dialogid, response, listitem, inputtext);
	#endif
    if(dialogid != cellmin && dialogid != dialogid)
        response = false;

 	Anims_OnDialogResponse(playerid, dialogid, response, listitem, inputtext);

	switch(dialogid)
	{
		case 2:
		{
	    	if(!response) return SetTimerEx (!#kickPlayer, 249, false, !"i", playerid);
		    if(isnull(inputtext) || strlen(inputtext) > 21)
				return Dialog::Output(playerid, 2, DIALOG_STYLE_PASSWORD, IN_HEAD" "white"» "grey"Zaloguj się", TEXT_LOGIN"\n\nNie podałeś hasła!", "Zaloguj", "Wyjdź");

			new salt[ 10 ],
				bool:log,
				buffer[ 256 ];

	        //mysql_real_escape_string(inputtext, inputtext);

			#if Forum
				format(buffer, sizeof buffer,
					"SELECT m.member_id, m.premium, m.members_display_name FROM `mini_players` p JOIN `"IN_PREF"members` m ON m.member_id = p.guid WHERE p.name = '%s'",
					NickName(playerid)
				);
			#else
				format(buffer, sizeof buffer,
					"SELECT m.uid, m.premium, m.username FROM `mini_players` p JOIN `"IN_PREF"users` m ON m.uid = p.guid WHERE p.name = '%s'",
					NickName(playerid)
				);
			#endif
			mysql_query(buffer);
		    mysql_store_result();
		    if(mysql_num_rows())
		    {
				mysql_fetch_row_format(buffer);
		        sscanf(buffer, "p<|>dds[120]",
			        Player(playerid, player_guid),
			        Player(playerid, player_premium),
			        Player(playerid, player_gname)
		        );
		        mysql_free_result();
				log = true;
		    }
		    else
		    {
				mysql_free_result();
				#if Forum
					format(buffer, sizeof buffer,
						"SELECT m.member_id, m.premium, m.members_display_name FROM `mini_players` p JOIN `"IN_PREF"members` m ON m.member_id = p.guid WHERE m.name = '%s'",
						NickName(playerid)
					);
				#else
					format(buffer, sizeof buffer,
						"SELECT m.uid, m.username FROM `mini_players` p JOIN `"IN_PREF"users` m ON m.uid = p.guid WHERE m.username = '%s'",
						NickName(playerid)
					);
				#endif
				mysql_query(buffer);
			    mysql_store_result();
			    if(mysql_num_rows())
			    {
					mysql_fetch_row_format(buffer);
			        sscanf(buffer, "p<|>dds[120]",
				        Player(playerid, player_guid),
				        Player(playerid, player_premium),
				        Player(playerid, player_gname)
			        );
			        mysql_free_result();
					log = false;
			    }
			    else
			    {
					mysql_free_result();
					// brak konta OOC, lub IC z kontem OOC 
					
					format(buffer, sizeof buffer,
						"SELECT 1 FROM `mini_players` WHERE `name` = '%s'",
						NickSamp(playerid)
					);
					mysql_query(buffer);
				    mysql_store_result();
				    if(mysql_num_rows())
				    {
				        mysql_free_result();
				        
				        format(buffer, sizeof buffer,
							"SELECT `uid` FROM `mini_players` WHERE `name` = '%s' AND `password` = md5('%s')",
							NickSamp(playerid),
							inputtext
						);
						mysql_query(buffer);
					    mysql_store_result();
					    if(mysql_num_rows())
				    	{
					        Player(playerid, player_uid) = mysql_fetch_int();
					        Player(playerid, player_guid) = -1;
					        OnPlayerLoginIn(playerid, Player(playerid, player_uid));
				    	}
				    	else Dialog::Output(playerid, 2, DIALOG_STYLE_PASSWORD, IN_HEAD" "white"» "grey"Zaloguj się", TEXT_LOGIN"\n\nPodałeś nieprawidłowe hasło do konta, spróbuj ponownie.", "Zaloguj", "Wyjdź");
                        mysql_free_result();
					}
					else
					{
						ShowInfo(playerid, red"Jest już zarejestrowane konto z taką nazwą lub konto nie posiada przypisanych postaci!");
						SetTimerEx (!#kickPlayer, 249, false, !"i", playerid);
						//Dialog::Output(playerid, 8, DIALOG_STYLE_PASSWORD, IN_HEAD, TEXT_REGISTER, "Zarejestruj", "Wyjdź");
					}
			     	return 1;
		     	}
		    }
		    #if Forum
			    format(buffer, sizeof buffer,
					"SELECT `members_pass_salt` FROM `"IN_PREF"members` WHERE `member_id` = '%d'",
					Player(playerid, player_guid)
				);
			#else
			    format(buffer, sizeof buffer,
					"SELECT `salt` FROM `"IN_PREF"users` WHERE `uid` = '%d'",
					Player(playerid, player_guid)
				);
			#endif
			mysql_query(buffer);
			mysql_store_result();
			mysql_fetch_row(salt);
			mysql_free_result();
			
		    new password[ 120 ];
	 		format(password, sizeof password, "%s%s", MD5_Hash(salt), MD5_Hash(inputtext));
	 		mysql_real_escape_string(password, password);
			if(log == false) // Nazwa OOC
			{
				new query[ 512 ];
				#if Forum
			 		format(query, sizeof query,
					 	"SELECT p.uid, p.name, p.block FROM `mini_players` p JOIN `"IN_PREF"members` m ON m.members_pass_hash = md5('%s') WHERE p.guid = '%d' AND m.member_id = '%d'",
						 password,
						 Player(playerid, player_guid),
						 Player(playerid, player_guid)
					);
		 		#else
			 		format(query, sizeof query,
					 	"SELECT p.uid, p.name, p.block FROM `mini_players` p JOIN `"IN_PREF"users` m ON m.password = md5('%s') WHERE p.guid = '%d' AND m.uid = '%d'",
						 password,
						 Player(playerid, player_guid),
						 Player(playerid, player_guid)
					);
		 		#endif
				mysql_query(query);
			   	mysql_store_result();
			   	query[ 0 ] = EOS;
			    if(mysql_num_rows())
			    {
			        while(mysql_fetch_row(buffer))
			        {
			            static uid,
							name[ MAX_PLAYER_NAME ],
							block;

						sscanf(buffer, "p<|>ds[24]d",
							uid,
							name,
							block
						);

						if(block & block_ban)
							format(query, sizeof query, "%s"red"%d\t%s\n", query, uid, name);
						else
							format(query, sizeof query, "%s%d\t%s\n", query, uid, name);
			        }
			        if(isnull(query))
			        {
						ShowInfo(playerid, "Nie znaleziono żadnej postaci na tym koncie.");
						SetTimerEx (!#kickPlayer, 249, false, !"i", playerid);
			        }
			        else Dialog::Output(playerid, 3, DIALOG_STYLE_LIST, IN_HEAD" "white"» "grey"Wybierz postać", query, Lang(playerid, lang_select), "Wyjdź");
			    }
			    else Dialog::Output(playerid, 2, DIALOG_STYLE_PASSWORD, IN_HEAD" "white"» "grey"Zaloguj się", TEXT_LOGIN"\n\nPodałeś nieprawidłowe hasło do konta, spróbuj ponownie.", "Zaloguj", "Wyjdź");
				mysql_free_result();
			}
			else
			{
			    new query[ 512 ];
			    #if Forum
			 		format(query, sizeof query,
					 	"SELECT p.uid, p.block FROM `mini_players` p JOIN `"IN_PREF"members` m ON m.members_pass_hash = md5('%s') WHERE p.guid = '%d' AND p.name = '%s'",
						 password,
						 Player(playerid, player_guid),
						 NickName(playerid)
			 		);
		 		#else
			 		format(query, sizeof query,
					 	"SELECT p.uid, p.block FROM `mini_players` p JOIN `"IN_PREF"users` m ON m.password = md5('%s') WHERE p.guid = '%d' AND p.name = '%s'",
						 password,
						 Player(playerid, player_guid),
						 NickName(playerid)
			 		);
		 		#endif
				mysql_query(query);
			   	mysql_store_result();
			    if(mysql_num_rows())
			    {
			        mysql_fetch_row_format(query);
			        sscanf(query, "p<|>dd",
						Player(playerid, player_uid),
						Player(playerid, player_block)
					);

					if(Player(playerid, player_block) & block_ban)
					{
						Chat::Output(playerid, RED, "Ta postać jest zbanowana!");
						SetTimerEx (!#kickPlayer, 249, false, !"i", playerid);
					}
					else OnPlayerLoginIn(playerid, Player(playerid, player_uid));
			    }
			    else Dialog::Output(playerid, 2, DIALOG_STYLE_PASSWORD, IN_HEAD" "white"» "grey"Zaloguj się", TEXT_LOGIN"\n\nPodałeś nieprawidłowe hasło do konta, spróbuj ponownie.", "Zaloguj", "Wyjdź");
				mysql_free_result();
			}
		}
		case 3:
		{
		    if(!response) return SetTimerEx (!#kickPlayer, 249, false, !"i", playerid);
			Player(playerid, player_uid) = strval(inputtext);
			OnPlayerLoginIn(playerid, Player(playerid, player_uid));
		}
		case 4:
		{
		    Player(playerid, player_team) = response ? team_red : team_blue;
		    SetPlayerTeam(playerid, Player(playerid, player_team));
		    Team(Player(playerid, player_team), team_players)++;
		    
			FadeColorForPlayer(playerid, 0, 0, 0, 0, 0, 0, 0, 255, 15, 0); // Ściemnienie
			Player(playerid, player_dark) = dark_spawn;
		}
		case 6:
		{
		    if(!response) return 1;
	        
		    if(DIN(inputtext, Lang(playerid, lang_set)))
		    {
				new buffer[ 512 ];
		        format(buffer, sizeof buffer, "{000000}1 "white"%s:\t\t\t%s\n", Lang(playerid, lang_set_panor), YesOrNo(bool:(Player(playerid, player_option) & option_panor)));
		        format(buffer, sizeof buffer, "%s{000000}2 "white"%s:\t\t%s\n", buffer, Lang(playerid, lang_set_message), YesOrNo(bool:(Player(playerid, player_option) & option_pm)));
				//format(buffer, sizeof buffer, "%s{000000}3 "white"First Person Camera:\t\t%s\n", buffer, YesOrNo(bool:(Player(playerid, player_option) & option_fp)));
				format(buffer, sizeof buffer, "%s{000000}4 "white"%s:\t\t%s\n", buffer, Lang(playerid, lang_set_shoot), YesOrNo(bool:(Player(playerid, player_option) & option_shooting)));
				if(Player(playerid, player_option) & option_shooting)
					format(buffer, sizeof buffer, "%s{000000}5 "white"\t- %s:\t\t%s\n", buffer, Lang(playerid, lang_set_shoot_s), (Player(playerid, player_option) & option_hand) ? ("L") : ("R"));
				if(Player(playerid, player_premium))
				{
				    strcat(buffer, "\n"grey"-----------[PREMIUM]------------\n");
		        	format(buffer, sizeof buffer, "%s{000000}6 "white"%s:\t\t\t\t%s\n", buffer, Lang(playerid, lang_set_nitro), YesOrNo(bool:(Player(playerid, player_premium_option) & prem_option_nitro)));
		        	format(buffer, sizeof buffer, "%s{000000}7 "white"%s:\t\t\t%s\n", buffer, Lang(playerid, lang_set_neon), YesOrNo(bool:(Player(playerid, player_premium_option) & prem_option_neon)));
				}
				Dialog::Output(playerid, 7, DIALOG_STYLE_LIST, Lang(playerid, lang_set_head), buffer, Lang(playerid, lang_select), Lang(playerid, lang_back));
		    }
		    else if(DIN(inputtext, "Language"))
		    {
		        new buffer[ 256 ];
		        for(new c; c < sizeof Lang; c++)
		            format(buffer, sizeof buffer, "%s%d\t%s\t%s\n", buffer, c, Lang[ c ][ 1 ], Lang[ c ][ 0 ]);
				Dialog::Output(playerid, 11, DIALOG_STYLE_LIST, Lang(playerid, lang_set_head), buffer, Lang(playerid, lang_select), Lang(playerid, lang_back));
		    }
		}
		case 7:
		{
		    if(!response) return cmd_stats(playerid, "");
		    new id;
		    sscanf(inputtext, "d", id);
			switch(id)
		    {
		        case 1:
		        {
			        if(Player(playerid, player_option) & option_panor)
			        {
			            Player(playerid, player_option) -= option_panor;

						TextDrawHideForPlayer(playerid, Setting(setting_td_box)[ 0 ]);
						TextDrawHideForPlayer(playerid, Setting(setting_td_box)[ 1 ]);
					}
					else
					{
					    Player(playerid, player_option) |= option_panor;

						TextDrawShowForPlayer(playerid, Setting(setting_td_box)[ 0 ]);
						TextDrawShowForPlayer(playerid, Setting(setting_td_box)[ 1 ]);
					}
		        }
		        case 2:
		        {
			        if(Player(playerid, player_option) & option_pm)
			            Player(playerid, player_option) -= option_pm;
					else
					    Player(playerid, player_option) += option_pm;
				}
				case 3:
				{
			        if(Player(playerid, player_option) & option_fp)
			        {
			            Player(playerid, player_option) -= option_fp;

			            DestroyObject(Player(playerid, player_fp_object));
			            SetCameraBehindPlayer(playerid);
			        }
			        else
			        {
			            Player(playerid, player_option) += option_fp;

			            Player(playerid, player_fp_object) = CreateObject(playerid, 19300, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
						AttachObjectToPlayer(Player(playerid, player_fp_object), playerid, 0.0, 0.15, 0.65, 0.0, 0.0, 0.0);
						AttachCameraToObject(playerid, Player(playerid, player_fp_object));
			        }
				}
				case 4:
				{
			        if(Player(playerid, player_option) & option_shooting)
			            Player(playerid, player_option) -= option_shooting;
			        else
			        {
			            if(Player(playerid, player_option) & option_fp)
			                return ShowInfo(playerid, Lang(playerid, lang_fp_error));
			            Player(playerid, player_option) += option_shooting;
					}
				}
				case 5:
				{
			        if(Player(playerid, player_option) & option_hand)
			            Player(playerid, player_option) -= option_hand;
			        else
			            Player(playerid, player_option) += option_hand;
				}
				case 6:
				{
			        if(Player(playerid, player_premium_option) & prem_option_nitro)
	                    Player(playerid, player_premium_option) -= prem_option_nitro;
			        else
	                    Player(playerid, player_premium_option) += prem_option_nitro;
				}
				case 7:
				{
			        if(Player(playerid, player_premium_option) & prem_option_neon)
			        {
			            UnistallNeon(playerid);
			            Player(playerid, player_premium_option) -= prem_option_neon;
			        }
			        else
			        {
			            InstallNeon(playerid);
			            Player(playerid, player_premium_option) += prem_option_neon;
			        }
				}
			}
		    OnDialogResponseEx(playerid, 6, 1, 0, Lang(playerid, lang_set));
		}
		case 8:
		{
	    	if(!response) return SetTimerEx (!#kickPlayer, 249, false, !"i", playerid);
		    if(isnull(inputtext) || strlen(inputtext) > 21)
				return Dialog::Output(playerid, 8, DIALOG_STYLE_PASSWORD, IN_HEAD" "white"» "grey"Zarejestruj się", TEXT_REGISTER"\n\nNie podałeś hasła!", "Zaloguj", "Wyjdź");

			mysql_real_escape_string(inputtext, inputtext);
			
			new string[ 126 ];
			format(string, sizeof string,
				"INSERT INTO `mini_players` (`guid`, `name`, `password`, `joined`) VALUES ('-1', '%s', md5('%s'), UNIX_TIMESTAMP())",
				NickSamp(playerid),
				inputtext
			);
			mysql_query(string);
			
			Player(playerid, player_uid) = mysql_insert_id();
			Player(playerid, player_guid) = -1;
			SendClientMessage(playerid, -1, "Gratulacje! Zarejestrowałeś się!");
			
			new count;
			mysql_query("SELECT COUNT(*) FROM `mini_players`");
			mysql_store_result();
			count = mysql_fetch_int();
			mysql_free_result();
				
			format(string, sizeof string,
				"Gracz %s zarejestrował się! Mamy już %d %s",
				NickName(playerid),
				count,
				dli(count, "zarejestrowanego użytkownika", "zarejestrowanych użytkowników", "zarejestrowanych użytkowników")
			);
			SendClientMessageToAll(-1, string);
			
			OnPlayerLoginIn(playerid, Player(playerid, player_uid));
		}
		case 9:
		{
		    if(!response) return 1;
		    new cat = strval(inputtext),
				buffer[ 512 ],
				string[ 150 ];

			format(string, sizeof string,
				"SELECT s.uid, s.name, i.used, i.player, i.time FROM `mini_shop` s LEFT JOIN `mini_items` i ON s.uid = i.shopuid WHERE s.cat = '%d'",
				cat
			);
		    mysql_query(string);
			mysql_store_result();
			while(mysql_fetch_row(string))
			{
			    static uid,
					name[ 32 ],
					used;
					
				new time_end,
					player,
					color[ 9 ],
					time_str[ 32 ];
			    
			    sscanf(string, "p<|>ds[32]ddd",
					uid,
					name,
					used,
					player,
					time_end
				);
				
				time_end -= gettime();
			    
			    if(player == Player(playerid, player_uid) && time_end > 0)
			    {
			        if(used)
			            color = item_used;
					else
						color = item_buyed;
					ReturnTimeEx(time_end, time_str);
			    	format(buffer, sizeof buffer, "%s%d\t%s%s (%s: %s)\n", buffer, uid, color, name, Lang(playerid, lang_to_end), time_str);
			    }
			    else format(buffer, sizeof buffer, "%s%d\t%s\n", buffer, uid, name);
			}
			ShowList(playerid, buffer);
			mysql_free_result();
		}
		case 10:
		{
//		    new cat = strval(inputtext),
//				buffer[ 512 ],
//				string[ 150 ];
		}
		case 11:
		{
		    if(!response) return cmd_stats(playerid, "");
		    new lang, string[ 126 ];
		    sscanf(inputtext, "d", lang);
		    ChangeLang(playerid, Player(playerid, player_lang) = lang);
		    cmd_stats(playerid, "");
		    format(string, sizeof string,
		        "UPDATE `mini_players` SET `lang` = '%d' WHERE `uid` = '%d'",
		        Player(playerid, player_lang),
		        Player(playerid, player_uid)
			);
			mysql_query(string);
			foreach(Character, i) UpdatePlayerNick(i);
		}
		case 12:
		{
		    if(!response) return 1;
		    new uid = GetPVarInt(playerid, "Ubranie_id"),
				r,
				string[ 126 ];
			if(sscanf(inputtext, "d", r))
			{
				set(string, "Wybierz sposób płatności:\n");

				if(Skin(uid, skin_resp) <= Player(playerid, player_exp) && Skin(uid, skin_resp))
				    strcat(string, "1\tExp\n");
				if(Skin(uid, skin_cash) <= Player(playerid, player_cash) && Skin(uid, skin_cash))
				    strcat(string, "2\tKasa\n");
				if(!Skin(uid, skin_cash) && !Skin(uid, skin_resp))
			    	strcat(string, "3\tZa darmo\n");

	            Dialog::Output(playerid, 12, DIALOG_STYLE_LIST, IN_HEAD, string, Lang(playerid, lang_select), Lang(playerid, lang_back));
				return 1;
			}
			if(r == 1) Player(playerid, player_exp) -= Skin(uid, skin_resp);
			else if(r == 2) GivePlayerMoney(playerid, 0 - Skin(uid, skin_cash));

		    SetPlayerSkin(playerid, Player(playerid, player_skin) = Skin(uid, skin_model));
		    
 			DeletePVar(playerid, "Ubranie");
 			DeletePVar(playerid, "Ubranie_id");

			format(string, sizeof string, "{68AB5C}Zakupiłeś ubranie model: {497840}%d{68AB5C}. Koszt: ", Skin(uid, skin_model));
			if(r == 1) format(string, sizeof string, "%s{497840}%d {68AB5C}exp", string, Skin(uid, skin_resp));
			else if(r == 2) format(string, sizeof string, "%s{497840}$"white"%d", string, Skin(uid, skin_cash));
			else if(r == 3) strcat(string, "{497840}Za darmo");
	    	ShowCMD(playerid, string);

			SetCameraBehindPlayer(playerid);
	   		TogglePlayerControllable(playerid, true);
	   		
	   		PlayerTextDrawHide(playerid, Player(playerid, player_td_shoot));
		}
	}
	return 1;
}


FuncPub::InstallNeon(playerid)
{
    if(!(Player(playerid, player_premium_option) & prem_option_neon))
        return 1;
	new vehicleid = GetPlayerVehicleID(playerid);
	if(vehicleid)
	{
		new neons[] = {18647, 18648, 18649, 18650, 18651, 18652},
			neon_idx = neons[random(sizeof neons)];
	    new Float:pos[ 3 ];
	    GetVehicleModelInfo(Vehicle(vehicleid, vehicle_model), VEHICLE_MODEL_INFO_SIZE, pos[ 0 ], pos[ 1 ], pos[ 2 ]);
		if(IsCar(vehicleid))// is a car
		{
	    	Player(playerid, player_neon_object)[ 0 ] = CreateObject(neon_idx, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 100.0);
	    	Player(playerid, player_neon_object)[ 1 ] = CreateObject(neon_idx, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 100.0);

			AttachObjectToVehicle(Player(playerid, player_neon_object)[ 0 ], vehicleid, floatdiv(pos[ 0 ], 2.4), 0, floatdiv(pos[ 2 ], -3.5), 0.0, 0.0, 0.0);
			AttachObjectToVehicle(Player(playerid, player_neon_object)[ 1 ], vehicleid, floatdiv(pos[ 0 ], -2.4), 0, floatdiv(pos[ 2 ], -3.5), 0.0, 0.0, 0.0);
		}
		else if(IsABike(vehicleid) || IsARower(vehicleid))
		{
	    	Player(playerid, player_neon_object)[ 0 ] = CreateObject(neon_idx, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 100.0);
			AttachObjectToVehicle(Player(playerid, player_neon_object)[ 0 ], vehicleid, floatdiv(pos[ 0 ], 2.4), 0, floatdiv(pos[ 2 ], -3.5), 0.0, 0.0, 0.0);
		}
	}
	return 1;
}

FuncPub::UnistallNeon(playerid)
{
 	if(Player(playerid, player_neon_object)[ 0 ] != INVALID_OBJECT_ID)
    {
        DestroyObject(Player(playerid, player_neon_object)[ 0 ]);
        Player(playerid, player_neon_object)[ 0 ] = INVALID_OBJECT_ID;
	}
    if(Player(playerid, player_neon_object)[ 1 ] != INVALID_OBJECT_ID)
    {
        DestroyObject(Player(playerid, player_neon_object)[ 1 ]);
        Player(playerid, player_neon_object)[ 1 ] = INVALID_OBJECT_ID;
	}
	return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
    if(oldstate == PLAYER_STATE_ONFOOT && newstate == PLAYER_STATE_DRIVER)
    {
		if(Game(game_typ) == game_type_vehicle)
		{
			new vehicleid = GetPlayerVehicleID(playerid);
			if(Game(game_vehID) == vehicleid)
			{
				if(Player(playerid, player_team) == team_red)
				{
				    SendClientMessage(playerid, -1, Lang(playerid, lang_vehicle_info));
					SetPlayerCheckpoint(playerid, Game(game_marker_pos)[ 0 ], Game(game_marker_pos)[ 1 ], Game(game_marker_pos)[ 2 ], 10.0);
					foreach(Player, i)
					{
			    		if(!Player(i, player_play)) continue;
					    if(Player(i, player_team) == team_blue)
					    {
					        SendClientMessage(i, -1, Lang(playerid, lang_vehicle_binfo));
					    }
					}
				}
				else
				{
					// Wsiadł do swego pojazdu
				}
			}
	    }
	    InstallNeon(playerid);
	}
	else if(newstate == PLAYER_STATE_ONFOOT && oldstate == PLAYER_STATE_DRIVER)
	{
		if(Game(game_typ) == game_type_vehicle)
		{
			DisablePlayerCheckpoint(playerid);
			/*new vehicleid = GetPlayerVehicleID(playerid);
			if(Game(game_vehID) == vehicleid)
			{
			    
			}*/
		}
		else if(Game(game_typ) == game_type_race && !Player(playerid, player_adminlvl))
		{
		    PutPlayerInVehicle(playerid, Player(playerid, player_vehicle), 0);
		}
		if(Player(playerid, player_nitro_object))
			DestroyObject(Player(playerid, player_nitro_object));

		UnistallNeon(playerid);
	}
    return 1;
}

public OnPlayerEnterCheckpoint(playerid)
{
	if(Game(game_typ) == game_type_vehicle)
	{
		new vehicleid = GetPlayerVehicleID(playerid);
		if(Game(game_vehID) != vehicleid) return 1;
		if(Player(playerid, player_team) == team_red)
		{
		    Team(Player(playerid, player_team), team_points)++;
		    SetVehicleToRespawn(Game(game_vehID));
			foreach(Player, i)
			{
			    if(!Player(i, player_play)) continue;
			    if(Player(i, player_team) == team_blue)
			        SendClientMessage(i, -1, Lang(playerid, lang_vehicle_win));
				else if(Player(i, player_team) == team_red)
		        	SendClientMessage(i, -1, Lang(playerid, lang_vehicle_lose));
			}
		}
	}
	else if(Game(game_typ) == game_type_bomb)
	{
	    if(Game(game_bomb_player) == playerid && Player(playerid, player_team) == team_red && !Game(game_bomb))
	    {
	    	Game(game_plante) = team_red;
	    	Player(playerid, player_plante) = true;
		}
		else if(Player(playerid, player_team) == team_blue && Game(game_bomb))
		{
		    Game(game_plante) = team_blue;
		    Player(playerid, player_plante) = true;
		}
	}
	else if(Game(game_typ) == game_type_spado)
	{
	    if(Game(game_time) > 30) Game(game_time) = 30;

		new string[ 126 ],
			Float:czas = floatdiv(GetTickCount() - Game(game_time_start), 1000);

	    new Float:r = AddRecord(playerid, top_spado, czas);
		if(r)
		{
            format(string, sizeof string,
	            "Własny rekord pobity!! Stary czas: %.2f %s, nowy czas: %.2f %s",
	            r,
				dlix(playerid, floatval(r)),
				czas,
				dlix(playerid, floatval(czas))
			);
			SendClientMessage(playerid, -1, string);
		}
        SendClientMessage(playerid, -1, Lang(playerid, lang_end));
		Game(game_race)++;

 		format(string, sizeof string, "%s: %.2f %s",
			Lang(playerid, lang_time),
			czas,
			dlix(playerid, floatval(czas))
		);
        SendClientMessage(playerid, -1, string);

		new exp = floatval(floatdiv(100, Game(game_race)));
        format(string, sizeof string, "Zajales %d miejsce!~n~~y~~h~+%d exp", Game(game_race), exp);
	    PlayerTextDrawSetString(playerid, Player(playerid, player_td_shoot), string);
	    PlayerTextDrawShow(playerid, Player(playerid, player_td_shoot));
		if(Player(playerid, player_shoot_timer)[ 1 ])
		    KillTimer(Player(playerid, player_shoot_timer)[ 1 ]);
	    Player(playerid, player_shoot_timer)[ 1 ] = SetTimerEx("HideCelownikEx", 10000, false, "d", playerid);
	}
 	return 1;
}

public OnPlayerLeaveCheckpoint(playerid)
{
    if(Game(game_typ) == game_type_bomb)
	{
	    new c = -1;
	    foreachex(Player, c)
	        if(Player(playerid, player_plante))
				break;
		if(c == -1)
		{
	    	Game(game_plante) = team_none;
	    	Game(game_progress) = 0;
    	}
	}
	return 1;
}

public OnPlayerEnterRaceCheckpoint(playerid)
{
	if(!Player(playerid, player_ready)) return 1;
	if(!Player(playerid, player_play)) return 1;

    Player(playerid, player_race)++;
	PlayerPlaySound(playerid, 1056, 0.0, 0.0, 0.0);
	Race(Player(playerid, player_race), race_player)[ Race(Player(playerid, player_race), race_idx)++ ] = playerid;
	Player(playerid, player_race_time)[ Player(playerid, player_race) ] = GetTickCount();
	
    if(Game(game_race_max) == Player(playerid, player_race))
    {
        if(Game(game_time) > 30) Game(game_time) = 30;
        
		new string[ 126 ],
			Float:czas = floatdiv(GetTickCount() - Game(game_time_start), 1000);
			
		new Float:r = AddRecord(playerid, top_race, czas);
		if(r)
		{
            format(string, sizeof string,
	            "Własny rekord pobity!! Stary czas: %.2f %s, nowy czas: %.2f %s",
	            r,
				dlix(playerid, floatval(r)),
				czas,
				dlix(playerid, floatval(czas))
			);
			SendClientMessage(playerid, -1, string);
		}
        
        SendClientMessage(playerid, -1, Lang(playerid, lang_end));
		Game(game_race)++;
        
 		format(string, sizeof string, "%s: %.2f %s",
			Lang(playerid, lang_time),
			czas,
			dlix(playerid, floatval(czas))
		);
        SendClientMessage(playerid, -1, string);
        
		new exp = floatval(floatdiv(100, Game(game_race)));
        format(string, sizeof string, "Zajales %d miejsce!~n~~y~~h~+%d exp", Game(game_race), exp);
	    PlayerTextDrawSetString(playerid, Player(playerid, player_td_shoot), string);
	    PlayerTextDrawShow(playerid, Player(playerid, player_td_shoot));
		if(Player(playerid, player_shoot_timer)[ 1 ])
		    KillTimer(Player(playerid, player_shoot_timer)[ 1 ]);
	    Player(playerid, player_shoot_timer)[ 1 ] = SetTimerEx("HideCelownikEx", 10000, false, "d", playerid);

        new reszta, tm<tmTime>;
        gmtime(Time:floatval(czas), tmTime);
		reszta = floatval((czas - floatval(czas)) * 100);
		if(Game(game_race) < sizeof RacePlace)
	    	format(string, sizeof string, "%s. (%02d:%02d:%d) %s ~y~~h~+%d", RacePlace[ Game(game_race) ], tmTime[ tm_min ], tmTime[ tm_sec ], reszta, NickName(playerid), exp);
		else
	    	format(string, sizeof string, "%dth. (%02d:%02d:%d) %s~y~~h~+%d", Game(game_race), tmTime[ tm_min ], tmTime[ tm_sec ], reszta, NickName(playerid), exp);

        GivePlayerExp(playerid, exp);

		foreach(Player, i)
		{
		    //if(!Player(i, player_play)) continue;
			ShowPlayerRecord(i);
			
			if(Game(game_race) < sizeof Setting(setting_td_left))
			{
			    TextDrawSetString(Setting(setting_td_left)[ Game(game_race) - 1 ], string);
				TextDrawShowForPlayer(i, Setting(setting_td_left)[ Game(game_race) - 1 ]);
			}
		}

        DestroyVehicle(Player(playerid, player_vehicle));
		Player(playerid, player_vehicle) = INVALID_VEHICLE_ID;
		ToSpawn(playerid);
    }
	else if(Game(game_race_max) == Player(playerid, player_race)+1)
	{
	    SetPlayerRaceCheckpoint(playerid, 1,
			Race(Player(playerid, player_race), race_pos)[ 0 ],
			Race(Player(playerid, player_race), race_pos)[ 1 ],
			Race(Player(playerid, player_race), race_pos)[ 2 ],
			Race(Player(playerid, player_race)+1, race_pos)[ 0 ],
			Race(Player(playerid, player_race)+1, race_pos)[ 1 ],
			Race(Player(playerid, player_race)+1, race_pos)[ 2 ],
		10);
	}
	else
	{
	    SetPlayerRaceCheckpoint(playerid, 0,
			Race(Player(playerid, player_race), race_pos)[ 0 ],
			Race(Player(playerid, player_race), race_pos)[ 1 ],
			Race(Player(playerid, player_race), race_pos)[ 2 ],
			Race(Player(playerid, player_race)+1, race_pos)[ 0 ],
			Race(Player(playerid, player_race)+1, race_pos)[ 1 ],
			Race(Player(playerid, player_race)+1, race_pos)[ 2 ],
		10);
	}
	return 1;
}

public OnVehicleSpawn(vehicleid)
{
	SetVehicleParamsEx(Vehicle(vehicleid, vehicle_carid), 1, 1, 0, 0, 0, 0, (Game(game_vehID) == vehicleid));
	Vehicle(vehicleid, vehicle_hp) = 1000.0;
	
    if(Game(game_typ) == game_type_tdm)
		SetVehicleNumberPlate(Vehicle(vehicleid, vehicle_carid), Team(Vehicle(vehicleid, vehicle_team), team_name));
    else
		SetVehicleNumberPlate(Vehicle(vehicleid, vehicle_carid), IN_NAME);
	return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(!IsPlayerInAnyVehicle(playerid))
	{
	    if(Player(playerid, player_play))
	    {
			if(PRESSED(KEY_HANDBRAKE) && GetPlayerWeapon(playerid) >= 22)
			{
				Player(playerid, player_aim) = true;

				if(!(Player(playerid, player_option) & option_fp) && Player(playerid, player_option) & option_shooting)
				{
					Player(playerid, player_aim_object) = CreateObject(playerid, 19300, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
					AttachObjectToPlayer(Player(playerid, player_aim_object), playerid, (Player(playerid, player_option) & option_hand) ? (-0.5) : (0.5), -0.92, Player(playerid, player_crouch) ? (0.3) : (0.6), 0.0, 0.0, 0.0);
					AttachCameraToObject(playerid, Player(playerid, player_aim_object));
				}
			}
		 	else if(RELEASED(KEY_HANDBRAKE) && Player(playerid, player_aim))
		 	{
			 	Player(playerid, player_aim) = false;
			 	if(!(Player(playerid, player_option) & option_fp))
				{
			 		DestroyObject(Player(playerid, player_aim_object));
			 		SetCameraBehindPlayer(playerid);
				}
			}
			if(newkeys == (KEY_HANDBRAKE + KEY_YES) && Player(playerid, player_aim))
			{
		        if(Player(playerid, player_option) & option_hand)
		            Player(playerid, player_option) -= option_hand;
		        else
		            Player(playerid, player_option) += option_hand;

				AttachObjectToPlayer(Player(playerid, player_aim_object), playerid, (Player(playerid, player_option) & option_hand) ? (-0.5) : (0.5), -0.92, Player(playerid, player_crouch) ? (0.3) : (0.6), 0.0, 0.0, 0.0);
				AttachCameraToObject(playerid, Player(playerid, player_aim_object));
			}
		}
		else
		{
			if(newkeys & KEY_NO)
			{
			    cmd_sklep(playerid, "");
			}
			if(newkeys & KEY_YES)
			{
			    cmd_gotowy(playerid, "");
			}
		}
	}
	else
	{
	    if(Player(playerid, player_nitro) > 0.0)
	    {
		    new carid = GetPlayerVehicleID(playerid);
		    if(PRESSED(KEY_FIRE) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
			{
		        if(!IsValidObject(Player(playerid, player_nitro_object)) && Player(playerid, player_premium_option) & prem_option_nitro)
				{
		        	Player(playerid, player_nitro_object) = CreateObject(18694, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 500.0);
		        	AttachObjectToVehicle(Player(playerid, player_nitro_object), carid, 0.0, -2.3, 1.2, 180.0, 0.0, 0.0);
		        }
		        if(!Player(playerid, player_nitro_timer))
		        	Player(playerid, player_nitro_timer) = SetTimerEx("NitroTimer", 200, true, "dd", playerid, carid);
		        AddVehicleComponent(carid, 1010);
		    }
		    else if(RELEASED(KEY_FIRE))
		    {
				if(Player(playerid, player_nitro_object))
				{
					DestroyObject(Player(playerid, player_nitro_object));
					Player(playerid, player_nitro_object) = INVALID_OBJECT_ID;
				}
				if(Player(playerid, player_nitro_timer))
                {
                    KillTimer(Player(playerid, player_nitro_timer));
                    Player(playerid, player_nitro_timer) = 0;
                }
                if(Player(playerid, player_nitro) > 0.0)
                    AddVehicleComponent(carid, 1010);
				else
	            	RemoveVehicleComponent(carid, 1010);
		    }
	    }
	}
	return 1;
}

FuncPub::NitroTimer(playerid, carid)
{
    Player(playerid, player_nitro) -= 0.1;
    if(Player(playerid, player_nitro) <= 0.0)
    {
        KillTimer(Player(playerid, player_nitro_timer));
        Player(playerid, player_nitro_timer) = 0;
        Player(playerid, player_nitro) = 0.0;
        RemoveVehicleComponent(carid, 1010);
    }
	return 1;
}

FuncPub::GlobalTimer()
{
	static godzina,
		minuta,
		second;
		
	CountDown();
	
	gettime(godzina, minuta, second);
	foreach(Player, i)
	{
		if(!Player(i, player_spawned) || !Player(i, player_logged))
			continue;
		if(Player(i, player_screen))
		{
		    Player(i, player_screen)--;
		    if(!Player(i, player_screen))
		    {
		    	if(Player(i, player_premium))
				    Player(i, player_color) = player_nick_prem;
				else
					Player(i, player_color) = player_nick_def;
		        UpdatePlayerNick(i);
		    }
		}
			
		Player(i, player_afktime)[ 0 ]++;
        if(Player(i, player_afktime)[ 0 ] > 5)
        {
			Player(i, player_afktime)[ 1 ]++;
			Player(i, player_afktime)[ 2 ]++;
			UpdatePlayerNick(i);
		}

		if(Player(i, player_afktime)[ 0 ] <= 10)
		{
            Player(i, player_timehere)[ 0 ]++;
		    Player(i, player_timehere)[ 1 ]++;
		}
		AntyCheat(i);
	}
	if(!(minuta % 10) && !second)
	{
	    new idx = 1;
	    for(new textid; textid < MAX_3DTEXT; textid++)
	    {
	        if(!Text(textid, text_uid)) continue;
	        if(Text(textid, text_game) == Setting(setting_game)) continue;
	        if(Text(textid, text_textID) == Text3D:INVALID_3DTEXT_ID) continue;
			SetTimerEx("UpdateText", idx * 1000, false, "d", textid);
			idx++;
		}
	}
	if(Game(game_plante) != team_none && Game(game_started))
	{
	 	if(Game(game_progress) == bomb_time)
	  	{
	    	if(Game(game_plante) == team_red)
	        	Planted_Bomb();
			else if(Game(game_plante) == team_blue)
				Defused_Bomb();
		}
	    else Game(game_progress)++;
    }
    if(Game(game_bomb_countdown) && Game(game_bomb) && Game(game_started))
    {
        Game(game_bomb_countdown)--;
        if(Game(game_bomb_countdown) == 7)
        {
 			foreach(Player, i)
			{
			    if(!Audio_IsClientConnected(i)) continue;
			    if(!Player(i, player_bomb_sound)) continue;
			    Audio_Stop(i, Player(i, player_bomb_sound));
			    Player(i, player_bomb_sound) = 0;
			    Audio_Play(i, bomb_2);
			}
        }
        if(Game(game_bomb_countdown))
        	Boom();
    }
    
    if(Game(game_typ) == game_type_hay && Game(game_started))
    {
        foreach(Player, i)
        {
	        if(!Player(i, player_ready)) continue;
	        if(!Player(i, player_play)) continue;
	        if(!Player(i, player_logged)) continue;
	        
	        new Float:tmp, Float:pos;
	        GetPlayerPos(i, tmp, tmp, pos);
	        if(pos <= Team(Player(i, player_team), team_spawn_pos_z)[ 0 ]-10.0)
	        {
			    PlayerTextDrawSetString(i, Player(i, player_td_shoot), "Odpadles z zabawy!");
			    PlayerTextDrawShow(i, Player(i, player_td_shoot));
				if(Player(i, player_shoot_timer)[ 1 ])
				    KillTimer(Player(i, player_shoot_timer)[ 1 ]);
			    Player(i, player_shoot_timer)[ 1 ] = SetTimerEx("HideCelownikEx", 5000, false, "d", i);
	            ToSpawn(i);
	        }
	        
	        if(Game(game_players) == 1)
	        {
	            GivePlayerExp(i, 100);
			    PlayerTextDrawSetString(i, Player(i, player_td_shoot), "Wygrales zabawe!~n~~y~~h~+100 exp");
			    PlayerTextDrawShow(i, Player(i, player_td_shoot));
				if(Player(i, player_shoot_timer)[ 1 ])
				    KillTimer(Player(i, player_shoot_timer)[ 1 ]);
			    Player(i, player_shoot_timer)[ 1 ] = SetTimerEx("HideCelownikEx", 5000, false, "d", i);
	            ToSpawn(i);
	        }
		}
		Game(game_idx)--;
        if(!Game(game_idx))
        {
            Game(game_idx) = 5;
            foreach(Player, i)
            {
		        if(!Player(i, player_ready)) continue;
		        if(!Player(i, player_play)) continue;
		        if(!Player(i, player_logged)) continue;
                ResetPlayerWeaponsEx(i);
            }
            new r = GetRandomPlayer();
            if(r != INVALID_PLAYER_ID)
            	GivePlayerWeaponEx(r, 24, 1);
        }
    }
	return 1;
}

FuncPub::GetRandomPlayer()
{
    new online[ MAX_PLAYERS ], playersonline;
    foreach(Player, i)
    {
        if(!Player(i, player_ready)) continue;
        if(!Player(i, player_play)) continue;
        if(!Player(i, player_logged)) continue;
        online[ playersonline ] = i;
        playersonline++;
    }
    if(!playersonline) return INVALID_PLAYER_ID;
    return online[ random(playersonline) ];
}

FuncPub::Planted_Bomb()
{
	Game(game_bomb) = true;
	Game(game_progress) = 0;
	Game(game_bomb_player) = INVALID_PLAYER_ID;
	foreach(Player, i)
	{
        if(!Player(i, player_ready)) continue;
        if(!Player(i, player_play)) continue;
        if(!Player(i, player_logged)) continue;

		GameTextForPlayer(i, "~n~~n~~n~~n~~n~~n~~g~Bomb has been planted!", 4000, 5);

		if(Audio_IsClientConnected(i))
		{
	    	Audio_Play(i, bomb_planted);
	    	Player(i, player_bomb_sound) = Audio_Play(i, bomb_1, .loop = true);
		}
	}
	return 1;
}

FuncPub::Boom()
{
    if(Game(game_time) > 5) Game(game_time) = 5;
    CreateExplosion(Game(game_marker_pos)[ 0 ], Game(game_marker_pos)[ 1 ], Game(game_marker_pos)[ 2 ], 6, 10.0);
	foreach(Player, i)
	{
        if(!Player(i, player_ready)) continue;
        if(!Player(i, player_play)) continue;
        if(!Player(i, player_logged)) continue;
        
    	GameTextForPlayer(i, "~n~~n~~n~~n~~n~~n~~r~Bomb boom!", 4000, 5);
	}
	return 1;
}

FuncPub::Defused_Bomb()
{
    if(Game(game_time) > 5) Game(game_time) = 5;
	foreach(Player, i)
	{
        if(!Player(i, player_ready)) continue;
        if(!Player(i, player_play)) continue;
        if(!Player(i, player_logged)) continue;

		GameTextForPlayer(i, "~n~~n~~n~~n~~n~~n~~g~Bomb has been defused!", 4000, 5);

		if(Audio_IsClientConnected(i))
		{
	    	Audio_Play(i, bomb_defused);
	    	if(Player(i, player_bomb_sound))
	    	{
		    	Audio_Stop(i, Player(i, player_bomb_sound));
			    Player(i, player_bomb_sound) = 0;
		    }
		}
	}
	return 1;
}

FuncPub::Reset(playerid)
{
    DisablePlayerRaceCheckpoint(playerid);
    DisablePlayerCheckpoint(playerid);
    Player(playerid, player_race) = 0;
    Player(playerid, player_team) = team_none;
    SetPlayerTeam(playerid, Player(playerid, player_team));
	Player(playerid, player_ready) = false;
	Player(playerid, player_play) = false;
	DestroyVehicle(Player(playerid, player_vehicle));
	Player(playerid, player_vehicle) = INVALID_VEHICLE_ID;
	PlayerTextDrawHide(playerid, Player(playerid, player_td_wyniki));
	if(Player(playerid, player_nitro_timer))
	{
	    KillTimer(Player(playerid, player_nitro_timer));
		Player(playerid, player_nitro_timer) = 0;
	}
	Player(playerid, player_nitro) = 0.0;
	UnLoadPickupTextDraw(playerid);
	if(Player(playerid, player_connect_audio))
	{
	    if(Audio_IsClientConnected(playerid))
	        Audio_Stop(playerid, Player(playerid, player_connect_audio));
	    else
	    	StopAudioStreamForPlayer(playerid);
    	Player(playerid, player_connect_audio) = 0;
	}
	return 1;
}

FuncPub::ToSpawn(playerid)
{
    Reset(playerid);
    Game(game_players)--;
    mysql_query("UPDATE `mini_info` SET `played` = `played` - 1");
    Team(Player(playerid, player_team), team_players)--;
    Player(playerid, player_play) = true;
    SetTimerEx("Recall", 1000, false, "d", playerid);
    FadeColorForPlayer(playerid, 0, 0, 0, 0, 0, 0, 0, 255, 15, 0); // Ściemnienie
	Player(playerid, player_dark) = dark_none;
	return 1;
}

FuncPub::Recall(playerid)
{
	Player(playerid, player_dark) = dark_spawn;
	OnFadeComplete(playerid, false);
	return 1;
}

FuncPub::ShowPlayerRecord(playerid)
{
	new count = 1,
		string[ 256 ],
		right[ 126 ],
		left[ 126 ];
    format(string, sizeof string,
        "SELECT p.uid, p.name, t.value, IFNULL(o.ID, -1) FROM `mini_top` t, `mini_players` p LEFT JOIN `all_online` o ON (o.player = p.uid AND o.type = "#type_mini") WHERE p.uid = t.player AND t.gameuid = '%d' ORDER BY t.value ASC LIMIT 5",
        Setting(setting_game)
	);
	mysql_query(string);
	mysql_store_result();
	while(mysql_fetch_row(string))
	{
	    static uid,
			name[ MAX_PLAYER_NAME ],
			Float:time_rec,
			tm<tmTime>,
			reszta,
			victimid;

		sscanf(string, "p<|>ds["#MAX_PLAYER_NAME"]fd",
			uid,
			name,
			time_rec,
			victimid
		);
		gmtime(Time:floatval(time_rec), tmTime);
		reszta = floatval((time_rec - floatval(time_rec)) * 100);
		if(victimid == playerid)
		{
			format(left, sizeof left, "%s%d. ~g~%s~w~~n~", left, count, name);
			format(right, sizeof right, "%s~g~%02d:%02d:%d~w~~n~", right, tmTime[ tm_min ], tmTime[ tm_sec ], reszta);
		}
		else
		{
			format(left, sizeof left, "%s%d. %s~n~", left, count, name);
			format(right, sizeof right, "%s%02d:%02d:%d~n~", right, tmTime[ tm_min ], tmTime[ tm_sec ], reszta);
		}
		count++;
	}
	for(; count <= 5; count++)
	{
		format(left, sizeof left, "%s%d. ---------~n~", left, count);
		format(right, sizeof right, "%s00:00:00~n~", right);
	}
	mysql_free_result();
	
	PlayerTextDrawSetString(playerid, Player(playerid, player_td_record)[ 0 ], left);
	PlayerTextDrawSetString(playerid, Player(playerid, player_td_record)[ 1 ], right);
    TextDrawShowForPlayer(playerid, Setting(setting_td_record)[ 0 ]);
    TextDrawShowForPlayer(playerid, Setting(setting_td_record)[ 1 ]);
    PlayerTextDrawShow(playerid, Player(playerid, player_td_record)[ 0 ]);
    PlayerTextDrawShow(playerid, Player(playerid, player_td_record)[ 1 ]);
    if(!Player(playerid, player_record))
    {
        if(!Game(game_started))
			Player(playerid, player_record) = SetTimerEx("HideTD", Game(game_countdown)*1000, false, "d", playerid);
		else
			Player(playerid, player_record) = SetTimerEx("HideTD", Game(game_time)*1000, false, "d", playerid);
	}
	return 1;
}

FuncPub::HideTD(playerid)
{
    TextDrawHideForPlayer(playerid, Setting(setting_td_record)[ 0 ]);
    TextDrawHideForPlayer(playerid, Setting(setting_td_record)[ 1 ]);
    PlayerTextDrawHide(playerid, Player(playerid, player_td_record)[ 0 ]);
    PlayerTextDrawHide(playerid, Player(playerid, player_td_record)[ 1 ]);
    KillTimer(Player(playerid, player_record));
    Player(playerid, player_record) = 0;
	return 1;
}

FuncPub::CountDown()
{
	static string[ 64 ];
	new tm<tmTime>;
	
	if(Game(game_time))
	{
	    if(Game(game_started) && Setting(setting_game) != INVALID_GAME_ID && !Setting(setting_debug)) Game(game_time)--;
	    else if(!Game(game_started) && Setting(setting_game) == INVALID_GAME_ID) Game(game_time)--;
    	gmtime(Time:Game(game_time), tmTime);
    
		format(string, sizeof string, "%s%d:%02d", tmTime[ tm_sec ] < 30 && !tmTime[ tm_min ] ? ("~r~") : (""), tmTime[ tm_min ], tmTime[ tm_sec ]);
		TextDrawSetString(Setting(setting_td_time)[ 0 ], string);
		TextDrawSetString(Setting(setting_td_time)[ 2 ], string);
		TextDrawSetString(Setting(setting_td_time)[ 3 ], string);
		if(!Game(game_time))
	    {
	        if(Game(game_started))
	        {
				foreach(Player, i)
				{
				    if(Player(i, player_play))
				    {
				        if(Game(game_typ) == game_type_tdm || Game(game_typ) == game_type_vehicle || Game(game_typ) == game_type_dm)
				        {
					        format(string, sizeof string,
								"%s: %d/%d (Ratio(K/D): %.2f)",
								Lang(i, lang_result),
					            Player(i, player_kills_game),
					            Player(i, player_deaths_game),
		                        floatdiv(Player(i, player_kills_game), Player(i, player_deaths_game))
							);
							SendClientMessage(i, -1, string);
						}
					    new Float:r;
						r = AddRecord(i, top_kills_game, Player(i, player_kills_game));
						if(r)
						{
						    // Rekord pobity
						}
					    r = AddRecord(i, top_kills_round, Player(i, player_kills_round));
						if(r)
						{
						    // Rekord pobity
						}
						r = AddRecord(i, top_deaths_game, Player(i, player_deaths_game));
						if(r)
						{
						    // Rekord pobity
						}

					    Player(i, player_kills_game) = 0;
					    Player(i, player_kills_round) = 0;
					    Player(i, player_deaths_game) = 0;

				        ToSpawn(i);
				    }
					SendClientMessage(i, -1, Lang(i, lang_started));
				}
				EndGame();
				Game(game_time) = 120;
				for(new td; td < sizeof Setting(setting_td_left); td++)
				    TextDrawHideForAll(Setting(setting_td_left)[ td ]);
			    // Koniec gry.
			}
			else LoadRandomGame();
		}
	}
	return 1;
}

FuncPub::OptTimer()
{
	foreach(Player, i)
	{
		if(!Player(i, player_logged))
			continue;
			
        if(Player(i, player_respawn) > 0)
		{
			static string[ 32 ];
			Player(i, player_respawn) -= 0.1;
			format(string, sizeof string,
				"%s %.1f %s",
				Lang(i, lang_respawn),
				Player(i, player_respawn),
				dlix(i, floatval(Player(i, player_respawn)))
			);
			PlayerTextDrawSetString(i, Player(i, player_td_respawn), string);

	        if(Player(i, player_respawn) < 0 || !Game(game_started))
	        {
	            Player(i, player_respawn) = 0;
	            Player(i, player_death) = false;
	            PlayerTextDrawHide(i, Player(i, player_td_respawn));
	            
	            FadeColorForPlayer(i, 0, 0, 0, 0, 0, 0, 0, 255, 15, 0); // Ściemnienie
	            Player(i, player_dark) = dark_spawn;
	        }
		}
		
		if(!Player(i, player_spawned))
			continue;
		if(Player(i, player_play)/* && Game(game_started)*/)
		{
			new progress[ 126 ];
			if(Game(game_typ) == game_type_race)
			{
			    new Float:t = floatdiv(GetTickCount() - Game(game_time_start), 1000),
			        Float:res;
			        
				if(Game(game_started)) res = t;
				else res = 0;
				
				format(progress, sizeof progress,
					"~y~CP: ~w~%d/%d~n~~y~%s: ~w~%.2fs",
					Player(i, player_race),
					Game(game_race_max),
					Lang(i, lang_curr_time),
					res
				);
				if(Player(i, player_nitro) > 0.0)
				    format(progress, sizeof progress,
				        "%s~n~~y~Nitro: ~w~%.1f%%",
				        progress,
				        Player(i, player_nitro)
					);
			}
			else if(Game(game_typ) == game_type_dm || Game(game_typ) == game_type_vehicle)
			{
			    format(progress, sizeof progress,
					"~y~%s: ~w~%d~n~~y~%s: ~w~%d",
					Lang(i, lang_kill),
					Player(i, player_kills_game),
					Lang(i, lang_death),
					Player(i, player_deaths_game)
				);
			}
			else if(Game(game_typ) == game_type_tdm)
			{
			    format(progress, sizeof progress,
					"~y~%s: ~w~%d~n~~y~%s: ~w~%d",
					Lang(i, lang_kill),
					Player(i, player_kills_game),
					Lang(i, lang_death),
					Player(i, player_deaths_game)
				);
				format(progress, sizeof progress,
					"%s~n~~y~%s: ~w~%d~n~~y~%s: ~w~%d",
					progress,
					Team(team_red, team_name),
					Team(team_red, team_points),
  					Team(team_blue, team_name),
  					Team(team_blue, team_points)
				);
			}
			else if(Game(game_typ) == game_type_bomb)
			{
			    format(progress, sizeof progress,
					"~y~%s: ~w~%d~n~~y~%s: ~w~%d",
					Lang(i, lang_kill),
					Player(i, player_kills_game),
					Lang(i, lang_death),
					Player(i, player_deaths_game)
				);
			
			    if(Game(game_bomb_countdown) && Game(game_bomb))
				    format(progress, sizeof progress,
						"%s~n~~r~Bomb: ~w~%ds",
						progress,
						Game(game_bomb_countdown)
					);
			}
			else if(Game(game_typ) == game_type_hay)
			{
			    format(progress, sizeof progress,
			        "~y~%s: ~w~%d %s~n~~y~Zostalo: ~w~%d",
			        Lang(i, lang_time),
			        Game(game_idx),
			        dlix(i, Game(game_idx)),
			        Game(game_players)
				);
			}
			else if(Game(game_typ) == game_type_stunt)
			{
			    format(progress, sizeof progress,
			        "~y~Zostalo: ~w~%d",
			        Game(game_players)
				);
			}
			if(!isnull(progress))
				PlayerTextDrawSetString(i, Player(i, player_td_wyniki), progress);
				
			Pickup_Timer(i);
		}
	}
	AntyCheatVehicle();
	return 1;
}

public OnFadeComplete(playerid, beforehold)
{
	switch(Player(playerid, player_dark))
	{
		case dark_camera:
		{
		    FadeColorForPlayer(playerid, 0, 0, 0, 255, 0, 0, 0, 0, 15, 0); // Rozjaśnienie
			Player(playerid, player_dark) = dark_none;
			OnPlayerCameraChange(playerid);
		}
		case dark_login:
		{
		    FadeColorForPlayer(playerid, 0, 0, 0, 255, 0, 0, 0, 0, 15, 0); // Rozjaśnienie
			Player(playerid, player_dark) = dark_login2;
			OnPlayerCameraChange(playerid);
		}
		case dark_login2:
		{
			PreloadAnimLibraries(playerid);
		    Player(playerid, player_dark) = dark_none;
		}
		case dark_spawn:
		{
		    TogglePlayerSpectating(playerid, 0);
		    FadeColorForPlayer(playerid, 0, 0, 0, 255, 0, 0, 0, 0, 15, 0); // Rozjaśnienie
			Player(playerid, player_dark) = dark_none;
			KillTimer(Player(playerid, player_cam_timer));
		    SpawnPlayer(playerid);
		}
		case dark_kick: Kick(playerid);
		case dark_start:
		{
  			if(Game(game_typ) == game_type_tdm || Game(game_typ) == game_type_vehicle)
			{
			    TextDrawShowForPlayer(playerid, Setting(setting_td_box)[ 0 ]);
				TextDrawShowForPlayer(playerid, Setting(setting_td_box)[ 1 ]);
				
				if(Game(game_camera)[ 0 ] != 0.0 && Game(game_camera)[ 1 ] != 0.0 && Game(game_camera)[ 2 ] != 0.0)
					SetPlayerCameraPos(playerid, Game(game_camera)[ 0 ], Game(game_camera)[ 1 ], Game(game_camera)[ 2 ]);
				if(Game(game_camera)[ 3 ] != 0.0 && Game(game_camera)[ 4 ] != 0.0 && Game(game_camera)[ 5 ] != 0.0)
					SetPlayerCameraLookAt(playerid, Game(game_camera)[ 3 ], Game(game_camera)[ 4 ], Game(game_camera)[ 5 ]);

				SetPlayerInterior(playerid, Game(game_camera_int));
				Player(playerid, player_dark) = dark_start2;
			}
			else
			{
			    SpawnPlayer(playerid);
			    Player(playerid, player_dark) = dark_none;
			}
			if(Game(game_started))
				PlayerTextDrawShow(playerid, Player(playerid, player_td_wyniki));
		    FadeColorForPlayer(playerid, 0, 0, 0, 255, 0, 0, 0, 0, 15, 0); // Rozjaśnienie
		}
		case dark_start2:
		{
			ShowPlayerTeam(playerid);
		}
	}
	return 1;
}

FuncPub::TimerCameraChange(playerid)
{
	#if Debug
	    printf("TimerCameraChange(%d)", playerid);
	#endif
	FadeColorForPlayer(playerid, 0, 0, 0, 0, 0, 0, 0, 255, 15, 0); // Ściemnienie
	Player(playerid, player_dark) = dark_camera;
	return 1;
}

FuncPub::OnPlayerCameraChange(playerid)
{
	#if Debug
	    printf("OnPlayerCameraChange(%d)", playerid);
	#endif
	new string[ 100 ],
  		Float:pos[ 3 ],
  		Float:rpos[ 3 ];

    format(string, sizeof string,
		"SELECT * FROM `mini_cams` WHERE `uid` != '%d' ORDER BY RAND() LIMIT 1",
		Player(playerid, player_cam)
	);
    mysql_query(string);
	mysql_store_result();
 	mysql_fetch_row_format(string);
 	
 	sscanf(string, "p<|>da<f>[3]a<f>[3]",
 	    Player(playerid, player_cam),
	 	pos,
	 	rpos
	);
	mysql_free_result();

 	SetPlayerCameraPos(playerid, pos[ 0 ], pos[ 1 ], pos[ 2 ]);
	SetPlayerCameraLookAt(playerid, rpos[ 0 ], rpos[ 1 ], rpos[ 2 ]);
	SetPlayerPos(playerid, pos[ 0 ], pos[ 1 ], pos[ 2 ] + 20.0);
	return 1;
}

FuncPub::OnPlayerLoginOut(playerid)
{
	new string[ 512 ];
	format(string, sizeof string,
		"UPDATE `mini_players` SET `cash` = '%d', `kills` = '%d', `death` = '%d', `afk` = '%d', `veh_dist` = '%.2f', `visits` = '%d', `timehere` = '%d', `achiv` = '%d', `premium_option` = '%d', `exp` = '%d', `lvl` = '%d', `lastlogged` = UNIX_TIMESTAMP() WHERE `uid` = '%d'",
		Player(playerid, player_cash),
		Player(playerid, player_kills),
		Player(playerid, player_deaths),
		Player(playerid, player_afktime)[ 1 ],
		Player(playerid, player_veh_dist),
		Player(playerid, player_visits),
		Player(playerid, player_timehere)[ 0 ],
		Player(playerid, player_achiv),
		Player(playerid, player_premium_option),
		Player(playerid, player_exp),
		Player(playerid, player_lvl),
		Player(playerid, player_uid)
	);
	mysql_query(string);
	
	if(Player(playerid, player_play) && Player(playerid, player_ready))
	{
		Game(game_players)--;
		mysql_query("UPDATE `mini_info` SET `played` = `played` - 1");
	}
	format(string, sizeof string,
		"DELETE FROM `all_online` WHERE `player` = '%d' AND `ID` = '%d' AND `type` = '"#type_mini"'",
		Player(playerid, player_uid),
		playerid
	);
	mysql_query(string);

	for(new eLang:i; i < eLang; i++)
	    Lang(playerid, i) = 0;
	    
	for(new eKlan:i; i < eKlan; i++)
	    Klan(playerid, i) = 0;
	
    for(new ePlayers:i; i < ePlayers; i++)
    	Player(playerid, i) = 0;
    ClearData(playerid);
	return 1;
}

FuncPub::OnPlayerLoginIn(playerid, pl_uid)
{
	#if Debug
	    printf("OnPlayerLoginIn(%d, %d)", playerid, pl_uid);
	#endif
	
	new string[ 256 ],
		pl_name[ MAX_PLAYER_NAME ],
		pl_lastlogged,
		premium;
	if(Player(playerid, player_guid) == -1)
		format(string, sizeof string,
			"SELECT * FROM `mini_players` WHERE `uid` = '%d' LIMIT 1",
			pl_uid
		);
	else
		format(string, sizeof string,
			"SELECT * FROM `mini_players` WHERE `uid` = '%d' AND `guid` = '%d' LIMIT 1",
			pl_uid,
			Player(playerid, player_guid)
		);
	mysql_query(string);
    mysql_store_result();
    if(!mysql_num_rows())
    {
        SetTimerEx (!#kickPlayer, 249, false, !"i", playerid);
    	mysql_free_result();
    	return 1;
    }
    mysql_fetch_row_format(string);
    sscanf(string, "p<|>dds[24]{s[64]}ddddddddddddfddddddd",
        Player(playerid, player_guid),
        Player(playerid, player_uid),
		pl_name,
		Player(playerid, player_lvl),
		Player(playerid, player_exp),
		Player(playerid, player_skin),
		premium,
		Player(playerid, player_cash),
		Player(playerid, player_block),
		Player(playerid, player_kills),
		Player(playerid, player_deaths),
		Player(playerid, player_option),
		Player(playerid, player_premium_option),
		Player(playerid, player_adminlvl),
		Player(playerid, player_afktime)[ 1 ],
		Player(playerid, player_veh_dist),
        Player(playerid, player_visits),
        Player(playerid, player_timehere)[ 0 ],
        Player(playerid, player_achiv),
		Klan(playerid, klan_uid),
		Klan(playerid, klan_rank),
		Player(playerid, player_lang),
		pl_lastlogged
	);

	mysql_free_result();

	if(Player(playerid, player_block) & block_ban)
	    return SetTimerEx (!#kickPlayer, 249, false, !"i", playerid);
	    
	SetPlayerName(playerid, pl_name);
	GivePlayerMoney(playerid, Player(playerid, player_cash));
	KillTimer(Player(playerid, player_cam_timer));
	
	if(Player(playerid, player_adminlvl) > sizeof AdminLvl-1) Player(playerid, player_adminlvl) = sizeof AdminLvl-1;

	Player(playerid, player_logged)	= true;
	Player(playerid, player_visits)++;
	Player(playerid, player_color) = player_nick_def;
	
	LoadPlayerTextDraws(playerid);
	LoadKlan(playerid);
	ChangeLang(playerid, Player(playerid, player_lang));
//	LoadIcons(playerid);

	#if STREAMER
	if(Player(playerid, player_tag)[ playerid ] == Text3D:INVALID_3DTEXT_ID)
 	#else
 	if(Player(playerid, player_tag)[ playerid ] == PlayerText3D:INVALID_3DTEXT_ID)
    #endif
    {
		new nametag[ MAX_PLAYER_NAME + 4 ];
        foreach(Character, i)
        {
			format(nametag, sizeof nametag, "%s (%d)", NickName(i), i);
			
			#if STREAMER
				Player(playerid, player_tag)[ i ] = CreateDynamic3DTextLabel(nametag, Player(i, player_color), 0.0, 0.0, 0.17, 14.0, i, INVALID_VEHICLE_ID, 1, .playerid = playerid);

	            if(Player(i, player_tag)[ playerid ] == Text3D:INVALID_3DTEXT_ID)
					Player(i, player_tag)[ playerid ] = CreateDynamic3DTextLabel(nametag, Player(playerid, player_color), 0.0, 0.0, 0.17, 14.0, playerid, INVALID_VEHICLE_ID, 1, .playerid = i);
			#else
				Player(playerid, player_tag)[ i ] = CreatePlayer3DTextLabel(playerid, nametag, Player(i, player_color), 0.0, 0.0, 0.17, 14.0, i, INVALID_VEHICLE_ID, 1);

	            if(Player(i, player_tag)[ playerid ] == PlayerText3D:INVALID_3DTEXT_ID)
					Player(i, player_tag)[ playerid ] = CreatePlayer3DTextLabel(i, nametag, Player(playerid, player_color), 0.0, 0.0, 0.17, 14.0, playerid, INVALID_VEHICLE_ID, 1);
			#endif
			UpdatePlayerNick(i);
		}
	}
	LoadPlayerFriends(playerid);

	format(string, sizeof string,
		"INSERT INTO `all_online` VALUES ('"#type_mini"', '%d', '%d', UNIX_TIMESTAMP())",
		Player(playerid, player_uid),
		playerid
	);
	mysql_query(string);
	
	if(Player(playerid, player_guid) == -1)
		set(string, Lang(playerid, lang_login_nglob));
	else
		set(string, Lang(playerid, lang_login_glob));
	Chat::Output(playerid, CLR_WHITE, string);
	GameTextForPlayer(playerid, Lang(playerid, lang_logged), 3000, 1);

    if(premium && Player(playerid, player_guid) == -1)
		Player(playerid, player_premium) = premium;

	if(gettime() < Player(playerid, player_premium))
	{
	    Chat::Output(playerid, CLR_YELLOW, Lang(playerid, lang_premium));
	    
	    Player(playerid, player_color) = player_nick_prem;
	    UpdatePlayerNick(playerid);
	    
	    if((Player(playerid, player_premium) - gettime()) < (24 * 60 * 60))
	        Player(playerid, player_premium_timer) = SetTimerEx("Un_Premium", (Player(playerid, player_premium) - gettime()) * 1000, false, "d", playerid);
	}
	else if(Player(playerid, player_premium))
	{
	    Chat::Output(playerid, CLR_YELLOW, Lang(playerid, lang_premium_end));
	    
		Player(playerid, player_premium_option) = prem_option_none;
		Player(playerid, player_premium) = 0;
		if(Player(playerid, player_guid) == -1)
		    format(string, sizeof string,
		        "UPDATE `mini_players` SET `premium` = '0', `prem_option` = '0' WHERE `uid` = '%d'",
		        Player(playerid, player_guid)
			);
		else
	    #if Forum
	 		format(string, sizeof string,
		        "UPDATE `"IN_PREF"members` SET `premium` = '0' WHERE `member_id` = '%d'",
		        Player(playerid, player_guid)
			);
 		#else
	 		format(string, sizeof string,
		        "UPDATE `"IN_PREF"users` SET `premium` = '0' WHERE `uid` = '%d'",
		        Player(playerid, player_guid)
			);
 		#endif
		mysql_query(string);
	}

	SetSpawnInfo(playerid, NO_TEAM, Player(playerid, player_skin), Setting(setting_pos)[ 0 ], Setting(setting_pos)[ 1 ], Setting(setting_pos)[ 2 ], Setting(setting_pos)[ 3 ], 0, 0, 0, 0, 0, 0);

	FadeColorForPlayer(playerid, 0, 0, 0, 0, 0, 0, 0, 255, 15, 0); // Ściemnienie
	Player(playerid, player_dark) = dark_spawn;
	return 1;
}

FuncPub::Un_Premium(playerid)
{
    Chat::Output(playerid, CLR_YELLOW, Lang(playerid, lang_premium_end));
    
    if(!Player(playerid, player_screen))
    	Player(playerid, player_color) = player_nick_def;
    UpdatePlayerNick(playerid);
    Player(playerid, player_premium) = 0;
    Player(playerid, player_premium_option) = prem_option_none;
    
    if(Player(playerid, player_neon_object)[ 0 ] != INVALID_OBJECT_ID)
    {
        DestroyObject(Player(playerid, player_neon_object)[ 0 ]);
        Player(playerid, player_neon_object)[ 0 ] = INVALID_OBJECT_ID;
	}
    if(Player(playerid, player_neon_object)[ 1 ] != INVALID_OBJECT_ID)
    {
        DestroyObject(Player(playerid, player_neon_object)[ 1 ]);
        Player(playerid, player_neon_object)[ 1 ] = INVALID_OBJECT_ID;
	}
	return 1;
}

FuncPub::EndGame()
{
	new count = GetTickCount(),
		cnt = 0;
    print("\t## Rozpoczynam czyszczenie po grze!");
	for(new carid; carid < MAX_VEHICLES; carid++)
	{
	    if(!Vehicle(carid, vehicle_carid)) continue;
	    
	    DestroyVehicle(Vehicle(carid, vehicle_carid));
	    for(new eVehicles:i; i < eVehicles; i++)
    		Vehicle(carid, i) = 0;
    	cnt++;
	}
    if(cnt)
    	printf("\t# %d | Pojazdy skasowane - pomyślnie!", cnt);
	cnt = 0;
    #if STREAMER
		for(new num; num < Streamer_GetUpperBound(STREAMER_TYPE_OBJECT); num++)
	    {
			if(!IsValidDynamicObject(num)) continue;
	    	if(Streamer_IsInArrayData(STREAMER_TYPE_OBJECT, num, E_STREAMER_WORLD_ID, 0)) continue;

		    new c;
			for(; c < MAX_OBJECTS; c++)
			    if(Object(c, obj_objID) == num)
			        break;
	        if(c != MAX_OBJECTS)
	        {
	            for(new eObjects:i; i < eObjects; i++)
					Object(c, i) = 0;
				Object(c, obj_objID) = INVALID_OBJECT_ID;
			}
			DestroyDynamicObject(num);
			cnt++;
		}
    #else
		for(new objid; objid < MAX_OBJECTS; objid++)
		{
		    if(!Object(objid, obj_objID)) continue;

		    DestroyObject(Object(objid, obj_objID));
		    for(new eObjects:i; i < eObjects; i++)
	    		Object(objid, i) = 0;
            cnt++;
		}
	#endif
 	if(cnt)
	    printf("\t# %d | Obiekty skasowane - pomyślnie!", cnt);
	cnt = 0;
	for(new teamid; teamid < MAX_TEAM; teamid++)
	{
		if(Team(teamid, team_spawn_pos_x)[ 0 ] == 0.0 && Team(teamid, team_spawn_pos_y)[ 0 ] == 0.0 && Team(teamid, team_spawn_pos_z)[ 0 ] == 0.0)
			continue;
		
	    for(new eTeam:i; i < eTeam; i++)
    		Team(teamid, i) = 0;
        cnt++;
	}
 	if(cnt)
    	printf("\t# %d | Teamy skasowane - pomyślnie!", cnt);
	cnt = 0;
	
    for(new raceid; raceid < MAX_CHECKPOINT; raceid++)
    {
        if(!Race(raceid, race_uid)) continue;
        
        for(new eRace:i; i < eRace; i++)
            Race(raceid, i) = 0;
        cnt++;
    }
    if(cnt)
    	printf("\t# %d | Checkpointy skasowane - pomyślnie!", cnt);
	cnt = 0;
    
    for(new pickid; pickid < MAX_PICKUPS; pickid++)
    {
        if(!Pickup(pickid, pick_uid)) continue;
        if(Pickup(pickid, pick_game) == INVALID_GAME_ID) continue;
//        if(Pickup(pickid, pick_func) != pick_func_weapon) continue;
        
        #if STREAMER
            DestroyDynamicPickup(Pickup(pickid, pick_pickID));
            foreach(Player, i) UnLoadPickupTextDraw(i);
        #else
        	DestroyPickup(Pickup(pickid, pick_pickID));
        	if(Pickup(pickid, pick_textID) != Text3D:INVALID_3DTEXT_ID)
				Delete3DTextLabel(Pickup(pickid, pick_textID));
        #endif
        
        for(new ePickup:i; i < ePickup; i++)
            Pickup(pickid, i) = 0;
        #if !STREAMER
        	Pickup(pickid, pick_textID) = Text3D:INVALID_3DTEXT_ID;
        #endif
        cnt++;
    }
    if(cnt)
    	printf("\t# %d | Pickupy skasowane - pomyślnie!", cnt);
	cnt = 0;
	
	for(new map; map < MAX_MAPICON; map++)
    {
        if(!Map(map, map_ID)) continue;
        
        DestroyDynamicMapIcon(Map(map, map_ID));
        
        for(new eMapIcon:i; i < eMapIcon; i++)
 			Map(map, i) = 0;
		cnt++;
    }
    if(cnt)
    	printf("\t# %d | MapIcons skasowane - pomyślnie!", cnt);
	cnt = 0;

	for(new textid; textid < MAX_3DTEXT; textid++)
    {
        if(!Text(textid, text_uid)) continue;
        if(Text(textid, text_game) == INVALID_GAME_ID) continue;

        if(Text(textid, text_textID) != Text3D:INVALID_3DTEXT_ID)
			Delete3DTextLabel(Text(textid, text_textID));
		#if bots
		    if(Text(textid, text_botID) != INVALID_PLAYER_ID)
		    {
				Kick(Text(textid, text_botID));
		    }
		#endif

        for(new eText:i; i < eText; i++)
        	Text(textid, i) = 0;
        Text(textid, text_textID) = Text3D:INVALID_3DTEXT_ID;
        #if bots
        	Text(textid, text_botID) = INVALID_PLAYER_ID;
        #endif
        cnt++;
	}
	if(cnt)
    	printf("\t# %d | 3DTeksty skasowane - pomyślnie!", cnt);
	cnt = 0;
    
    new t = Game(game_time);
    for(new eGame:i; i < eGame; i++)
		Game(i) = 0;
	Game(game_time) = t;

	Setting(setting_lgame) = Setting(setting_game);
	Setting(setting_game) = INVALID_GAME_ID;
	
	new string[ 126 ];
	if(Setting(setting_next) == INVALID_GAME_ID)
	    format(string, sizeof string,
			"SELECT `uid`, `name`, `min` FROM `mini_game` WHERE `uid` != '%d' AND `active` = '1' ORDER BY RAND() LIMIT 1",
	        Setting(setting_lgame)
		);
	else
	    format(string, sizeof string,
			"SELECT `uid`, `name`, `min` FROM `mini_game` WHERE `uid` = '%d'",
	        Setting(setting_next)
		);
	mysql_query(string);
	mysql_store_result();
	mysql_fetch_row(string);
    sscanf(string, "p<|>ds[32]d",
		Setting(setting_next),
		Game(game_name),
		Game(game_minimum)
	);
    mysql_free_result();
    printf("\t# Wylosowano następną grę | %d(%s)", Setting(setting_next), Game(game_name));
	format(string, sizeof string, "Next: %s", Game(game_name));
	TextDrawSetString(Setting(setting_td_game_name), string);
	
	new Float:czas = floatdiv(GetTickCount() - count, 1000);
	printf("\t## Czyszczenie po grze wykonane - pomyślnie! | Czas wykonywania: %.2f %s",
		czas,
		dli(floatval(czas), "sekunde", "sekundy", "sekund")
	);
	return 1;
}

FuncPub::LoadRandomGame()
{
	new count = GetTickCount();
	print("\t## Rozpoczynam wczytywanie losowej gry!");
	new string[ 256 ],
		carid = 1,
		hour;

	if(Setting(setting_next) == INVALID_GAME_ID)
	    format(string, sizeof string,
			"SELECT * FROM `mini_game` WHERE `uid` != '%d' AND `active` = '1' ORDER BY RAND() LIMIT 1",
	        Setting(setting_lgame)
		);
	else
	    format(string, sizeof string,
			"SELECT * FROM `mini_game` WHERE `uid` = '%d' LIMIT 1",
	        Setting(setting_next)
		);
	mysql_query(string);
	mysql_store_result();
	mysql_fetch_row(string);
	sscanf(string, "p<|>ds[32]ddfddd{a<s[32]>[2]dd}da<f>[4]a<f>[3]a<f>[6]da<d>[4]{dfd}s[126]",
	    Setting(setting_game),
	    Game(game_name),
	    Game(game_time),
	    Game(game_minimum),
	    Game(game_hp),
	    Game(game_typ),
	    Setting(setting_weather),
	    hour,
	    Game(game_model),
	    Vehicle(carid, vehicle_pos),
	    Game(game_marker_pos),
	    Game(game_camera),
	    Game(game_camera_int),
	    Game(game_weapon),
	    Game(game_sound)
	);
	mysql_free_result();
	SetWorldTime(hour);
	format(string, sizeof string, "Map: %s", Game(game_name));
	TextDrawSetString(Setting(setting_td_game_name), string);
	
	format(string, sizeof string, "UPDATE `mini_info` SET `map` = '%d'", Setting(setting_game));
	mysql_query(string);
	
	format(string, sizeof string, "mapname %s", Game(game_name));
	SendRconCommand(string);
	
	printf("\t# Ustawienia wczytane - pomyślnie! | %d(%s -> %s)", Setting(setting_game), Game(game_name), GameName[ Game(game_typ) ][ 1 ]);
	
	if(Game(game_typ) == game_type_vehicle)
	{
	    new color = random(120);
	    Vehicle(carid, vehicle_model) = Game(game_model);
    	Vehicle(carid, vehicle_carid) = Game(game_vehID) = CreateVehicle(Vehicle(carid, vehicle_model), Vehicle(carid, vehicle_pos)[ 0 ], Vehicle(carid, vehicle_pos)[ 1 ], Vehicle(carid, vehicle_pos)[ 2 ], Vehicle(carid, vehicle_pos)[ 3 ], color, color, 60);
    	SetVehicleVirtualWorld(Vehicle(carid, vehicle_carid), Setting(setting_game));
		OnVehicleSpawn(carid);
		carid++;
	}
	if(Game(game_typ) == game_type_tdm || Game(game_typ) == game_type_vehicle || Game(game_typ) == game_type_bomb)
	{
		format(string, sizeof string,
		    "SELECT `name1`, `name2`, `c1`, `c2` FROM `mini_game` WHERE `uid` = '%d'",
		    Setting(setting_game)
		);
		mysql_query(string);
		mysql_store_result();
		mysql_fetch_row(string);
		sscanf(string, "p<|>s[32]s[32]dd",
		    Team(team_red, team_name),
		    Team(team_blue, team_name),
		    Team(team_red, team_color),
		    Team(team_blue, team_color)
		);
		TextDrawBoxColor(Setting(setting_td_time)[ 2 ], CarColHex[ Team(team_blue, team_color) ]);
		TextDrawBoxColor(Setting(setting_td_time)[ 0 ], CarColHex[ Team(team_red, team_color) ]);
		mysql_free_result();
		printf("\t# Nazwy teamów wczytane - pomyślnie | %s/%s", Team(team_red, team_name), Team(team_blue, team_name));
	}
	if(Game(game_typ) == game_type_race)
	{
	    format(string, sizeof string,
	        "SELECT * FROM `mini_race` WHERE `gameuid` = '%d'",
	        Setting(setting_game)
		);
		mysql_query(string);
		mysql_store_result();
		while(mysql_fetch_row(string))
		{
		    if(Game(game_race_max) == MAX_CHECKPOINT) break;
		    
		    sscanf(string, "p<|>d{d}a<f>[3]",
		    	Race(Game(game_race_max), race_uid),
		    	Race(Game(game_race_max), race_pos)
		    );
		    
		    Game(game_race_max)++;
		}
		mysql_free_result();
		printf("\t# Checkpointy wczytane - pomyślnie | %d", Game(game_race_max));
	}

	format(string, sizeof string,
		"SELECT * FROM `mini_spawns` WHERE `gameuid` = '%d'",
		Setting(setting_game)
	);
	mysql_query(string);
	mysql_store_result();
	if(mysql_num_rows())
	{
		while(mysql_fetch_row(string))
		{
		    static teamid;
		    sscanf(string, "p<|>{dd}d", teamid);
		    if(Team(teamid, team_spawn_max) == MAX_SPAWN) continue;

			sscanf(string, "p<|>{ddd}ffffd",
			    Team(teamid, team_spawn_pos_x)[ Team(teamid, team_spawn_max) ],
			    Team(teamid, team_spawn_pos_y)[ Team(teamid, team_spawn_max) ],
			    Team(teamid, team_spawn_pos_z)[ Team(teamid, team_spawn_max) ],
			    Team(teamid, team_spawn_pos_a)[ Team(teamid, team_spawn_max) ],
			    Team(teamid, team_spawn_int)[ Team(teamid, team_spawn_max) ]
			);
			Team(teamid, team_spawn_max)++;
		}
		printf("\t# Spawny wczytane - pomyślnie! | %d/%d/%d", Team(team_none, team_spawn_max), Team(team_red, team_spawn_max), Team(team_blue, team_spawn_max));
	}
	else
	{
		print("\t# Brak spawnów do wczytania!");
	    new Float:czas = floatdiv(GetTickCount() - count, 1000);
		printf("\t## Losowa gra wczytana - NIE pomyślnie! | Czas wykonywania: %.2f %s",
			czas,
			dli(floatval(czas), "sekunde", "sekundy", "sekund")
		);
		new uid = Setting(setting_game);
   	    EndGame();
   	    Setting(setting_lgame) = uid;
   	    Setting(setting_next) = INVALID_GAME_ID;
   	    LoadRandomGame();
		return 1;
	}
	mysql_free_result();

	format(string, sizeof string,
	    "SELECT * FROM `mini_vehicles` WHERE `gameuid` = '%d'",
	    Setting(setting_game)
	);
	mysql_query(string);
	mysql_store_result();
	if(mysql_num_rows())
	{
		while(mysql_fetch_row(string))
		{
		    if(carid == MAX_VEHICLES) break;

		    static color;

			sscanf(string, "p<|>d{d}dda<f>[4]",
			    Vehicle(carid, vehicle_uid),
			    Vehicle(carid, vehicle_team),
			    Vehicle(carid, vehicle_model),
			    Vehicle(carid, vehicle_pos)
			);
			if(Vehicle(carid, vehicle_team) == team_red) color = Team(team_red, team_color);
			else if(Vehicle(carid, vehicle_team) == team_blue) color = Team(team_blue, team_color);
			else color = random(120);

			Vehicle(carid, vehicle_carid) = CreateVehicle(Vehicle(carid, vehicle_model), Vehicle(carid, vehicle_pos)[ 0 ], Vehicle(carid, vehicle_pos)[ 1 ], Vehicle(carid, vehicle_pos)[ 2 ], Vehicle(carid, vehicle_pos)[ 3 ], color, color, 60);
			SetVehicleVirtualWorld(Vehicle(carid, vehicle_carid), Setting(setting_game));
			OnVehicleSpawn(carid);
			carid++;
		}
		printf("\t# Pojazdy wczytane - pomyślnie! | %d", carid-1);
	}
	else print("\t# Brak pojazdów do wczytania!");
	mysql_free_result();
	
	LoadObjects(Setting(setting_game));
	LoadPickups(Setting(setting_game));
	LoadText(Setting(setting_game));
	
	new idx = 2;
	for(new t = 1; t < MAX_3DTEXT; t++)
	{
	    if(!Text(t, text_uid)) continue;
	    if(Text(t, text_game) != Setting(setting_game)) continue;
	    SetTimerEx("UpdateText", idx * 1000, false, "d", t);
	    idx++;
	}
    
	new Float:czas = floatdiv(GetTickCount() - count, 1000);
	printf("\t## Losowa gra wczytana - pomyślnie! | Czas wykonywania: %.2f %s",
		czas,
		dli(floatval(czas), "sekunde", "sekundy", "sekund")
	);

   	foreach(Player, i)
   	{
   	    if(Player(i, player_ready))
   	    {
			FadeColorForPlayer(i, 0, 0, 0, 0, 0, 0, 0, 255, 15, 0); // Ściemnienie
			Player(i, player_dark) = dark_start;
   	    }
	   	SendClientMessage(i, -1, Lang(i, lang_game_started));
   	}
	Setting(setting_timer_game) = SetTimer("Odliczanie", 1000, false);
   	Game(game_countdown) = 20;
   	Setting(setting_next) = INVALID_GAME_ID;
	return 1;
}

FuncPub::Odliczanie()
{
    Game(game_countdown)--;
    KillTimer(Setting(setting_timer_game));
   	foreach(Player, i)
   	{
   	    if(Player(i, player_play))
   	    {
			switch(Game(game_countdown))
			{
			    case 4:
			    {
			        HideTD(i);
			        LoadPickupTextDraw(i);
					if(Player(i, player_option) & option_fp)
					{
					    DestroyObject(Player(i, player_fp_object));
						Player(i, player_fp_object) = CreateObject(i, 19300, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
						AttachObjectToPlayer(Player(i, player_fp_object), i, 0.0, 0.15, 0.65, 0.0, 0.0, 0.0);
						AttachCameraToObject(i, Player(i, player_fp_object));
					}
					else SetCameraBehindPlayer(i);
			    }
			    case 3:
			    {
				   	GameTextForPlayer(i, "~b~3..", 3000, 3);
				   	PlayerPlaySound(i, 1056, 0, 0, 0);
				   	if(Game(game_typ) == game_type_race)
				   	    SetVehicleParamsEx(Player(i, player_vehicle), 1, 0, 0, 0, 0, 0, 0);
				   	    
				   	if(Game(game_typ) == game_type_hay)
				   		Game(game_idx) = 5;

					if(Game(game_typ) == game_type_bomb)
					    SetPlayerCheckpoint(i, Game(game_marker_pos)[ 0 ], Game(game_marker_pos)[ 1 ], Game(game_marker_pos)[ 2 ], 3.0);
			    }
			    case 2:
			    {
				   	GameTextForPlayer(i, "~r~2..", 3000, 3);
				   	PlayerPlaySound(i, 1056, 0, 0, 0);
				   	if(Game(game_typ) == game_type_race)
				   	    SetVehicleParamsEx(Player(i, player_vehicle), 1, 1, 0, 0, 0, 0, 0);
			    }
			    case 1:
			    {
				   	GameTextForPlayer(i, "~y~1..", 3000, 3);
				   	PlayerPlaySound(i, 1056, 0, 0, 0);
			    }
			    case 0:
			    {
					PlayerTextDrawShow(i, Player(i, player_td_wyniki));
					HideTD(i);
				   	GameTextForPlayer(i, Lang(i, lang_start), 3000, 3);
				   	PlayerPlaySound(i, 1057, 0, 0, 0);
				   	UnFreeze(i);
			    }
			}
   	    }
	}
	if(!Game(game_countdown))
	{
	    new string[ 90 ];
		format(string, sizeof string,
		    "UPDATE `mini_game` SET `visits` = `visits` + 1 WHERE `uid` = '%d'",
		    Setting(setting_game)
		);
		mysql_query(string);
		Game(game_time_start) = GetTickCount();
		Game(game_started) = true;
		Setting(setting_timer_game) = 0;
		print("# Game started!");
	}
	else
		Setting(setting_timer_game) = SetTimer("Odliczanie", 1000, false);
	return 1;
}

FuncPub::UnFreeze(playerid)
{
	UnFreezePlayer(playerid);
	if(Game(game_typ) == game_type_race)
	{
	    if(Game(game_race_max) == Player(playerid, player_race)+1)
		{
		    SetPlayerRaceCheckpoint(playerid, 1,
				Race(Player(playerid, player_race), race_pos)[ 0 ],
				Race(Player(playerid, player_race), race_pos)[ 1 ],
				Race(Player(playerid, player_race), race_pos)[ 2 ],
				Race(Player(playerid, player_race)+1, race_pos)[ 0 ],
				Race(Player(playerid, player_race)+1, race_pos)[ 1 ],
				Race(Player(playerid, player_race)+1, race_pos)[ 2 ],
			10);
		}
		else
		{
		    SetPlayerRaceCheckpoint(playerid, 0,
				Race(Player(playerid, player_race), race_pos)[ 0 ],
				Race(Player(playerid, player_race), race_pos)[ 1 ],
				Race(Player(playerid, player_race), race_pos)[ 2 ],
				Race(Player(playerid, player_race)+1, race_pos)[ 0 ],
				Race(Player(playerid, player_race)+1, race_pos)[ 1 ],
				Race(Player(playerid, player_race)+1, race_pos)[ 2 ],
			10);
		}
	}
	return 1;
}

FuncPub::ShowPlayerTeam(playerid)
{
    Dialog::Output(playerid, 4, DIALOG_STYLE_MSGBOX, IN_HEAD, "Wybierz team!", Team(team_red, team_name), Team(team_blue, team_name));
	return 1;
}

FuncPub::ChangeLang(playerid, lang)
{
	switch(lang)
	{
	    case lang_eng:
		{
			#include "lang/eng.pwn"
		}
	    case lang_de:
		{
			#include "lang/de.pwn"
		}
	    default:
		{
			#include "lang/pl.pwn"
		}
	}
	return 1;
}
