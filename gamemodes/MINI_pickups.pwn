FuncPub::LoadPickups(game)
{
	new pickid = 1, string[ 126 ];
	format(string, sizeof string,
	    "SELECT * FROM `mini_pickups` WHERE `gameuid` = '%d'",
	    game
	);
	mysql_query(string);
	mysql_store_result();
	if(mysql_num_rows())
	{
		while(mysql_fetch_row(string))
		{
			if(pickid == MAX_PICKUPS) break;
			for(; pickid < MAX_PICKUPS; pickid++)
			    if(!Pickup(pickid, pick_uid))
			        break;

			sscanf(string, "p<|>dddda<f>[3]d",
			    Pickup(pickid, pick_uid),
			    Pickup(pickid, pick_game),
			    Pickup(pickid, pick_model),
			    Pickup(pickid, pick_type),
			    Pickup(pickid, pick_pos),
			    Pickup(pickid, pick_func)
			);
			new mdl = (Pickup(pickid, pick_func) == pick_func_weapon) ? (ObjectModel[ Pickup(pickid, pick_model) ]) : (Pickup(pickid, pick_model));
			#if STREAMER
				Pickup(pickid, pick_pickID) = CreateDynamicPickup(mdl, Pickup(pickid, pick_type), Pickup(pickid, pick_pos)[ 0 ], Pickup(pickid, pick_pos)[ 1 ], Pickup(pickid, pick_pos)[ 2 ]);
			#else
				Pickup(pickid, pick_textID) = Text3D:INVALID_3DTEXT_ID;
			    static str[ 20 ];
				if(Pickup(pickid, pick_func) == pick_func_nitro) str = "[NITRO]";
				else if(Pickup(pickid, pick_func) == pick_func_repair) str = "[REPAIR]";
				else if(Pickup(pickid, pick_func) == pick_func_hunter) str = "[HUNTER]";
				else if(Pickup(pickid, pick_func) == pick_func_weapon)
				{
				    static weaponname[ 32 ];
				    GetWeaponName(Pickup(pickid, pick_model), weaponname, sizeof weaponname);
					format(str, sizeof str, "[%s]", weaponname);
				}
				else str[ 0 ] = EOS;
			    Pickup(pickid, pick_pickID) = CreatePickup(mdl, Pickup(pickid, pick_type), Pickup(pickid, pick_pos)[ 0 ], Pickup(pickid, pick_pos)[ 1 ], Pickup(pickid, pick_pos)[ 2 ]);
			    if(!isnull(str)) Pickup(pickid, pick_textID) = Create3DTextLabel(str, COLOR_PURPLE, Pickup(pickid, pick_pos)[ 0 ], Pickup(pickid, pick_pos)[ 1 ], Pickup(pickid, pick_pos)[ 2 ], 20.0, game, false);
			#endif
			pickid++;
		}
    	printf("%s# Pickupy wczytane - pomyœlnie! | %d", game ? ("\t") : (""), pickid - 1);
	}
	else printf("%s# Brak pickupów do wczytania!", game ? ("\t") : (""));
	mysql_free_result();
	return 1;
}
#if STREAMER
	FuncPub::LoadPickupTextDraw(playerid)
	{
	    #if Debug
			printf("LoadPickupTextDraw(%d)", playerid);
	    #endif
	    new str[ 20 ];
		for(new pickid; pickid < MAX_PICKUPS; pickid++)
		{
			if(!Pickup(pickid, pick_uid)) continue;

			if(Pickup(pickid, pick_func) == pick_func_nitro) str = "[NITRO]";
			else if(Pickup(pickid, pick_func) == pick_func_repair) str = "[REPAIR]";
			else if(Pickup(pickid, pick_func) == pick_func_hunter) str = "[HUNTER]";
			else if(Pickup(pickid, pick_func) == pick_func_weapon)
			{
			    static weaponname[ 32 ];
			    GetWeaponName(Pickup(pickid, pick_model), weaponname, sizeof weaponname);
				format(str, sizeof str, "[%s]", weaponname);
			}
			else continue;
			#if STREAMER
				if(Player(playerid, player_pick_tag)[ pickid ] == Text3D:INVALID_3DTEXT_ID)
	            	Player(playerid, player_pick_tag)[ pickid ] = CreateDynamic3DTextLabel(str, COLOR_PURPLE, Pickup(pickid, pick_pos)[ 0 ], Pickup(pickid, pick_pos)[ 1 ], Pickup(pickid, pick_pos)[ 2 ], 20.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, .playerid = playerid);
				else
				    UpdateDynamic3DTextLabelText(Player(playerid, player_pick_tag)[ pickid ], COLOR_PURPLE, str);
			#else
				if(Player(playerid, player_pick_tag)[ pickid ] == PlayerText3D:INVALID_3DTEXT_ID)
	            	Player(playerid, player_pick_tag)[ pickid ] = CreatePlayer3DTextLabel(playerid, str, COLOR_PURPLE, Pickup(pickid, pick_pos)[ 0 ], Pickup(pickid, pick_pos)[ 1 ], Pickup(pickid, pick_pos)[ 2 ], 20.0);
				else
				    UpdatePlayer3DTextLabelText(playerid, Player(playerid, player_pick_tag)[ pickid ], COLOR_PURPLE, str);
			#endif
		}
		return 1;
	}
	FuncPub::UnLoadPickupTextDraw(playerid)
	{
		for(new pickid; pickid < MAX_PICKUPS; pickid++)
		{
			if(!Pickup(pickid, pick_uid)) continue;
			#if STREAMER
			    if(Player(playerid, player_pick_tag)[ pickid ] == Text3D:INVALID_3DTEXT_ID) continue;
	            DestroyDynamic3DTextLabel(Player(playerid, player_pick_tag)[ pickid ]);
	            Player(playerid, player_pick_tag)[ pickid ] = Text3D:INVALID_3DTEXT_ID;
			#else
	            if(Player(playerid, player_pick_tag)[ pickid ] == PlayerText3D:INVALID_3DTEXT_ID) continue;
	            DeletePlayer3DTextLabel(playerid, Player(playerid, player_pick_tag)[ pickid ]);
	            Player(playerid, player_pick_tag)[ pickid ] = PlayerText3D:INVALID_3DTEXT_ID;
            #endif
		}
		return 1;
	}
#endif

public OnPlayerPickUpPickup(playerid, pickupid)
{
	new pick;
	for(; pick != MAX_PICKUPS; pick++)
	    if(Pickup(pick, pick_pickID) == pickupid && Pickup(pick, pick_uid))
	        break;
	if(pick == MAX_PICKUPS) return 1;
	
	switch(Pickup(pick, pick_func))
	{
	    case pick_func_weapon:
		{
			for(new x; x != sizeof ObjectModel; x++)
		    {
		        if(Pickup(pick, pick_model) == ObjectModel[ x ])
		        {
		            GivePlayerWeaponEx(playerid, x, 30);
		            break;
		        }
		    }
		}
	}
	return 1;
}

FuncPub::Pickup_Timer(playerid)
{
	new pick;
	for(; pick != MAX_PICKUPS; pick++)
		if(IsPlayerInRangeOfPoint(playerid, 3.0, Pickup(pick, pick_pos)[ 0 ], Pickup(pick, pick_pos)[ 1 ], Pickup(pick, pick_pos)[ 2 ]) && Pickup(pick, pick_uid))
	    	break;
	if(pick == MAX_PICKUPS) return 1;
	if(Player(playerid, player_pickup) == pick) return 1;
	    	
    switch(Pickup(pick, pick_func))
	{
	    case pick_func_repair:
	    {
	        new carid = GetPlayerVehicleID(playerid);
	        if(!carid) return 1;
	        Player(playerid, player_pickup) = pick;
	        PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
	        SetTimerEx("DisPick", 3000, false, "d", playerid);
	        
	        Vehicle(carid, vehicle_ac) = true;
	        Vehicle(carid, vehicle_hp) = 1000.0;
	        SetVehicleHealth(Vehicle(carid, vehicle_carid), Vehicle(carid, vehicle_hp));
	        RepairVehicle(carid);
	        SetTimerEx("EnableAnty", 2000, false, "d", carid);
	    }
	    case pick_func_nitro:
	    {
	        new carid = GetPlayerVehicleID(playerid);
	        if(!carid) return 1;
	        Player(playerid, player_pickup) = pick;
	        PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
	        SetTimerEx("DisPick", 3000, false, "d", playerid);

	        AddVehicleComponent(carid, 1009);
	        Player(playerid, player_nitro) += 10.0;
	        if(Player(playerid, player_nitro) > 100.0)
	            Player(playerid, player_nitro) = 100.0;
	    }
	    case pick_func_hunter:
	    {
	        if(Player(playerid, player_pickup) == -2) return 1;
	        AddRecord(playerid, top_race, floatdiv(GetTickCount() - Game(game_time_start), 1000));
	        Player(playerid, player_pickup) = -2;
	        PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
	        SetTimerEx("DisPick", 3000, false, "d", playerid);
	    }
	    case pick_func_health:
		{
			SetPlayerHealth(playerid, Player(playerid, player_hp) += randomEx(10, 30));
			
			new map = Pickup(pick, pick_mapID);
			DestroyPickup(pick);
			if(map) DestroyDynamicMapIcon(map);
			#if STREAMER
				if(Player(playerid, player_pick_tag)[ pick ] != Text3D:INVALID_3DTEXT_ID)
				    DestroyDynamic3DTextLabel(Player(playerid, player_pick_tag)[ pick ]);
			#else
			    if(Player(playerid, player_pick_tag)[ pick ] != PlayerText3D:INVALID_3DTEXT_ID)
					DeleteDeletePlayer3DTextLabel(playerid, Player(playerid, player_pick_tag)[ pick ]);
			#endif
			
			for(new ePickup:i; i < ePickup; i++)
	    		Pickup(pick, i) = 0;
	    		
	    	if(map)
	    	{
				for(new eMapIcon:i; i < eMapIcon; i++)
		    		Map(map, i) = 0;
			}
		}
    }
	return 1;
}

FuncPub::DisPick(playerid)
{
    Player(playerid, player_pickup) = -1;
	return 1;
}
