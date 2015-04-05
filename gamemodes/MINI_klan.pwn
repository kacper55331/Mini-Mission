FuncPub::LoadKlan(playerid)
{
	if(!Klan(playerid, klan_uid)) return 1;
	new string[ 100 ];
	format(string, sizeof string,
	    "SELECT `name`, `color`, IFNULL(`tag`, 'Brak') FROM `mini_klan` WHERE `uid` = '%d'",
	    Klan(playerid, klan_uid)
	);
	mysql_query(string);
	mysql_store_result();
	if(mysql_num_rows())
	{
		mysql_fetch_row(string);
		mysql_free_result();
		sscanf(string, "p<|>s[32]xs[5]",
		    Klan(playerid, klan_name),
		    Klan(playerid, klan_color),
			Klan(playerid, klan_tag)
		);
		
		if(!Klan(playerid, klan_rank)) return 1;
		format(string, sizeof string,
	    	"SELECT `lvl`, `name` FROM `mini_ranks` WHERE `uid` = '%d'",
	    	Klan(playerid, klan_rank)
		);
		mysql_query(string);
		mysql_store_result();
		if(mysql_num_rows())
		{
		    mysql_fetch_row(string);
		    mysql_free_result();
			sscanf(string, "p<|>ds[32]",
				Klan(playerid, klan_ranklvl),
				Klan(playerid, klan_rankname)
			);
		}
		else Klan(playerid, klan_rank) = 0;
	}
	else
	{
		Klan(playerid, klan_uid) = 0;
		Klan(playerid, klan_rank) = 0;
	}
	return 1;
}

stock GiveKlanExp(klanuid, exp)
{
	if(!klanuid) return false;
	if(!exp) return false;
	new string[ 126 ];
	format(string, sizeof string,
	    "UPDATE `mini_klan` SET `points` = `points` + '%d' WHERE `uid` = '%d'",
	    exp,
	    klanuid
	);
	mysql_query(string);
	
	foreach(Player, i)
	    if(Klan(i, klan_uid) == klanuid)
	    	Klan(i, klan_exp) += exp;
	return true;
}

stock AddKill(klanuid)
{
	new string[ 126 ];
	format(string, sizeof string,
	    "UPDATE `mini_klan` SET `points` = `points` + '%d' WHERE `uid` = '%d'",
	    exp,
	    klanuid
	);
	//mysql_query(string);
}

stock AddDeath(klanuid)
{
	new string[ 126 ];
	format(string, sizeof string,
	    "UPDATE `mini_klan` SET `points` = `points` + '%d' WHERE `uid` = '%d'",
	    exp,
	    klanuid
	);
	//mysql_query(string);
}

Cmd::Input->klan(playerid, params[])
{
	new str1[ 64 ],
		str2[ 64 ];
	if(sscanf(params, "s[64]S()[64]", str1, str2))
		return ShowCMD(playerid, "Tip: /k(lan) [info/online/zapros/wypros/przebierz/opusc]");
	if(!Klan(playerid, klan_uid)) return ShowCMD(playerid, "Nie jesteś w żadnym klanie!");
	if(!strcmp(str1, "info", true))
	{
	    new buffer[ 256 ];
		format(buffer, sizeof buffer, "Nazwa i UID grupy:\t\t\t%s (%d)\n", Klan(playerid, klan_name), Klan(playerid, klan_uid));
		format(buffer, sizeof buffer, "%sTag:\t\t\t\t\t%s\n", buffer, Klan(playerid, klan_tag));
		format(buffer, sizeof buffer, "%sKolor:\t\t\t\t\t{%06x}#%x\n", buffer, Klan(playerid, klan_color) >>> 8, Klan(playerid, klan_color));
		if(Klan(playerid, klan_rank))
		{
			strcat(buffer, grey"------------------------\n");
			format(buffer, sizeof buffer, "%sRanga:\t\t\t\t\t%s (%d)\n", buffer, Klan(playerid, klan_rankname), Klan(playerid, klan_ranklvl));
		}
		Dialog::Output(playerid, 999, DIALOG_STYLE_LIST, IN_HEAD" "white"» "grey"Informacja", buffer, "Okey", "");
	}
	else if(!strcmp(str1, "online", true))
	{
	    new buffer[ 1024 ];
	    format(buffer, sizeof buffer, "{%06x}%s (UID: %d)\n", Klan(playerid, klan_color) >>> 8, Klan(playerid, klan_name), Klan(playerid, klan_uid));
        foreach(Player, i)
        {
            if(Klan(playerid, klan_uid) != Klan(i, klan_uid)) continue;

            if(Player(i, player_afktime)[ 0 ] > 5)
            {
                static string[ 45 ];
                ReturnTimeMega(Player(i, player_afktime)[ 0 ], string, sizeof string);
				format(buffer, sizeof buffer, "%s%d\t%s "red"(AFK: %s)\n", buffer, i, NickName(i), string);
			}
			else
			{
			    if(Klan(i, klan_rank))
					format(buffer, sizeof buffer, "%s%d\t%s (%s)\n", buffer, i, NickName(i), Klan(i, klan_rankname));
				else
					format(buffer, sizeof buffer, "%s%d\t%s\n", buffer, i, NickName(i));
			}
		}
		Dialog::Output(playerid, 999, DIALOG_STYLE_LIST, IN_HEAD" "white"» "grey"Informacja", buffer, "Okey", "");
	}
	else if(!strcmp(str1, "zapros", true))
	{
	
	}
	else if(!strcmp(str1, "wypros", true))
	{
	
	}
	else if(!strcmp(str1, "przebierz", true))
	{
	
	}
	else if(!strcmp(str1, "opusc", true))
	{
	
	}
	return 1;
}
