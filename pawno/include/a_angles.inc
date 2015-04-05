// a_angles.inc
// Angle functions
// Created by:
// Tannz0rz

#if defined _a_angles_included
  #endinput
#endif
#define _a_angles_included

#include <a_samp>

stock IsPlayerBehindPlayer(playerid, targetid, Float:dOffset)
{

	new
	    Float:pa,
	    Float:ta;

	if(!IsPlayerConnected(playerid) || !IsPlayerConnected(targetid)) return 0;
	
	GetPlayerFacingAngle(playerid, pa);
	GetPlayerFacingAngle(targetid, ta);
	
	if(AngleInRangeOfAngle(pa, ta, dOffset) && IsPlayerFacingPlayer(playerid, targetid, dOffset)) return true;

	return false;

}

stock SetPlayerToFacePlayer(playerid, targetid)
{

	new
		Float:pX,
		Float:pY,
		Float:pZ,
		Float:X,
		Float:Y,
		Float:Z,
		Float:ang;

	if(!IsPlayerConnected(playerid) || !IsPlayerConnected(targetid)) return 0;

	GetPlayerPos(targetid, X, Y, Z);
	GetPlayerPos(playerid, pX, pY, pZ);

	if( Y > pY ) ang = (-acos((X - pX) / floatsqroot((X - pX)*(X - pX) + (Y - pY)*(Y - pY))) - 90.0);
	else if( Y < pY && X < pX ) ang = (acos((X - pX) / floatsqroot((X - pX)*(X - pX) + (Y - pY)*(Y - pY))) - 450.0);
	else if( Y < pY ) ang = (acos((X - pX) / floatsqroot((X - pX)*(X - pX) + (Y - pY)*(Y - pY))) - 90.0);

	if(X > pX) ang = (floatabs(floatabs(ang) + 180.0));
	else ang = (floatabs(ang) - 180.0);
	
	SetPlayerFacingAngle(playerid, ang);

 	return 0;

}

stock IsPlayerFacingPlayer(playerid, targetid, Float:dOffset)
{

	new
		Float:pX,
		Float:pY,
		Float:pZ,
		Float:pA,
		Float:X,
		Float:Y,
		Float:Z,
		Float:ang;

	if(!IsPlayerConnected(playerid) || !IsPlayerConnected(targetid)) return 0;

	GetPlayerPos(targetid, pX, pY, pZ);
	GetPlayerPos(playerid, X, Y, Z);
	GetPlayerFacingAngle(playerid, pA);

	if( Y > pY ) ang = (-acos((X - pX) / floatsqroot((X - pX)*(X - pX) + (Y - pY)*(Y - pY))) - 90.0);
	else if( Y < pY && X < pX ) ang = (acos((X - pX) / floatsqroot((X - pX)*(X - pX) + (Y - pY)*(Y - pY))) - 450.0);
	else if( Y < pY ) ang = (acos((X - pX) / floatsqroot((X - pX)*(X - pX) + (Y - pY)*(Y - pY))) - 90.0);

	if(AngleInRangeOfAngle(-ang, pA, dOffset)) return true;

	return false;

}

stock AngleInRangeOfAngle(Float:a1, Float:a2, Float:range)
{

	a1 -= a2;
	if((a1 < range) && (a1 > -range)) return true;

	return false;

}

stock Float:PlayerAngle(playerid)
{
	new Float:Angle;
	if(IsPlayerInAnyVehicle(playerid)) GetVehicleZAngle(GetPlayerVehicleID(playerid), Angle);
	else GetPlayerFacingAngle(playerid, Angle);
	return Angle;
}

stock bool:IsPlayerFacingPoint(playerid, Float:PointX, Float:PointY, Float:Range = 10.0)
{
	new Float:FacingAngle = PlayerAngle(playerid), Float:Angle;
	new Float:X, Float:Y, Float:Z;
	GetPlayerPos(playerid, X, Y, Z);
	if(X > PointX && Y > PointY) Angle = floatabs(atan2(floatsub(PointX, X), floatsub(PointY, Y)));
	if(X > PointX && Y <= PointY) Angle = floatadd(floatabs(atan2(floatsub(Y, PointY), floatsub(PointX, X))), 270.0);
	if(X <= PointX && Y > PointY) Angle = floatadd(floatabs(atan2(floatsub(PointY, Y), floatsub(X, PointX))), 90.0);
	if(X <= PointX && Y <= PointY) Angle = floatadd(floatabs(atan2(floatsub(X, PointX), floatsub(Y, PointY))), 180.0);
	Range /= 2.0;
	return floatabs(floatsub(FacingAngle, Angle)) <= floatabs(Range) || floatabs(floatsub(floatadd(FacingAngle, 360.0), Angle)) <= floatabs(Range);
}

stock IsPlayerFacingVehicle(playerid,vehicleid)
{

	new Float:pX,Float:pY,Float:pZ,Float:X,Float:Y,Float:Z,Float:ang;

	if(!IsPlayerConnected(playerid)) return 0;

	GetVehiclePos(vehicleid, X, Y, Z);
	GetPlayerPos(playerid, pX, pY, pZ);

	if( Y > pY ) ang = (-acos((X - pX) / floatsqroot((X - pX)*(X - pX) + (Y - pY)*(Y - pY))) - 90.0);
	else if( Y < pY && X < pX ) ang = (acos((X - pX) / floatsqroot((X - pX)*(X - pX) + (Y - pY)*(Y - pY))) - 450.0);
	else if( Y < pY ) ang = (acos((X - pX) / floatsqroot((X - pX)*(X - pX) + (Y - pY)*(Y - pY))) - 90.0);

	if(X > pX) ang = (floatabs(floatabs(ang) + 180.0));
	else ang = (floatabs(ang) - 180.0);
	new Float:russia;
	GetPlayerFacingAngle(playerid,russia);
	if(ang-russia<-130 || ang-russia>130) return 0;
	else return 1;
}

