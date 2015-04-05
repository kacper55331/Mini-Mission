public OnPlayerCommandReceived(playerid, cmdtext[])
{
	return 1;
}

public OnPlayerCommandPerformed(playerid, cmdtext[], success)
{
	printf("[zcmd] [%s]: %s", NickSamp(playerid), cmdtext);
//	Player(playerid, player_cmds)++;

//	SetTimerEx("CheckSpamCmd", 3000, 0, "d", playerid);

    if(!success) PlayerPlaySound(playerid, 1085, 0.0, 0.0, 0.0);
	return 1;
}

//
Cmd::Input->ready(playerid, params[]) cmd_gotowy(playerid, params);
Cmd::Input->gotowy(playerid, params[])
{
	Player(playerid, player_ready) = !Player(playerid, player_ready);
	if(Setting(setting_game) != INVALID_GAME_ID && Player(playerid, player_ready) && !Player(playerid, player_play))
	{
	    if(Game(game_time) < 30)
	    {
	        SendClientMessage(playerid, -1, "Nie możesz dołączyć do kończącej się rozgrywki!");
	        Player(playerid, player_ready) = false;
	        return 1;
	    }
	    if(Game(game_typ) == game_type_hay && Game(game_started))
	    {
	        SendClientMessage(playerid, -1, "Nie możesz dołączyć do trwającej rozgrywki HAY!");
	        Player(playerid, player_ready) = false;
	        return 1;
	    }

	    Game(game_players)++;
	    mysql_query("UPDATE `mini_info` SET `played` = `played` + 1");
	    SendClientMessage(playerid, -1, "Dołączenie do rozgrywki");
		FadeColorForPlayer(playerid, 0, 0, 0, 0, 0, 0, 0, 255, 15, 0); // Ściemnienie
		Player(playerid, player_dark) = dark_start;
	}
	else if(!Player(playerid, player_ready) && Player(playerid, player_play))
	{
	    Game(game_players)--;
	    mysql_query("UPDATE `mini_info` SET `played` = `played` - 1");
	    Team(Player(playerid, player_team), team_players)--;
	    SendClientMessage(playerid, -1, "Powrót do poczekalni");
		FadeColorForPlayer(playerid, 0, 0, 0, 0, 0, 0, 0, 255, 15, 0); // Ściemnienie
		Player(playerid, player_dark) = dark_spawn;
	}
	else
	{
	    if(Player(playerid, player_ready))
	    {
		    if(Game(game_players) >= Team(Player(playerid, player_team), team_spawn_max) && Game(game_typ) == game_type_race && !Game(game_started))
		    {
		        SendClientMessage(playerid, -1, "Nie możesz dołączyć do tej rozgrywki, ponieważ zabrakło miejsc!");
		        SendClientMessage(playerid, -1, "Możesz do niej dołączyć, gdy już wystartuje.");
                Player(playerid, player_ready) = false;
		        return 1;
		    }
			SendClientMessage(playerid, -1, "Jesteś gotowy");
	        Game(game_players)++;
	        mysql_query("UPDATE `mini_info` SET `played` = `played` + 1");
	        if(Game(game_players) >= Game(game_minimum))
	        {
	            if(Game(game_time) > 30) Game(game_time) = 30;
	            SendClientMessageToAll(-1, "Osiągnięto minimalną ilość graczy. Rozgrywka wystartuje za kilkanaście sekund!");
	        }
		}
		else if(!Player(playerid, player_ready))
		{
		    Game(game_players)--;
		    mysql_query("UPDATE `mini_info` SET `played` = `played` - 1");
		    SendClientMessage(playerid, -1, "Nie jesteś gotowy");
		}
	}
	return 1;
}
Cmd::Input->statystyki(playerid, params[]) cmd_stats(playerid, params);
Cmd::Input->stats(victimid, params[])
{
	new playerid;
	if(!isnull(params))
	{
		if(Player(victimid, player_adminlvl)) sscanf(params, "u", playerid);
		else playerid = victimid;
	}
	else playerid = victimid;

	if(!IsPlayerConnected(playerid) && !Player(playerid, player_logged))
		return NoPlayer(victimid);

	new buffer[ 1024 ],
		buffer2[ 64 ],
		timeStr[ 45 ],
		timeStr2[ 45 ];
		
	FullTimeExtra(Player(playerid, player_timehere)[ 0 ], timeStr);
	FullTimeExtra(Player(playerid, player_timehere)[ 1 ], timeStr2);
	
  	format(buffer2, sizeof buffer2, C_BLUE2"%s "white"[%s] (ID: %d)", NickName(playerid), Player(playerid, player_ip), playerid);
	if(Player(playerid, player_guid) != -1 && !isnull(Player(playerid, player_gname)))
		format(buffer, sizeof buffer, "%sNick Glob:\t\t%s(%d)\n", buffer, Player(playerid, player_gname), Player(playerid, player_guid));
    format(buffer, sizeof buffer, "%sNick:\t\t\t%s(%d)\n", buffer, NickName(playerid), Player(playerid, player_uid));
    format(buffer, sizeof buffer, "%sCzas gry:\t\t%s\n", buffer, timeStr);
    format(buffer, sizeof buffer, "%sGrasz od:\t\t%s\n", buffer, timeStr2);
	format(buffer, sizeof buffer, "%sOdwiedzin:\t\t%d\n", buffer, Player(playerid, player_visits));
    format(buffer, sizeof buffer, "%sJęzyk:\t\t\t%s\n", buffer, Lang[ Player(playerid, player_lang) ][ 0 ]);
	strcat(buffer, grey"------------------------\n");
	format(buffer, sizeof buffer, "%sLevel:\t\t\t%d (%s)\n", buffer, Player(playerid, player_lvl), LevelName[ Player(playerid, player_lvl) ][ Player(playerid, player_lang) ]);
	format(buffer, sizeof buffer, "%sExp:\t\t\t%d\n", buffer, Player(playerid, player_exp));
    format(buffer, sizeof buffer, "%s%s:\t\t\t"green2"$"white"%d\n", buffer, Lang(playerid, lang_money), Player(playerid, player_cash));
    format(buffer, sizeof buffer, "%sSkin:\t\t\t%d\n", buffer, Player(playerid, player_skin));
    format(buffer, sizeof buffer, "%sWorld:\t\t\t%d\n", buffer, GetPlayerVirtualWorld(playerid));
    if(Audio_IsClientConnected(playerid))
        strcat(buffer, "Audio Plugin:\t\t"green2"Tak\n");
	if(Player(playerid, player_adminlvl))
	{
	    if(isnull(AdminLvl[ Player(playerid, player_adminlvl) ][ admin_tag ]))
			format(buffer, sizeof buffer, "%sAdmin:\t\t\t%d ({%06x}%s"white")\n", buffer, Player(playerid, player_adminlvl), AdminLvl[ Player(playerid, player_adminlvl) ][ admin_color ] >>> 8, AdminLvl[ Player(playerid, player_adminlvl) ][ admin_name ]);
		else
		    format(buffer, sizeof buffer, "%sAdmin:\t\t\t%d ({%06x}%s %s"white")\n", buffer, Player(playerid, player_adminlvl), AdminLvl[ Player(playerid, player_adminlvl) ][ admin_color ] >>> 8, AdminLvl[ Player(playerid, player_adminlvl) ][ admin_name ], AdminLvl[ Player(playerid, player_adminlvl) ][ admin_tag ]);
	}
	if(Klan(playerid, klan_uid))
	{
		strcat(buffer, grey"------------------------\n");
		format(buffer, sizeof buffer, "%sKlan:\t\t\t%s (%d)\n", buffer, Klan(playerid, klan_name), Klan(playerid, klan_uid));
	}
	if(playerid == victimid)
	{
		strcat(buffer, grey"------------------------\n");
		format(buffer, sizeof buffer, "%s%s\n", buffer, Lang(playerid, lang_set));
		format(buffer, sizeof buffer, "%s%s\n", buffer, "Language");
	}
	Dialog::Output(victimid, 6, DIALOG_STYLE_LIST, buffer2, buffer, "Wybierz", "Zamknij");
	return 1;
}

Cmd::Input->kill(playerid, params[])
{
	SetPlayerHealth(playerid, 0.0);
	return 1;
}

Cmd::Input->shop(playerid, params[]) cmd_sklep(playerid, params);
Cmd::Input->sklep(playerid, params[])
{
    if(Player(playerid, player_play))
        return 1;
        
    new string[ 64 ],
		buffer[ 256 ];
		
	mysql_query("SELECT * FROM `mini_shop_cat`");
	mysql_store_result();
	while(mysql_fetch_row(string))
	{
	    static uid,
			name[ 32 ];
	    
		sscanf(string, "p<|>ds[32]",
			uid,
			name
		);
		
		format(buffer, sizeof buffer, "%s%d\t%s\n", buffer, uid, name);
	}
	mysql_free_result();
	Dialog::Output(playerid, 9, DIALOG_STYLE_LIST, IN_HEAD, buffer, "Wybierz", "Zamknij");
    return 1;
}

Cmd::Input->p(playerid, params[])
{
    if(Player(playerid, player_play))
        return 1;

    new string[ 64 ],
		buffer[ 256 ];

	mysql_query("SELECT * FROM `mini_shop_cat`");
	mysql_store_result();
	while(mysql_fetch_row(string))
	{
	    static uid,
			name[ 32 ];

		sscanf(string, "p<|>ds[32]",
			uid,
			name
		);

		format(buffer, sizeof buffer, "%s%d\t%s\n", buffer, uid, name);
	}
	mysql_free_result();
	Dialog::Output(playerid, 10, DIALOG_STYLE_LIST, IN_HEAD, buffer, "Wybierz", "Zamknij");
	return 1;
}

Cmd::Input->game(playerid, params[])
{
	new sub[ 20 ],
		rest[ 30 ];
   	if(sscanf(params, "s[20]S()[30]", sub, rest))
   	    return ShowCMD(playerid, "Tip: /game [next/redo/end/start/debug]");
   	    
   	if(!strcmp(sub, "next", true))
   	{
   	    new value = strval(rest);
   	    if(!value)
   	        return ShowCMD(playerid, "Tip: /game next [ID]");
   	        
   	    new string[ 126 ];
   	    format(string, sizeof string,
   	        "SELECT `name` FROM `mini_game` WHERE `uid` = '%d'",
   	        value
		);
		mysql_query(string);
		mysql_store_result();
		if(mysql_num_rows())
		{
			mysql_fetch_row(string);
	   	    Setting(setting_next) = value;
	   	    
	   	    format(string, sizeof string, "Następna rozgrywka: %s", string);
	   	    ShowCMD(playerid, string);

	   	    if(Setting(setting_game) == INVALID_GAME_ID)
			    EndGame();
			//LoadRandomGame();
		}
		else ShowCMD(playerid, "Error: Nie ma takiej gry!");
		mysql_free_result();
   	}
   	else if(!strcmp(sub, "restart", true) || !strcmp(sub, "redo", true))
   	{
   	    Setting(setting_next) = Setting(setting_game);
		foreach(Player, i)
		{
		    if(Player(i, player_play))
		    {
		        Reset(i);
		        Player(i, player_ready) = true;
			}
		}
   	    EndGame();
   	    LoadRandomGame();
   	}
   	else if(!strcmp(sub, "end", true) || !strcmp(sub, "koniec", true))
   	{
   	    if(Game(game_countdown) || Setting(setting_timer_game)) return SendClientMessage(playerid, -1, "Trwa odliczanie startowe");
   	    if(Game(game_started))
   	    {
   	        if(Game(game_time) > 5) Game(game_time) = 5;
   	        SendClientMessage(playerid, -1, "Skrócono czas do zakończenia rozgrywki");
		}
   	}
   	else if(!strcmp(sub, "start", true))
   	{
   	    if(Game(game_countdown) || Setting(setting_timer_game))
   	    {
   	        if(Game(game_countdown) > 5)
   				Game(game_countdown) = 5;
   			SendClientMessage(playerid, -1, "Odliczanie wystartowało!");
   	    }
   	    else if(!Game(game_started))
   	    {
   	        if(Game(game_time) > 5) Game(game_time) = 5;
   	        SendClientMessage(playerid, -1, "Skrócono czas do rozpoczęcia rozgrywki");
   	    }
   	    /*else
   	    {
   	        if(Setting(setting_timer_game))
   	            KillTimer(Setting(setting_timer_game));
   	        Game(game_countdown) = 5;
   	        Setting(setting_timer_game) = SetTimer("Odliczanie", 1000, false);
   	        SendClientMessage(playerid, -1, "Odliczanie wystartowało!");
   	    }*/
   	}
   	else if(!strcmp(sub, "debug", true))
   	{
   	    if(Setting(setting_debug))
		   Setting(setting_debug) = false;
		else
		   Setting(setting_debug) = true;
   	}
   	else cmd_game(playerid, "");
	return 1;
}

Cmd::Input->rate(playerid, params[])
{
    if(Setting(setting_game) == INVALID_GAME_ID)
		return ShowInfo(playerid, red"Nie możesz teraz głosować!");
    new string[ 126 ];
    format(string, sizeof string,
        "SELECT `uid`, `rate` FROM `mini_rate` WHERE `player` = '%d' AND `game` = '%d'",
        Player(playerid, player_uid),
		Setting(setting_game)
	);
	mysql_query(string);
	mysql_store_result();
	if(mysql_num_rows())
	{
	    mysql_fetch_row(string);
	    mysql_free_result();
	    new uid, rate;
	    sscanf(string, "dd", uid, rate);
	    if(isnull(params))
	    {
	        // Twój wynik/średnia
	        format(string, sizeof string,
	            "SELECT IFNULL(SUM(rate)/COUNT(*), 1) FROM `mini_rate` WHERE `game` = '%d'",
	            Setting(setting_game)
			);
			mysql_query(string);
			mysql_store_result();
			new Float:r;
			mysql_fetch_float(r);
			mysql_free_result();
	        format(string, sizeof string,
	            "Dałeś tej mapie %d/5 pkt. Średnia: %.2f/5 pkt",
				rate,
				r
			);
			SendClientMessage(playerid, -1, string);
	    }
	    else
	    {
	        // Zmiana wyniku
		    new value = strval(params);
		    if(!(1 < value <= 5)) value = 5;
	        format(string, sizeof string,
	            "UPDATE `mini_rate` SET `rate` = '%d' WHERE `uid` = '%d'",
	            value,
	            uid
			);
			mysql_query(string);
	        format(string, sizeof string,
	            "Stare rate: %d/5 pkt. Nowe rate: %d/5 pkt.",
				rate,
				value
			);
			SendClientMessage(playerid, -1, string);
	    }
	}
	else
	{
	    mysql_free_result();
	    if(isnull(params))
	    {
	        // Twój wynik/średnia
	        format(string, sizeof string,
	            "SELECT IFNULL(SUM(rate)/COUNT(*), 1) FROM `mini_rate` WHERE `game` = '%d'",
	            Setting(setting_game)
			);
			mysql_query(string);
			mysql_store_result();
			new Float:r;
			mysql_fetch_float(r);
			mysql_free_result();
	        format(string, sizeof string,
	            "Średnia: %.2f/5 pkt.",
				r
			);
			SendClientMessage(playerid, -1, string);
			ShowCMD(playerid, "Aby zagłosowac wpisz /rate [1-5]");
			return 1;
	    }
	    else
	    {
		    new value = strval(params);
		    if(!(1 < value <= 5)) value = 5;
		    
		    format(string, sizeof string,
		        "INSERT INTO `mini_rate` VALUES (NULL, '%d', '%d', '%d')",
		        Player(playerid, player_uid),
				Setting(setting_game),
				value
			);
			mysql_query(string);
			
	        format(string, sizeof string,
	            "SELECT IFNULL(SUM(rate)/COUNT(*), 1) FROM `mini_rate` WHERE `game` = '%d'",
	            Setting(setting_game)
			);
			mysql_query(string);
			mysql_store_result();
			new Float:r;
			mysql_fetch_float(r);
			mysql_free_result();

			format(string, sizeof string,
			    "Zagłosowałeś na mapę: %d/5. Średnia: %.2f/5",
			    value,
			    r
			);
			SendClientMessage(playerid, -1, string);
	    }
	}
	return 1;
}

Cmd::Input->veh(playerid, params[])
{
	new model = 411;
	if(!isnull(params)) model = strval(params);
	new Float:pos[ 3 ];
	GetPlayerPos(playerid, pos[ 0 ], pos[ 1 ], pos[ 2 ]);
	new c = CreateVehicle(model, pos[ 0 ], pos[ 1 ]+2, pos[ 2 ], 0, 36, 36, -1);
	SetVehicleVirtualWorld(c, GetPlayerVirtualWorld(playerid));
	SetVehicleParamsEx(c, 1, 1, 0, 0, 0, 0, false);
	Vehicle(c, vehicle_hp) = 1000.0;
	return 1;
}
