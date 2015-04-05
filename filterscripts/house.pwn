/*
- MapIcony na minimapce (Zielony domek[KUPNO] , Czerwony domek[ZAJÊTY])
- Kupuj¹c domek p³acimy tylko raz(Nie p³acimy ¿adnego czynszu)
- Mo¿liwoœæ ustawienia has³a do domku (brak has³a = otwarty dom)
- Mo¿liwoœæ zmiany wnêtrza domu
- Nad pickupem do wejœcia 3dtext kto jest w³aœcicielem domu np.
	W³aœciciel: Kuba (Dom do kupna 3dtext: Dom na sprzeda¿\n Cena %d)
- Chcia³bym by przy ka¿dym wyjœciu z interiora (domu) automatycznie
	po stworzeniu domu tworzy³ siê pickup je¿eli w niego wejdziemy wpisujemy /wyjdz
- Wszystko w GUI
- U¿ycie: ZCMD, SSCANF, STREAMER i jeœli potrzeba FOREACH.
*/
#define FILTERSCRIPT
#define _YSI_NO_VERSION_CHECK
#define debug
#include <YSI\y_ini>
#include <zcmd>
#include <sscanf2>
#include <streamer>

#if !defined dli
	#define dli(%1,%2,%3,%4) 	((%1==1)?(%2):(((%1% 10>1)&&(%1% 10<5)&&!((%1% 100>=10)&&(%1% 100<=21)))?(%3):(%4)))
#endif
#if !defined isnull
	#define isnull(%1) 			((!(%1[0])) || (((%1[0]) == '\1') && (!(%1[1]))))
#endif

#define FuncPub::%1(%2)		forward %1(%2);public %1(%2)
#define House(%1,%2)    	HouseData[%1][%2]
#define Int(%1,%2)          InteriorData[%1][%2]
#define Cmd::Input->%1(%2)  COMMAND:%1(%2)
#define Chat::Output        SendClientMessage
#define Dialog::Output		ShowPlayerDialog

#define MAX_HOUSE   		200
#define MAX_INTERIOR_NAME   32
#define MAX_PASSWD      	32
#define dialog_id           555

#define INVALID_HOUSE_ID    -1
#define INVALID_FILE_ID     MAX_HOUSE+1

enum eHouse {
	h_price,
	h_owner[ MAX_PLAYER_NAME ],
	h_passwd[ MAX_PASSWD ],
	h_in[ 2 ], // int, vw
	Float:h_in_pos[ 3 ], // x, y, z
	
	h_out[ 2 ], // int, vw
	Float:h_out_pos[ 3 ], // x, y, z
	
	Text3D:h_text,
	h_pickup,
	h_file_id = INVALID_FILE_ID,
	h_mapicon,
}

enum eInterior {
	i_name[ MAX_INTERIOR_NAME ],
	i_int,
 	Float:i_pos_x,
	Float:i_pos_y,
	Float:i_pos_z,
}

new HouseData[ MAX_HOUSE ][ eHouse ], playerhouse[ MAX_PLAYERS ];

new const InteriorData[ ][ eInterior ] = {
	{"Safe House", 5, 2233.69, -1112.81, 1050.88},
	{"Johnson House", 3, 2496.05, -1695.17, 1014.74}
};

public OnFilterScriptInit()
{
	LoadHouse();
	return 1;
}

public OnFilterScriptExit()
{
    for(new i = 1; i != MAX_HOUSE; i++)
    {
        SaveHouse(i);
    }
	return 1;
}

public OnPlayerConnect(playerid)
{
    playerhouse[ playerid ] = INVALID_HOUSE_ID;
    return 1;
}

FuncPub::LoadHouse()
{
	new path[ 32 ],
		loaded = 0;
    for(new i = 1; i != MAX_HOUSE; i++)
	{
        format(path, sizeof path, "House/%d.ini", i);
        if(!fexist(path)) continue;
        INI_ParseFile(path, "LoadHouseFromFile", .bExtra = true, .extra = i);
        House(i, h_file_id) = i;
        House(i, h_text) = Text3D:INVALID_3DTEXT_ID;
        UpdateHouse(i);
        loaded++;
	}
	printf("# Wczytano %d %s.", loaded, dli(loaded, "dom", "domy", "domów"));
	return 1;
}

FuncPub::LoadHouseFromFile(i, name[], value[])
{
	INI_Int("price", House(i, h_price));
	INI_String("owner", House(i, h_owner), MAX_PLAYER_NAME); 
    INI_String("passwd", House(i, h_passwd), MAX_PASSWD); 
    INI_Int("out_int", House(i, h_out)[ 0 ]); 
    INI_Int("out_vw", House(i, h_out)[ 1 ]); 
    INI_Float("out_x", House(i, h_out_pos)[ 0 ]); 
    INI_Float("out_y", House(i, h_out_pos)[ 1 ]); 
    INI_Float("out_z", House(i, h_out_pos)[ 2 ]); 
    INI_Int("in_int", House(i, h_in)[ 0 ]); 
    INI_Int("in_vw", House(i, h_in)[ 1 ]); 
    INI_Float("in_x", House(i, h_in_pos)[ 0 ]); 
    INI_Float("in_y", House(i, h_in_pos)[ 1 ]); 
    INI_Float("in_z", House(i, h_in_pos)[ 2 ]); 
	return 0;
}

FuncPub::SaveHouse(i)
{
	new path[ 32 ];
	if(House(i, h_file_id) == INVALID_FILE_ID) GetAvailableFileID();
	
    format(path, sizeof path, "House/%d.ini", House(i, h_file_id));
    new INI:handle = INI_Open(path);
	INI_WriteInt(handle, "price", House(i, h_price));
	INI_WriteString(handle, "owner", House(i, h_owner));
    INI_WriteString(handle, "passwd", House(i, h_passwd));
    INI_WriteInt(handle, "out_int", House(i, h_out)[ 0 ]);
    INI_WriteInt(handle, "out_vw", House(i, h_out)[ 1 ]);
    INI_WriteFloat(handle, "out_x", House(i, h_out_pos)[ 0 ]);
    INI_WriteFloat(handle, "out_y", House(i, h_out_pos)[ 1 ]);
    INI_WriteFloat(handle, "out_z", House(i, h_out_pos)[ 2 ]);
    INI_WriteInt(handle, "in_int", House(i, h_in)[ 0 ]);
    INI_WriteInt(handle, "in_vw", House(i, h_in)[ 1 ]);
    INI_WriteFloat(handle, "in_x", House(i, h_in_pos)[ 0 ]);
    INI_WriteFloat(handle, "in_y", House(i, h_in_pos)[ 1 ]);
    INI_WriteFloat(handle, "in_z", House(i, h_in_pos)[ 2 ]);
    INI_Close(handle);
	return 1;
}

FuncPub::UpdateHouse(houseid)
{
	if(House(houseid, h_out_pos)[ 0 ] == 0.0 && House(houseid, h_out_pos)[ 1 ] == 0.0 && House(houseid, h_out_pos)[ 2 ] == 0.0)
	    return 1;
	#if defined debug
		printf("UpdateHouse(%d)", houseid);
	#endif
	new buffer[ 126 ];
	if(isnull(House(houseid, h_owner)))
    {
        format(buffer, sizeof buffer,
			"Dom na sprzeda¿\nCena: %d",
			House(houseid, h_price)
		);
    }
    else
    {
        format(buffer, sizeof buffer,
			"W³aœciciel: %s",
			House(houseid, h_owner)
		);
    }
	if(House(houseid, h_text) == Text3D:INVALID_3DTEXT_ID)
		House(houseid, h_text) = Create3DTextLabel(buffer, -1, House(houseid, h_out_pos)[ 0 ], House(houseid, h_out_pos)[ 1 ], House(houseid, h_out_pos)[ 2 ], 20.0, 0);
	else
		Update3DTextLabelText(House(houseid, h_text), -1, buffer);

	if(!House(houseid, h_mapicon))
		House(houseid, h_mapicon) = CreateDynamicMapIcon(House(houseid, h_out_pos)[ 0 ], House(houseid, h_out_pos)[ 1 ], House(houseid, h_out_pos)[ 2 ], isnull(House(houseid, h_owner)) ? 31 : 32, 0);
	
	if(!House(houseid, h_pickup))
		House(houseid, h_pickup) = CreatePickup(isnull(House(houseid, h_owner)) ? 1273 : 1239, 2, House(houseid, h_out_pos)[ 0 ], House(houseid, h_out_pos)[ 1 ], House(houseid, h_out_pos)[ 2 ]);

	SaveHouse(houseid);
	return 1;
}

stock GetPlayerHouse(playerid)
{
	for(new i = 1; i != MAX_HOUSE; i++)
		if(IsPlayerInRangeOfPoint(playerid, 5.0, House(i, h_out_pos)[ 0 ], House(i, h_out_pos)[ 1 ], House(i, h_out_pos)[ 2 ]) || (GetPlayerInterior(playerid) == House(i, h_in)[ 0 ] && GetPlayerVirtualWorld(playerid) == House(i, h_in)[ 1 ] && GetPlayerInterior(playerid) != 0))
			return i;
	return INVALID_HOUSE_ID;
}

stock NickName(playerid)
{
	new name[ MAX_PLAYER_NAME ];
	GetPlayerName(playerid, name, sizeof name);
	return name;
}

stock GetAvailableFileID()
{
    new path[ 32 ];
    for(new i = 1; i<MAX_HOUSE; i++)
    {
        format(path, sizeof(path), "House/%d.ini", i);
        if(!fexist(path)) return i;
    }
    return 0;
}
#if defined debug
	Cmd::Input->t(playerid, params[])
	{
		new i = strval(params);
		if(!i) return Chat::Output(playerid, -1, "Nie ma takiego domu.");
		SetPlayerPos(playerid, House(i, h_out_pos)[ 0 ], House(i, h_out_pos)[ 1 ], House(i, h_out_pos)[ 2 ]);
		SetPlayerScore(playerid, 9999);
		return 1;
	}
#endif

Cmd::Input->stworz(playerid, params[])
{
	new houseid = GetAvailableFileID();
	if(!houseid) return Chat::Output(playerid, -1, "Wykorzystano limit domów.");
	new Float:pos[ 3 ], int, vw;
	vw = GetPlayerVirtualWorld(playerid);
	int = GetPlayerInterior(playerid);
	GetPlayerPos(playerid, pos[ 0 ], pos[ 1 ], pos[ 2 ]);
	
	House(houseid, h_price) = strval(params);
	House(houseid, h_out_pos)[ 0 ] = pos[ 0 ];
	House(houseid, h_out_pos)[ 1 ] = pos[ 1 ];
	House(houseid, h_out_pos)[ 2 ] = pos[ 2 ];
	House(houseid, h_out)[ 0 ] = int;
	House(houseid, h_out)[ 1 ] = vw;
	House(houseid, h_text) = Text3D:INVALID_3DTEXT_ID;
	House(houseid, h_file_id) = houseid;
    UpdateHouse(houseid);
    Chat::Output(playerid, -1, "Dom stworzony.");
	return 1;
}

Cmd::Input->usun(playerid, params[])
{
	new i = strval(params), path[ 32 ];
    format(path, sizeof path, "House/%d.ini", i);
	if(!i) return Chat::Output(playerid, -1, "Tip: /usun [id]");
	if(!fexist(path)) return Chat::Output(playerid, -1, "Nie znaleziono takiego pliku.");

	DestroyDynamicMapIcon(House(i, h_mapicon));
	DestroyPickup(House(i, h_pickup));
	Delete3DTextLabel(House(i, h_text));
    for(new eHouse:d; d < eHouse; d++)
    	House(i, d) = 0;
    House(i, h_file_id) = INVALID_FILE_ID;
    fremove(path);
    Chat::Output(playerid, -1, "Dom skasowany.");
	return 1;
}

Cmd::Input->dom(playerid, params[])
{
	new i = GetPlayerHouse(playerid);
	if(i == INVALID_HOUSE_ID)
	{
	    playerhouse[ playerid ] = INVALID_HOUSE_ID;
		Chat::Output(playerid, -1, "Nie jesteœ przy ¿adnym domu!");
	    return 1;
	}
	
	new string[ 256 ], head[ 32 ];
    if(IsPlayerInRangeOfPoint(playerid, 5.0, House(i, h_out_pos)[ 0 ], House(i, h_out_pos)[ 1 ], House(i, h_out_pos)[ 2 ]))
    	strcat(string, "WejdŸ\n");
	else if(IsPlayerInRangeOfPoint(playerid, 5.0, House(i, h_in_pos)[ 0 ], House(i, h_in_pos)[ 1 ], House(i, h_in_pos)[ 2 ]))
        strcat(string, "WyjdŸ\n");

	if(isnull(House(i, h_owner)))
	{
	    strcat(string, "Kup\n");
	}
	else
	{
	    if(!strcmp(House(i, h_owner), NickName(playerid), false))
	    {
			strcat(string, "Ustaw has³o\n");
			strcat(string, "Zmieñ interior\n");
			strcat(string, "Sprzedaj\n");
		}
	}
	playerhouse[ playerid ] = i;
	format(head, sizeof head, "Dom -> %d", i);
	Dialog::Output(playerid, dialog_id, DIALOG_STYLE_LIST, head, string, "Wybierz", "Zamknij");
	return 1;
}

FuncPub::EnterHouse(playerid, houseid)
{
    playerhouse[ playerid ] = houseid;
	SetPlayerPos(playerid, House(houseid, h_in_pos)[ 0 ], House(houseid, h_in_pos)[ 1 ], House(houseid, h_in_pos)[ 2 ]);
	SetPlayerVirtualWorld(playerid, House(houseid, h_in)[ 1 ]);
	SetPlayerInterior(playerid, House(houseid, h_in)[ 0 ]);
	return 1;
}

FuncPub::LeaveHouse(playerid, houseid)
{
    playerhouse[ playerid ] = INVALID_HOUSE_ID;
	SetPlayerPos(playerid, House(houseid, h_out_pos)[ 0 ], House(houseid, h_out_pos)[ 1 ], House(houseid, h_out_pos)[ 2 ]);
	SetPlayerVirtualWorld(playerid, House(houseid, h_out)[ 1 ]);
	SetPlayerInterior(playerid, House(houseid, h_out)[ 0 ]);
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	#if defined debug
		printf("OnDialogResponse(%d, %d, %d, %d, %s)", playerid, dialogid, response, listitem, inputtext);
	#endif
	switch(dialogid)
	{
	    case dialog_id:
	    {
	        if(!response) return 1;
	        new i = playerhouse[ playerid ];
	        if(strfind(inputtext, "WejdŸ", true) != -1)
	        {
	            if(isnull(House(i, h_passwd)))
	            {
	                // WejdŸ
	                EnterHouse(playerid, i);
	            }
	            else
	                Dialog::Output(playerid, dialog_id+1, DIALOG_STYLE_PASSWORD, "Dom -> Has³o", "Podaj has³o, by wejœæ.", "Dalej", "Wróæ");
	        }
	        else if(strfind(inputtext, "WyjdŸ", true) != -1)
	        {
	        	LeaveHouse(playerid, i);
	        }
	        else if(strfind(inputtext, "Kup", true) != -1)
	        {
	            if(GetPlayerScore(playerid) < House(i, h_price))
	                return Chat::Output(playerid, -1, "Nie staæ Ciê na zakup tego domu!");

				SetPlayerScore(playerid, GetPlayerScore(playerid) - House(i, h_price));
				format(House(i, h_owner), MAX_PLAYER_NAME, NickName(playerid));
				DestroyDynamicMapIcon(House(i, h_mapicon)); House(i, h_mapicon) = 0;
				DestroyPickup(House(i, h_pickup)); House(i, h_pickup) = 0;
				UpdateHouse(i);
				
				Chat::Output(playerid, -1, "Dom kupiony, teraz nale¿y do Ciebie.");
	        }
	        else if(strfind(inputtext, "Ustaw has³o", true) != -1)
	        {
	            Dialog::Output(playerid, dialog_id+2, DIALOG_STYLE_INPUT, "Dom -> Ustaw has³o", "Podaj has³o, które bêdzie zabezpiecza³o Twój dom", "Dalej", "Wróæ");
	        }
	        else if(strfind(inputtext, "Sprzedaj", true) != -1)
	        {
	            SetPlayerScore(playerid, GetPlayerScore(playerid) + House(i, h_price));
				format(House(i, h_owner), MAX_PLAYER_NAME, "");
				DestroyDynamicMapIcon(House(i, h_mapicon)); House(i, h_mapicon) = 0;
				DestroyPickup(House(i, h_pickup)); House(i, h_pickup) = 0;
				UpdateHouse(i);
				
				Chat::Output(playerid, -1, "Dom sprzedany, teraz nie nale¿y do Ciebie.");
	        }
	        else if(strfind(inputtext, "Zmieñ interior", true) != -1)
	        {
	            new buffer[ 512 ];
	            for(new int; int != sizeof InteriorData; int++)
	            	format(buffer, sizeof buffer, "%s%d\t%s\n", buffer, int, Int(int, i_name));

	            Dialog::Output(playerid, dialog_id+3, DIALOG_STYLE_LIST, "Dom -> Ustaw interior", buffer, "Wybierz", "Wróæ");
			}
	    }
	    
	    // passwd
	    case dialog_id+1:
	    {
	        if(!response) return cmd_dom(playerid, "");
	        new i = playerhouse[ playerid ];
	        if(!strcmp(House(i, h_passwd), inputtext, false))
	        {
	            EnterHouse(playerid, i);
	        }
	        else Dialog::Output(playerid, dialog_id+1, DIALOG_STYLE_PASSWORD, "Dom -> Has³o", "Podaj has³o, by wejœæ.\n\nB³êdne has³o", "Dalej", "Wróæ");
	    }
	    
	    // Zmiana has³a
	    case dialog_id+2:
	    {
	        if(!response) return cmd_dom(playerid, "");
	        new i = playerhouse[ playerid ];
			format(House(i, h_passwd), MAX_PASSWD, inputtext);
			UpdateHouse(i);
	        if(isnull(House(i, h_passwd)))
	            Chat::Output(playerid, -1, "Has³o zresetowane. Dom otwarty!");
	        else
	        {
	            new string[ 64 ];
				format(string, sizeof string, "Has³o ustawione poprawnie! Nowe has³o: %s", House(i, h_passwd));
	            Chat::Output(playerid, -1, string);
	        }
	    }
	    
	    // Zmiana inta
	    case dialog_id+3:
	    {
	        if(!response) return cmd_dom(playerid, "");
	        new i = playerhouse[ playerid ];
	        new int = strval(inputtext);
	        
	        House(i, h_in_pos)[ 0 ] = Int(int, i_pos_x);
	        House(i, h_in_pos)[ 1 ] = Int(int, i_pos_y);
	        House(i, h_in_pos)[ 2 ] = Int(int, i_pos_z);
	        House(i, h_in)[ 0 ] = Int(int, i_int);
	        
	        new string[ 64 ];
			format(string, sizeof string, "Interior zmieniony na: %s", Int(int, i_name));
	       	Chat::Output(playerid, -1, string);
	       	
            UpdateHouse(i);
	    }
	}
	return 1;
}
