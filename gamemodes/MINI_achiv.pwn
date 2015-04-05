stock bool:GetPlayerAchiv(playerid, achiv_type)
{
	if(Player(playerid, player_achiv) & achiv_type)
		return true;
	return false;
}

FuncPub::GivePlayerAchiv(playerid, achiv_type)
{
	if(GetPlayerAchiv(playerid, achiv_type))
		return 0;
	
	Player(playerid, player_achiv) += achiv_type;
	Audio_Play(playerid, achiv_sound);
	
	new string[ 100 ];
	format(string, sizeof string, 
		"INSERT INTO `all_achiv` VALUES (NULL, '%d', '%d', UNIX_TIMESTAMP(), '"#type_mini"')",
		Player(playerid, player_uid),
		achiv_type
	);
	mysql_query(string);

	new id;
	for(; id != sizeof AchivData; id++)
	    if(AchivData[ id ][ 0 ] == achiv_type)
	        break;

	if(id == sizeof AchivData) return 1;
	
	Player(playerid, player_exp) += AchivData[ id ][ 1 ];
	
	format(string, sizeof(string),
		"~w~ODBLOKOWANO OSIAGNIECIE~n~%s%dEXP - %s",
		AchivData[ id ][ 1 ] <= 0 ? ("~r~") : ("~y~~h~"),
		AchivData[ id ][ 1 ],
		AchivDataName[ Player(playerid, player_lang) ][ id ]
	);
 	PlayerTextDrawSetString(playerid, Player(playerid, player_td_achiv), string);
 	PlayerTextDrawShow(playerid, Player(playerid, player_td_achiv));
 	TextDrawShowForPlayer(playerid, Setting(setting_td_achiv)[ 0 ]);
 	TextDrawShowForPlayer(playerid, Setting(setting_td_achiv)[ 1 ]);

 	if(Player(playerid, player_achiv_timer))
 		KillTimer(Player(playerid, player_achiv_timer));
 	Player(playerid, player_achiv_timer) = SetTimerEx("HideAchiv", 5000, false, "d", playerid);
	return 1;
}

FuncPub::HideAchiv(playerid)
{
 	PlayerTextDrawHide(playerid, Player(playerid, player_td_achiv));
 	TextDrawHideForPlayer(playerid, Setting(setting_td_achiv)[ 0 ]);
 	TextDrawHideForPlayer(playerid, Setting(setting_td_achiv)[ 1 ]);
 	Player(playerid, player_achiv_timer) = 0;
	return 1;
}

FuncPub::DeletePlayerAchiv(playerid, achiv_type)
{
	if(!GetPlayerAchiv(playerid, achiv_type))
		return 0;

	Player(playerid, player_achiv) -= achiv_type;
	
	new string[ 100 ];
	format(string, sizeof string,
		"DELETE FROM `all_achiv` WHERE `player` = '%d' AND `type` = '%d' AND `server` = '"#type_mini"'",
		Player(playerid, player_uid),
		achiv_type
	);
	mysql_query(string);
	return 1;
}
