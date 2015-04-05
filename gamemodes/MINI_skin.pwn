FuncPub::LoadSkins()
{
	new skinid = 1, string[ 126 ];
	mysql_query("SELECT * FROM `mini_skin`");
	mysql_store_result();
	if(mysql_num_rows())
	{
	    while(mysql_fetch_row(string))
	    {
	        if(skinid == MAX_SKINS) break;
	        
	        sscanf(string, "p<|>dddd",
				Skin(skinid, skin_uid),
				Skin(skinid, skin_model),
				Skin(skinid, skin_resp),
				Skin(skinid, skin_cash)
			);
	        
	        skinid++;
	    }
	    printf("# Skiny zostały wczytane. | %d", skinid-1);
	}
	else print("# Brak skinów do wczytania!");
	mysql_free_result();
	return 1;
}

FuncPub::Skin_OnPlayerUpdate(playerid)
{
    if(GetPVarInt(playerid, "Ubranie"))
    {
		new Keys, ud, lr;
  		GetPlayerKeys(playerid, Keys, ud, lr);
        if(lr < 0 || lr > 0)
        {
            new action = lr < 0 ? 1 : -1,
				uid = GetPVarInt(playerid, "Ubranie_id"),
				str[ 126 ];
            do
            {
                uid = uid + action < 0 ? MAX_SKINS - 1: (uid + action >= MAX_SKINS ? 0: uid + action);
            } while(!Skin(uid, skin_model));

            SetPVarInt(playerid, "Ubranie_id", uid);
            SetPlayerSkin(playerid, Skin(uid, skin_model));

			format(str, sizeof str, "Skin: %d~n~~n~", Skin(uid, skin_model));
			if(Skin(uid, skin_cash))
			{
			    if(Skin(uid, skin_cash) <= Player(playerid, player_cash))
					format(str, sizeof str, "%s%s: ~g~$%d", str, Lang(playerid, lang_money), Skin(uid, skin_cash));
				else
					format(str, sizeof str, "%s%s: ~r~$%d", str, Lang(playerid, lang_money), Skin(uid, skin_cash));
			}
			if(Skin(uid, skin_resp))
			{
			    if(Skin(uid, skin_cash)) strcat(str, "~n~~w~lub~n~");
			    if(Skin(uid, skin_resp) <= Player(playerid, player_exp))
					format(str, sizeof str, "%s~w~exp: ~g~%d", str, Skin(uid, skin_resp));
				else
					format(str, sizeof str, "%s~w~exp: ~r~%d", str, Skin(uid, skin_resp));
			}
			if(!Skin(uid, skin_cash) && !Skin(uid, skin_resp))
			    strcat(str, "~w~Za darmo!");
			    
		    PlayerTextDrawSetString(playerid, Player(playerid, player_td_shoot), str);
		}
        if(Keys & KEY_SECONDARY_ATTACK || Keys & KEY_JUMP)
        {
			new uid = GetPVarInt(playerid, "Ubranie_id"),
				string[ 64 ];
			
			if(Skin(uid, skin_resp) <= Player(playerid, player_exp) && Skin(uid, skin_resp))
			    strcat(string, "1\tExp\n");
			if(Skin(uid, skin_cash) <= Player(playerid, player_cash) && Skin(uid, skin_cash))
			    strcat(string, "2\tKasa\n");
			if(!Skin(uid, skin_cash) && !Skin(uid, skin_resp))
			    strcat(string, "3\tZa darmo\n");
			    
            if(!isnull(string))
            {
                format(string, sizeof string, "Wybierz sposób płatności:\n%s", string);
            	Dialog::Output(playerid, 12, DIALOG_STYLE_LIST, IN_HEAD, string, Lang(playerid, lang_select), Lang(playerid, lang_back));
			}
			else ShowInfo(playerid, red"Nie stać Cię na to ubranie!");
        }
    }
	return 1;
}

Cmd::Input->skin(playerid, params[])
{
    if(!GetPVarInt(playerid, "Ubranie"))
    {
        TogglePlayerControllable(playerid, false);
 		GetPlayerPos(playerid, Player(playerid, player_position)[ 0 ], Player(playerid, player_position)[ 1 ], Player(playerid, player_position)[ 2 ]);
 		SetPlayerFacingAngle(playerid, 90);
    	SetPlayerCameraPos(playerid, Player(playerid, player_position)[ 0 ]-3, Player(playerid, player_position)[ 1 ], Player(playerid, player_position)[ 2 ]);
  		SetPlayerCameraLookAt(playerid, Player(playerid, player_position)[ 0 ], Player(playerid, player_position)[ 1 ], Player(playerid, player_position)[ 2 ]);
        SetPVarInt(playerid, "Ubranie", GetPlayerSkin(playerid));
        
        PlayerTextDrawSetString(playerid, Player(playerid, player_td_shoot), "Uzyj strzalek,~n~aby wybrac ubranie");
		PlayerTextDrawShow(playerid, Player(playerid, player_td_shoot));
		
        //ShowCMD(playerid, "Aby wybrać ubranie "white"używaj strzałek"grey", aby zakupić wciśnij "white"ENTER lub F"grey".");
        //ShowCMD(playerid, "Aby anulować zakup wpisz ponownie "white"(/kup)"grey".");
    }
    else
    {
	    ShowCMD(playerid, "Zakup ubrania anulowany.");
		SetCameraBehindPlayer(playerid);
     	SetPlayerSkin(playerid, GetPVarInt(playerid, "Ubranie"));
 		DeletePVar(playerid, "Ubranie");
   		TogglePlayerControllable(playerid, true);
   		PlayerTextDrawHide(playerid, Player(playerid, player_td_shoot));
    }
    return 1;
}
