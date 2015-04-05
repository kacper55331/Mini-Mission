/* ---------------------------------------------------------- 
   Copyright by Kacper Michiewicz
   ---------------------------------------------------------- */
   
#include <CTime>
#include <foreach>
#include <socket>
#include <a_angles>

// ----------------------------------------------------------------------------------------------------
// Macros
// ----------------------------------------------------------------------------------------------------

#define type_dm			1
#define type_tdm		2
#define type_stunt		3
#define type_race		4
#define type_rp			5
#define type_truck		6
#define type_mini		7
#define type_mta		8

#define TIME_H			2	// Strefa czasowa
#define MAX_LINE		100	// Iloœæ linijek do przeniesienia do drugiej linijki

#define glob_name		"C-Games"
#define IN_HEAD         	grey""IN_NAME" "white"» "grey""IN_VERSION


#define Distance2D(%1,%2,%3,%4)		floatsqroot((%1 - %3) * (%1 - %3) + (%2 - %4) * (%2 - %4))
//#define Distance3D(%1,%2,%3,%4,%5,%6) 	floatsqroot((%1 - %4) * (%1 - %4) + (%2 - %5) * (%2 - %5) + (%3 - %6) * (%3 - %6))


#define isnull(%1) 		((!(%1[0])) || (((%1[0]) == '\1') && (!(%1[1]))))
#define dli(%1,%2,%3,%4) 	((%1==1)?(%2):(((%1% 10>1)&&(%1% 10<5)&&!((%1% 100>=10)&&(%1% 100<=21)))?(%3):(%4)))
#define A_CHAR(%0) 			for(new i = strlen(%0) - 1; i >= 0; i--) if(%0[i] == '%') %0[i] = '#'
#define randomEx(%0,%1) 	(random((%1)-(%0))+(%0))
#define isupper(%1) 		(((%1) > 0x60 && (%1) <= 0x7A) ? ((%1) ^ 0x20) : (%1))
#define islower(%1) 		(((%1) > 0x40 && (%1) <= 0x5A) ? ((%1) | 0x20) : (%1))
#define FuncPub::%1(%2)		forward %1(%2);public %1(%2)
#define Cmd::Input->%1(%2)  	COMMAND:%1(%2)
#define Chat::Output        	SendClientMessage
#define Dialog::Output		ShowPlayerDialog

#define green 				"{42B542}"
#define green2				"{007E00}"
#define red     			"{FF0000}"
#define red2				"{8B0000}"
#define white   			"{FFFFFF}"
#define yellow  			"{FFFF00}"
#define grey    			"{AFAFAF}"
#define C_BLUE2      		"{4682B4}"
#define C_YELLOW     		"{E9E312}"
#define C_ORANGE     		"{FF9900}"
#define C_GREEN      		"{33AA33}"
#define C_LIGHTGREEN 		"{90EE90}"

#define BIALY           	0xFFFFFFFF
#define COLOR_YELLOW    	0xFFFF00AA
#define COLOR_FADE1     	0xE6E6E6E6
#define COLOR_FADE2     	0xC8C8C8C8
#define COLOR_FADE3     	0xAAAAAAAA
#define COLOR_FADE4     	0x8C8C8C8C
#define COLOR_FADE5     	0x6E6E6E6E
#define COLOR_PURPLE 	  	0xC2A2DAAA
#define COLOR_PURPLE2 		0xBB98D6FF
#define COLOR_PURPLE3 		0xAD83CDFF
#define COLOR_PURPLE4 		0xA778C9FF
#define COLOR_PURPLE5 		0x9963C0FF
#define COLOR_DO 			0x88A2ECFF
#define COLOR_DO2 			0x88A2ECFF
#define COLOR_DO3 			0x6283E6FF
#define COLOR_DO4 			0x486FE1FF
#define COLOR_DO5 			0x3C65DFFF
#define SZARY           	0xAFAFAFAA
#define RED             	0xFF0000FF
#define ITEM_COLOR      	0x8a5fe7aa
#define KREMOWY         	0xFFBFFFAA
#define COLOR_LIGHTBLUE 	0x33CCFFAA
#define ITEM_COLOR 			0x8a5fe7aa
#define COLOR_LIGHTORANGE 	0xF7A26FFF
#define GREEN 				0x33AA33AA
#define COLOR_YELLOW    	0xFFFF00AA
#define CLR_BLACK 			0x000000FF
#define CLR_GRAY 			0xAFAFAFAA
#define CLR_WHITE 			0xFFFFFFFF
#define CLR_RED 			0xFF0000FF
#define CLR_DARKRED 	  	0xCF4028FF
#define CLR_ORANGE 			0xFFC973FF
#define CLR_DARKORANGE 		0xFDAE33FF
#define CLR_GREEN 			0x42B542FF
#define CLR_LIGHTGREEN 		0xA8EEA8FF
#define CLR_LIGHTBLUE 		0x1E90FFFF
#define CLR_YELLOW 			0xFFFF02FF
#define CLR_CYAN 			0x42D3FFFF
#define CLR_DARKCYAN 	  	0x59BDC6FF
#define CLR_PINK 			0xC2A2DAFF
#define CLR_LIGHTPINK 		0xFFC3FFFF
#define CLR_NIEBIESKI 		0x688CCEAA
#define CLR_ZOLTY 			0xFFFF00AA
#define CLR_KREMOWY 	  	0xF5DEB3AA
#define CLR_ROZOWY 			0xFFBFFFAA


// ----------------------------------------------------------------------------------------------------
// Variables
// ----------------------------------------------------------------------------------------------------


stock const MonthNames[ 12 ][ 12 ] = {
	{ "Styczeñ" 	 },	{ "Luty" 		}, { "Marzec"	},
	{ "Kwiecieñ" 	 },	{ "Maj" 		}, { "Czerwiec"	},
	{ "Lipiec"  	 },	{ "Sierpieñ"  	}, { "Wrzesieñ"	},
	{ "PaŸdziernik"  },	{ "Listopad"  	}, { "Grudzieñ"	}
};

stock const MonthNamesShort[ 12 ][ 4 ] = {
	{ "Sty" 	 },	{ "Lut" 	}, { "Mar"	},
	{ "Kwi" 	 },	{ "Maj" 	}, { "Cze"	},
	{ "Lip"  	 },	{ "Sie"  	}, { "Wrz"	},
	{ "PaŸ"  	 },	{ "Lis"  	}, { "Gru"	}
};

stock const days[ 7 ][ 13 ] =
{
	{ "Niedziela" 	}, { "Poniedzialek"	}, { "Wtorek"  }, { "Sroda"     },
	{ "Czwartek" 	}, { "Piatek"		}, { "Sobota"  }
};

stock const DiscReason[ 3 ][ 9 ] = {
	{ "Crash" 		},
	{ "/q" 			},
	{ "Kick/Ban" 	}
};

stock const ObjectModel[ ] = {
	-1,  331, 333, 334, 335, 336, 337, 338, 339, 341, 321, 322,
	323, 324, 325, 326, 342, 343, 344,  -1,  -1,  -1, 346, 347,
	348, 349, 350, 351, 352, 353, 355, 356, 372, 357, 358, 359,
	360, 361, 362, 363, 364, 365, 366, 367, 368, 369, 371, -1
};

stock const NazwyPojazdow[ 212 ][ 18 ] =
{
	{ "Landstalker"       }, { "Bravura"           }, { "Buffalo"           }, { "Linerunner"        }, // 400, 401, 402, 403
	{ "Perrenial"         }, { "Sentinel"          }, { "Dumper"            }, { "Firetruck"         }, // 404, 405, 406, 407
	{ "Trashmaster"       }, { "Stretch"           }, { "Manana"            }, { "Infernus"          }, // 408, 409, 410, 411
	{ "Voodoo"            }, { "Pony"              }, { "Mule"              }, { "Cheetah"           }, // 412, 413, 414, 415
	{ "Ambulance"         }, { "Leviathan"         }, { "Moonbeam"          }, { "Esperanto"         }, // 416, 417, 418, 419
	{ "Taxi"              }, { "Washington"        }, { "Bobcat"            }, { "Mr Whoopee"        }, // 420, 421, 422, 423
	{ "BF Injection"      }, { "Hunter"            }, { "Premier"           }, { "Enforcer"          }, // 424, 425, 426, 427
	{ "Securicar"         }, { "Banshee"           }, { "Predator"          }, { "Bus"               }, // 428, 429, 430, 431
	{ "Rhino"             }, { "Barracks"          }, { "Hotknife"          }, { "Trailer 1"         }, // 432, 433, 434, 435
	{ "Previon"           }, { "Coach"             }, { "Cabbie"            }, { "Stallion"          }, // 436, 437, 438, 439
	{ "Rumpo"             }, { "RC Bandit"         }, { "Romero"            }, { "Packer"            }, // 440, 441, 442, 443
	{ "Monster"           }, { "Admiral"           }, { "Squalo"            }, { "Seasparrow"        }, // 444, 445, 446, 447
	{ "Pizzaboy"          }, { "Tram"              }, { "Trailer 2"         }, { "Turismo"           }, // 448, 449, 450, 451
	{ "Speeder"           }, { "Reefer"            }, { "Tropic"            }, { "Flatbed"           }, // 452, 453, 454, 455
	{ "Yankee"            }, { "Caddy"             }, { "Solair"            }, { "RC Van"            }, // 456, 457, 458, 459
	{ "Skimmer"           }, { "PCJ-600"           }, { "Faggio"            }, { "Freeway"           }, // 460, 461, 462, 463
	{ "RC Baron"          }, { "RC Raider"         }, { "Glendale"          }, { "Oceanic"           }, // 464, 465, 466, 467
	{ "Sanchez"           }, { "Sparrow"           }, { "Patriot"           }, { "Quad"              }, // 468, 469, 470, 471
	{ "Coastguard"        }, { "Dinghy"            }, { "Hermes"            }, { "Sabre"             }, // 472, 473, 474, 475
	{ "Rustler"           }, { "ZR-350"            }, { "Walton"            }, { "Regina"            }, // 476, 477, 478, 479
	{ "Comet"             }, { "BMX"               }, { "Burrito"           }, { "Camper"            }, // 480, 481, 482, 483
	{ "Marquis"           }, { "Baggage"           }, { "Dozer"             }, { "Maverick"          }, // 484, 485, 486, 487
	{ "News Chopper"      }, { "Rancher"           }, { "FBI Rancher"       }, { "Virgo"             }, // 488, 489, 490, 491
	{ "Greenwood"         }, { "Jetmax"            }, { "Hotring"           }, { "Sandking"          }, // 492, 493, 494, 495
	{ "Blista"            }, { "Police Maverick"   }, { "Boxville"          }, { "Benson"            }, // 496, 497, 498, 499
	{ "Mesa"              }, { "RC Goblin"         }, { "Hotring A"         }, { "Hotring B"         }, // 500, 501, 502, 503
	{ "Bloodring Banger"  }, { "Rancher"           }, { "Super GT"          }, { "Elegant"           }, // 504, 505, 506, 507
	{ "Journey"           }, { "Bike"              }, { "Mountain Bike"     }, { "Beagle"            }, // 508, 509, 510, 511
	{ "Cropdust"          }, { "Stuntplane"        }, { "Tanker"            }, { "Roadtrain"         }, // 512, 513, 514, 515
	{ "Nebula"            }, { "Majestic"          }, { "Buccaneer"         }, { "Shamal"            }, // 516, 517, 518, 519
	{ "Hydra"             }, { "FCR-900"           }, { "NRG-500"           }, { "HPV1000"           }, // 520, 521, 522, 523
	{ "Cement Truck"      }, { "Tow Truck"         }, { "Fortune"           }, { "Cadrona"           }, // 524, 525, 526, 527
	{ "FBI Truck"         }, { "Willard"           }, { "Forklift"          }, { "Tractor"           }, // 528, 529, 530, 531
	{ "Combine"           }, { "Feltzer"           }, { "Remington"         }, { "Slamvan"           }, // 532, 533, 534, 535
	{ "Blade"             }, { "Freight"           }, { "Streak"            }, { "Vortex"            }, // 536, 537, 538, 539
	{ "Vincent"           }, { "Bullet"            }, { "Clover"            }, { "Sadler"            }, // 540, 541, 542, 543
	{ "Firetruck LA"      }, { "Hustler"           }, { "Intruder"          }, { "Primo"             }, // 544, 545, 546, 547
	{ "Cargobob"          }, { "Tampa"             }, { "Sunrise"           }, { "Merit"             }, // 548, 549, 550, 551
	{ "Utility"           }, { "Nevada"            }, { "Yosemite"          }, { "Windsor"           }, // 552, 553, 554, 555
	{ "Monster"           }, { "Monster"           }, { "Uranus"            }, { "Jester"            }, // 556, 557, 558, 559
	{ "Sultan"            }, { "Stratum"           }, { "Elegy"             }, { "Raindance"         }, // 560, 561, 562, 563
	{ "RC Tiger"          }, { "Flash"             }, { "Tahoma"            }, { "Savanna"           }, // 564, 565, 566, 567
	{ "Bandito"           }, { "Freight Flat"      }, { "Streak Carriage"   }, { "Kart"              }, // 568, 569, 570, 571
	{ "Mower"             }, { "Duneride"          }, { "Sweeper"           }, { "Broadway"          }, // 572, 573, 574, 575
	{ "Tornado"           }, { "AT-400"            }, { "DFT-30"            }, { "Huntley"           }, // 576, 577, 578, 579
	{ "Stafford"          }, { "BF-400"            }, { "Newsvan"           }, { "Tug"               }, // 580, 581, 582, 583
	{ "Trailer 3"         }, { "Emperor"           }, { "Wayfarer"          }, { "Euros"             }, // 584, 585, 586, 587
	{ "Hotdog"            }, { "Club"              }, { "Freight Carriage"  }, { "Trailer 3"         }, // 588, 589, 590, 591
	{ "Andromada"         }, { "Dodo"              }, { "RC Cam"            }, { "Launch"            }, // 592, 593, 594, 595
	{ "Police LS"         }, { "Police SF"         }, { "Police LV"         }, { "Police Ranger"     }, // 596, 597, 598, 599
	{ "Picador"           }, { "S.W.A.T. Van"      }, { "Alpha"             }, { "Phoenix"           }, // 600, 601, 602, 603
	{ "Glendale"          }, { "Sadler"            }, { "Luggage Trailer A" }, { "Luggage Trailer B" }, // 604, 605, 606, 607
	{ "Stair Trailer"     }, { "Boxville"          }, { "Farm Plow"         }, { "Utility Trailer"   }  // 608, 609, 610, 611
};

stock const znaki[ 62 ] =
{
	'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm',
	'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z',
	'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M',
	'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z',
	'0', '1', '2', '3', '4', '5', '6', '7', '8', '9'
};

stock TypeTeamColor(type)
{
	new back[ 16 ];
	switch(type)
	{
			case type_mini:		back = C_LIGHTGREEN"[MINI]";
			case type_rp:		back = C_BLUE2"[RP]";
/*	    	case type_dm:   	back = C_YELLOW"[DM]";
	    	case type_tdm:  	back = C_ORANGE"[TDM]";
	    	case type_race: 	back = C_LIGHTGREEN"[RACE]";
	    	case type_stunt:    back = C_GREEN"[STUNT]";
			case type_truck:	back = "[TRUCK]";
*/
	}
	return back;
}

stock CarColHex[127] = {
	0x000000FF,0xF5F5F5FF,0x2A77A1FF,0x840410FF,0x263739FF,0x86446EFF,0xD78E10FF,0x4C75B7FF,
	0xBDBEC6FF,0x5E7072FF,0x46597AFF,0x656A79FF,0x5D7E8DFF,0x58595AFF,0xD6DAD6FF,0x9CA1A3FF,
	0x335F3FFF,0x730E1AFF,0x7B0A2AFF,0x9F9D94FF,0x3B4E78FF,0x732E3EFF,0x691E3BFF,0x96918CFF,
	0x515459FF,0x3F3E45FF,0xA5A9A7FF,0x635C5AFF,0x3D4A68FF,0x979592FF,0x421F21FF,0x5F272BFF,
	0x8494ABFF,0x767B7CFF,0x646464FF,0x5A5752FF,0x252527FF,0x2D3A35FF,0x93A396FF,0x6D7A88FF,
	0x221918FF,0x6F675FFF,0x7C1C2AFF,0x5F0A15FF,0x193826FF,0x5D1B20FF,0x9D9872FF,0x7A7560FF,
	0x989586FF,0xADB0B0FF,0x848988FF,0x304F45FF,0x4D6268FF,0x162248FF,0x272F4BFF,0x7D6256FF,
	0x9EA4ABFF,0x9C8D71FF,0x6D1822FF,0x4E6881FF,0x9C9C98FF,0x917347FF,0x661C26FF,0x949D9FFF,
	0xA4A7A5FF,0x8E8C46FF,0x341A1EFF,0x6A7A8CFF,0xAAAD8EFF,0xAB988FFF,0x851F2EFF,0x6F8297FF,
	0x585853FF,0x9AA790FF,0x601A23FF,0x20202CFF,0xA4A096FF,0xAA9D84FF,0x78222BFF,0x0E316DFF,
	0x722A3FFF,0x7B715EFF,0x741D28FF,0x1E2E32FF,0x4D322FFF,0x7C1B44FF,0x2E5B20FF,0x395A83FF,
	0x6D2837FF,0xA7A28FFF,0xAFB1B1FF,0x364155FF,0x6D6C6EFF,0x0F6A89FF,0x204B6BFF,0x2B3E57FF,
	0x9B9F9DFF,0x6C8495FF,0x4D5D60FF,0xAE9B7FFF,0x406C8FFF,0x1F253BFF,0xAB9276FF,0x134573FF,
	0x96816CFF,0x64686AFF,0x105082FF,0xA19983FF,0x385694FF,0x525661FF,0x7F6956FF,0x8C929AFF,
	0x596E87FF,0x473532FF,0x44624FFF,0x730A27FF,0x223457FF,0x640D1BFF,0xA3ADC6FF,0x695853FF,
	0x9B8B80FF,0x620B1CFF,0x5B5D5EFF,0x624428FF,0x731827FF,0x1B376DFF,0xEC6AAEFF
};

stock IsCar(vehicleid) 
{
	switch(GetVehicleModel(vehicleid))
	{
		case
			416, //ambulan - car
			445, //admiral - car
			602, //alpha - car
			485, //baggage - car
			568, //bandito - car
			429, //banshee - car
			499, //benson - car
			424, //bfinject, //car
			536, //blade - car
			496, //blistac - car
			504, //bloodra - car
			422, //bobcat - car
			609, //boxburg - car
			498, //boxville, //car
			401, //bravura - car
			575, //broadway, //car
			518, //buccanee, //car
			402, //buffalo - car
			541, //bullet - car
			482, //burrito - car
			431, //bus - car
			438, //cabbie - car
			457, //caddy - car
			527, //cadrona - car
			483, //camper - car
			524, //cement - car
			415, //cheetah - car
			542, //clover - car
			589, //club - car
			480, //comet - car
			596, //copcarla, //car
			599, //copcarru, //car
			597, //copcarsf, //car
			598, //copcarvg, //car
			578, //dft30 - car
			486, //dozer - car
			507, //elegant - car
			562, //elegy - car
			585, //emperor - car
			427, //enforcer, //car
			419, //esperant, //car
			587, //euros - car
			490, //fbiranch, //car
			528, //fbitruck, //car
			533, //feltzer - car
			544, //firela - car
			407, //firetruk, //car
			565, //flash - car
			455, //flatbed - car
			530, //forklift, //car
			526, //fortune - car
			466, //glendale, //car
			604, //glenshit, //car
			492, //greenwoo, //car
			474, //hermes - car
			434, //hotknife, //car
			502, //hotrina - car
			503, //hotrinb - car
			494, //hotring - car
			579, //huntley - car
			545, //hustler - car
			411, //infernus, //car
			546, //intruder, //car
			559, //jester - car
			508, //journey - car
			571, //kart - car
			400, //landstal, //car
			403, //linerun - car
			517, //majestic, //car
			410, //manana - car
			551, //merit - car
			500, //mesa - car
			418, //moonbeam, //car
			572, //mower - car
			423, //mrwhoop - car
			516, //nebula - car
			582, //newsvan - car
			467, //oceanic - car
			404, //peren - car
			514, //petro - car
			603, //phoenix - car
			600, //picador - car
			413, //pony - car
			426, //premier - car
			436, //previon - car
			547, //primo - car
			489, //rancher - car
			441, //rcbandit, //car
			594, //rccam - car
			564, //rctiger - car
			515, //rdtrain - car
			479, //regina - car
			534, //remingtn, //car
			505, //rnchlure, //car
			442, //romero - car
			440, //rumpo - car
			475, //sabre - car
			543, //sadler - car
			605, //sadlshit, //car
			495, //sandking, //car
			567, //savanna - car
			428, //securica, //car
			405, //sentinel, //car
			535, //slamvan - car
			458, //solair - car
			580, //stafford, //car
			439, //stallion, //car
			561, //stratum - car
			409, //stretch - car
			560, //sultan - car
			550, //sunrise - car
			506, //supergt - car
			601, //swatvan - car
			574, //sweeper - car
			566, //tahoma - car
			549, //tampa - car
			420, //taxi - car
			459, //topfun - car
			576, //tornado - car
			583, //tug - car
			451, //turismo - car
			558, //uranus - car
			552, //utility - car
			540, //vincent - car
			491, //virgo - car
			412, //voodoo - car
			478, //walton - car
			421, //washing - car
			529, //willard - car
			555, //windsor - car
			456, //yankee - car
			554, //yosemite - car
			477 //zr350 - car
		: return 1;
	}
	return 0;
}

stock IsABoat(carid)
{
	new model = GetVehicleModel(carid);
	switch(model)
	{
		case 430,446,452,453,454,472,473,484,493,595: return 1;
		default: return 0;
	}
	return 1;
}

stock IsABike(carid)//Kategoria A
{
	new model = GetVehicleModel(carid);
	switch(model)
	{
		case 521,522,581,586,448,461,462,463,468,471: return 1;
		default: return 0;
	}
	return 1;
}
stock IsARower(carid)
{
	new model = GetVehicleModel(carid);
	switch(model)
	{
		case 481,509,510: return 1;
		default: return 0;
	}
	return 1;
}
stock IsAPlane(carid)
{
	new model = GetVehicleModel(carid);
	switch(model)
	{
		case 460,464,476,511,513,519,520,539,593,417,425,447,465: return 1;
		case 469,487,488,497,501,548,563,592,577,553: return 1;
		default: return 0;
	}
	return 1;
}
stock IsATir(carid)//Kategoria C+E
{
	new model = GetVehicleModel(carid);
	switch(model)
	{
		case 524,578,455,403,443,514,515,408,499,498,609,414,456: return 1;
		case 406,407,416,427,428,433,486,532,544,573: return 1;
		default: return 0;
	}
	return 1;
}
stock IsABus(carid)
{ //Kategoria D+E
	new model = GetVehicleModel(carid);
	switch(model){
	    case 431:return 1;
	    case 437:return 1;
	   	default: return 0;

	}
	return 1;
}

stock Float:Distance3D(Float:x1, Float:y1, Float:z1, Float:x2, Float:y2, Float:z2)
{
    return VectorSize(x1-x2, y1-y2, z1-z2);
}

stock ReturnTime(time, string[], len = sizeof string)
{
	new tm<tmTime>;
	
    gmtime(Time:time, tmTime);

	if((tmTime[ tm_mday ]-1) > 0)
		format(string, len, "%d%s", tmTime[ tm_mday ]-1, dli(tmTime[ tm_mday ]-1, "dzieñ", "dni", "dni"));
	else
	{
		if(!tmTime[ tm_hour ] && !tmTime[ tm_min ])
			format(string, len, "%d %s", tmTime[ tm_sec ], dli(tmTime[ tm_sec ], "sekunda", "sekundy", "sekund"));
    	else if(!tmTime[ tm_hour ] && !tmTime[ tm_sec ])
			format(string, len, "%d %s", tmTime[ tm_min ], dli(tmTime[ tm_min ], "minuta", "minuty", "minut"));
    	else if(!tmTime[ tm_min ] && !tmTime[ tm_sec ])
			format(string, len, "%d %s", tmTime[ tm_hour ], dli(tmTime[ tm_hour ], "godzina", "godziny", "godzin"));
    	else if(!tmTime[ tm_hour ])
			format(string, len, "%d %s %d %s", tmTime[ tm_min ], dli(tmTime[ tm_min ], "minuta", "minuty", "minut"), tmTime[ tm_sec ], dli(tmTime[ tm_sec ], "sekunda", "sekundy", "sekund"));
		else
		{
			format(string, len, "%d %s %d %s %d %s", tmTime[ tm_hour ], dli(tmTime[ tm_hour ], "godzina", "godziny", "godzin"), tmTime[ tm_min ], dli(tmTime[ tm_min ], "minuta", "minuty", "minut"), tmTime[ tm_sec ]);
			strcat(string, dli(tmTime[ tm_sec ], "sekunda", "sekundy", "sekund"), len);
		}
	}
	return 1;
}

stock ReturnTimeMega(time, string[], len = sizeof string)
{
	new tm<tmTime>;
	
    gmtime(Time:time, tmTime);

	if((tmTime[ tm_mday ]-1) > 0)
		format(string, len, "%d%s", tmTime[ tm_mday ]-1, dli(tmTime[ tm_mday ]-1, "dzieñ", "dni", "dni"));
	else
	{
		if(!tmTime[ tm_hour ] && !tmTime[ tm_min ])
			format(string, len, "%ds", tmTime[ tm_sec ]);
    	else if(!tmTime[ tm_hour ] && !tmTime[ tm_sec ])
			format(string, len, "%dmin", tmTime[ tm_min ]);
    	else if(!tmTime[ tm_min ] && !tmTime[ tm_sec ])
			format(string, len, "%dh", tmTime[ tm_hour ]);
    	else if(!tmTime[ tm_hour ])
			format(string, len, "%dmin %ds", tmTime[ tm_min ], tmTime[ tm_sec ]);
    	else if(!tmTime[ tm_min ])
			format(string, len, "%dh %ds", tmTime[ tm_hour ], tmTime[ tm_sec ]);
    	else if(!tmTime[ tm_sec ])
			format(string, len, "%dh %dmin", tmTime[ tm_hour ], tmTime[ tm_sec ]);
		else
			format(string, len, "%dh %dmin %ds", tmTime[ tm_hour ], tmTime[ tm_min ], tmTime[ tm_sec ]);
	}
	return 1;
}

stock ReturnTimeEx(time, string[], len = sizeof string)
{
	new tm<tmTime>;
	
    gmtime(Time:time, tmTime);

	if((tmTime[ tm_mday ]-1) > 0)
	{
		if(tmTime[ tm_hour ] > 0)
			format(string, len, "%d %s %d %s", tmTime[ tm_mday ]-1, dli(tmTime[ tm_mday ]-1, "dzieñ", "dni", "dni"), tmTime[ tm_hour ], dli(tmTime[ tm_hour ], "godzina", "godziny", "godzin"));
		else
			format(string, len, "%d %s", tmTime[ tm_mday ]-1, dli(tmTime[ tm_mday ]-1, "dzieñ", "dni", "dni"));
	}
	else
	{
		if(tmTime[ tm_hour ] > 0)
		{
			if(tmTime[ tm_min ] > 0)
				format(string, len, "%d %s %d %s", tmTime[ tm_hour ], dli(tmTime[ tm_hour ], "godzina", "godziny", "godzin"), tmTime[ tm_min ], dli(tmTime[ tm_min ], "minuta", "minuty", "minut"));
			else
				format(string, len, "%d %s", tmTime[ tm_hour ], dli(tmTime[ tm_hour ], "godzina", "godziny", "godzin"));
		}
		else
		{
			if(tmTime[ tm_min ] > 0)
			{
				if(tmTime[ tm_sec ] > 0)
					format(string, len, "%d %s %d %s", tmTime[ tm_min ], dli(tmTime[ tm_min ], "minuta", "minuty", "minut"), tmTime[ tm_sec ], dli(tmTime[ tm_sec ], "sekunda", "sekundy", "sekund"));
				else
					format(string, len, "%d %s", tmTime[ tm_min ], dli(tmTime[ tm_min ], "minuta", "minuty", "minut"));
			}
			else
				format(string, len, "%d %s", tmTime[ tm_sec ], dli(tmTime[ tm_sec ], "sekunda", "sekundy", "sekund"));
		}
	}
	return 1;
}


stock ReturnTimeAgo(time, string[], len = sizeof string)
{
	static acttime[ 3 ];
	new tm<tmTime>;
	
	gmtime(Time:time, tmTime);
	getdate(acttime[ 0 ], acttime[ 1 ], acttime[ 2 ]);
	
 	if(tmTime[ tm_mday ] == acttime[ 2 ] && acttime[ 1 ] == (tmTime[ tm_mon ]+1))
 		format(string, len, "Dzisiaj %02d:%02d", (tmTime[ tm_hour ] + TIME_H) % 24, tmTime[ tm_min ]);
 	else if(tmTime[ tm_mday ] == (acttime[ 2 ]-1) && acttime[ 1 ] == (tmTime[ tm_mon ]+1))
 		format(string, len, "Wczoraj %02d:%02d\t", (tmTime[ tm_hour ] + TIME_H) % 24, tmTime[ tm_min ]);
 	else
 		format(string, len, "%02d %s %02d:%02d", tmTime[ tm_mday ], MonthNamesShort[ tmTime[ tm_mon ] ], (tmTime[ tm_hour ] + TIME_H) % 24, tmTime[ tm_min ]);
	return 1;
}

stock HexToInt(string[])
{
    if(string[ 0 ] == 0)
		return 0;
    new i,
		cur = 1,
		res = 0;
    for(i = strlen(string); i > 0; i--)
    {
        if (string[ i-1 ] < 58)
            res = res + cur * (string[ i - 1 ] - 48);
        else
        {
            res = res + cur * (string[ i-1 ] - 65 + 10);
            cur = cur * 16;
        }
    }
    return res;
}

stock NiceMoney(amount, sep[] = ",")
{
    new
        str[16],
        negativ = 0;
    if(amount < 0) negativ = 1;
    format(str, sizeof(str), "%i", amount);
    new
        lenght = strlen(str);
    while((lenght -= 3) > negativ) strins(str, sep, lenght);
    return str;
}

stock chartostring(_char)
{
	new string[ 2 ];
	string[ 0 ] = _char;
	return string;
}

stock decodepl(string[], dechar = '#')
{
	new charstring[ 2 ],
		length = strlen(string),
		i;

	charstring = chartostring(dechar);
	while ((i = strfind (string, charstring, false, i)) != -1)
	{
	    strdel (string, i, i+1);
	    length--;
	    switch (string[i])
	    {
	        case 'a': string [i] = '¹';
			case 'c': string [i] = 'æ';
			case 'e': string [i] = 'ê';
			case 'l': string [i] = '³';
			case 'n': string [i] = 'ñ';
			case 'o': string [i] = 'ó';
			case 's': string [i] = 'œ';
			case 'x': string [i] = 'Ÿ';
			case 'z': string [i] = '¿';
			case 'A': string [i] = '¥';
			case 'C': string [i] = 'Æ';
			case 'E': string [i] = 'Ê';
			case 'L': string [i] = '£';
			case 'N': string [i] = 'Ñ';
			case 'O': string [i] = 'Ó';
			case 'S': string [i] = 'Œ';
			case 'X': string [i] = '';
			case 'Z': string [i] = '¯';
	    }
	    i++;
	}
}

stock char_replace(buffer[], ch[], ch2[], bool:chars_size = false, len = sizeof buffer)
{
	new f = strfind(buffer, ch, chars_size);
	while (f >= 0)
	{
		strdel(buffer, f, f+strlen(ch));
		strins(buffer, ch2, f, len);
		f = strfind(buffer, ch, chars_size);
	}
}

stock CheckTextDrawString(const string[])
{
	for(new znak = 0; znak < strlen(string); znak++)
	{
		if(string[znak] == '~')
		{
			if((string[znak+1] == 'r' || string[znak+1] == 'g' || string[znak+1] == 'b' || string[znak+1] == 'w' || string[znak+1] == 'l' || string[znak+1] == 'p' || string[znak+1] == 'n') && string[znak+2] == '~')
			{
				if(string[znak+2] == '~') znak += 2;
			}
			else return 0;
		}
	}
	return 1;
}

stock abs(value)
{
    return ((value < 0 ) ? (-value) : (value));
}

stock StripEmbed(const string[])
{
    new
        ret[128],
        count = 0,
        position = -1;

    strcat(ret, string, sizeof(ret));
    while ((position = strfind(ret, "{")) != -1)
    {
        for (new index = position + 1; index < position + 7; index ++)
        {
            switch (ret[index])
            {
                case 'a'..'z': count++;
                case 'A'..'Z': count++;
                case '0'..'9': count++;
                default: break;
            }
        }
        if (count == 6)
        {
            strdel(ret, position, position + 8);
            count = 0;
            continue;
        }
        break;
    }
    return ret;
}

stock bool:IsValidSkin(skinid)
{
	if(skinid < 0 || skinid > 299) return true;
	switch(skinid)
	{
		case 74: return true;
	}
	return false;
}

stock bool:IsValidWeapon(weaponid)
{
	if(weaponid < 0 || weaponid > 46) return true;
	switch(weaponid)
	{
		case 18, 19, 20, 21, 44, 45: return true;
	}
	return false;
}

stock Float:GetXYInFrontOfPlayer(playerid, &Float:x, &Float:y, Float:distance)
{
    new Float:a;
    GetPlayerPos(playerid, x, y, a);
    if(IsPlayerInAnyVehicle(playerid))
		GetVehicleZAngle(GetPlayerVehicleID(playerid), a);
	else
		GetPlayerFacingAngle(playerid, a);
    x += (distance * floatsin(-a, degrees));
	y += (distance * floatcos(-a, degrees));
    return a;
}

stock OdlegloscMiedzyGraczami(Float:radi, playerid, targetid)
{
	if(IsPlayerConnected(playerid) && IsPlayerConnected(targetid))
	{
		new Float:posx, Float:posy, Float:posz;
		new Float:oldposx, Float:oldposy, Float:oldposz;
		new Float:tempposx, Float:tempposy, Float:tempposz;
		GetPlayerPos(playerid, oldposx, oldposy, oldposz);
		GetPlayerPos(targetid, posx, posy, posz);
		tempposx = (oldposx -posx);
		tempposy = (oldposy -posy);
		tempposz = (oldposz -posz);
		if (((tempposx < radi) && (tempposx > -radi)) && ((tempposy < radi) && (tempposy > -radi)) && ((tempposz < radi) && (tempposz > -radi)))
			return 1;
	}
	return 0;
}

stock floatval(Float:f)
{
//	formatex(liczba, 10, "%.0f", f);
	new liczba[ 10 ];
	format(liczba, sizeof liczba, "%f", (f-floatfract(f)));
	return strval(liczba);
}

stock EscapePL(name[])
{
    for(new i = 0; name[i] != 0; i++)
    {
	    if(name[i] == 'œ') name[i] = 's';
	    else if(name[i] == 'ê') name[i] = 'e';
	    else if(name[i] == 'ó') name[i] = 'o';
	    else if(name[i] == '¹') name[i] = 'a';
	    else if(name[i] == '³') name[i] = 'l';
	    else if(name[i] == '¿') name[i] = 'z';
	    else if(name[i] == 'Ÿ') name[i] = 'z';
	    else if(name[i] == 'æ') name[i] = 'c';
	    else if(name[i] == 'ñ') name[i] = 'n';
    }
}

stock YesOrNo(bool:what)
{
	new str[ 12 ];
	if(what) str = green2"Tak";
	else str = red2"Nie";
	return str;
}

stock HavePlayerWeapon(playerid)
{
	return IsPlayerWeapon(GetPlayerWeapon(playerid));
}

stock IsPlayerWeapon(model)
{
   	switch(model)
   	{
      		case 16..18,22..39,41,42: return true;
      		default: return false;
	}
	return false;
}

stock GetWeaponSlot(wID)
{
	if (wID >= 0 && wID <= 46)
	{
	    if (wID == 0 || wID == 1) return 0;
	    if (wID >= 2 && wID <= 9) return 1;
	    if (wID >= 10 && wID <= 15) return 10;
	    if ((wID >= 16 && wID <= 18) || wID == 39) return 8;
	    if (wID >= 19 && wID <= 21) return -1;
	    if (wID >= 22 && wID <= 24) return 2;
	    if (wID >= 25 && wID <= 27) return 3;
	    if (wID == 28 || wID == 29 || wID == 32) return 4;
	    if (wID == 30 || wID == 31) return 5;
	    if (wID == 33 || wID == 34) return 6;
	    if (wID >= 35 && wID <= 38) return 7;
	    if (wID == 40) return 12;
	    if (wID >= 41 && wID <= 43) return 9;
	    if (wID >= 44 && wID <= 46) return 11;
	}
	return -1;
}

stock RemovePlayerWeapon(playerid, weaponid)
{
	new plyWeapons[12];
	new plyAmmo[12];

	for(new slot = 0; slot != 12; slot++)
	{
		new wep, ammo;
		GetPlayerWeaponData(playerid, slot, wep, ammo);
		
		if(wep != weaponid)
		{
			GetPlayerWeaponData(playerid, slot, plyWeapons[slot], plyAmmo[slot]);
		}
	}
	
	ResetPlayerWeapons(playerid);
	for(new slot = 0; slot != 12; slot++)
	{
		GivePlayerWeapon(playerid, plyWeapons[slot], plyAmmo[slot]);
	}
}

stock FullTime(sekundy,&godziny,&minuty,&sek)  // By Terminator3
{
	if(sekundy<60)
	{
		sek=sekundy;
		return 1;
	}
	if(!sekundy) return 1;
	while(sekundy>=3600)
	{
		godziny+=1;
		sekundy-=3600;
	}
	if(!sekundy) return 1;
	while(sekundy >= 60)
	{
		minuty+=1;
		sekundy-=60;
	}
	sek=sekundy;
	return 1;
}

stock FullTimeExtra(time, string[], len = sizeof string)
{
	new timex[ 3 ];
	FullTime(time, timex[ 0 ], timex[ 1 ], timex[ 2 ]);

	if(!timex[ 0 ] && !timex[ 1 ])
		format(string, len, "%ds", timex[ 2 ]);
	else if(!timex[ 0 ] && !timex[ 2 ])
		format(string, len, "%dmin", timex[ 1 ]);
	else if(!timex[ 1 ] && !timex[ 2 ])
		format(string, len, "%dh", timex[ 0 ]);
	else if(!timex[ 0 ])
		format(string, len, "%dmin %ds", timex[ 1 ], timex[ 2 ]);
	else if(!timex[ 1 ])
		format(string, len, "%dh %ds", timex[ 0 ], timex[ 2 ]);
	else if(!timex[ 2 ])
		format(string, len, "%dh %dmin", timex[ 0 ], timex[ 2 ]);
	else
		format(string, len, "%dh %dmin %ds", timex[ 0 ], timex[ 1 ], timex[ 2 ]);
	return 1;
}

stock IsNumeric(const string[])
{
  	if(!strlen(string)) return 0;
  	for(new i = 0; i < strlen(string); i++)
      	if((string[i] > '9' || string[i] < '0' && string[i] != '-' && string[i] != '+') || (string[i] == '-' && i != 0) || (string[i] == '+' && i != 0)) return 0;
  	if(strlen(string) == 1 && (string[0] == '-' || string[0] == '+')) return 0;
  	return 1;
}

stock Float:AngleDifference(Float:a, Float:b)
{
	if(a < 0.0)
		a+= 360;
	if(b < 0.0)
		b += 360;
	if(a == b)
		return 0.0;

	if(floatabs(a - b) <= 180.0)
		return floatabs(a - b);
	else
	{
		if(a > 180.0)
		    a = 360 - a;
		else if(b > 180.0)
		    b = 360 - b;

		return (a + b);
	}
}