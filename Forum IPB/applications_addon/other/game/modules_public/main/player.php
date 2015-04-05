<?php

class public_game_main_player extends ipsCommand
{
	public function doExecute( ipsRegistry $registry ) 
	{
		ipsRegistry::getClass('class_localization')->loadLanguageFile( array( 'public_game' ) );
		require_once(IPSLib::getAppDir('game') . '/sources/classes/global.php');
		
		if(!$this->memberData['member_id'])
			$this->registry->getClass('output')->showError( $this->lang->words['no_member'] );
			
		if(!intval($this->request['uid']))
			$this->registry->getClass('output')->showError( 'Nie wybrano postaci!' );
			
		$this->DB->query('SELECT p.*, r.lvl as ranklvl FROM `mini_players` p LEFT JOIN `mini_ranks` r ON (r.uid = p.klanrank AND r.klanuid = p.klan AND p.klan != 0) WHERE p.uid = '.intval($this->request['uid']));
		if(!$this->DB->getTotalRows($query))
			$this->registry->getClass('output')->showError( 'Nie znaleziono postaci!' );
		$player = $this->DB->fetch();
		
		$this->DB->query('SELECT 1 FROM `all_logs` WHERE `victim` = '.$player['uid'].' AND `server` = '.MMClass::getServerID());
		$player['log'] = $this->DB->getTotalRows();
		
		$this->DB->query('SELECT 1 FROM `mini_connect` WHERE `player` = '.$player['uid']);
		$player['connect'] = $this->DB->getTotalRows();

		if(!$player['klan'])
		{
			$this->DB->query('SELECT 1 FROM `mini_join` WHERE `player` = '.$player['uid']);
			$player['join'] = $this->DB->getTotalRows();
		}
		if($player['guid'] != $this->memberData['member_id'] || $player['guid'] == -1)
			$this->registry->getClass('output')->showError( 'Ta postać nie należy do Ciebie!' );

		switch(	$this->request['desc'] )
		{
			case "klan":
				$this->showPlayerKlan($player, intval($this->request['kuid']));
				break;
			case "klan_options":
				$this->showPlayerKlanOptions($player, intval($this->request['kuid']));
				break;
			case "achievment":
				$this->showPlayerAchivment($player);
				break;
			case "logs":
				$this->showPlayerPenalty($player);
				break;
			case "connect":
				$this->showPlayerConnect($player);
				break;
			case "klan_join":
				$this->showPlayerJoin($player);
				break;			
			default:
				$this->showPlayer($player);
				break;
		}		
	}
	
	protected function showPlayerJoin($player)
	{
		if($this->request['kuid'])
		{
			if($this->request['opt'] == 'accept')
			{
				$join_uid = intval($this->request['kuid']);
				$this->DB->query('SELECT `klan` FROM `mini_join` WHERE `uid` = '.$join_uid);
				$p = $this->DB->fetch();
				$klan_uid = intval($p['klan']);
				
				$this->DB->query('DELETE FROM `mini_join` WHERE `uid` = '.$join_uid);
				$this->DB->query('UPDATE `mini_players` SET `klan` = '.$klan_uid.' WHERE `uid` = '.$player['uid']);
				$this->registry->output->redirectScreen('Zaakceptowałeś zaproszenie do klanu', $this->registry->output->buildUrl('module=main&section=player&uid='.$player['uid'].'&desc=klan&kuid='.$klan_uid, 'publicWithApp'));
			}
			else $this->showPlayerJoin($player);
		}
		else
		{
			$this->DB->query('SELECT j.uid as join_uid, k.color as klan_color, k.name as klan_name, p.uid as player_uid, p.name as player_name, j.time FROM `mini_join` j JOIN `mini_klan` k JOIN `mini_players` p WHERE p.uid = j.from AND j.klan = k.uid AND j.player = '.$player['uid']);
			while($k = $this->DB->fetch())
			{
				for($i = 2; $i < 8; $i++) 
					$color .= $k['klan_color'][$i];
				$k['klan_color'] = $color;
				$klan[] = $k;
			}
			
			$template = $this->registry->output->getTemplate('game')->game_player_klan_join($player, $klan);
			ipsRegistry::getClass('output')->addContent($template);
			$this->registry->output->setTitle($this->lang->words['game_cp']);
			$this->registry->output->addNavigation($this->lang->words['game_cp'], 'app=game');
			$this->registry->output->addNavigation($this->lang->words['char'].': '.$player['name'], 'app=game&module=main&section=player&uid='.$player['uid']);
			$this->registry->output->addNavigation('Zaproszenia', 'app=game&module=main&section=player&uid='.$player['uid'].'&desc=klan_join');
			ipsRegistry::getClass('output')->sendOutput();	
		}
	}
	
	protected function showPlayerAchivment($player)
	{
		if($player['achiv']) 
		{
			$achiv = MMClass::getPlayerAchievments($player['uid']);
		}
		$template = $this->registry->output->getTemplate('game')->game_player_achiv($player, $achiv);
		ipsRegistry::getClass('output')->addContent($template);
		$this->registry->output->setTitle($this->lang->words['game_cp']);
		$this->registry->output->addNavigation($this->lang->words['game_cp'], 'app=game');
		$this->registry->output->addNavigation($this->lang->words['char'].': '.$player['name'], 'app=game&module=main&section=player&uid='.$player['uid']);
		$this->registry->output->addNavigation($this->lang->words['achievments'], 'app=game&module=main&section=player&uid='.$player['uid'].'&desc=achievment');
		ipsRegistry::getClass('output')->sendOutput();
	}
	
	protected function showPlayerPenalty($player)
	{
		$penalty = MMClass::showPenalty($player['uid']);
		$template = $this->registry->output->getTemplate('game')->game_player_penalty($player, $penalty);
		ipsRegistry::getClass('output')->addContent($template);
		$this->registry->output->setTitle($this->lang->words['game_cp']);
		$this->registry->output->addNavigation($this->lang->words['game_cp'], 'app=game');
		$this->registry->output->addNavigation($this->lang->words['char'].': '.$player['name'], 'app=game&module=main&section=player&uid='.$player['uid']);
		$this->registry->output->addNavigation($this->lang->words['penalty_log'], 'app=game&module=main&section=player&uid='.$player['uid'].'&desc=logs');
		ipsRegistry::getClass('output')->sendOutput();
	}
	
	protected function showPlayerConnect($player)
	{
		$this->DB->query('SELECT * FROM `mini_connect` WHERE `player` = '.$player['uid'].' ORDER BY `time` DESC LIMIT 30');
		while($log = $this->DB->fetch())
		{
			$log['afkhours'] = floor($log['afktime'] / 3600);
			$log['afkminutes'] = floor(($log['afktime'] - floor($log['afktime'] / 3600) * 3600) / 60);
		
			$log['hours'] = floor($log['timehere'] / 3600);
			$log['minutes'] = floor(($log['timehere'] - floor($log['timehere'] / 3600) * 3600) / 60);
		
			$connect[] = $log;
		}
		$template = $this->registry->output->getTemplate('game')->game_player_connect($player, $connect);
		ipsRegistry::getClass('output')->addContent($template);
		$this->registry->output->setTitle($this->lang->words['game_cp']);
		$this->registry->output->addNavigation($this->lang->words['game_cp'], 'app=game');
		$this->registry->output->addNavigation($this->lang->words['char'].': '.$player['name'], 'app=game&module=main&section=player&uid='.$player['uid']);
		$this->registry->output->addNavigation($this->lang->words['connect_log'], 'app=game&module=main&section=player&uid='.$player['uid'].'&desc=connect');
		ipsRegistry::getClass('output')->sendOutput();
	}
	
	
	protected function showPlayer($player)
	{
		$player['hours'] = floor($player['timehere'] / 3600);
		$player['minutes'] = floor(($player['timehere'] - floor($player['timehere'] / 3600) * 3600) / 60);

		if($player['death'])
			$player['k_d'] = sprintf('%.2f', $player['kills']/$player['death']);
		
		$player['afk_hours'] = floor($player['afk'] / 3600);
		$player['afk_minutes'] = floor(($player['afk'] - floor($player['afk'] / 3600) * 3600) / 60);

		$template = $this->registry->output->getTemplate('game')->game_player_main($player);
		ipsRegistry::getClass('output')->addContent($template);
		$this->registry->output->setTitle($this->lang->words['game_cp']);
		$this->registry->output->addNavigation($this->lang->words['game_cp'], 'app=game');
		$this->registry->output->addNavigation($this->lang->words['char'].': '.$player['name'], 'app=game&module=main&section=player&uid='.$player['uid']);
		ipsRegistry::getClass('output')->sendOutput();
	}
	
	protected function showPlayerKlanOptions($player, $klan_uid)
	{
		if(!$klan_uid)
			$this->registry->getClass('output')->showError( 'Nie wybrano klanu!' );
		
		if($player['ranklvl'] != 255)
			$this->registry->getClass('output')->showError( $this->lang->words['no_acces'] );
			
		$query = $this->DB->query('SELECT * FROM `mini_klan` WHERE `uid` = '.$klan_uid);
		if(!$this->DB->getTotalRows($query))
		{
			$this->DB->query("UPDATE `mini_players` SET `klan` = '0', `klanrank` = '0' WHERE `uid` = ".$player['uid']);
			$this->registry->output->redirectScreen('Nie znaleziono klanu!', $this->registry->output->buildUrl('module=main&section=player&uid='.$player['uid'], 'publicWithApp'));
		}
		$klan = $this->DB->fetch($query);
		
		for($i = 2; $i < 8; $i++) $color .= $klan['color'][$i];
		$klan['color'] = $color;
		
		$this->DB->query('SELECT * FROM `mini_ranks` WHERE `klanuid` = '.$klan_uid);
		while( $r = $this->DB->fetch() ) 
		{
			if(isset($this->request['klan_save_ranks']) && $this->request['request_method'] == 'post')
			{
				if($this->request[$r['uid'].'_name'] != $r['name'] || $this->request[$r['uid'].'_lvl'] != $r['lvl'])
				{
					$players[$r['uid']][0] = $this->request[$r['uid'].'_name'];
					$players[$r['uid']][1] = intval($this->request[$r['uid'].'_lvl']);
					
					if($r['uid'] == $player['klanrank']) $players[$r['uid']][1] = 255;
					
					if($players[$r['uid']][1] > 255) $players[$r['uid']][1] = 255;
					else if($players[$r['uid']][1] < 0) $players[$r['uid']][1] = 0;
				}
			}
			$klanRanks[] = $r;
		}
		
		if(isset($this->request['klan_save_ranks']) && $this->request['request_method'] == 'post')
		{
			foreach($players as $key=>$value)
			{
				$this->DB->query("UPDATE `mini_ranks` SET `name` = '".$this->DB->addSlashes($value[0])."', `lvl` = ".intval($value[1])." WHERE `uid` = ".$key);
			}
			$this->registry->output->redirectScreen("Rangi zapisane!", $this->registry->output->buildUrl('module=main&section=player&uid='.$player['uid'].'&desc=klan_options&kuid='.$klan['uid'], 'publicWithApp'));
		}
		else if(isset($this->request['klan_add_rank']) && $this->request['request_method'] == 'post')
		{
			if(empty($this->request['rank_name']))
				$this->registry->output->redirectScreen("", $this->registry->output->buildUrl('module=main&section=player&uid='.$player['uid'].'&desc=klan_options&kuid='.$klan['uid'], 'publicWithApp'));
			
			$this->DB->query("INSERT INTO `mini_ranks` (`name`, `klanuid`) VALUES ('".$this->DB->addSlashes($value[0])."', ".$klan_uid.")");			
			$this->registry->output->redirectScreen("Ranga dodana!", $this->registry->output->buildUrl('module=main&section=player&uid='.$player['uid'].'&desc=klan_options&kuid='.$klan['uid'], 'publicWithApp'));
		}
		else if(isset($this->request['klan_save']) && $this->request['request_method'] == 'post')
		{
			if(empty($this->request['klan_tag']))
				$messages[] = "Tag nie może być pusty.";
			else if(!preg_match('/^[-0-9A-Z_\[\]_()=@]+$/i', $this->request['klan_tag']))
				$messages[] = 'Podany tag nie jest dozwolony.';
			if(strlen($this->request['klan_tag']) > 5)
				$messages[] = 'Za długa nazwa tagu.';

			if(empty($this->request['klan_color']) || !preg_match('/^[A-Fa-f0-9]{6}$/i', $this->request['klan_color']))
				$this->request['klan_color'] = 'FFFFFF';
				
			if(IPSMember::isInGroup($this->memberData, MMClass::getAdminGroupAcces()))
			{
				if(empty($this->request['klan_name']))
					$messages[] = "Nazwa nie może być pusta.";
				else if(!preg_match('/^[-0-9A-Z_\[\]_ ()=@]+$/i', $this->request['klan_name']))
					$messages[] = 'Podana nazwa nie jest dozwolona.';
				if(strlen($this->request['klan_name']) > 32)
					$messages[] = 'Za długa nazwa.';
				else if(strlen($this->request['klan_name']) < 3)
					$messages[] = 'Za krótka nazwa.';
			}
			else $this->request['klan_name'] = $klan['name'];
			$this->request['klan_color'] = '0x'.$this->request['klan_color'].'AA';
			
			if(count($messages))
				$this->registry->output->redirectScreen("<li>".implode('</li><li>',$messages)."</li>", $this->registry->output->buildUrl('module=main&section=player&uid='.$player['uid'].'&desc=klan_options&kuid='.$klan['uid'], 'publicWithApp'));
				
			$this->DB->query("UPDATE `mini_klan` SET `name` = '".$this->DB->addSlashes($this->request['klan_name'])."', `tag` = '".$this->DB->addSlashes($this->request['klan_tag'])."', `color` = '".$this->DB->addSlashes($this->request['klan_color'])."' WHERE `uid` = ".$klan['uid']);
			$this->registry->output->redirectScreen("Ustawienia klanu zapisane!", $this->registry->output->buildUrl('module=main&section=player&uid='.$player['uid'].'&desc=klan_options&kuid='.$klan['uid'], 'publicWithApp'));
		}
		
		$template = $this->registry->output->getTemplate('game')->game_player_klan_options($player, $klan, $klanRanks);
		ipsRegistry::getClass('output')->addContent($template);
		$this->registry->output->setTitle($this->lang->words['game_cp']);
		$this->registry->output->addNavigation($this->lang->words['game_cp'], 'app=game');
		$this->registry->output->addNavigation($this->lang->words['char'].': '.$player['name'], 'app=game&module=main&section=player&uid='.$player['uid']);
		$this->registry->output->addNavigation('Klan: '.$klan['name'], 'app=game&module=main&section=player&uid='.$player['uid'].'&desc=klan&kuid='.$klan['uid']);
		$this->registry->output->addNavigation($this->lang->words['setting'], 'app=game&module=main&section=player&uid='.$player['uid'].'&desc=klan_options&kuid='.$klan['uid']);
		ipsRegistry::getClass('output')->sendOutput();	
	}
	
	protected function showPlayerKlan($player, $klan_uid)
	{
		if(!$klan_uid)
			$this->registry->getClass('output')->showError( 'Nie wybrano klanu!' );

		if(isset($this->request['klan_add_player']) && $player['ranklvl'] == 255 && $this->request['request_method'] == 'post')
		{
			$this->DB->query("SELECT `uid`, `klan` FROM `mini_players` WHERE `name` LIKE '".$this->DB->addSlashes($this->request['player_name'])."'");
			if(!$this->DB->getTotalRows())
				$this->registry->output->redirectScreen('Nie znaleziono gracza!', $this->registry->output->buildUrl('module=main&section=player&uid='.$player['uid'].'&desc=klan&kuid='.$klan_uid, 'publicWithApp'));
			$p = $this->DB->fetch();
			
			if($p['klan'] != $klan_uid && $p['klan'])
				$this->registry->output->redirectScreen('Ten gracz należy już do jakiego klanu!', $this->registry->output->buildUrl('module=main&section=player&uid='.$player['uid'].'&desc=klan&kuid='.$klan_uid, 'publicWithApp'));

			if($p['klan'] == $klan_uid && $p['klan'])
				$this->registry->output->redirectScreen('Ten gracz należy już do klanu!', $this->registry->output->buildUrl('module=main&section=player&uid='.$player['uid'].'&desc=klan&kuid='.$klan_uid, 'publicWithApp'));

			$this->DB->query('SELECT 1 FROM `mini_join` WHERE klan = '.$klan_uid.' AND player = '.$p['uid']);
			if($this->DB->getTotalRows())
				$this->registry->output->redirectScreen('Wysłano już zaproszenie temu graczowi.', $this->registry->output->buildUrl('module=main&section=player&uid='.$player['uid'].'&desc=klan&kuid='.$klan_uid, 'publicWithApp'));
			
			$this->DB->query('INSERT INTO `mini_join` VALUES (NULL, '.$klan_uid.', '.$player['uid'].', '.$p['uid'].', '.time().')');
			$this->registry->output->redirectScreen( "Gracz został zaproszony.", $this->registry->output->buildUrl('module=main&section=player&uid='.$player['uid'].'&desc=klan&kuid='.$klan_uid, 'publicWithApp'));
		}
		
		$query = $this->DB->query('SELECT * FROM `mini_klan` WHERE `uid` = '.$klan_uid);
		if(!$this->DB->getTotalRows($query))
		{
			$this->DB->query("UPDATE `mini_players` SET `klan` = '0', `klanrank` = '0' WHERE `uid` = ".$player['uid']);
			$this->registry->output->redirectScreen('Nie znaleziono klanu!', $this->registry->output->buildUrl('module=main&section=player&uid='.$player['uid'], 'publicWithApp'));
		}
		$klan = $this->DB->fetch($query);
		
		for($i = 2; $i < 8; $i++) $color .= $klan['color'][$i];
		$klan['color'] = $color;
		
		$query = $this->DB->query('SELECT p.guid, p.uid, p.name, p.klanrank, r.name as rank_name, IFNULL(r.lvl, 0) as rank_lvl FROM `mini_players` p LEFT JOIN `mini_ranks` r ON (r.uid = p.klanrank AND r.klanuid = p.klan) WHERE p.klan = '.$klan_uid.' ORDER BY rank_lvl DESC');
		while( $r = $this->DB->fetch($query) )
		{
			if( !isset($r['rank_name']) ) $r['rank_name'] = "<i>".$this->lang->words['none']."</i>";
			if( $r['rank_lvl'] == 255 ) $r['rank_name'] = "<b>".$r['rank_name']."</b>";
			if( $r['guid'] != -1 )
			{
				$r['member'] = IPSMember::load( $r['guid'] );
				$r['member'] = IPSMember::buildProfilePhoto( $r['member']['member_id'] );
			}
			
			if(isset($this->request['save_klan_members']) && $player['ranklvl'] == 255)
			{
				if($this->request[$r['uid'].'_rank'] != $r['klanrank'] && $r['uid'] != $player['uid'])
				{
					$players[$r['uid']] = intval($this->request[$r['uid'].'_rank']);
				}
			}
			$klanMembers[] = $r;
		}
		
		if(isset($this->request['save_klan_members']) && $player['ranklvl'] == 255)
		{
			foreach($players as $key=>$value)
			{
				$this->DB->query("UPDATE `mini_players` SET `klanrank` = '".intval($value)."' WHERE `uid` = ".$key);
			}
			print_r($players);
			$this->registry->output->redirectScreen( "Ustawienia zostały zapisane.", $this->registry->output->buildUrl('module=main&section=player&uid='.$player['uid'].'&desc=klan&kuid='.$player['klan'], 'publicWithApp'));
		}

		
		$this->DB->query('SELECT `uid`, `name` FROM `mini_ranks` WHERE `klanuid` = '.$klan_uid);
		while( $r = $this->DB->fetch() ) $klanRanks[] = $r;

		$this->DB->query('SELECT j.uid, j.time, p.name as player_player, e.name as player_from FROM `mini_join` j JOIN `mini_players` p JOIN `mini_players` e WHERE e.uid = j.from AND p.uid = j.player AND j.klan = '.$klan_uid);
		while( $r = $this->DB->fetch() ) $klanJoin[] = $r;
		
		
		$template = $this->registry->output->getTemplate('game')->game_player_klan_main($player, $klan, $klanMembers, $klanRanks, $klanJoin);
		ipsRegistry::getClass('output')->addContent($template);
		$this->registry->output->setTitle($this->lang->words['game_cp']);
		$this->registry->output->addNavigation($this->lang->words['game_cp'], 'app=game');
		$this->registry->output->addNavigation($this->lang->words['char'].': '.$player['name'], 'app=game&module=main&section=player&uid='.$player['uid']);
		$this->registry->output->addNavigation('Klan: '.$klan['name'], 'app=game&module=main&section=player&uid='.$player['uid'].'&desc=klan&kuid='.$klan['uid']);
		ipsRegistry::getClass('output')->sendOutput();
	}
}
?>
