#if defined PStreamer
  #endinput
#endif
#define PStreamer
native PStreamer_Init();
native PStreamer_Exit();
native PStreamer_TickRate(rate);
native PStreamer_CountStreamObject();
native PStreamer_PlayerInit(playerid);
native PStreamer_PlayerExit(playerid);
native CreateStreamObject(objectid, Float:x, Float:y, Float:z, Float:xrot, Float:yrot, Float:zrot, Float:distance = 300.000, interior = 0, virtualworld = 0);
native DestroyStreamObject(PSobject);        
native GetStreamObjectRot(objectid,&Float:x,&Float:y,&Float:z);
native GetStreamObjectPos(objectid,&Float:x,&Float:y,&Float:z);
native SetStreamObjectRot(objectid,Float:x,Float:y,Float:z);
native SetStreamObjectPos(objectid,Float:x,Float:y,Float:z);
native MoveStreamObject(objectid,Float:posx,Float:posy,Float:posz,Float:speed,Float:rotx = -1000.0,Float:roty = -1000.0,Float:rotz = -1000.0);
forward OnStreamObjectMoved(objectid);        
forward OnStreamObjectStreamIn(objectid,forplayerid);   
forward OnStreamObjectStreamOut(objectid,forplayerid);                                                                                    