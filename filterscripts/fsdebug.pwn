#include <a_samp>

new playerlvl[ MAX_PLAYERS ] = {0, ...};
new score[ ][ 2 ] = {
	{ 1, 0 },
	{ 2, 10 },
	{ 3, 50 },
	{ 4, 100 },
	{ 5, 150 }
};

public OnFilterScriptInit()
{
	SetTimer("CheckScore", 1000, true);
	return 1;
}

forward CheckScore();
public CheckScore()
{
	for(new playerid = 0, max_players = GetMaxPlayers(); playerid != max_players; playerid++)
	{
		if(!IsPlayerConnected(playerid)) continue;
		for(new sc = 0; sc != sizeof score; sc++)
		{
			if(playerlvl[ playerid ] < score[ sc ][ 0 ]) continue;
			if(GetPlayerScore(playerid) >= score[ sc ][ 1 ])
			{
				playerlvl[ playerid ] = score[ sc ][ 0 ];
				
				new string[ 126 ];
				format(string, sizeof string, "Gracz %d osi¹gn¹³ %d lvl!", playerid, playerlvl[ playerid ]);
				SendClientMessageToAll(0, string);
				print(string);
			}
		}
	}
	return 1;
}
