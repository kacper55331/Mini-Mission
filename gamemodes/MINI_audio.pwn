public Audio_OnClientConnect(playerid)
{
	#if Debug
	    printf("Audio_OnClientConnect(%d)", playerid);
	#endif

	Audio_TransferPack(playerid);
	KillTimer(Player(playerid, player_audio_timer));
	CheckAudioPlugin(playerid);
	return 1;
}

FuncPub::CheckAudioPlugin(playerid)
{
    if(!Player(playerid, player_play) || !Player(playerid, player_logged))
    {
        if(Player(playerid, player_connect_audio)) return 1;
		if(Audio_IsClientConnected(playerid))
			Player(playerid, player_connect_audio) = Audio_PlayStreamed(playerid, Setting(setting_url));
		else
			Player(playerid, player_connect_audio) = PlayAudioStreamForPlayer(playerid, Setting(setting_url));
	}
	else
	{
		if(!Player(playerid, player_connect_audio)) return 1;
	    if(Audio_IsClientConnected(playerid))
	        Audio_Stop(playerid, Player(playerid, player_connect_audio));
	    else
	    	StopAudioStreamForPlayer(playerid);
    	Player(playerid, player_connect_audio) = 0;
	}
	return 1;
}

public Audio_OnTransferFile(playerid, file[], current, total, result)
{
	if(current == total)
	    GameTextForPlayer(playerid, "~g~Plugin audio zaladowany!", 3000, 3);
	return 1;
}
