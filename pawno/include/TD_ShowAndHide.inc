// by mrdrifter & edit by CeKa

#if defined _tdefect_included
	#endinput
#endif	
#define _tdefect_included

forward SHOW_HIDE_PTD(PlayerText:TextDraw, Float:step, Float:step_end, Float:mix, speed, bool:hide, forplayer, color);
public SHOW_HIDE_PTD(PlayerText:TextDraw,  Float:step, Float:step_end, Float:mix, speed, bool:hide, forplayer, color){

	if(hide){
		if(step<step_end){ //+, 1.0
			PlayerTextDrawColor(forplayer, TextDraw, alphatd(color, step));
			PlayerTextDrawHide(forplayer, TextDraw);
			
			SetTimerEx("SHOW_HIDE_PTD", speed, 0, "dfffdbdd", _:TextDraw,  step + mix, step_end, mix, speed, hide, forplayer, color);
			return;
		}
		PlayerTextDrawColor(forplayer, TextDraw, color);
		PlayerTextDrawHide(forplayer, TextDraw);
	} else {
		if(step>step_end){ //-, 0.1
			PlayerTextDrawColor(forplayer, TextDraw, alphatd(color, step));
			PlayerTextDrawShow(forplayer, TextDraw);
			SetTimerEx("SHOW_HIDE_PTD", speed, 0, "dfffdbdd", _:TextDraw,  step - mix, step_end, mix, speed, hide, forplayer, color);
		}
	}
}

forward SHOW_HIDE_TD(Text:TextDraw, Float:step, Float:step_end, Float:mix, speed, bool:hide, forplayer, color);
public SHOW_HIDE_TD(Text:TextDraw,  Float:step, Float:step_end, Float:mix, speed, bool:hide, forplayer, color){

	if(hide){
		if(step<step_end){ //+, 1.0
			TextDrawColor(TextDraw, alphatd(color, step));
			
			if(forplayer == INVALID_PLAYER_ID) 
				TextDrawShowForAll(TextDraw);
			else 
				TextDrawShowForPlayer(forplayer, TextDraw);
			
			SetTimerEx("SHOW_HIDE_TD", speed, 0, "dfffdbdd", _:TextDraw,  step + mix, step_end, mix, speed, hide, forplayer, color);
			return;
		}
		if(forplayer == INVALID_PLAYER_ID) 
			TextDrawHideForAll(TextDraw);
		else 
			TextDrawHideForPlayer(forplayer, TextDraw);
	} else {
		if(step>step_end){ //-, 0.1
			TextDrawColor(TextDraw, alphatd(color, step));
			if(forplayer == INVALID_PLAYER_ID) 
				TextDrawShowForAll(TextDraw);
			else 
				TextDrawShowForPlayer(forplayer, TextDraw);
			SetTimerEx("SHOW_HIDE_TD", speed, 0, "dfffdbdd", _:TextDraw,  step - mix, step_end, mix, speed, hide, forplayer, color);
		}
	}
}
  
stock alphatd(colorur, Float:mix){

	new color[1];
	color[0] = colorur;
	
	color{3} = floatround(float(color{3})-(float(color{3})*mix));

	return color[0];
}
