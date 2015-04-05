#define Panel			1
#define Light			2
#define Doors			3
#define Tire			4

#define HOOD 			1 	// maska
#define TRUNK 			2 	// baga¿nik
#define LEFT_DOOR 		3 	// lewe drzwi
#define RIGHT_DOOR 		4 	// prawe drzwi

#define LEFT_F_TIRE 	1 	// Lewa przednia opona
#define LEFT_B_TIRE 	2 	// Lewa tylnia opona
#define RIGHT_F_TIRE 	3 	// Prawa przednia opona
#define RIGHT_B_TIRE 	4 	// Prawa tylnia opona

#define LEFT_LIGHT 		1 	// Lewa lampa
#define RIGHT_LIGHT 	2 	// Prawa lampa

#define FRONT_PANEL 	1 	// Przedni zderzak
#define BACK_PANEL 		2 	// Tylni zderzak

//STATUSY ELEMENTÓW
#define FULL 			0 	// Nieuszkodzony   	(we wszystkich elementach)
#define OPENED 			1 	// otwarty     	 	(tylko w masce, baga¿niku oraz drzwiach lewych i prawych)
#define DAMAGED 		2 	// uszkodzony   	(we wszystkich elementach)
#define OPENED_DAMAGED 	3 	// otwarty-uszkodz 	(tylko w masce, baga¿niku oraz drzwiach lewych i prawych)
#define REMOVED 		4 	// usuniêty 	 	(we wszystkich elementach oprócz lamp œwietlnych i opon)
#define SHAKED 			5 	// zachwiany  	 	(tylko w zderzakach)   

//Statusy elementow (binarnie - cstring)
#define IN_FULL "00000000" // 0
#define IN_OPENED "00000001" //1
#define IN_DAMAGED "00000010" //2
#define IN_OPENED_DAMAGED "00000011" //3
#define IN_REMOVED "00000100" //4
#define IN_FRONT_PANEL_FULL "00000000000000000000000"
#define IN_BACK_PANEL_FULL "000"
#define IN_BACK_PANEL_DAMAGED "100"
#define IN_BACK_PANEL_REMOVED "110"

//Funkcje pomocnicze
stock BinToDec(bin[])
{
    new dec=0;
    for(new i=strlen(bin)-1, g=0; i>=0; i--, g++)
    {
        if(49<bin[i]>48) return -1;
        dec=dec+(bin[i]-48)*power(2, g);
    }

    return dec;
}

stock power(int, pot)
{
    if(pot==0) return 1;
    if(pot<0) return -1;
    new out=int;
    for(new i=1; i<pot; i++)
    {
        out=out*int;
    }

    return out;
}

stock GetChar(index, string[])
{
	new temp = strlen(string);
	strdel(string,index + 1,temp);
	strdel(string,0,index);
}

stock getDoor(vehicleid, element)
{
	if(GetVehicleModel(vehicleid) != 0 && element > 0 && element < 5)
	{
	new part[4];
	new str[50];
	new temp[10];
	new strtemp[50];
	new length;
	GetVehicleDamageStatus(vehicleid,part[0],part[1],part[2],part[3]);
	
	format(str,sizeof(str),"%b",part[1]);
	length = strlen(str);
	strcat(strtemp,str);
	if(length != 31 || str[0] == '0')
	{
	    length = 32 - length;
	    new length2 = 32 - length;

	    for(new i = 0; i < length; i++)
	    {
     		str[i] = '0';
     		strdel(str,length,length2);
        }
		strins(str,strtemp,length);
	}

	if(element == HOOD)
	    strmid(temp,str,24,32,9);
	    
    else if(element == TRUNK)
	    strmid(temp,str,16,24,9);
        
    else if(element == LEFT_DOOR)
        strmid(temp,str,8,16,9);
        
    else if(element == RIGHT_DOOR)
        strmid(temp,str,0,8,9);
        
    if(strcmp(temp,IN_FULL,true) == 0)
		return FULL;
		
	else if(strcmp(temp,IN_OPENED,true) == 0)
	   	return OPENED;
	    
	else if(strcmp(temp,IN_DAMAGED,true) == 0)
	    return DAMAGED;
	    
	else if(strcmp(temp,IN_OPENED_DAMAGED,true) == 0)
		return OPENED_DAMAGED;
	    
	else if(strcmp(temp,IN_REMOVED,true) == 0)
		return REMOVED;
	}
	    
	return -1;
}

stock setDoor(vehicleid, element, status)
{
	if(GetVehicleModel(vehicleid) != 0 && element > 0 && element < 5 && status > - 1 && status < 5)
	{
	new str[50];
	new tmp[4][30];
	new door[4];
	door[0] = getDoor(vehicleid,HOOD);
	door[1] = getDoor(vehicleid,TRUNK);
	door[2] = getDoor(vehicleid,LEFT_DOOR);
	door[3] = getDoor(vehicleid,RIGHT_DOOR);
	
	if(element == HOOD)
	    door[0] = status;

	else if(element == TRUNK)
		door[1] = status;
		
	else if(element == LEFT_DOOR)
	    door[2] = status;
	    
	else if(element == RIGHT_DOOR)
	    door[3] = status;
	
	for(new i = 0; i < 4; i++)
	{
	    if(door[i] == FULL)
	    {
            tmp[i] = IN_FULL;
     	}

		else if(door[i] == OPENED)
		{
		    tmp[i] = IN_OPENED;
	  	}
		    
		else if(door[i] == DAMAGED)
		{
		    tmp[i] = IN_DAMAGED;
		}
		    
		else if(door[i] == OPENED_DAMAGED)
		{
		    tmp[i] = IN_OPENED_DAMAGED;
  		}
		    
		else if(door[i] == REMOVED)
		{
		    tmp[i] = IN_REMOVED;
  		}
	}
	format(str,sizeof(str),"%s%s%s%s",tmp[3],tmp[2],tmp[1],tmp[0]);
	new val = BinToDec(str);
	new part[4];
	GetVehicleDamageStatus(vehicleid,part[0],part[1],part[2],part[3]);
	UpdateVehicleDamageStatus(vehicleid,part[0],val,part[2],part[3]);
	}
}

stock getLight(vehicleid, element)
{
	if(GetVehicleModel(vehicleid) != 0 && element > 0 && element < 3)
	{
	    new part[4];
        GetVehicleDamageStatus(vehicleid,part[0],part[1],part[2],part[3]);
        if(part[2] != 0)
        {
            new str[5];
        	new strtemp[5];
        	new length;
        	new status;
            format(str,sizeof(str),"%b",part[2]);
        	length = strlen(str);
        	strcat(strtemp,str);
        	if(length != 3)
			{
			    length = 3 - length;
            	new length2 = 3 - length;
            	for(new i = 0; i < length; i++)
            	{
               		str[i] = '0';
                	strdel(str,length,length2);
            	}
            	strins(str,strtemp,length);
			}
			if(element == LEFT_LIGHT)
			{
			    GetChar(2,str);
			    if(strcmp(str,"1",true) == 0)
			        status = DAMAGED;

				else if(strcmp(str,"0",true) == 0)
				    status = FULL;
			}
			else if(element == RIGHT_LIGHT)
			{
			    GetChar(0,str);
			    if(strcmp(str,"1",true) == 0)
			        status = DAMAGED;

				else if(strcmp(str,"0",true) == 0)
				    status = FULL;
			}
			return status;
        }
        else
			return FULL;

	}
	return -1;
}

stock setLight(vehicleid, element, status)
{
    if(GetVehicleModel(vehicleid) != 0 && element > 0 && element < 3 && status == FULL || status == DAMAGED)
    {
        new tmp[2][2];
        new light[2];
        light[0] = getLight(vehicleid,LEFT_LIGHT);
        light[1] = getLight(vehicleid,RIGHT_LIGHT);

        if(element == LEFT_LIGHT)
            light[0] = status;

        else if(element == RIGHT_LIGHT)
            light[1] = status;

		for(new i = 0; i < 2; i++)
		{
		    if(light[i] == FULL)
		        tmp[i] = "0";

		     else if(light[i] == DAMAGED)
		        tmp[i] = "1";
		}

		new str[5];
		new part[4];
		format(str,sizeof(str),"%s0%s",tmp[1],tmp[0]);
		GetVehicleDamageStatus(vehicleid,part[0],part[1],part[2],part[3]);
		new val = BinToDec(str);
		UpdateVehicleDamageStatus(vehicleid,part[0],part[1],val,part[3]);
    }
}

stock getPanel(vehicleid, element)
{
	if(GetVehicleModel(vehicleid) != 0 && element > 0 && element < 3)
	{
	    new part[4];
	    new str[30];
	    new strtemp[30];
	    new length;
	    new status;
	    GetVehicleDamageStatus(vehicleid,part[0],part[1],part[2],part[3]);
	    format(str,sizeof(str),"%b",part[0]);
	    length = strlen(str);
	    strcat(strtemp,str);
	    if(length != 26)
	    {
			if(length != 25)
			{
	        	length = 26 - length;
	    		new length2 = 26 - length;

	    		for(new i = 0; i < length; i++)
	    		{
     				str[i] = '0';
     				strdel(str,length,length2);
      			}
				strins(str,strtemp,length);
			}
	    }
	    strdel(strtemp,0,26);
	    strcat(strtemp,str);


	   	if(element == FRONT_PANEL)
		{
		    strdel(str,0,3); //Begin Removed
		    strdel(str,3,26);
		    if(strcmp(str,"110",true) == 0 || strcmp(str,"011",true) == 0)
		        return REMOVED; //End Removed

			strdel(str,0,26); //Begin Damaged
			strcat(str,strtemp);
			new length3 = strlen(str);
			strdel(str,0,4);
			strdel(str,2,26);
  			if(strcmp(str,"10",true) == 0 && length3 == 25 || strcmp(str,"01",true) == 0 && length3 == 26)
			    return DAMAGED; //End Damaged

			if(strcmp(str,"01",true) == 0 && length3 == 25 || strcmp(str,"10",true) == 0 && length3 == 26) //Begin Shaked
			    return SHAKED;

			strdel(str,0,26);
			strcat(str,strtemp);
			strdel(str,6,26);
			if(strcmp(str,"100100",true) == 0)
			    return SHAKED; //End shaked

		}
	   	else if(element == BACK_PANEL)
		{
			strdel(str,3,26);
			if(strcmp(str,IN_BACK_PANEL_DAMAGED,true) == 0 && str[25] == '\0')
				status = DAMAGED;

		    else if(strcmp(str,IN_BACK_PANEL_DAMAGED,true) == 0)
				status = SHAKED;

		    else if(strcmp(str,IN_BACK_PANEL_REMOVED,true) == 0)
		        status = REMOVED;

		    else if(strcmp(str,IN_BACK_PANEL_FULL,true) == 0)
		        status = FULL;
	   	}
	   	return status;
	}
	return -1;
}

stock setPanel(vehicleid, element, status)
{
	if(GetVehicleModel(vehicleid) != 0 && element > 0 && element < 3 && status > -1 && status < 6)
	{
		new panel[2];
		new tmp[2][30];
		panel[0] = getPanel(vehicleid,FRONT_PANEL);
		panel[1] = getPanel(vehicleid,BACK_PANEL);

		if(element == FRONT_PANEL)
			panel[0] = status;

		else if(element == BACK_PANEL)
	  	   panel[1] = status;

		if(panel[0] == FULL) //FRONT
     		tmp[0] = IN_FRONT_PANEL_FULL;


 		if(panel[1] == FULL) //BACK
 			tmp[1] = IN_BACK_PANEL_FULL;

 		else if(panel[1] == DAMAGED || panel[1] == SHAKED)
 	 	   tmp[1] = IN_BACK_PANEL_DAMAGED;

    	else if(panel[1] == REMOVED)
  			tmp[1] = IN_BACK_PANEL_REMOVED;

 		new str[30];
 		new part[4];
 		GetVehicleDamageStatus(vehicleid,part[0],part[1],part[2],part[3]);

		if(element == FRONT_PANEL)
 		{
 	    	if(panel[0] == FULL)
 	    	{
 	     		format(str,sizeof(str),"%s%s",tmp[1],tmp[0]);
 	     		if(panel[1] == DAMAGED)
 	     	   	 	str[25] = '\0';
 	        	UpdateVehicleDamageStatus(vehicleid,0,0,0,0);
 	    	}
 	    	else if(panel[0] == DAMAGED)
 	    	{
 	        	if(panel[1] == FULL)
      	   			format(str,sizeof(str),"%s%s",IN_BACK_PANEL_FULL,"100000000000000010000");
 	        	else if(panel[1] == DAMAGED)
 	            	format(str,sizeof(str),"%s%s",IN_BACK_PANEL_DAMAGED,"0100000000000000000000");
 	       	    else if(panel[1] == SHAKED || panel[1] == REMOVED)
 	            	format(str,sizeof(str),"%s%s",IN_BACK_PANEL_DAMAGED,"00100000000000000010000");
 	    	}
 	    	else if(panel[0] == SHAKED)
 	    	{
				if(panel[1] == FULL || panel[1] == DAMAGED)
			    	format(str,sizeof(str),"%s%s",IN_BACK_PANEL_FULL,"1000000000000000100000");
				else if(panel[1] == SHAKED)
			    	format(str,sizeof(str),"%s%s",IN_BACK_PANEL_DAMAGED,"01000000000000000100000");
				else if(panel[1] == REMOVED)
			    	format(str,sizeof(str),"%s%s",IN_BACK_PANEL_DAMAGED,"01000000000000000000010");
   			}
   			else if(panel[0] == REMOVED)
			{
			    if(panel[1] == FULL)
		        	format(str,sizeof(str),"%s%s",IN_BACK_PANEL_FULL,"1100000000000000100010");
				else if(panel[1] == DAMAGED)
			    	format(str,sizeof(str),"%s%s",IN_BACK_PANEL_DAMAGED,"1100110000000000110010");
				else if(panel[1] == SHAKED)
			    	format(str,sizeof(str),"%s%s",IN_BACK_PANEL_DAMAGED,"01100100000000000100000");
				else if(panel[1] == REMOVED)
			    	format(str,sizeof(str),"%s%s",IN_BACK_PANEL_REMOVED,"01100110000000000110011");
			}
 		}
 		else if(element == BACK_PANEL)
 		{
 	    	if(panel[1] == FULL)
 	    	{
				if(panel[0] == FULL)
				    str = "0";
				else if(panel[0] == DAMAGED)
				   format(str,sizeof(str),"%s%s",IN_BACK_PANEL_FULL,"100000000000000010000");
				else if(panel[0] == SHAKED)
				    format(str,sizeof(str),"%s%s",IN_BACK_PANEL_FULL,"1000010000000000000001");
				else if(panel[0] == REMOVED)
				    format(str,sizeof(str),"%s%s",IN_BACK_PANEL_FULL,"1100100000000000110000");
				   
                UpdateVehicleDamageStatus(vehicleid,0,0,0,0);
 	    	}
 	    	else if(panel[1] == DAMAGED)
 	    	{
 	    	    if(panel[0] == FULL)
 	    	        format(str,sizeof(str),"%s%s",IN_BACK_PANEL_DAMAGED,"0000000000000000000000");
 	    	    else if(panel[0] == DAMAGED)
 	    	        format(str,sizeof(str),"%s%s",IN_BACK_PANEL_DAMAGED,"0100000000000000000000");
 	    	    else if(panel[0] == SHAKED)
 	    	        format(str,sizeof(str),"%s%s",IN_BACK_PANEL_DAMAGED,"1000000000000000010000");
 	    	    else if(panel[0] == REMOVED)
 	    	        format(str,sizeof(str),"%s%s",IN_BACK_PANEL_DAMAGED,"1100010000000000100010");
 	    	}
 	    	else if(panel[1] == SHAKED)
 	    	{
 	    	    if(panel[0] == FULL)
 	    	        format(str,sizeof(str),"%s%s",IN_BACK_PANEL_DAMAGED,"00000000000000000000000");
 	    	    else if(panel[0] == DAMAGED)
 	    	        format(str,sizeof(str),"%s%s",IN_BACK_PANEL_DAMAGED,"00100000000000000010000");
 	    	    else if(panel[0] == SHAKED)
 	    	        format(str,sizeof(str),"%s%s",IN_BACK_PANEL_DAMAGED,"01000000000000000100000");
 	    	    else if(panel[0] == REMOVED)
 	    	        format(str,sizeof(str),"%s%s",IN_BACK_PANEL_DAMAGED,"01100010000000000000010");
 	    	}
 	    	else if(panel[1] == REMOVED)
			{
			    if(panel[0] == FULL)
                    format(str,sizeof(str),"%s%s",IN_BACK_PANEL_REMOVED,"00000000000000000000000");
                else if(panel[0] == DAMAGED)
                    format(str,sizeof(str),"%s%s",IN_BACK_PANEL_REMOVED,"00100000000000000000001");
                else if(panel[0] == SHAKED)
                    format(str,sizeof(str),"%s%s",IN_BACK_PANEL_REMOVED,"01000000000000000100000");
                else if(panel[0] == REMOVED)
                    format(str,sizeof(str),"%s%s",IN_BACK_PANEL_REMOVED,"01100000000000000100000");
			}
 		}
 		new val = BinToDec(str);
 		UpdateVehicleDamageStatus(vehicleid,val,part[1],part[2],part[3]);
 	}
}

stock getTire(vehicleid, element)
{
	if(GetVehicleModel(vehicleid) != 0 &&  element > 0 &&  element < 5)
	{
	    new str[15];
	    new part[4];
	    new strtemp[15];
	    new status;
	    new length;
	    GetVehicleDamageStatus(vehicleid,part[0],part[1],part[2],part[3]);
	    format(str,sizeof(str),"%b",part[3]);
	    strcat(strtemp,str);
	    length = strlen(str);
		if(length != 4)
	 	{
	 	    length = 4 - length;
	 	    new length2 = 4 - length;
 	    	for(new i = 0; i < length; i++)
 	    	{
	 	        str[i] = '0';
	 	       	strdel(str,length,length2);
	 	    }
	 	    strins(str,strtemp,length);
	 	    
	   	 	for(new i = 0; i < 4; i++)
	    	{
	       		if(i + 1 == element)
				{
			 		GetChar(i,str); //Begin
					if(strcmp(str,"1",true) == 0)
				   		status = DAMAGED;

					else if(strcmp(str,"0",true) == 0)
				   		status = FULL;
				    
					strdel(str,0,5);
					strcat(str,strtemp); //End
			    	break;
				}
			}
			return status;
	    }
	    else if(length == 4)
	   	{
	        new strtmp[5];
	        strcat(strtmp,str);
	        for(new i = 0; i < 4; i++)
	       	{
	          	if(i + 1 == element)
	           	{
	            	GetChar(i,str); //Begin
					if(strcmp(str,"1",true) == 0)
				   		status = DAMAGED;

					else if(strcmp(str,"0",true) == 0)
				   		status = FULL;

					strdel(str,0,5);
					strcat(str,strtmp); //End
			   		break;
			   	}
	       	}
	       	return status;
	   	}
	}
	return -1;
}

stock setTire(vehicleid, element, status)
{
	if(GetVehicleModel(vehicleid) != 0 && element > 0 && element < 5)
	{
	    new tmp[4][20];
	    new tire[4];
	    tire[0] = getTire(vehicleid,LEFT_F_TIRE);
	    tire[1] = getTire(vehicleid,LEFT_B_TIRE);
		tire[2] = getTire(vehicleid,RIGHT_F_TIRE);
		tire[3] = getTire(vehicleid,RIGHT_B_TIRE);
		
		if(element == LEFT_F_TIRE)
			tire[0] = status;

		else if(element == LEFT_B_TIRE)
		    tire[1] = status;
		    
		else if(element == RIGHT_F_TIRE)
		    tire[2] = status;
		    
		else if(element == RIGHT_B_TIRE)
		    tire[3] = status;
		    
		for(new i = 0; i < 4; i++)
		{
			if(tire[i] == FULL)
			    tmp[i] = "0";
			    
			else if(tire[i] == DAMAGED)
			    tmp[i] = "1";
		}
		new str[5];
		new part[4];
		GetVehicleDamageStatus(vehicleid,part[0],part[1],part[2],part[3]);
		format(str,sizeof(str),"%s%s%s%s",tmp[0],tmp[1],tmp[2],tmp[3]);
		new val = BinToDec(str);
		UpdateVehicleDamageStatus(vehicleid,part[0],part[1],part[2],val);
	}
}

