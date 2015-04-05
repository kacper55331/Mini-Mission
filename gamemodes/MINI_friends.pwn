FuncPub::LoadPlayerFriends(playerid)
{
    #if !Forum
        return 1;
	#endif
	if(Player(playerid, player_guid) == -1) return 1;
	new string[ 320 ];
	#if Forum
		format(string, sizeof string,
			"SELECT DISTINCT o.ID, g.members_display_name FROM `all_online` o, `mini_players` p, `"IN_PREF"profile_friends` f, `"IN_PREF"members` g WHERE o.player = p.uid AND g.member_id = p.guid AND f.friends_member_id = p.guid AND f.friends_friend_id = '%d' AND o.type = '"#type_mini"' AND f.friends_approved = '1'",
			Player(playerid, player_guid)
		);
	#endif
	mysql_query(string);
	mysql_store_result();
	if(mysql_num_rows())
	{
		while(mysql_fetch_row(string))
		{
		    static id,
		        name[ 32 ],
				str[ 80 ];

			sscanf(string, "p<|>ds[32]",
				id,
				name
			);

			format(str, sizeof str, "~y~~h~%s~n~~w~dolaczyl do gry!", Player(playerid, player_gname));
			PlayerTextDrawSetString(id, Player(id, player_td_friend), str);
			PlayerTextDrawShow(id, Player(id, player_td_friend));
			if(Audio_IsClientConnected(id)) Audio_Play(id, info_sound);

			Player(id, player_friends)[ playerid ] = true;
			Player(playerid, player_friends)[ id ] = true;
			UpdatePlayerNick(id);
			UpdatePlayerNick(playerid);

			if(Player(id, player_friends))
				KillTimer(Player(id, player_friends_timer));
			Player(id, player_friends_timer) = SetTimerEx("HideFriend", 5000, 0, "d", id);
		}
	}
	mysql_free_result();
	return 1;
}

FuncPub::HideFriend(playerid)
{
	PlayerTextDrawHide(playerid, Player(playerid, player_td_friend));
	Player(playerid, player_friends_timer) = 0;
	return 1;
}
