<?php

class profile_characters extends profile_plugin_parent
{
	public function return_html_block( $profile=array() ) 
	{
		ipsRegistry::getClass('class_localization')->loadLanguageFile( array( 'public_game' ) );
		require_once(IPSLib::getAppDir('game') . '/sources/classes/global.php');

		$this->DB->query('SELECT DISTINCT p.*, o.time FROM `mini_players` p LEFT JOIN `all_online` o ON o.player = p.uid AND o.type = 7 WHERE p.guid = '.$profile['member_id']);
		while( $r = $this->DB->fetch() )
		{
			$charList .= ','.$r['uid'];
			$r['hours'] = floor( $r['timehere'] / 3600 );
			$r['minutes'] = floor( ( $r['timehere'] - floor( $r['timehere'] / 3600 ) * 3600 ) / 60 );
			if(isset($r['time']))
			{			
				$r['logged'] = 1;
				$r['time'] = time() - $r['time'];
				$r['g_hours'] = floor( $r['time'] / 3600 );
				$r['g_minutes'] = floor( ( $r['time'] - floor( $r['time'] / 3600 ) * 3600 ) / 60 );
			}
			$chars[] = $r;
		}	
		
		if(count($chars))
		{
			$charsRP = $returnKary = array();

			$queryCharsRP = $this->DB->query("SELECT `uid` FROM `mini_players` WHERE `guid` = ".$profile['member_id']);
			while($r = $this->DB->fetch($queryCharsRP)) $charsRP[] = $r['uid'];

			$charsRP = implode(",", $charsRP);

			$zapytanie = "";

			if($this->DB->getTotalRows($queryCharsRP) > 0)
			{
				$zapytanie = "(l.server = 7 AND l.victim IN (".$charsRP."))";
			}

			$queryDlaKar = $this->DB->query("SELECT l.*, spv.uid as pl_uid, spv.name, fm.member_id, fm.members_display_name, fm.member_group_id FROM all_logs l LEFT JOIN mini_players spv ON (l.server = 7 AND l.victim = spv.uid) LEFT JOIN mini_players spa ON (l.server = 7 AND l.player = spa.uid) LEFT JOIN ".$this->DB->obj['sql_tbl_prefix']."members fm ON (l.player != -1 AND spa.guid = fm.member_id) WHERE ".$zapytanie." ORDER BY l.uid DESC");
			while($r = $this->DB->fetch($queryDlaKar))
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
				$returnKary[] = $r;
			}
		}
				
		return $this->registry->getClass('output')->getTemplate('game')->game_profile($chars, $returnKary, $profile);
	}
}
?>