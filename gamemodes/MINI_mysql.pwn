FuncPub::MySQL_Connect()
{
	mysql_debug(0);
	if(!DOF2_FileExists(IN_BAZA))
	{
		DOF2_CreateFile(IN_BAZA);
		DOF2_SetInt(IN_BAZA, "id", 			1);
	    DOF2_SetString(IN_BAZA, "host1", 	"localhost");
	    DOF2_SetString(IN_BAZA, "user1", 	"root");
	    DOF2_SetString(IN_BAZA, "db1", 		"db");
	    DOF2_SetString(IN_BAZA, "pass1", 	"password");
	    DOF2_SaveFile();
		print("[Serwer] EXIT (reason): Nie znaleziono pliku konfiguracyjnego.");
		print("[Serwer] EXIT (reason): Plik zostal utworzony, ale wymagane jest uzupelnienie go.");
		SendRconCommand("exit");
		return 0;
	}
	new connectstr[ 4 ][ 10 ],
		id;

	id = DOF2_GetInt(IN_BAZA, "id");

	format(connectstr[0], sizeof connectstr[], "host%d", id);
	format(connectstr[1], sizeof connectstr[], "user%d", id);
	format(connectstr[2], sizeof connectstr[], "db%d", id);
	format(connectstr[3], sizeof connectstr[], "pass%d", id);

	Setting(setting_mysql) = mysql_connect(
		DOF2_GetString(IN_BAZA, connectstr[0]),
		DOF2_GetString(IN_BAZA, connectstr[1]),
		DOF2_GetString(IN_BAZA, connectstr[2]),
		DOF2_GetString(IN_BAZA, connectstr[3])
	);
	mysql_debug(1);
	return 1;
}

public OnQueryError(errorid, error[], resultid, extraid, callback[], query[], connectionHandle)
{
	if(errorid == CR_SERVER_LOST || errorid == CR_SERVER_GONE_ERROR)
	{
		print("[MySQL Error]: Utracono polaczenie z baza danych!");
		print("[MySQL Error]: Ponawiam polaczenie!!");
		mysql_reconnect();
		if(mysql_ping() == -1)
		{
			SendRconCommand("mapname ~MySQL Error~");
			print("[MySQL Error]: Brak po³¹czenia z baz¹ danych!");
			mysql_reload();
		}
		else print("[MySQL]: Po³¹czono z baz¹ danych!");
	}
	print("[MySQL Error]:");
	printf("ID: %d", errorid);
	printf("ERROR: %s", error);
	printf("LINE: %s", query);
	return 1;
}
