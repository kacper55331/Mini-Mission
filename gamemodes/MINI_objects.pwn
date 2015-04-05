FuncPub::LoadObjects(game)
{
	new objid, counter, string[ 370 ];
	format(string, sizeof string,
	    "SELECT * FROM `mini_objects` WHERE `gameuid` = '%d'",
	    game
	);
	mysql_query(string);
	mysql_store_result();
	if(mysql_num_rows())
	{
		while(mysql_fetch_row(string))
		{
			#if STREAMER
			    new uid, model,
					Float:pos[ 3 ], Float:rot[ 3 ],
					Float:gate[ 3 ], Float:rgate[ 3 ],
					own;

				new index_mat, index_text,
					color_text, color_mat, bgcolor,
					size, tsize, align, bold, text[ 64 ],
					modelid, txdname[ 32 ],
					texturename[ 32 ], font[ 32 ];

			    sscanf(string, "p<|>d{d}da<f>[3]a<f>[3]a<f>[3]a<f>[3]ddxxxdddds[64]ds[32]s[32]s[32]",
			        uid, model,
			        pos, rot,
			        gate, rgate,
			        own,
			        index_text, index_mat,
					color_text, color_mat,
					bgcolor,
					size, tsize,
					align, bold,
					text, modelid,
					txdname, texturename,
					font
				);
			    objid = CreateDynamicObject(model, pos[ 0 ], pos[ 1 ], pos[ 2 ], rot[ 0 ], rot[ 1 ], rot[ 2 ], game, -1, -1, 1000.0);
                Streamer_SetIntData(STREAMER_TYPE_OBJECT, objid, E_STREAMER_EXTRA_ID, uid);
                
				if(!(DIN(txdname, "NULL")) || !(DIN(texturename, "NULL")))
				    SetDynamicObjectMaterial(objid, index_mat, modelid, txdname, texturename, color_mat);
				if(!(DIN(text, "NULL")))
				    SetDynamicObjectMaterialText(objid, index_text, text, size, font, tsize, bold, color_text, bgcolor, align);

			    if(gate[ 0 ] != 0.0 || gate[ 1 ] != 0.0 || gate[ 2 ] != 0.0 || rgate[ 0 ] != 0.0 || rgate[ 1 ] != 0.0 || rgate[ 2 ] != 0.0)
			    {
		    		if(counter == MAX_OBJECTS) continue;
			        Object(counter, obj_uid) = uid;
			        Object(counter, obj_model) = model;
			        Object(counter, obj_pos) = pos[ 0 ];
			        Object(counter, obj_pos) = pos[ 1 ];
			        Object(counter, obj_pos) = pos[ 2 ];
			        Object(counter, obj_rot) = rot[ 0 ];
			        Object(counter, obj_rot) = rot[ 1 ];
			        Object(counter, obj_rot) = rot[ 2 ];
			        Object(counter, obj_pos_gate)[ 0 ] = gate[ 0 ];
			        Object(counter, obj_pos_gate)[ 1 ] = gate[ 1 ];
			        Object(counter, obj_pos_gate)[ 2 ] = gate[ 2 ];
			        Object(counter, obj_pos_rgate)[ 0 ] = rgate[ 0 ];
			        Object(counter, obj_pos_rgate)[ 1 ] = rgate[ 1 ];
			        Object(counter, obj_pos_rgate)[ 2 ] = rgate[ 2 ];
			        Object(counter, obj_owner) = own;
			        counter++;
			    }
			#else
			    if(objid == MAX_OBJECTS) break;

			    sscanf(string, "p<|>d{d}da<f>[3]a<f>[3]a<f>[3]",
			        Object(objid, obj_uid),
			        Object(objid, obj_model),
			        Object(objid, obj_pos),
			        Object(objid, obj_rot),
			        Object(objid, obj_pos_gate)
				);
				Object(objid, obj_objID) = CreateObject(Object(objid, obj_model), Object(objid, obj_pos)[ 0 ], Object(objid, obj_pos)[ 1 ], Object(objid, obj_pos)[ 2 ], Object(objid, obj_rot)[ 0 ], Object(objid, obj_rot)[ 1 ], Object(objid, obj_rot)[ 2 ]);
			#endif
			objid++;
		}
    	printf("%s# Obiekty wczytane - pomyślnie! | %d/%d", game ? ("\t") : (""), objid - 1, counter);
	}
	else printf("%s# Brak obiektów do wczytania!",  game ? ("\t") : (""));
	mysql_free_result();
	return 1;
}


#if STREAMER
	Cmd::Input->mc(playerid, params[])
	{
        if(!Player(playerid, player_adminlvl))
			return 1;
        
		if(isnull(params))
		    return ShowCMD(playerid, "Tip: /mc [modelid]");

		new Float:pos[ 3 ];
	    GetPlayerPos(playerid, pos[ 0 ], pos[ 1 ], pos[ 2 ]);
		GetXYInFrontOfPlayer(playerid, pos[ 0 ], pos[ 1 ], 0.5);
	    //pos[ 2 ] -= player_down;

		new modelid, objectuid, string[ 200 ];
		modelid = strval(params);

		if(!(0 <= modelid <= 100000))
		    return ShowCMD(playerid, "Error: Zbyt wysoki lub zbyt niski model obiektu!");

		if(CrashedObject(modelid))
		    return ShowCMD(playerid, "Error: Obiekt crasujący rozgrywkę!");

		format(string, sizeof string,
			"INSERT INTO `mini_objects` (`model`, `x`, `y`, `z`, `gameuid`) VALUES ('%d', '%f', '%f', '%f', '%d')",
			modelid,
			pos[ 0 ],
			pos[ 1 ],
			pos[ 2 ],
			Player(playerid, player_play) ? Setting(setting_game) : 0
		);
		mysql_query(string);
		objectuid = mysql_insert_id();

		Player(playerid, player_edit) = create_cat_obj;

	    new objectid;
		objectid = CreateDynamicObject(modelid, pos[ 0 ], pos[ 1 ], pos[ 2 ], 0, 0, 0, Player(playerid, player_vw), -1, -1, 1000.0);
	    Streamer_SetIntData(STREAMER_TYPE_OBJECT, objectid, E_STREAMER_EXTRA_ID, objectuid);
		Streamer_Update(playerid);
		Player(playerid, player_selected_object) = objectid;
		EditDynamicObject(playerid, objectid);
		return 1;
	}
	
	Cmd::Input->msel(playerid, params[])
	{
        if(!Player(playerid, player_adminlvl))
			return 1;
		if(isnull(params))
		{
			if(Player(playerid, player_selected_object) == INVALID_OBJECT_ID)
			{
				SelectObject(playerid);
			    ShowCMD(playerid, "Wybierz obiekt do edycji.");
			    Player(playerid, player_selected_object) = -1;
			}
			else
			{
				ShowCMD(playerid, "Edycja obiektu zakończona!");
				//PlayerTextDrawHide(playerid, Player(playerid, player_infos));
			    Player(playerid, player_selected_object) = INVALID_OBJECT_ID;
			    Player(playerid, player_edit) = create_cat_none;
			    CancelEdit(playerid);
			}
		}
		else
		{
			new model = strval(params);
			if(!model)
			    return ShowCMD(playerid, "Tip: /mselid [model]");

			new string[ 126 ];
			new Float:Prevdist = 50.0;
			new objectid;

			new Float:ppos[ 3 ];
			GetPlayerPos(playerid, ppos[ 0 ], ppos[ 1 ], ppos[ 2 ]);
			for(new num; num < Streamer_GetUpperBound(STREAMER_TYPE_OBJECT); num++)
		    {
				if(!IsValidDynamicObject(num)) continue;
		    	if(!Streamer_IsInArrayData(STREAMER_TYPE_OBJECT, num, E_STREAMER_WORLD_ID, GetPlayerVirtualWorld(playerid))) continue;
		        if(Streamer_GetIntData(STREAMER_TYPE_OBJECT, num, E_STREAMER_MODEL_ID) != model) continue;

				new Float:pos[ 3 ];
			    Streamer_GetFloatData(STREAMER_TYPE_OBJECT, num, E_STREAMER_X, pos[ 0 ]);
			    Streamer_GetFloatData(STREAMER_TYPE_OBJECT, num, E_STREAMER_Y, pos[ 1 ]);
			    Streamer_GetFloatData(STREAMER_TYPE_OBJECT, num, E_STREAMER_Z, pos[ 2 ]);

				new Float:Dist = Distance3D(ppos[ 0 ], ppos[ 1 ], ppos[ 2 ], pos[ 0 ], pos[ 1 ], pos[ 2 ]);
				if(Dist < Prevdist)
				{
					Prevdist = Dist;
					objectid = num;
				}
		    }
		    if(!objectid) return ShowInfo(playerid, red"Nie znaleziono!");
		    Streamer_GetFloatData(STREAMER_TYPE_OBJECT, objectid, E_STREAMER_X, Player(playerid, player_obj_pos)[ 0 ]);
		    Streamer_GetFloatData(STREAMER_TYPE_OBJECT, objectid, E_STREAMER_Y, Player(playerid, player_obj_pos)[ 1 ]);
		    Streamer_GetFloatData(STREAMER_TYPE_OBJECT, objectid, E_STREAMER_Z, Player(playerid, player_obj_pos)[ 2 ]);
		    Streamer_GetFloatData(STREAMER_TYPE_OBJECT, objectid, E_STREAMER_R_X, Player(playerid, player_obj_pos)[ 3 ]);
		    Streamer_GetFloatData(STREAMER_TYPE_OBJECT, objectid, E_STREAMER_R_Y, Player(playerid, player_obj_pos)[ 4 ]);
		    Streamer_GetFloatData(STREAMER_TYPE_OBJECT, objectid, E_STREAMER_R_Z, Player(playerid, player_obj_pos)[ 5 ]);
			EditDynamicObject(playerid, objectid);

			format(string, sizeof string, "Wybrałeś obiekt ID: %d, UID: %d", objectid, Streamer_GetIntData(STREAMER_TYPE_OBJECT, objectid, E_STREAMER_EXTRA_ID));
			ShowCMD(playerid, string);

		    //format(string, sizeof string, "x: %f~n~y: %f~n~z: %f~n~rx: %f~n~ry: %f~n~rz: %f", Player(playerid, player_obj_pos)[ 0 ], Player(playerid, player_obj_pos)[ 1 ], Player(playerid, player_obj_pos)[ 2 ], Player(playerid, player_obj_pos)[ 0 ], Player(playerid, player_obj_pos)[ 1 ], Player(playerid, player_obj_pos)[ 2 ]);
			//PlayerTextDrawSetString(playerid, Player(playerid, player_infos), string);
		
			//PlayerTextDrawShow(playerid, Player(playerid, player_infos));
			Player(playerid, player_edit) = create_cat_eobj;
		    Player(playerid, player_selected_object) = objectid;
		}
		return 1;
	}
	
	Cmd::Input->mmat(playerid, params[])
	{
		new object = Player(playerid, player_selected_object);
		if(object == INVALID_OBJECT_ID)
		    return ShowCMD(playerid, "Nie wybrałeś żadnego obiektu do edycji!");
		new index, typ, parametr[64];
		if(sscanf(params, "ddS()[64]", index, typ, parametr))
		    return ShowCMD(playerid, "Tip: /mmat [index] [typ] [parametr]");

		if(typ == 0)
		{
		    new color, model, txdname[ 32 ], texturename[ 32 ];
			if(sscanf(parametr, "xds[32]s[32]", color, model, txdname, texturename))
			    return ShowCMD(playerid, "Tip: /mmat [index] [typ] [color] [model] [txdname] [texturename]");
			if(!(0 <= model <= 100000))
			    return ShowCMD(playerid, "Error: Zbyt wysoki lub zbyt niski model obiektu!");

			mysql_real_escape_string(txdname, txdname);
			mysql_real_escape_string(texturename, texturename);
			new string[ 256 ];
			format(string, sizeof string,
			    "UPDATE `mini_objects` SET `index_mat` = '%d', `txdname` = '%s', `texturename` = '%s', `color_mat` = '%x', `modelid` = '%d' WHERE `uid` = '%d'",
			    index,
			    txdname,
			    texturename,
			    color,
			    model,
				Streamer_GetIntData(STREAMER_TYPE_OBJECT, object, E_STREAMER_EXTRA_ID)
			);

			mysql_query(string);
   			SetDynamicObjectMaterial(object, index, model, txdname, texturename, color);
			ShowCMD(playerid, "Object Material zmieniony!");
		}
		else if(typ == 1)
		{
		    new matsize, fontsize, bold, align, color_text, bgcolor, font[ 32 ], text[ 64 ];
		    if(sscanf(parametr, "dddxxds[32]s[64]", matsize, fontsize, bold, color_text, bgcolor, align, font, text))
		    	return ShowCMD(playerid, "Tip: /mmat [index] [typ] [matsize] [fontsize] [bold] [fcolor] [bcolor] [align] [font] [text]");
			if(matsize % 10 || !(10 <= matsize <= 140))
			    return ShowCMD(playerid, "Error: Matsize musi być podzielne przez 10 i w zakresie 10-140.");
			if(!(24 <= fontsize <= 255))
			    return ShowCMD(playerid, "Error: Fontsize musi być w zakresie 24-255.");
	        if(!(0 <= align <= 2))
	            return ShowCMD(playerid, "Error: Align (0 lewo, 1 środek, 2 prawo).");
	        if(!(0 <= bold <= 1))
	            return ShowCMD(playerid, "Error: Bold (0 wyłączony, 1 włączony).");

			mysql_real_escape_string(text, text);
			mysql_real_escape_string(font, font);
			new string[ 256 ];
			format(string, sizeof string,
			    "UPDATE `mini_objects` SET `index_text` = '%d', `text` = '%s', `font` = '%s', `align` = '%d', `size` = '%d', `tsize` = '%d', `color_text` = '%x', `bgcolor` = '%x', `bold` = '%d' WHERE `uid` = '%d'",
			    index,
			    text,
			    font,
			    align,
			    fontsize,
			    matsize,
			    color_text,
			    bgcolor,
			    bold,
				Streamer_GetIntData(STREAMER_TYPE_OBJECT, object, E_STREAMER_EXTRA_ID)
			);
			mysql_query(string);
			SetDynamicObjectMaterialText(object, index, text, matsize, font, fontsize, bold, color_text, bgcolor, align);
			ShowCMD(playerid, "Material Text zmieniony!");
		}
		else ShowCMD(playerid, "Za wysoki typ");
		return 1;
	}
	
	Cmd::Input->mdel(playerid, params[])
	{
		new object = Player(playerid, player_selected_object);
		if(object == INVALID_OBJECT_ID)
		    return ShowCMD(playerid, "Nie wybrałeś żadnego obiektu do edycji!");
	    if(Player(playerid, player_edit) == create_cat_obj)
	        return ShowCMD(playerid, "Wciśnij ESC.");

		new string[ 128 ];
		format(string, sizeof string,
			"DELETE FROM `mini_objects` WHERE `uid` = '%d'",
			Streamer_GetIntData(STREAMER_TYPE_OBJECT, object, E_STREAMER_EXTRA_ID)
		);
		mysql_query(string);

		format(string, sizeof string, "Skasowano obiekt, ID: %d, UID: %d", object, Streamer_GetIntData(STREAMER_TYPE_OBJECT, object, E_STREAMER_EXTRA_ID));
	    ShowCMD(playerid, string);

		new c;
		for(; c < MAX_OBJECTS; c++)
		    if(Object(c, obj_objID) == object)
		        break;
        if(c != MAX_OBJECTS)
        {
            for(new eObjects:i; i < eObjects; i++)
				Object(c, i) = 0;
			Object(c, obj_objID) = INVALID_OBJECT_ID;
		}
		DestroyDynamicObject(object);
		
		//PlayerTextDrawHide(playerid, Player(playerid, player_infos));
	    Player(playerid, player_selected_object) = INVALID_OBJECT_ID;
		CancelEdit(playerid);
		return 1;
	}
	
	public OnPlayerSelectDynamicObject(playerid, objectid, modelid, Float:x, Float:y, Float:z)
	{
		if(Player(playerid, player_selected_object) == objectid)
		    return ShowInfo(playerid, red"Edytujesz ten obiekt!");

		Player(playerid, player_edit) = create_cat_eobj;
		Player(playerid, player_selected_object) = objectid;

		EditDynamicObject(playerid, Player(playerid, player_selected_object));

		StopDynamicObject(objectid);
	    Streamer_GetFloatData(STREAMER_TYPE_OBJECT, objectid, E_STREAMER_X, Player(playerid, player_obj_pos)[ 0 ]);
	    Streamer_GetFloatData(STREAMER_TYPE_OBJECT, objectid, E_STREAMER_Y, Player(playerid, player_obj_pos)[ 1 ]);
	    Streamer_GetFloatData(STREAMER_TYPE_OBJECT, objectid, E_STREAMER_Z, Player(playerid, player_obj_pos)[ 2 ]);
	    Streamer_GetFloatData(STREAMER_TYPE_OBJECT, objectid, E_STREAMER_R_X, Player(playerid, player_obj_pos)[ 3 ]);
	    Streamer_GetFloatData(STREAMER_TYPE_OBJECT, objectid, E_STREAMER_R_Y, Player(playerid, player_obj_pos)[ 4 ]);
	    Streamer_GetFloatData(STREAMER_TYPE_OBJECT, objectid, E_STREAMER_R_Z, Player(playerid, player_obj_pos)[ 5 ]);

		new string[ 126 ];
		format(string, sizeof string,
			"Wybrałeś obiekt ID: %d, UID: %d",
			Player(playerid, player_selected_object),
			Streamer_GetIntData(STREAMER_TYPE_OBJECT, objectid, E_STREAMER_EXTRA_ID)
		);
		ShowCMD(playerid, string);
		ShowCMD(playerid, "Obiekt wybrany, wpisz: /mmat lub /mgate. Aby anulować wpisz /msel");

	    /*format(string, sizeof string, "x: %f~n~y: %f~n~z: %f~n~rx: %f~n~ry: %f~n~rz: %f", Player(playerid, player_obj_pos)[ 0 ], Player(playerid, player_obj_pos)[ 1 ], Player(playerid, player_obj_pos)[ 2 ], Player(playerid, player_obj_pos)[ 0 ], Player(playerid, player_obj_pos)[ 1 ], Player(playerid, player_obj_pos)[ 2 ]);
		PlayerTextDrawSetString(playerid, Player(playerid, player_infos), string);

		PlayerTextDrawShow(playerid, Player(playerid, player_infos));*/
		return 1;
	}
	public OnPlayerEditDynamicObject(playerid, objectid, response, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz)
	{
		if(!IsValidDynamicObject(objectid)) return 1;
		MoveDynamicObject(objectid, x, y, z, 10.0, rx, ry, rz);
		if(Player(playerid, player_edit) == create_cat_obj)
		{
		    //new objectuid = Player(playerid, player_obj_uid);
		    if(response == EDIT_RESPONSE_CANCEL)
			{
			    new string[ 64 ];
				format(string, sizeof string,
					"DELETE FROM `mini_objects` WHERE `uid` = '%d'",
					Streamer_GetIntData(STREAMER_TYPE_OBJECT, objectid, E_STREAMER_EXTRA_ID)
				);
				mysql_query(string);

				new c;
				for(; c < MAX_OBJECTS; c++)
				    if(Object(c, obj_objID) == Player(playerid, player_selected_object))
				        break;
                if(c != MAX_OBJECTS)
                {
                    for(new eObjects:i; i < eObjects; i++)
						Object(c, i) = 0;
					Object(c, obj_objID) = INVALID_OBJECT_ID;
				}
				DestroyDynamicObject(Player(playerid, player_selected_object));

	            //End_Create(playerid);
			    //PlayerTextDrawHide(playerid, Player(playerid, player_infos));
	            Player(playerid, player_selected_object) = INVALID_OBJECT_ID;

			    Chat::Output(playerid, SZARY, "Stawianie obiektu anulowane!");
			}
			else if(response == EDIT_RESPONSE_UPDATE)
			{
			    new string[ 126 ];
			    format(string, sizeof string, "x: %f~n~y: %f~n~z: %f~n~rx: %f~n~ry: %f~n~rz: %f", x, y, z, rx, ry, rz);
			    //PlayerTextDrawSetString(playerid, Player(playerid, player_infos), string);
			}
			else if(response == EDIT_RESPONSE_FINAL)
			{
			    new object = Player(playerid, player_selected_object),
					string[ 200 ];

				format(string, sizeof string,
					"UPDATE `mini_objects` SET `X` = '%f', `Y` = '%f', `Z` = '%f', `rX` = '%f', `rY` = '%f', `rZ` = '%f' WHERE `uid` = '%d'",
					x, y, z,
					rx, ry, rz,
					Streamer_GetIntData(STREAMER_TYPE_OBJECT, objectid, E_STREAMER_EXTRA_ID)
				);
				mysql_query(string);

                StopDynamicObject(object);
			    Streamer_SetFloatData(STREAMER_TYPE_OBJECT, object, E_STREAMER_X, x);
			    Streamer_SetFloatData(STREAMER_TYPE_OBJECT, object, E_STREAMER_Y, y);
			    Streamer_SetFloatData(STREAMER_TYPE_OBJECT, object, E_STREAMER_Z, z);
			    Streamer_SetFloatData(STREAMER_TYPE_OBJECT, object, E_STREAMER_R_X, rx);
			    Streamer_SetFloatData(STREAMER_TYPE_OBJECT, object, E_STREAMER_R_Y, ry);
			    Streamer_SetFloatData(STREAMER_TYPE_OBJECT, object, E_STREAMER_R_Z, rz);

                SetDynamicObjectRot(object, rx, ry, rz);
                SetDynamicObjectPos(object, x, y, z);

				format(string, sizeof string, "Obiekt stworzony! UID: %d, sampid: %d", Streamer_GetIntData(STREAMER_TYPE_OBJECT, objectid, E_STREAMER_EXTRA_ID), object);
	            Chat::Output(playerid, SZARY, string);

			    //PlayerTextDrawHide(playerid, Player(playerid, player_infos));
				Player(playerid, player_selected_object) = INVALID_OBJECT_ID;
			}
		}
		
		else if(Player(playerid, player_edit) == create_cat_eobj)
		{
		    new object = Player(playerid, player_selected_object);
			/*if(Create(playerid, create_value)[ 1 ] == 1)
			{
			    new doorid = Player(playerid, player_door);

				new string[ 360 ];
				format(string, sizeof string,
				    "UPDATE `surv_objects` SET `gateX` = '%f', `gateY` = '%f', `gateZ` = '%f', `gateRotX` = '%f', `gateRotY` = '%f', `gateRotZ` = '%f', `ownerType` = '%d', `owner` = '%d' WHERE `uid` = '%d'",
					x, y, z,
					rx, ry, rz,
					Door(doorid, door_owner)[ 0 ],
					Door(doorid, door_owner)[ 1 ],
				    Streamer_GetIntData(STREAMER_TYPE_OBJECT, object, E_STREAMER_EXTRA_ID)
				);
				mysql_query(string);

				new c;
				for(; c < MAX_OBJECTS; c++)
				    if(Object(c, obj_objID) == object)
				        break;
				if(c == MAX_OBJECTS)
				{
				    for(c = 0; c < MAX_OBJECTS; c++)
				    	if(Object(c, obj_objID) == INVALID_OBJECT_ID)
				    	    break;
				    if(c != MAX_OBJECTS)
				    {
						Object(c, obj_objID) = object;
						Object(c, obj_position)[ 0 ] = Player(playerid, player_obj_pos)[ 0 ];
						Object(c, obj_position)[ 1 ] = Player(playerid, player_obj_pos)[ 1 ];
						Object(c, obj_position)[ 2 ] = Player(playerid, player_obj_pos)[ 2 ];
						Object(c, obj_positionrot)[ 0 ] = Player(playerid, player_obj_pos)[ 3 ];
						Object(c, obj_positionrot)[ 1 ] = Player(playerid, player_obj_pos)[ 4 ];
						Object(c, obj_positionrot)[ 2 ] = Player(playerid, player_obj_pos)[ 5 ];
						Object(c, obj_positiongate)[ 0 ] = x;
						Object(c, obj_positiongate)[ 1 ] = y;
						Object(c, obj_positiongate)[ 2 ] = z;
						Object(c, obj_positiongaterot)[ 0 ] = rx;
						Object(c, obj_positiongaterot)[ 1 ] = ry;
						Object(c, obj_positiongaterot)[ 2 ] = rz;
						Object(c, obj_owner)[ 0 ] = Door(doorid, door_owner)[ 0 ];
						Object(c, obj_owner)[ 1 ] = Door(doorid, door_owner)[ 1 ];
						Object(c, obj_gaterange) = 2.0;
					}
				}
                else if(c != MAX_OBJECTS)
                {
					Object(c, obj_positiongate)[ 0 ] = x;
					Object(c, obj_positiongate)[ 1 ] = y;
					Object(c, obj_positiongate)[ 2 ] = z;
					Object(c, obj_positiongaterot)[ 0 ] = rx;
					Object(c, obj_positiongaterot)[ 1 ] = ry;
					Object(c, obj_positiongaterot)[ 2 ] = rz;
				}
                SetDynamicObjectPos(object, Player(playerid, player_obj_pos)[ 0 ], Player(playerid, player_obj_pos)[ 1 ], Player(playerid, player_obj_pos)[ 2 ]);
                SetDynamicObjectRot(object, Player(playerid, player_obj_pos)[ 3 ], Player(playerid, player_obj_pos)[ 4 ], Player(playerid, player_obj_pos)[ 5 ]);

	            Player(playerid, player_selected_object) = INVALID_OBJECT_ID;
			    PlayerTextDrawHide(playerid, Player(playerid, player_infos));
	            Create(playerid, create_value)[ 1 ] = 0;

				ShowCMD(playerid, "Pozycja bramy zapisana!");
			}
			else if(Create(playerid, create_value)[ 1 ] == 2)
			{
				new string[ 1024 ];

				new uid, model, Float:pos[ 3 ], Float:rot[ 3 ], owner[ 2 ];
			    new index_mat, index_text,
					color_text, color_mat, bgcolor,
					size, tsize, align, text[ 64 ],
					modelid, txdname[ 32 ], bold, vw,
					texturename[ 32 ], font[ 32 ];

				format(string, sizeof string, "INSERT INTO `surv_objects` (`model`, `X`, `Y`, `Z`, `rX`, `rY`, `rZ`, `gateX`, `gateY`, `gateZ`, `gatestatus`, `gateRange`, `ownerType`, `owner`, `index_text`, `index_mat`, `color_text`, `color_mat`, `bgcolor`, `tsize`, `size`, `align`, `bold`, `text`, `modelid`, `txdname`, `texturename`, `font`, `door`, `accept`)");
				format(string, sizeof string, "%s SELECT '%d', '%f', '%f', '%f', '%f', '%f', '%f', `gateX`, `gateY`, `gateZ`, `gatestatus`, `gateRange`, `ownerType`, `owner`, `index_text`, `index_mat`, `color_text`, `color_mat`, `bgcolor`, `tsize`, `size`, `align`, `bold`, `text`, `modelid`, `txdname`, `texturename`, `font`, `door`, '1' FROM `surv_objects` WHERE `uid` = '%d'",
					string,
					Streamer_GetIntData(STREAMER_TYPE_OBJECT, object, E_STREAMER_MODEL_ID),
					x,y,z,
					rx,ry,rz,
				    Streamer_GetIntData(STREAMER_TYPE_OBJECT, object, E_STREAMER_EXTRA_ID)
				);
				mysql_query(string);
				uid = mysql_insert_id();

				format(string, sizeof string,
				    "SELECT o.*, IFNULL(d.in_pos_vw, 0) as 'vw' FROM `surv_objects` o LEFT JOIN `surv_doors` d ON o.door = d.uid WHERE o.uid = '%d'",
				    uid
				);
				mysql_query(string);
				mysql_store_result();
				mysql_fetch_row(string);
				mysql_free_result();

				sscanf(string, "p<|>d{d}da<f>[3]a<f>[3]{a<f>[3]a<f>[3]df}a<d>[2]ddxxxdddds[64]ds[32]s[32]s[32]{dd}d",
			        uid, model, pos, rot, owner,
					index_text,
					index_mat,
					color_text,
					color_mat,
					bgcolor,
					size,
					tsize,
					align,
					bold,
					text,
					modelid,
					txdname,
					texturename,
					font,
					vw
				);

				object = CreateDynamicObject(model, pos[ 0 ], pos[ 1 ], pos[ 2 ], rot[ 0 ], rot[ 1 ], rot[ 2 ], vw, -1, -1, 1000.0);
				Streamer_SetIntData(STREAMER_TYPE_OBJECT, object, E_STREAMER_EXTRA_ID, uid);

                Player(playerid, player_obj_pos)[ 0 ] = pos[ 0 ];
                Player(playerid, player_obj_pos)[ 1 ] = pos[ 1 ];
                Player(playerid, player_obj_pos)[ 2 ] = pos[ 2 ];
                Player(playerid, player_obj_pos)[ 3 ] = rot[ 0 ];
                Player(playerid, player_obj_pos)[ 4 ] = rot[ 1 ];
                Player(playerid, player_obj_pos)[ 5 ] = rot[ 2 ];

				if(!(DIN(txdname, "NULL")) || !(DIN(texturename, "NULL")))
				    SetDynamicObjectMaterial(object, index_mat, modelid, txdname, texturename, color_mat);
				if(!(DIN(text, "NULL")))
				    SetDynamicObjectMaterialText(object, index_text, text, size, font, tsize, bold, color_text, bgcolor, align);

				Create(playerid, create_cat) = create_cat_eobj;
			    Player(playerid, player_selected_object) = object;
				EditDynamicObject(playerid, object);

				Create(playerid, create_value)[ 1 ] = 0;
				ShowCMD(playerid, "Obiekt skopiowany!");
			}
	        else if(Create(playerid, create_value)[ 1 ] == 3)
	        {
			    new string[ 256 ];
			    format(string, sizeof string, "x: %f~n~y: %f~n~z: %f~n~rx: %f~n~ry: %f~n~rz: %f", x, y, z, rx, ry, rz);
			    //PlayerTextDrawSetString(playerid, Player(playerid, player_infos), string);
				EditDynamicObject(playerid, object);
				Create(playerid, create_value)[ 1 ] = 0;
	        }
			else */
			if(response == EDIT_RESPONSE_UPDATE)
			{
			    new string[ 256 ];
			    format(string, sizeof string, "x: %f~n~y: %f~n~z: %f~n~rx: %f~n~ry: %f~n~rz: %f", x, y, z, rx, ry, rz);
			    //PlayerTextDrawSetString(playerid, Player(playerid, player_infos), string);
			}
			else if(response == EDIT_RESPONSE_CANCEL)
			{
				StopDynamicObject(object);
			    Streamer_SetFloatData(STREAMER_TYPE_OBJECT, object, E_STREAMER_X, Player(playerid, player_obj_pos)[ 0 ]);
			    Streamer_SetFloatData(STREAMER_TYPE_OBJECT, object, E_STREAMER_Y, Player(playerid, player_obj_pos)[ 1 ]);
			    Streamer_SetFloatData(STREAMER_TYPE_OBJECT, object, E_STREAMER_Z, Player(playerid, player_obj_pos)[ 2 ]);
			    Streamer_SetFloatData(STREAMER_TYPE_OBJECT, object, E_STREAMER_R_X, Player(playerid, player_obj_pos)[ 3 ]);
			    Streamer_SetFloatData(STREAMER_TYPE_OBJECT, object, E_STREAMER_R_Y, Player(playerid, player_obj_pos)[ 4 ]);
			    Streamer_SetFloatData(STREAMER_TYPE_OBJECT, object, E_STREAMER_R_Z, Player(playerid, player_obj_pos)[ 5 ]);

			    Player(playerid, player_selected_object) = INVALID_OBJECT_ID;
			    Player(playerid, player_edit) = 0;
			    //PlayerTextDrawHide(playerid, Player(playerid, player_infos));

			    ShowCMD(playerid, "Edycja obiektu anulowana!");
			}
			else if(response == EDIT_RESPONSE_FINAL)
			{
			    new string[ 256 ];
				format(string, sizeof string,
					"UPDATE `mini_objects` SET `X` = '%f', `Y` = '%f', `Z` = '%f', `rX` = '%f', `rY` = '%f', `rZ` = '%f' WHERE `uid` = '%d'",
					x,y,z,
					rx,ry,rz,
					Streamer_GetIntData(STREAMER_TYPE_OBJECT, object, E_STREAMER_EXTRA_ID)
				);
				mysql_query(string);

                StopDynamicObject(object);
			    Streamer_SetFloatData(STREAMER_TYPE_OBJECT, object, E_STREAMER_X, x);
			    Streamer_SetFloatData(STREAMER_TYPE_OBJECT, object, E_STREAMER_Y, y);
			    Streamer_SetFloatData(STREAMER_TYPE_OBJECT, object, E_STREAMER_Z, z);
			    Streamer_SetFloatData(STREAMER_TYPE_OBJECT, object, E_STREAMER_R_X, rx);
			    Streamer_SetFloatData(STREAMER_TYPE_OBJECT, object, E_STREAMER_R_Y, ry);
			    Streamer_SetFloatData(STREAMER_TYPE_OBJECT, object, E_STREAMER_R_Z, rz);

                SetDynamicObjectRot(object, rx, ry, rz);
                SetDynamicObjectPos(object, x, y, z);
				new c;
				for(; c < MAX_OBJECTS; c++)
				    if(Object(c, obj_objID) == object)
				        break;
				if(c != MAX_OBJECTS)
				{
					Object(c, obj_pos)[ 0 ] = x;
					Object(c, obj_pos)[ 1 ] = y;
					Object(c, obj_pos)[ 2 ] = z;
					Object(c, obj_rot)[ 0 ] = rx;
					Object(c, obj_rot)[ 1 ] = ry;
					Object(c, obj_rot)[ 2 ] = rx;
				}
			    Player(playerid, player_selected_object) = INVALID_OBJECT_ID;
			    Player(playerid, player_edit) = 0;
			    //PlayerTextDrawHide(playerid, Player(playerid, player_infos));
			    //Create(playerid, create_value)[ 1 ] = 0;

				format(string, sizeof string, "Zapisałeś obiekt ID: %d, UID: %d", object, Streamer_GetIntData(STREAMER_TYPE_OBJECT, object, E_STREAMER_EXTRA_ID));
				ShowCMD(playerid, string);

				ShowCMD(playerid, "Pozycja obiektu zapisana!");
			}
		}
		return 1;
	}
#endif


stock CrashedObject(model)
{
    switch(model)
    {
        case 384, 385, 386, 387, 388, 389, 390, 391, 392, 393, 1573:
        {
            return true;
        }
    }
    return false;
}
