stock SPD(playerid, dialogid, style, caption[], info[], button1[], button2[])
{
	Player(playerid, player_dialog) = (dialogid == -1) ? cellmin : dialogid;
	return Dialog::Output(playerid, dialogid, style, caption, info, button1, button2);
}
#define ShowPlayerDialog SPD

stock OnDialogResponseEx(playerid, dialogid, response, listitem, inputtext[])
{
	Player(playerid, player_dialog) = (dialogid == -1) ? cellmin : dialogid;
	return OnDialogResponse(playerid, dialogid, response, listitem, inputtext);
}

FuncPub::kickPlayer(playerid)
{
	TextDrawHideForPlayer(playerid, Setting(setting_td_box)[ 0 ]);
	TextDrawHideForPlayer(playerid, Setting(setting_td_box)[ 1 ]);
	
	FadeColorForPlayer(playerid, 0, 0, 0, 0, 0, 0, 0, 255, 15, 0); // Œciemnienie
	Player(playerid, player_dark) = dark_kick;
	return 1;
}

FuncPub::LoadSetting()
{
	new string[ 126 ];
	mysql_query("SELECT * FROM `mini_setting` LIMIT 1");
	mysql_store_result();
	mysql_fetch_row(string);
	sscanf(string, "p<|>{d}a<f>[4]ds[64]",
	    Setting(setting_pos),
		Setting(setting_int),
		Setting(setting_url)
	);
	mysql_free_result();
	
	SetWeather(Setting(setting_weather) = 1);
	SetWorldTime(12);
	
    Audio_DestroyTCPServer();
    Audio_CreateTCPServer(GetServerVarAsInt("port"));
    Audio_SetPack("mini");
    print("# Ustawienia wczytane.");
	return 1;
}

FuncPub::LoadPlayerTextDraws(playerid)
{
	Player(playerid, player_td_celownik)[ 0 ] = CreatePlayerTextDraw(playerid, 322.000000, 172.000000, "> <");
	PlayerTextDrawBackgroundColor(playerid, Player(playerid, player_td_celownik)[ 0 ], 255);
	PlayerTextDrawFont(playerid, Player(playerid, player_td_celownik)[ 0 ], 1);
	PlayerTextDrawLetterSize(playerid, Player(playerid, player_td_celownik)[ 0 ], 0.559999, 1.600000);
	PlayerTextDrawColor(playerid, Player(playerid, player_td_celownik)[ 0 ], -1);
	PlayerTextDrawSetOutline(playerid, Player(playerid, player_td_celownik)[ 0 ], 0);
	PlayerTextDrawSetProportional(playerid, Player(playerid, player_td_celownik)[ 0 ], 1);
	PlayerTextDrawSetShadow(playerid, Player(playerid, player_td_celownik)[ 0 ], 1);

	Player(playerid, player_td_celownik)[ 1 ] = CreatePlayerTextDraw(playerid, 332.000000, 165.000000, "\\/~n~~n~/\\");
	PlayerTextDrawBackgroundColor(playerid, Player(playerid, player_td_celownik)[ 1 ], 255);
	PlayerTextDrawFont(playerid, Player(playerid, player_td_celownik)[ 1 ], 1);
	PlayerTextDrawLetterSize(playerid, Player(playerid, player_td_celownik)[ 1 ], 0.529999, 1.000000);
	PlayerTextDrawColor(playerid, Player(playerid, player_td_celownik)[ 1 ], -1);
	PlayerTextDrawSetOutline(playerid, Player(playerid, player_td_celownik)[ 1 ], 0);
	PlayerTextDrawSetProportional(playerid, Player(playerid, player_td_celownik)[ 1 ], 1);
	PlayerTextDrawSetShadow(playerid, Player(playerid, player_td_celownik)[ 1 ], 1);

	Player(playerid, player_td_respawn) = CreatePlayerTextDraw(playerid, 317.000000, 80.000000, "Odrodzenie za: 5 sekund");
	PlayerTextDrawAlignment(playerid, Player(playerid, player_td_respawn), 2);
	PlayerTextDrawBackgroundColor(playerid, Player(playerid, player_td_respawn), 255);
	PlayerTextDrawFont(playerid, Player(playerid, player_td_respawn), 1);
	PlayerTextDrawLetterSize(playerid, Player(playerid, player_td_respawn), 0.370000, 1.600000);
	PlayerTextDrawColor(playerid, Player(playerid, player_td_respawn), -1);
	PlayerTextDrawSetOutline(playerid, Player(playerid, player_td_respawn), 1);
	PlayerTextDrawSetProportional(playerid, Player(playerid, player_td_respawn), 1);
	
	Player(playerid, player_td_wyniki) = CreatePlayerTextDraw(playerid, 500.000000,392.000000, "Loading..");
	PlayerTextDrawUseBox(playerid, Player(playerid, player_td_wyniki), 1);
	PlayerTextDrawBoxColor(playerid, Player(playerid, player_td_wyniki), 25);
	PlayerTextDrawTextSize(playerid, Player(playerid, player_td_wyniki), 636.000000,4.000000);
	PlayerTextDrawAlignment(playerid, Player(playerid, player_td_wyniki), 0);
	PlayerTextDrawBackgroundColor(playerid, Player(playerid, player_td_wyniki), 0x000000ff);
	PlayerTextDrawFont(playerid, Player(playerid, player_td_wyniki), 1);
	PlayerTextDrawLetterSize(playerid, Player(playerid, player_td_wyniki), 0.299999,1.000000);
	PlayerTextDrawColor(playerid, Player(playerid, player_td_wyniki), 0xffffffff);
	PlayerTextDrawSetOutline(playerid, Player(playerid, player_td_wyniki), 1);
	PlayerTextDrawSetProportional(playerid, Player(playerid, player_td_wyniki), 1);
	PlayerTextDrawSetShadow(playerid, Player(playerid, player_td_wyniki), 1);
	
	Player(playerid, player_td_friend) = CreatePlayerTextDraw(playerid, 548.000000, 29.000000, "~y~~h~Nick Name~n~~w~dolaczyl do gry!");
	PlayerTextDrawBackgroundColor(playerid, Player(playerid, player_td_friend), 255);
	PlayerTextDrawFont(playerid, Player(playerid, player_td_friend), 1);
	PlayerTextDrawLetterSize(playerid, Player(playerid, player_td_friend), 0.380000, 1.200000);
	PlayerTextDrawColor(playerid, Player(playerid, player_td_friend), -1);
	PlayerTextDrawSetOutline(playerid, Player(playerid, player_td_friend), 0);
	PlayerTextDrawSetProportional(playerid, Player(playerid, player_td_friend), 1);
	PlayerTextDrawSetShadow(playerid, Player(playerid, player_td_friend), 1);
	PlayerTextDrawUseBox(playerid, Player(playerid, player_td_friend), 1);
	PlayerTextDrawBoxColor(playerid, Player(playerid, player_td_friend), 150);
	PlayerTextDrawTextSize(playerid, Player(playerid, player_td_friend), 642.000000, 0.000000);

	Player(playerid, player_td_record)[ 0 ] = CreatePlayerTextDraw(playerid, 359.000000, 17.000000, "1. CeKa~n~2. Misiek~n~3. Mecca~n~4. Ktos~n~5. Bardzo dlugi nick");
	PlayerTextDrawBackgroundColor(playerid, Player(playerid, player_td_record)[ 0 ], 255);
	PlayerTextDrawFont(playerid, Player(playerid, player_td_record)[ 0 ], 1);
	PlayerTextDrawLetterSize(playerid, Player(playerid, player_td_record)[ 0 ], 0.200000, 1.000000);
	PlayerTextDrawColor(playerid, Player(playerid, player_td_record)[ 0 ], -1);
	PlayerTextDrawSetOutline(playerid, Player(playerid, player_td_record)[ 0 ], 0);
	PlayerTextDrawSetProportional(playerid, Player(playerid, player_td_record)[ 0 ], 1);
	PlayerTextDrawSetShadow(playerid, Player(playerid, player_td_record)[ 0 ], 1);

	Player(playerid, player_td_record)[ 1 ] = CreatePlayerTextDraw(playerid, 490.000000, 17.000000, "22.332");
	PlayerTextDrawAlignment(playerid, Player(playerid, player_td_record)[ 1 ], 3);
	PlayerTextDrawBackgroundColor(playerid, Player(playerid, player_td_record)[ 1 ], 255);
	PlayerTextDrawFont(playerid, Player(playerid, player_td_record)[ 1 ], 1);
	PlayerTextDrawLetterSize(playerid, Player(playerid, player_td_record)[ 1 ], 0.200000, 1.000000);
	PlayerTextDrawColor(playerid, Player(playerid, player_td_record)[ 1 ], -1);
	PlayerTextDrawSetOutline(playerid, Player(playerid, player_td_record)[ 1 ], 0);
	PlayerTextDrawSetProportional(playerid, Player(playerid, player_td_record)[ 1 ], 1);
	PlayerTextDrawSetShadow(playerid, Player(playerid, player_td_record)[ 1 ], 1);
	
	Player(playerid, player_td_shoot) = CreatePlayerTextDraw(playerid, 324.000000, 325.000000, "Strzal w dupe~n~~y~~h~+5 exp");
	PlayerTextDrawAlignment(playerid, Player(playerid, player_td_shoot), 2);
	PlayerTextDrawBackgroundColor(playerid, Player(playerid, player_td_shoot), 255);
	PlayerTextDrawFont(playerid, Player(playerid, player_td_shoot), 1);
	PlayerTextDrawLetterSize(playerid, Player(playerid, player_td_shoot), 0.370000, 1.600000);
	PlayerTextDrawColor(playerid, Player(playerid, player_td_shoot), -1);
	PlayerTextDrawSetOutline(playerid, Player(playerid, player_td_shoot), 1);
	PlayerTextDrawSetProportional(playerid, Player(playerid, player_td_shoot), 1);

	// Achievment
	Player(playerid, player_td_achiv) = CreatePlayerTextDraw(playerid, 522.0, 0.833435, "_");
	PlayerTextDrawLetterSize(playerid, Player(playerid, player_td_achiv), 0.244319, 1.215000);
	PlayerTextDrawTextSize(playerid, Player(playerid, player_td_achiv), 791.801208, 47.250019);
	PlayerTextDrawAlignment(playerid, Player(playerid, player_td_achiv), 1);
	PlayerTextDrawColor(playerid, Player(playerid, player_td_achiv), -1);
	PlayerTextDrawUseBox(playerid, Player(playerid, player_td_achiv), false);
	PlayerTextDrawBoxColor(playerid, Player(playerid, player_td_achiv), 150);
	PlayerTextDrawSetShadow(playerid, Player(playerid, player_td_achiv), 0);
	PlayerTextDrawSetOutline(playerid, Player(playerid, player_td_achiv), 0);
	PlayerTextDrawBackgroundColor(playerid, Player(playerid, player_td_achiv), 51);
	PlayerTextDrawFont(playerid, Player(playerid, player_td_achiv), 1);
	PlayerTextDrawSetProportional(playerid, Player(playerid, player_td_achiv), 1);
	return 1;
}

FuncPub::LoadTextDraws()
{
	// Panoramika przy logowaniu (czarne boxy)
	Setting(setting_td_box)[ 0 ] = TextDrawCreate(320.000000, 337.000000, "~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~");
	TextDrawAlignment(Setting(setting_td_box)[ 0 ], 2);
	TextDrawBackgroundColor(Setting(setting_td_box)[ 0 ], 255);
	TextDrawFont(Setting(setting_td_box)[ 0 ], 0);
	TextDrawLetterSize(Setting(setting_td_box)[ 0 ], 1.000000, 3.300000);
	TextDrawColor(Setting(setting_td_box)[ 0 ], -1);
	TextDrawSetOutline(Setting(setting_td_box)[ 0 ], 0);
	TextDrawSetProportional(Setting(setting_td_box)[ 0 ], 1);
	TextDrawSetShadow(Setting(setting_td_box)[ 0 ], 1);
	TextDrawUseBox(Setting(setting_td_box)[ 0 ], 1);
	TextDrawBoxColor(Setting(setting_td_box)[ 0 ], 255);
	TextDrawTextSize(Setting(setting_td_box)[ 0 ], 0.000000, 640.000000);
	TextDrawSetSelectable(Setting(setting_td_box)[ 0 ], 0);

	Setting(setting_td_box)[ 1 ] = TextDrawCreate(650.000000, 0.000000, "~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~");
	TextDrawBackgroundColor(Setting(setting_td_box)[ 1 ], 255);
	TextDrawFont(Setting(setting_td_box)[ 1 ], 1);
	TextDrawLetterSize(Setting(setting_td_box)[ 1 ], 0.500000, 1.000000);
	TextDrawColor(Setting(setting_td_box)[ 1 ], -1);
	TextDrawSetOutline(Setting(setting_td_box)[ 1 ], 0);
	TextDrawSetProportional(Setting(setting_td_box)[ 1 ], 1);
	TextDrawSetShadow(Setting(setting_td_box)[ 1 ], 1);
	TextDrawUseBox(Setting(setting_td_box)[ 1 ], 1);
	TextDrawBoxColor(Setting(setting_td_box)[ 1 ], 255);
	TextDrawTextSize(Setting(setting_td_box)[ 1 ], -10.000000, 10.000000);
	TextDrawSetSelectable(Setting(setting_td_box)[ 1 ], 0);
	
	// Czas do koñca gry
	Setting(setting_td_time)[ 1 ] = TextDrawCreate(284.000000, 10.000000, "_");
	TextDrawBackgroundColor(Setting(setting_td_time)[ 1 ], 255);
	TextDrawFont(Setting(setting_td_time)[ 1 ], 1);
	TextDrawLetterSize(Setting(setting_td_time)[ 1 ], 0.500000, 1.500000);
	TextDrawColor(Setting(setting_td_time)[ 1 ], -1);
	TextDrawSetOutline(Setting(setting_td_time)[ 1 ], 0);
	TextDrawSetProportional(Setting(setting_td_time)[ 1 ], 1);
	TextDrawSetShadow(Setting(setting_td_time)[ 1 ], 1);
	TextDrawUseBox(Setting(setting_td_time)[ 1 ], 1);
	TextDrawBoxColor(Setting(setting_td_time)[ 1 ], 0xCDCDB5AA);
	TextDrawTextSize(Setting(setting_td_time)[ 1 ], 350.000000, 0.000000);
	
	Setting(setting_td_time)[ 0 ] = TextDrawCreate(317.000000, 11.000000, "1:29");
	TextDrawAlignment(Setting(setting_td_time)[ 0 ], 2);
	TextDrawBackgroundColor(Setting(setting_td_time)[ 0 ], 255);
	TextDrawFont(Setting(setting_td_time)[ 0 ], 3);
	TextDrawLetterSize(Setting(setting_td_time)[ 0 ], 0.439999, 1.299999);
	TextDrawColor(Setting(setting_td_time)[ 0 ], -1);
	TextDrawSetOutline(Setting(setting_td_time)[ 0 ], 1);
	TextDrawSetProportional(Setting(setting_td_time)[ 0 ], 1);
	TextDrawUseBox(Setting(setting_td_time)[ 0 ], 1);
//	TextDrawBoxColor(Setting(setting_td_time)[ 0 ], team_color_red);
	TextDrawTextSize(Setting(setting_td_time)[ 0 ], 353.000000, 64.000000);

	Setting(setting_td_time)[ 2 ] = TextDrawCreate(317.000000, 11.000000, "1:29");
	TextDrawAlignment(Setting(setting_td_time)[ 2 ], 2);
	TextDrawBackgroundColor(Setting(setting_td_time)[ 2 ], 255);
	TextDrawFont(Setting(setting_td_time)[ 2 ], 3);
	TextDrawLetterSize(Setting(setting_td_time)[ 2 ], 0.439999, 1.299999);
	TextDrawColor(Setting(setting_td_time)[ 2 ], -1);
	TextDrawSetOutline(Setting(setting_td_time)[ 2 ], 1);
	TextDrawSetProportional(Setting(setting_td_time)[ 2 ], 1);
	TextDrawUseBox(Setting(setting_td_time)[ 2 ], 1);
//	TextDrawBoxColor(Setting(setting_td_time)[ 2 ], team_color_blue);
	TextDrawTextSize(Setting(setting_td_time)[ 2 ], 353.000000, 64.000000);
	
	Setting(setting_td_time)[ 3 ] = TextDrawCreate(317.000000, 11.000000, "1:29");
	TextDrawAlignment(Setting(setting_td_time)[ 3 ], 2);
	TextDrawBackgroundColor(Setting(setting_td_time)[ 3 ], 255);
	TextDrawFont(Setting(setting_td_time)[ 3 ], 3);
	TextDrawLetterSize(Setting(setting_td_time)[ 3 ], 0.439999, 1.299999);
	TextDrawColor(Setting(setting_td_time)[ 3 ], -1);
	TextDrawSetOutline(Setting(setting_td_time)[ 3 ], 1);
	TextDrawSetProportional(Setting(setting_td_time)[ 3 ], 1);
	TextDrawUseBox(Setting(setting_td_time)[ 3 ], 1);
//	TextDrawBoxColor(Setting(setting_td_time)[ 3 ], team_color_blue);
	TextDrawTextSize(Setting(setting_td_time)[ 3 ], 353.000000, 64.000000);

	Setting(setting_td_game_name) = TextDrawCreate(633.000000, 435.000000, "Mapa: Revolution TDM");
	TextDrawAlignment(Setting(setting_td_game_name), 3);
	TextDrawBackgroundColor(Setting(setting_td_game_name), 255);
	TextDrawFont(Setting(setting_td_game_name), 3);
	TextDrawLetterSize(Setting(setting_td_game_name), 0.370000, 1.000000);
	TextDrawColor(Setting(setting_td_game_name), -1);
	TextDrawSetOutline(Setting(setting_td_game_name), 1);
	TextDrawSetProportional(Setting(setting_td_game_name), 1);
	
	Setting(setting_td_record)[ 0 ] = TextDrawCreate(358.000000, 5.000000, "_");
	TextDrawBackgroundColor(Setting(setting_td_record)[ 0 ], 255);
	TextDrawFont(Setting(setting_td_record)[ 0 ], 1);
	TextDrawLetterSize(Setting(setting_td_record)[ 0 ], 0.500000, 6.699998);
	TextDrawColor(Setting(setting_td_record)[ 0 ], -1);
	TextDrawSetOutline(Setting(setting_td_record)[ 0 ], 0);
	TextDrawSetProportional(Setting(setting_td_record)[ 0 ], 1);
	TextDrawSetShadow(Setting(setting_td_record)[ 0 ], 1);
	TextDrawUseBox(Setting(setting_td_record)[ 0 ], 1);
	TextDrawBoxColor(Setting(setting_td_record)[ 0 ], 100);
	TextDrawTextSize(Setting(setting_td_record)[ 0 ], 494.000000, 69.000000);

	Setting(setting_td_record)[ 1 ] = TextDrawCreate(429.000000, 5.000000, "TOP 5:");
	TextDrawAlignment(Setting(setting_td_record)[ 1 ], 2);
	TextDrawBackgroundColor(Setting(setting_td_record)[ 1 ], 255);
	TextDrawFont(Setting(setting_td_record)[ 1 ], 1);
	TextDrawLetterSize(Setting(setting_td_record)[ 1 ], 0.310000, 1.100000);
	TextDrawColor(Setting(setting_td_record)[ 1 ], -1);
	TextDrawSetOutline(Setting(setting_td_record)[ 1 ], 0);
	TextDrawSetProportional(Setting(setting_td_record)[ 1 ], 1);
	TextDrawSetShadow(Setting(setting_td_record)[ 1 ], 1);
	
	for(new td; td != sizeof Setting(setting_td_left); td++)
	{
		Setting(setting_td_left)[ td ] = TextDrawCreate(5.000000, 325.000000 - (td * 13.0), "Wynik");
		TextDrawBackgroundColor(Setting(setting_td_left)[ td ], 255);
		TextDrawFont(Setting(setting_td_left)[ td ], 1);
		TextDrawLetterSize(Setting(setting_td_left)[ td ], 0.340000, 1.4);
		TextDrawColor(Setting(setting_td_left)[ td ], -1);
		TextDrawSetOutline(Setting(setting_td_left)[ td ], 1);
		TextDrawSetProportional(Setting(setting_td_left)[ td ], 1);
	}

	Setting(setting_td_achiv)[ 0 ] = TextDrawCreate(498.652343, 0.833435, "~n~~n~");
	TextDrawLetterSize(Setting(setting_td_achiv)[ 0 ], 0.244319, 1.215000);
	TextDrawTextSize(Setting(setting_td_achiv)[ 0 ], 791.801208, 47.250019);
	TextDrawAlignment(Setting(setting_td_achiv)[ 0 ], 1);
	TextDrawColor(Setting(setting_td_achiv)[ 0 ], -1);
	TextDrawUseBox(Setting(setting_td_achiv)[ 0 ], true);
	TextDrawBoxColor(Setting(setting_td_achiv)[ 0 ], 150);
	TextDrawSetShadow(Setting(setting_td_achiv)[ 0 ], 0);
	TextDrawSetOutline(Setting(setting_td_achiv)[ 0 ], 0);
	TextDrawBackgroundColor(Setting(setting_td_achiv)[ 0 ], 51);
	TextDrawFont(Setting(setting_td_achiv)[ 0 ], 1);
	TextDrawSetProportional(Setting(setting_td_achiv)[ 0 ], 1);

	Setting(setting_td_achiv)[ 1 ] = TextDrawCreate(494.652343, -2.0, "_");
	TextDrawFont(Setting(setting_td_achiv)[ 1 ], TEXT_DRAW_FONT_MODEL_PREVIEW);
	TextDrawBackgroundColor(Setting(setting_td_achiv)[ 1 ], 0);
	TextDrawTextSize(Setting(setting_td_achiv)[ 1 ], 30.0, 30.0);
	TextDrawSetPreviewRot(Setting(setting_td_achiv)[ 1 ], 0.0, 0.0, 00.0, 1.0);
	TextDrawSetPreviewModel(Setting(setting_td_achiv)[ 1 ], 1247);

	Setting(setting_td_black) = TextDrawCreate(0.0, 0.0, "~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~");
	TextDrawUseBox(Setting(setting_td_black), 1);
	TextDrawBoxColor(Setting(setting_td_black), 0x000000FF);
	TextDrawTextSize(Setting(setting_td_black), 640.0, 400.0);
	return 1;
}

stock NickName(playerid)
{
	new playername[ MAX_PLAYER_NAME ];
	GetPlayerName(playerid, playername, sizeof(playername));
	return playername;
}

stock NickSamp(playerid)
{
	new playername[ MAX_PLAYER_NAME ];
	GetPlayerName(playerid, playername, sizeof(playername));
	return playername;
}

FuncPub::UnFreezePlayer(playerid)
{
	Player(playerid, player_freezed) = false;
    TogglePlayerControllable(playerid, true);
    return 1;
}

FuncPub::FreezePlayer(playerid)
{
	GetPlayerPos(playerid, Player(playerid, player_position)[ 0 ], Player(playerid, player_position)[ 1 ], Player(playerid, player_position)[ 2 ]);
	GetPlayerFacingAngle(playerid, Player(playerid, player_position)[ 3 ]);

	Player(playerid, player_vw) = GetPlayerVirtualWorld(playerid);
	Player(playerid, player_int) = GetPlayerInterior(playerid);
	Player(playerid, player_freezed) = true;

    TogglePlayerControllable(playerid, false);
    return 1;
}

stock GivePlayerWeaponEx(playerid, weaponid, ammo)
{
	if(!ammo) return 0;
	
    Player(playerid, player_weapon)[ GetWeaponSlot(weaponid) ] = weaponid;
    GivePlayerWeapon(playerid, weaponid, ammo);
	return 1;
}

stock ResetPlayerWeaponsEx(playerid)
{
	for(new i; i < 13; i++)
	{
	    if(!Player(playerid, player_weapon)[ i ]) continue;
	    Player(playerid, player_weapon)[ 0 ] = 0;
	}
	ResetPlayerWeapons(playerid);
}

stock SetPlayerMoney(playerid, amount)
{
	ResetPlayerMoney(playerid);
	GivePlayerMoney(playerid, amount);
}

stock Float:AddRecord(playerid, type, Float:czas)
{
	if(!czas) return 0.0;
	new temp[ 10 ],
		string[ 256 ],
		Float:value,
		bool:num;
		
    format(string, sizeof string,
        "SELECT `value` FROM `mini_top` WHERE `gameuid` = '%d' AND `player` = '%d' AND `type` = '%d'",
        Setting(setting_game),
        Player(playerid, player_uid),
        type
	);
	mysql_query(string);
	mysql_store_result();
	mysql_fetch_row(temp);
	num = !!mysql_num_rows();
	mysql_free_result();
	value = floatstr(temp);
	if(num)
	{
	    if(value > czas)
	    {
	        format(string, sizeof string,
	            "UPDATE `mini_top` SET `value` = '%f', `time` = UNIX_TIMESTAMP() WHERE `gameuid` = '%d' AND `player` = '%d' AND `type` = '%d'",
				czas,
		        Setting(setting_game),
		        Player(playerid, player_uid),
		        type
	        );
            mysql_query(string);
			return value;
	    }
	}
	else
	{
	    format(string, sizeof string,
	        "INSERT INTO `mini_top` VALUES (NULL, '%d', '%d', '%d', '%f', UNIX_TIMESTAMP())",
	        Setting(setting_game),
	        Player(playerid, player_uid),
	        type,
			czas
		);
		mysql_query(string);
	}
	return 0.0;
}

stock set(newstring[], oldstring[])
{
	for (new i, j=  strlen(oldstring); i < j; ++i) newstring[i] = oldstring[i];
	newstring[strlen(oldstring)] = EOS;
}

stock GivePlayerExp(playerid, exp)
{
    Player(playerid, player_exp) += exp;
    new lvl;
    for(new c = sizeof Levels-1; c != Player(playerid, player_lvl); c--)
    {
        if(Levels[ c ] <= Player(playerid, player_exp))
        {
            lvl = c;
            break;
        }
    }
    if(lvl && Player(playerid, player_lvl) != lvl)
    {
	    Player(playerid, player_lvl) = lvl;
	    new string[ 126 ];
		format(string, sizeof string, "LVL up: %d (%s)", Player(playerid, player_lvl), LevelName[ Player(playerid, player_lvl) ][ Player(playerid, player_lang) ]);
	    SendClientMessage(playerid, -1, string);
    }
}
