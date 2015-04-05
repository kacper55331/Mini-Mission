public OnPlayerClickMap(playerid, Float:fX, Float:fY, Float:fZ)
{
    if(!Player(playerid, player_adminlvl)) return 1;
    #if mapandreas
    	MapAndreas_FindZ_For2DCoord(fX, fY, fZ);
    #endif
    SetPlayerPos(playerid, fX, fY, fZ);
    SetPlayerInterior(playerid, 0);
    return 1;
}

FuncPub::AntyCheat(playerid)
{
	if(IsPlayerNPC(playerid)) return 1;

	new Float:HP, Float: Armour;
	new reason[ 126 ], string[ 256 ];
	GetPlayerHealth(playerid, HP);
	GetPlayerArmour(playerid, Armour);
	
	// --- Anty Money Hack --- //
	if(GetPlayerMoney(playerid) != Player(playerid, player_cash))
		SetPlayerMoney(playerid, Player(playerid, player_cash));

	// --- Anty Health Hack --- //
	if(HP > Player(playerid, player_hp))
		SetPlayerHealth(playerid, Player(playerid, player_hp));

	// --- Anty Armour Hack --- //
	if(Armour > Player(playerid, player_armour))
	    SetPlayerArmour(playerid, Player(playerid, player_armour));

	new carid = GetPlayerVehicleID(playerid), Float:vehHP;
	if(carid > 0)
	{
	    // --- Anty Vehicle God --- //
        GetVehicleHealth(carid, vehHP);
        new Float:amount = (Vehicle(carid, vehicle_hp) - vehHP);
        if(amount < -10)
        {
            if(Vehicle(carid, vehicle_ac))
            {
				SetVehicleHealth(carid, Vehicle(carid, vehicle_hp) = 1000.0);
                Vehicle(carid, vehicle_ac) = false;
            }
            else
            {
		        format(reason, sizeof reason,
					"VehGod, naprawa pojazdu o %.2fj HP.",
					amount * -1
				);
				format(string, sizeof string,
					"~>~ Kick ~<~ ~r~%s ~w~zostal wyrzucony przez ~r~System~w~. ~w~Powod: ~r~%s",
					NickName(playerid),
					reason
				);
				//ShowKara(playerid, string);
				//Logs(-1, playerid, reason, kara_kick, -1);
				SetTimerEx (!#kickPlayer, 249, false, !"i", playerid);
				printf("[AC] Vehicle God, vhp: %f / ghp: %f", Vehicle(carid, vehicle_hp), vehHP);
				Vehicle(carid, vehicle_hp) = vehHP;
				SetVehicleHealth(carid, Vehicle(carid, vehicle_hp));
			}
        }
	}
	return 1;
}

FuncPub::AntyCheatVehicle()
{
	for(new carid; carid < MAX_VEHICLES; carid++)
	{
	    if(!Vehicle(carid, vehicle_uid)) continue;
	    if(!Vehicle(carid, vehicle_carid)) continue;
    	if(Vehicle(carid, vehicle_ac)) continue;
    	
        new Float:vehHP;
        GetVehicleHealth(carid, vehHP);
        new Float:amount = (Vehicle(carid, vehicle_hp) - vehHP);
        if(amount > 0)
        {
            /*foreach(Player, i)
            {
                if(GetPlayerVehicleID(i) != carid) continue;
            	//OnVehicleLoseHP(i, amount);
			}*/
			Vehicle(carid, vehicle_hp) = vehHP;
			//GetVehicleDamageStatus(Vehicle(carid, vehicle_vehID), Vehicle(carid, vehicle_damage)[ 0 ], Vehicle(carid, vehicle_damage)[ 1 ], Vehicle(carid, vehicle_damage)[ 2 ], Vehicle(carid, vehicle_damage)[ 3 ]);
        }
	}
	return 1;
}

FuncPub::EnableAnty(vehid)
{
    Vehicle(vehid, vehicle_ac) = false;
	return 1;
}

Cmd::Input->admins(playerid, params[]) return cmd_a(playerid, params);
Cmd::Input->a(playerid, params[])
{
	new string[ 512 ];
	foreach(Player, i)
	{
	    if(!Player(i, player_adminlvl)) continue;

	    if(isnull(AdminLvl[ Player(i, player_adminlvl) ][ admin_tag ]))
			format(string, sizeof string, "%s%d\t{%06x}%s%s\t"white"%s\n",
				string,
				i,
				AdminLvl[ Player(i, player_adminlvl) ][ admin_color ] >>> 8,
				AdminLvl[ Player(i, player_adminlvl) ][ admin_name ],
				("\t"),// Player(i, player_adminlvl) == 5 ? ("") : ("\t"),
				NickName(i)
			);
	    else
			format(string, sizeof string, "%s%d\t{%06x}%s\t\t"white"%s (%s)\n",
				string,
				i,
				AdminLvl[ Player(i, player_adminlvl) ][ admin_color ] >>> 8,
				AdminLvl[ Player(i, player_adminlvl) ][ admin_name ],
				NickName(i),
				AdminLvl[ Player(i, player_adminlvl) ][ admin_tag ]
			);
	}
	if(isnull(string)) ShowInfo(playerid, red"Nie ma ¿adnego administratora online.");
	else
	{
	    format(string, sizeof string, grey"ID:\tRanga:\t\t\tNick:\n%s", string);
		ShowList(playerid, string);
	}
	return 1;
}
