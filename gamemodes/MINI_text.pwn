FuncPub::LoadText(game)
{
	new textid = 1, string[ 126 ], idx = 2;
	format(string, sizeof string,
	    "SELECT * FROM `mini_text` WHERE `gameuid` = '%d'",
	    game
	);
	mysql_query(string);
	mysql_store_result();
	if(mysql_num_rows())
	{
		while(mysql_fetch_row(string))
		{
			if(textid == MAX_3DTEXT) break;
			for(; textid < MAX_3DTEXT; textid++)
			    if(!Text(textid, text_uid))
			        break;
			#if bots
				sscanf(string, "p<|>dds[256]a<f>[3]f",
				    Text(textid, text_uid),
				    Text(textid, text_game),
				    Text(textid, text_text),
				    Text(textid, text_pos),
				    Text(textid, text_pos_a)
				);
				Text(textid, text_botID) = INVALID_PLAYER_ID;
			#else
			    sscanf(string, "p<|>dds[256]a<f>[3]",
				    Text(textid, text_uid),
				    Text(textid, text_game),
				    Text(textid, text_text),
				    Text(textid, text_pos)
				);
			#endif
			
			if(!isnull(Text(textid, text_text)) && Text(textid, text_textID) == Text3D:INVALID_3DTEXT_ID)
				Text(textid, text_textID) = Create3DTextLabel(Text(textid, text_text), CLR_WHITE, Text(textid, text_pos)[ 0 ], Text(textid, text_pos)[ 1 ], Text(textid, text_pos)[ 2 ], 20.0, game, false);

			if(!game)
			{
				SetTimerEx("UpdateText", idx * 500, false, "d", textid);
				idx++;
			}
			textid++;
		}
    	printf("%s# 3DTexty wczytane - pomyślnie! | %d", game ? ("\t") : (""), textid-1);
	}
	else printf("%s# Brak 3DTextów do wczytania!", game ? ("\t") : (""));
	mysql_free_result();
	return 1;
}
#if bots
	new temp_tid,
		temp_uid,
		temp_name[ MAX_PLAYER_NAME ];

#endif

FuncPub::UpdateText(textid)
{
	if(Text(textid, text_textID) == Text3D:INVALID_3DTEXT_ID) return 1;
	#if Debug
	    printf("UpdateText(%d)", textid);
	#endif
	#define s_amount 	0
	#define s_time    	1
	#define s_cash      2
	#define s_float     3
	#define s_register  4
	
	new string[ 256 ], type, buffer[ 1024 ];
	if(DIN(Text(textid, text_text), "TOP_GAME_KILL;"))
	{
		format(string, sizeof string,
		    "SELECT p.name, t.value, p.uid FROM `mini_top` t, `mini_players` p WHERE p.uid = t.player AND t.gameuid = '%d' AND t.type = '"#top_kills_game"' ORDER BY t.value DESC LIMIT 10",
		    Text(textid, text_game)
		);
		buffer = "     Najwięcej zabójstw"green2"\n";
	}
	else if(DIN(Text(textid, text_text), "TOP_GAME_DEATH;"))
	{
		format(string, sizeof string,
		    "SELECT p.name, t.value, p.uid FROM `mini_top` t, `mini_players` p WHERE p.uid = t.player AND t.gameuid = '%d' AND t.type = '"#top_deaths_game"' ORDER BY t.value DESC LIMIT 10",
		    Text(textid, text_game)
		);
		buffer = "     Najwięcej śmierci"green2"\n";
	}
	else if(DIN(Text(textid, text_text), "TOP_ALL_KILL;"))
	{
		format(string, sizeof string,
		    "SELECT `name`, `kills`, `uid` FROM `mini_players` ORDER BY `kills` DESC LIMIT 10"
		);
		buffer = "     Najwięcej zabójstw"green2"\n";
	}
	else if(DIN(Text(textid, text_text), "TOP_ALL_DEATH;"))
	{
		format(string, sizeof string,
		    "SELECT `name`, `death`, `uid` FROM `mini_players` ORDER BY `death` DESC LIMIT 10"
		);
		buffer = "     Najwięcej śmierci"green2"\n";
	}
	else if(DIN(Text(textid, text_text), "TOP_ALL_TIME;"))
	{
		format(string, sizeof string,
		    "SELECT `name`, `timehere`, `uid` FROM `mini_players` ORDER BY `timehere` DESC LIMIT 10"
		);
		type = s_time;
		buffer = "     Najwięcej czasu online"green2"\n";
	}
	else if(DIN(Text(textid, text_text), "TOP_KLAN_POINTS;"))
	{
		format(string, sizeof string,
		    "SELECT `name`, `points` FROM `mini_klan` ORDER BY `points` DESC LIMIT 10"
		);
		buffer = "     Najlepszy klan"green2"\n";
	}
	else if(DIN(Text(textid, text_text), "TOP_KLAN_CASH;"))
	{
		format(string, sizeof string,
		    "SELECT `name`, `cash` FROM `mini_klan` ORDER BY `cash` DESC LIMIT 10"
		);
		buffer = "     Najbogatszy klan"green2"\n";
		type = s_cash;
	}
	else if(DIN(Text(textid, text_text), "TOP_ALL_GAME;"))
	{
		format(string, sizeof string,
		    "SELECT `name`, `visits` FROM `mini_game` ORDER BY `visits` DESC LIMIT 10"
		);
		buffer = "     Najczęściej grana mapa"green2"\n";
	}
	else if(DIN(Text(textid, text_text), "TOP_ALL_REGISTER;"))
	{
		format(string, sizeof string,
		    "SELECT COUNT(*) FROM `mini_players`"
		);
		buffer = "Zarejestrowanych kont: "green2;
		type = s_register;
	}
	else if(DIN(Text(textid, text_text), "TOP_ALL_GAME;"))
	{
		format(string, sizeof string,
		    "SELECT `name`, `rate` FROM `mini_game` ORDER BY `rate` DESC LIMIT 10"
		);
		buffer = "     Najlepiej oceniana mapa"green2"\n";
		type = s_float;
	}
	else return 1;

	mysql_query(string);
	mysql_store_result();
	if(mysql_num_rows())
	{
	    new idx = 1;
	    while(mysql_fetch_row(string))
	    {
	        new name[ MAX_PLAYER_NAME ], Float:value, uid, v;
	        if(type == s_register)
	            v = mysql_fetch_int();
	        else
	        	sscanf(string, "p<|>s["#MAX_PLAYER_NAME"]fd", name, value, uid);
	        
	        #if bots
	            if(!uid && Text(textid, text_botID) != INVALID_PLAYER_ID)
	            {
	                Kick(Text(textid, text_botID));
					Text(textid, text_botID) = INVALID_PLAYER_ID;
	            }
	        
		        if(idx == 1 && uid)
				{
				    if(Text(textid, text_botID) != INVALID_PLAYER_ID && uid != Text(textid, text_bot_uid))
				    {
						Kick(Text(textid, text_botID));
						Text(textid, text_botID) = INVALID_PLAYER_ID;
						Player(Text(textid, text_botID), player_bot) = 0;
				    }
				    if(Text(textid, text_botID) == INVALID_PLAYER_ID)
				    {
					    new str[ MAX_PLAYER_NAME ];
					    format(str, sizeof str, "%d_%s", Text(textid, text_uid), name);
					    temp_tid = textid; temp_uid = uid;
						format(temp_name, sizeof temp_name, name);
						FCNPC_Create(str);
					}
					else SetTimerEx("OnBotUpdate", 500, false, "d", Text(textid, text_botID));
				}
	        #endif
	        
	        if(type == s_register)
	        {
	            format(buffer, sizeof buffer, "%s%d", buffer, v);
	        }
	        else if(type == s_time)
	        {
	            new e[ 64 ];
	            ReturnTimeMega(floatval(value), e);
	            format(buffer, sizeof buffer, "%s%d"white". %s%s%s"green2"%s\n", buffer, idx, name, Spaces(name, 15), Spaces(e, 15), e);
	        }
	        else if(type == s_cash) format(buffer, sizeof buffer, "%s"green2"%d"white". %s%s"green2"$"white"%d\n", buffer, idx, name, Spaces(name), floatval(value));
	        else if(type == s_float) format(buffer, sizeof buffer, "%s%d"white". %s%s"green2"%.2f\n", buffer, idx, name, Spaces(name), value);
	        else format(buffer, sizeof buffer, "%s%d"white". %s%s"green2"%d\n", buffer, idx, name, Spaces(name), floatval(value));
	        idx++;
	    }
	    /*for(;idx <= 10; idx++)
            format(buffer, sizeof buffer, "%s%d"white". --%s%s"green2"-\n", buffer, idx, Spaces("--", 15), Spaces("-", 15));*/
		Update3DTextLabelText(Text(textid, text_textID), CLR_WHITE, buffer);
	}
	mysql_free_result();
	return 1;
}

stock Spaces(name[], max = 30, znak[] = " ")
{
	new spaces[ 32 ];
	for(new i = strlen(name); i <= max; i++)
	    strcat(spaces, znak);
	return spaces;
}

#if bots
	public FCNPC_OnCreate(npcid)
	{
		new textid;
		textid = Player(npcid, player_bot) = temp_tid;
		Text(textid, text_botID) = npcid;
		Player(npcid, player_uid) = Text(textid, text_bot_uid) = temp_uid;
		format(Text(textid, text_bot_name), MAX_PLAYER_NAME, temp_name);

		temp_name[0] = EOS;
	 	temp_tid = temp_uid = 0;
		#if Debug
		    printf("OnBotConnect(%d, %d, %s)", npcid, textid, Text(textid, text_bot_name));
		#endif
		if(!textid) return 1;
	    SetPlayerColor(npcid, 0xFFFFFF00);
	    FCNPC_SetHealth(npcid, Player(npcid, player_hp) = 99999.0);
	    Player(npcid, player_logged)  	= true;
		Player(npcid, player_color) 	= player_nick_def;
		#if STREAMER
	 	if(Player(npcid, player_tag)[ npcid ] == Text3D:INVALID_3DTEXT_ID)
		#else
	 	if(Player(npcid, player_tag)[ npcid ] == PlayerText3D:INVALID_3DTEXT_ID)
	 	#endif
	    {
			new nametag[ MAX_PLAYER_NAME ];
			format(nametag, sizeof nametag, "%s", Text(textid, text_bot_name));
			foreach(Player, i)
			{
			    #if STREAMER
			    	if(Player(i, player_tag)[ npcid ] != Text3D:INVALID_3DTEXT_ID) continue;
					Player(i, player_tag)[ npcid ] = CreateDynamic3DTextLabel(nametag, Player(npcid, player_color), 0.0, 0.0, 0.17, 14.0, npcid, INVALID_VEHICLE_ID, 1, .playerid = i);
			    #else
			    	if(Player(i, player_tag)[ npcid ] != PlayerText3D:INVALID_3DTEXT_ID) continue;
					Player(i, player_tag)[ npcid ] = CreatePlayer3DTextLabel(i, nametag, Player(npcid, player_color), 0.0, 0.0, 0.17, 14.0, npcid, INVALID_VEHICLE_ID, 1);
				#endif
			}
		}
		FCNPC_Spawn(npcid, Player(npcid, player_skin), Text(textid, text_pos)[ 0 ], Text(textid, text_pos)[ 1 ], Text(textid, text_pos)[ 2 ]);
		SetTimerEx("OnBotUpdate", 500, false, "d", npcid);
		return 1;
	}

	FuncPub::OnBotUpdate(npcid)
	{
		new textid = Player(npcid, player_bot);
		#if Debug
		    printf("OnBotUpdate(%d, %s)", npcid, Text(textid, text_bot_name));
		#endif

		new string[ 126 ];
		format(string, sizeof string,
		    "SELECT `guid`, `skin`, `klan`, `lang`, `premium`, `timehere` FROM `mini_players` WHERE `uid` = '%d'",
		    Player(npcid, player_uid)
		);
		mysql_query(string);
		mysql_store_result();
		mysql_fetch_row(string);
		sscanf(string, "p<|>dddddd",
		    Player(npcid, player_guid),
			Player(npcid, player_skin),
			Klan(npcid, klan_uid),
			Player(npcid, player_lang),
			Player(npcid, player_premium),
			Player(npcid, player_timehere)[ 0 ]
		);
		mysql_free_result();
		ChangeLang(npcid, Player(npcid, player_lang));
		LoadPlayerFriends(npcid);
		FCNPC_SetSkin(npcid, Player(npcid, player_skin));

		if(gettime() < Player(npcid, player_premium))
		    Player(npcid, player_color) = player_nick_prem;
		else
		    Player(npcid, player_premium) = 0;

		if(Klan(npcid, klan_uid))
		{
			format(string, sizeof string,
			    "SELECT `color`, `name`, `tag` FROM `mini_klan` WHERE `uid` = '%d'",
			    Klan(npcid, klan_uid)
			);
			mysql_query(string);
			mysql_store_result();
			mysql_fetch_row(string);
			sscanf(string, "p<|>xs[32]s[6]",
				Klan(npcid, klan_color),
				Klan(npcid, klan_name),
				Klan(npcid, klan_tag)
			);
			mysql_free_result();
		}
	    UpdatePlayerNick(npcid);
		return 1;
	}

	public FCNPC_OnSpawn(npcid)
	{
		if(Player(npcid, player_bot) == INVALID_PLAYER_ID) return 1;
		#if Debug
		    printf("OnBotSpawn(%d)", npcid);
		#endif
		new textid = Player(npcid, player_bot);
		if(!Text(textid, text_game))
		{
			FCNPC_SetInterior(npcid, Setting(setting_int));
			SetPlayerVirtualWorld(npcid, Player(npcid, player_vw) = 0);
		}
		else
		{
			FCNPC_SetInterior(npcid, 0);
			SetPlayerVirtualWorld(npcid, Player(npcid, player_vw) = Setting(setting_game));
		}
		new weap[] = {31, 30, 24, 28, 22};
		new idx = weap[ random( sizeof weap ) ];
		FCNPC_SetWeapon(npcid, idx);
		FCNPC_SetAmmo(npcid, 999);
		FCNPC_SetPosition(npcid, Text(textid, text_pos)[ 0 ], Text(textid, text_pos)[ 1 ], Text(textid, text_pos)[ 2 ]);
	    FCNPC_SetAngle(npcid, Text(textid, text_pos_a));
	    Player(npcid, player_spawn_time) = gettime();
	    SetDance(npcid);
	    if(!Player(npcid, player_cam_timer))
	    	Player(npcid, player_cam_timer) = SetTimerEx("SetDance", 10000, true, "d", npcid);
		return 1;
	}

	public FCNPC_OnPlayerGiveDamage(playerid, damagedid, Float:amount, weaponid, bodypart)
	{
	   	PlayerTextDrawShow(playerid, Player(playerid, player_td_celownik)[ 0 ]);
	    PlayerTextDrawShow(playerid, Player(playerid, player_td_celownik)[ 1 ]);

		new amo = floatval(amount);

	    if(Player(playerid, player_shoot_timer)[ 0 ])
			KillTimer(Player(playerid, player_shoot_timer)[ 0 ]);
	    Player(playerid, player_shoot_timer)[ 0 ] = SetTimerEx("HideCelownik", amo*100, false, "d", playerid);

		new string[ 126 ],
			exp;
		format(string, sizeof string, "%s~n~", Text(Player(damagedid, player_bot), text_bot_name));
	    if(!(bodypart == 0 || bodypart == 1 || bodypart == 2))
	    {
	        new shoot[ 64 ];
	        format(shoot, sizeof shoot, BodyParts[ Player(playerid, player_lang) ][ bodypart ]);
	        EscapePL(shoot);
		    format(string, sizeof string, "%s%s %s~n~", string, Lang(playerid, lang_shoot), shoot);
	    }
	    exp = 30 + BodyPartExp[ bodypart ];
	    format(string, sizeof string, "%s~y~~h~+%d exp", string, exp);

	    if(Klan(playerid, klan_uid) != Klan(damagedid, klan_uid) && Klan(playerid, klan_uid) && Klan(damagedid, klan_uid))
	    {
	        new cexp = random(20) + 10;
	        format(string, sizeof string,
				"%s~n~~w~Zabicie gracza z %s~n~~y~~h~+%d exp",
				string,
				Klan(damagedid, klan_tag),
				cexp
			);
			GiveKlanExp(Klan(damagedid, klan_uid), cexp);
			exp += cexp;
	    }

	    Player(playerid, player_hp) = 0.0;
	    GivePlayerExp(playerid, exp);
	    Player(playerid, player_c_exp) += exp;

	    PlayerTextDrawSetString(playerid, Player(playerid, player_td_shoot), string);
	    PlayerTextDrawShow(playerid, Player(playerid, player_td_shoot));
		if(Player(playerid, player_shoot_timer)[ 1 ])
		    KillTimer(Player(playerid, player_shoot_timer)[ 1 ]);
	    Player(playerid, player_shoot_timer)[ 1 ] = SetTimerEx("HideCelownikEx", 3000, false, "d", playerid);
	    PlayerPlaySound(playerid, 1147, 0.0, 0.0, 0.0);
		return 1;
	}

	FuncPub::SetDance(playerid)
	{
		switch(random(7))
		{
			case 0: ApplyAnimation(playerid, "DANCING", "DAN_Down_A", 4.00, 1, 1, 1, 1, 1); // Taichi
			case 1: ApplyAnimation(playerid, "DANCING", "DAN_Left_A", 4.00, 1, 1, 1, 1, 1); // Dilujesz
			case 2: ApplyAnimation(playerid, "DANCING", "DAN_Right_A", 4.0, 1, 1, 1, 1, 1); // Ręce
			case 3: ApplyAnimation(playerid, "DANCING", "DAN_Up_A", 4.0000, 1, 1, 1, 1, 1); // f**k
			case 4: ApplyAnimation(playerid, "DANCING", "dnce_M_a", 4.0000, 1, 1, 1, 1, 1); // Lookout
			case 5: ApplyAnimation(playerid, "RAPPING", "RAP_B_Loop", 4.00, 1, 0, 0, 0, 0); // Rapujesz
			case 6: ApplyAnimation(playerid, "DANCING", "DAN_Right_A", 4.0, 1, 1, 1, 1, 1); // Taniec
		}
		return 1;
	}
#endif
