#define gui_active          "{B9CBEC}"

// cmd

#define NoPlayer(%1)        ShowInfo(%1, red"Nie znaleziono gracza o podanym ID!")

#define kom     			"{999ccc}"
#define kom2     			"{9378ab}"

// items

#define item_used           "{33AA33}"
#define item_buyed          "{4682B4}"

// camera

#define dark_none           0
#define dark_camera         1
#define dark_spawn          2
#define dark_login          3
#define dark_login2         4
#define dark_kick           5
#define dark_start          6
#define dark_start2         7

// keys

#define PRESSED(%0) \
	(((newkeys & (%0)) == (%0)) && ((oldkeys & (%0)) != (%0)))
#define HOLDING(%0) \
	((newkeys & (%0)) == (%0))
#define RELEASED(%0) \
	(((newkeys & (%0)) != (%0)) && ((oldkeys & (%0)) == (%0)))
	
// blocks

#define block_none          0
#define block_ban           1

// Options

#define option_none         0
#define option_shooting     1
#define option_hand         2
#define option_fp          	4
#define option_pm           8
#define option_panor        16

#define prem_option_none    0
#define prem_option_nitro   1
#define prem_option_neon    2

// sounds

#define gui_button1_sound   		1
#define gui_button2_sound   		2
#define kill_doublekill_sound    	3
#define kill_killingspree_sound     4
#define kill_monsterkill_sound      5
#define kill_dominating_sound       6
#define kill_unstopable_sound       7
#define kill_godlike_sound        	8
#define kill_ludicrouskill_sound  	9
#define kill_firstblood_sound       10
#define bomb_planted                11
#define bomb_defused                12
#define bomb_1                      13
#define bomb_2                      14
#define info_sound                  15
#define achiv_sound                 16

// Edit

#define create_cat_none 	0
#define create_cat_obj 		1
#define create_cat_eobj     2

// Pickup

#define pick_func_none      0
#define pick_func_weapon    1
#define pick_func_nitro     2
#define pick_func_repair    3
#define pick_func_hunter    4
#define pick_func_health    5
