<?php
class MMClass
{
	static public function getPenalty( )
	{
		$Penalty = array( 
			0 => array("id" => 0, "name" => "Brak"), 
				array("id" => 1, "name" => "Kick"), 
				array("id" => 2, "name" => "Kick"), 
				array("id" => 3, "name" => "Kick"), 
				array("id" => 4, "name" => "Kick"), 
				array("id" => 5, "name" => "Kick"), 
				array("id" => 6, "name" => "Kick"), 
				array("id" => 7, "name" => "Kick"), 
				array("id" => 8, "name" => "Kick"), 
				array("id" => 9, "name" => "Kick"), 
				array("id" => 10, "name" => "Kick") 
			);
		return $Penalty;
	}
	
	static public function getPenaltyType( $type )
	{
		$result = MMClass::getPenalty( );
		return $result[ $type ][ 'name' ];
	}

	static public function getGameName( )
	{
		$game = array(
			0 => "None",
				"Team Death Match",
				"Eskorta",
				"Skoki spadochronowe",
				"Race",
				"Domination",
				"Demolition Derby",
				"Stunt",
				"Search and Destroy",
				"Hay"
			);
		return $game;	
	}
	
	static public function getGameNameType( $type )
	{
		$result = MMClass::getGameName( );
		return $result[ $type ];
	}
	
	static public function getServerID( )
	{
		return 7;
	}
	
	static public function getAdminGroupAcces( )
	{
		$result = array( 4 );
		return $result;
	}
	
	static public function dli($x, $a, $b, $c)
	{
		if($x == 1) return $a;
		if($x%10 > 1 && $x%10<5 && !($x%100 >= 10 && $x%100 <= 21)) return $b;
		return $c;
	}
	
	static public function getMaxPlayers( $premium )
	{
		if(time() < $premium && $premium) return 30;
		return 5;
	}
	
	static public function GetVehicleName($model)
	{
		$pojazdy = array("Landstalker","Bravura","Buffalo","Linerunner","Pereniel","Sentinel","Dumper","Firetruck","Trashmaster","Stretch","Manana","Infernus","Voodoo","Pony","Mule","Cheetah","Ambulans","Leviathan","Moonbeam","Esperanto",
		"Taxi","Washington","Bobcat","Mr Whoopee","BF Injection","Hunter","Premier","Enforcer","Securicar","Banshee","Predator","Bus","Rhino","Barracks","Hotknife","Trailer","Previon","Coach","Cabbie","Stallion",
		"Rumpo","RC Bandit","Romero","Packer","Monster","Admiral","Squalo","Seasparrow","Pizzaboy","Tram","Trailer","Turismo","Speeder","Reefer","Tropic","Flatbed","Yankee","Caddy","Solair","Berkley's RC Van",
		"Skimmer","PCJ-600","Faggio","Freeway","RC Baron","RC Raider","Glendale","Oceanic","Sanchez","Sparrow","Patriot","Quad","Coastguard","Dinghy","Hermes","Sabre","Rustler","ZR3 50","Walton","Regina",
		"Comet","BMX","Burrito","Camper","Marquis","Baggage","Dozer","Maverick","News Chopper","Rancher","FBI Rancher","Virgo","Greenwood","Jetmax","Hotring","Sandking","Blista Compact","Police Maverick","Boxville","Benson",
		"Mesa","RC Goblin","Hotring Racer","Hotring Racer","Bloodring Banger","Rancher","Super GT","Elegant","Journey","Bike","Mountain Bike","Beagle","Cropdust","Stunt","Tanker","RoadTrain","Nebula","Majestic","Buccaneer","Shamal",
		"Hydra","FCR-900","NRG-500","HPV1000","Cement Truck","Tow Truck","Fortune","Cadrona","FBI Truck","Willard","Forklift","Tractor","Combine","Feltzer","Remington","Slamvan","Blade","Freight","Streak","Vortex",
		"Vincent","Bullet","Clover","Sadler","Firetruck","Hustler","Intruder","Primo","Cargobob","Tampa","Sunrise","Merit","Utility","Nevada","Yosemite","Windsor","Monster","Monster","Uranus","Jester",
		"Sultan","Stratum","Elegy","Raindance","RC Tiger","Flash","Tahoma","Savanna","Bandito","Freight","Trailer","Kart","Mower","Duneride","Sweeper","Broadway","Tornado","AT-400","DFT-30","Huntley",
		"Stafford","BF-400","Newsvan","Tug","Trailer","Emperor","Wayfarer","Euros","Hotdog","Club","Trailer","Trailer","Andromada","Dodo","RC Cam","Launch","Radiowóz (LSPD)","Radiowóz (SFPD)","Radiowóz (LVPD)","Police Ranger",
		"Picador","S.W.A.T. Van","Alpha","Phoenix","Glendale","Sadler","Luggage Trailer","Luggage Trailer","Stair Trailer","Boxville","Farm Plow","Utility Trailer");
		$tmp2 = $model - 400;
		return $pojazdy[$tmp2]; 
	}
	
	static public function GetVehicleColorHex($color)
	{
		if($color == 0) return "#000000";
		elseif($color == 1) return "#F7F7F7";
		elseif($color == 2) return "#2975A6";
		elseif($color == 3) return "#840510";
		elseif($color == 4) return "#21343A";
		elseif($color == 5) return "#83456A";
		elseif($color == 6) return "#D58E10";
		elseif($color == 7) return "#4975B4";
		elseif($color == 8) return "#BEBEC6";
		elseif($color == 9) return "#597173";
		elseif($color == 10) return "#42597B";
		elseif($color == 11) return "#63687B";
		elseif($color == 12) return "#597D8B";
		elseif($color == 13) return "#595959";
		elseif($color == 14) return "#D6DBD5";
		elseif($color == 15) return "#9DA2A6";
		elseif($color == 16) return "#316139";
		elseif($color == 17) return "#740B19";
		elseif($color == 18) return "#7B0829";
		elseif($color == 19) return "#A59E94";
		elseif($color == 20) return "#3A4C7A";
		elseif($color == 21) return "#742C42";
		elseif($color == 22) return "#6B1C39";
		elseif($color == 23) return "#93928D";
		elseif($color == 24) return "#52555A";
		elseif($color == 25) return "#393C41";
		elseif($color == 26) return "#A5AAAD";
		elseif($color == 27) return "#635E5B";
		elseif($color == 28) return "#39496B";
		elseif($color == 29) return "#949693";
		elseif($color == 30) return "#431C21";
		elseif($color == 31) return "#59242A";
		elseif($color == 32) return "#8595AE";
		elseif($color == 33) return "#73787B";
		elseif($color == 34) return "#636562";
		elseif($color == 35) return "#5A5A52";
		elseif($color == 36) return "#222421";
		elseif($color == 37) return "#293831";
		elseif($color == 38) return "#93A29B";
		elseif($color == 39) return "#6A798C";
		elseif($color == 40) return "#221817";
		elseif($color == 41) return "#6C6964";
		elseif($color == 42) return "#7C1C28";
		elseif($color == 43) return "#63080F";
		elseif($color == 44) return "#183829";
		elseif($color == 45) return "#5A1819";
		elseif($color == 46) return "#9C9A73";
		elseif($color == 47) return "#7C7563";
		elseif($color == 48) return "#9D9684";
		elseif($color == 49) return "#ACB1B4";
		elseif($color == 50) return "#858A8D";
		elseif($color == 51) return "#315142";
		elseif($color == 52) return "#4A606B";
		elseif($color == 53) return "#11204B";
		elseif($color == 54) return "#282B4A";
		elseif($color == 55) return "#7B6152";
		elseif($color == 56) return "#9CA7AD";
		elseif($color == 57) return "#9C8E73";
		elseif($color == 58) return "#6B1822";
		elseif($color == 59) return "#4A6A83";
		elseif($color == 60) return "#9C9E9B";
		elseif($color == 61) return "#92724B";
		elseif($color == 62) return "#631C22";
		elseif($color == 63) return "#949E9D";
		elseif($color == 64) return "#A5AAA6";
		elseif($color == 65) return "#8C8F42";
		elseif($color == 66) return "#321819";
		elseif($color == 67) return "#6A798C";
		elseif($color == 68) return "#ADAE8C";
		elseif($color == 69) return "#AD9A8C";
		elseif($color == 70) return "#842028";
		elseif($color == 71) return "#6B8294";
		elseif($color == 72) return "#5A5954";
		elseif($color == 73) return "#9CA68D";
		elseif($color == 74) return "#641822";
		elseif($color == 75) return "#212028";
		elseif($color == 76) return "#A5A195";
		elseif($color == 77) return "#AE9E85";
		elseif($color == 78) return "#7C1F29";
		elseif($color == 79) return "#08306B";
		elseif($color == 80) return "#722839";
		elseif($color == 81) return "#7B705A";
		elseif($color == 82) return "#741C2A";
		elseif($color == 83) return "#192C32";
		elseif($color == 84) return "#4B3029";
		elseif($color == 85) return "#7A1841";
		elseif($color == 86) return "#295821";
		elseif($color == 87) return "#395884";
		elseif($color == 88) return "#6B2831";
		elseif($color == 89) return "#A4A28D";
		elseif($color == 90) return "#B4B2B5";
		elseif($color == 91) return "#314151";
		elseif($color == 92) return "#6B6D6A";
		elseif($color == 93) return "#08698C";
		elseif($color == 94) return "#21496C";
		elseif($color == 95) return "#2A3C52";
		elseif($color == 96) return "#9C9E9B";
		elseif($color == 97) return "#6A8692";
		elseif($color == 98) return "#495D5B";
		elseif($color == 99) return "#AD9A7A";
		elseif($color == 100) return "#426D8D";
		elseif($color == 101) return "#222439";
		elseif($color == 102) return "#AD9274";
		elseif($color == 103) return "#114574";
		elseif($color == 104) return "#94826A";
		elseif($color == 105) return "#63686B";
		elseif($color == 106) return "#115085";
		elseif($color == 107) return "#A59A84";
		elseif($color == 108) return "#385694";
		elseif($color == 109) return "#525564";
		elseif($color == 110) return "#7B6951";
		elseif($color == 111) return "#8B929C";
		elseif($color == 112) return "#5B6D85";
		elseif($color == 113) return "#4B3331";
		elseif($color == 114) return "#426152";
		elseif($color == 115) return "#730822";
		elseif($color == 116) return "#213452";
		elseif($color == 117) return "#630B17";
		elseif($color == 118) return "#A6ADC7";
		elseif($color == 119) return "#6C5953";
		elseif($color == 120) return "#9D8A84";
		elseif($color == 121) return "#630819";
		elseif($color == 122) return "#630819";
		elseif($color == 123) return "#644529";
		elseif($color == 124) return "#731821";
		elseif($color == 125) return "#19346B";
		elseif($color == 126) return "#F069AC";
		elseif($color == 130) return "#A96E44";
		elseif($color == 131) return "#2B946C";
		elseif($color == 132) return "#96926D";
		elseif($color == 142) return "#7B7F70";
		elseif($color == 144) return "#0F8450";
		elseif($color == 146) return "#A0296B";
		elseif($color == 147) return "#1A7566";
		elseif($color == 148) return "#541240";
		elseif($color == 149) return "#4F0F5B";
		elseif($color == 150) return "#5B083C";
		elseif($color == 151) return "#AE0917";
		elseif($color == 152) return "#29090C";
		elseif($color == 153) return "#1A0902";
		elseif($color == 154) return "#0F0A21";
		elseif($color == 155) return "#390907";
		elseif($color == 156) return "#140911";
		elseif($color == 157) return "#20082A";
		elseif($color == 158) return "#180835";
		elseif($color == 159) return "#4B0829";
		elseif($color == 160) return "#490830";
		elseif($color == 161) return "#530802";
		elseif($color == 173) return "#3B0827";
		elseif($color == 174) return "#3C0731";
		elseif($color == 175) return "#4A0730";
		elseif($color == 236) return "#091501";
		elseif($color == 237) return "#0C1A01";
		elseif($color == 239) return "#0C1A01";
		elseif($color == 243) return "#090C01";
		elseif($color == 252) return "#0A2A0";
	}
	
	static public function Achievments()
	{
		$tablica = array
		(
			1 => array
			(
				'name' => "Pierwsze logowanie",
				'img' => "",
				'time' => 0,
				'gp' => 0
			),

			2 => array
			(
				'name' => "Pierwsza śmierć",
				'img' => "first_death.jpg",
				'time' => 0,
				'gp' => -50
			),

			4 => array
			(
				'name' => "Pierwsza krew",
				'img' => "first_blood.jpg",
				'time' => 0,
				'gp' => 100
			),

			8 => array
			(
				'name' => "Wygrana w wyścigu",
				'img' => "race.jpg",
				'time' => 0,
				'gp' => 0
			),

			16 => array
			(
				'name' => "Rejestracja",
				'img' => "register.jpg",
				'time' => 0,
				'gp' => 25
			),

			32 => array
			(
				'name' => "Przegrane 20h",
				'img' => "",
				'time' => 0,
				'gp' => 0
			),

			64 => array
			(
				'name' => "100 wizyt",
				'img' => "",
				'time' => 0,
				'gp' => 0
			)
		);
		return $tablica;		
	}
	static public function getPlayerAchievments($uid)
	{
		$db = ipsRegistry::DB();

		$tablica = MMClass::Achievments();
		
		$query = $db->query("SELECT * FROM `all_achiv` WHERE `player` = '".$uid."' AND `server` = ".MMClass::getServerID()." ORDER BY time DESC");
		if(!$db->getTotalRows($query)) return false;
		while($r = $db->fetch($query)) $lista[] = $r;

		$max = 1;
		for($t = 1; $t < sizeof($tablica); $t++)
			$max *= 2; 
		
		$cyfra = 1;
		while(true)
		{
			foreach($lista as $values)
			{
				if(intval($values['type']) & $cyfra)
				{
					if($tablica[$cyfra]['gp'] > 0)
					{
						$tablica[$cyfra]['t'] = true;
					}	
					else 
					{
						$tablica[$cyfra]['gp'] = str_replace("-", "", $tablica[$cyfra]['gp']);
						$tablica[$cyfra]['t'] = false;
					}
					$tablica[$cyfra]['time'] = $values['time'];
					$return[] = $tablica[$cyfra];
				}
			}

			if($cyfra >= $max) break;
			$cyfra *= 2;
		}
		if(count($return)) return $return;
		else return false;
	}
	static public function givePlayerAchiv($player_uid, $type)
	{
		$db = ipsRegistry::DB();
		$db->query('SELECT `achiv` FROM `mini_players` WHERE `uid` = '.$player_uid);
		$player = $db->fetch();
		$achiv = $player['achiv'];
		if($achiv & $type)
			return false;
			
		$tablica = MMClass::Achievments();
		$exp = $tablica[$type]['gp'];
		
		$db->query('UPDATE `mini_players` SET `achiv` = `achiv` + '.$type.', `exp` = `exp` + '.$exp.' WHERE `uid` = '.$player_uid);
		$db->query('INSERT INTO `all_achiv` VALUES (NULL, '.$player_uid.', '.$type.', '.time().', '.MMClass::getServerID().')');
		return true;
	}
	static public function showPenalty($player_uid, $uid = 0)
	{
		$db = ipsRegistry::DB();
		if($uid) 
		{
			$db->query('SELECT l.*, spv.name, fm.member_id, fm.members_display_name, fm.member_group_id FROM all_logs l LEFT JOIN mini_players spv ON (l.server = '.MMClass::getServerID().' AND l.victim = spv.uid) LEFT JOIN mini_players spa ON (l.server = '.MMClass::getServerID().' AND l.player = spa.uid) LEFT JOIN '.$db->obj['sql_tbl_prefix'].'members fm ON (l.player != -1 AND spa.guid = fm.member_id) WHERE l.uid = '.$uid.' ORDER BY l.uid DESC');
			$penalty = $db->fetch();
		}
		else
		{
			$db->query('SELECT l.*, spv.name, fm.member_id, fm.members_display_name, fm.member_group_id FROM all_logs l LEFT JOIN mini_players spv ON (l.server = '.MMClass::getServerID().' AND l.victim = spv.uid) LEFT JOIN mini_players spa ON (l.server = '.MMClass::getServerID().' AND l.player = spa.uid) LEFT JOIN '.$db->obj['sql_tbl_prefix'].'members fm ON (l.player != -1 AND spa.guid = fm.member_id) WHERE l.victim = '.$player_uid.' ORDER BY l.uid DESC');
			while( $r = $db->fetch() )
			{
				if($r['player'] == -1)
				{
					$r['adminName'] = "System";
					$r['member_id'] = -1;
				}
				else
				{
					$r['adminName'] = IPSMember::makeNameFormatted($r['members_display_name'], $r['member_group_id']);
					$r['adminName'] = IPSMember::makeProfileLink($r['adminName'], $r['member_id']);
				}

				if(empty($r['reason']))
				{
					$r['reason'] = "<i>Nie podano powodu</i>";
				}
				$r['type'] = MMClass::getPenaltyType($r['type']);
				$penalty[] = $r;
			}
		}
		return $penalty;
	}	
}
?>