<?php

class public_game_admin_char_edit extends ipsCommand
{
	public function doExecute( ipsRegistry $registry ) 
	{
		ipsRegistry::getClass('class_localization')->loadLanguageFile( array( 'public_game' ) );
		require_once(IPSLib::getAppDir('game') . '/sources/classes/global.php');
		
		if(!$this->memberData['member_id'])
			$this->registry->getClass('output')->showError( $this->lang->words['no_member'] );
		
		if(!IPSMember::isInGroup($this->memberData['member_id'], MMClass::getAdminGroupAcces()))
			$this->registry->getClass('output')->showError( $this->lang->words['no_acces'] );
		
		switch($this->request['desc'])
		{
			case "edit":
				$this->editCharacter(intval($this->request['uid']));
				break;
			case "edit_penalty":
				$this->editPenalty(intval($this->request['uid']), intval($this->request['luid']));
				break;
			case "del_penalty":
				$this->deletePenalty(intval($this->request['uid']));
				break;
			case "deleted":
				$this->registry->output->redirectScreen("Postać skasowana!", $this->registry->output->buildUrl('module=admin&section=char_edit', 'publicWithApp'));
				break;
			default:
				$this->showCharacter();
				break;
		}
	}
	
	protected function editPenalty($player_uid, $log_uid)
	{
		if(isset($this->request['admin_edit_log']) && $this->request['request_method'] == 'post')
		{
			$this->registry->output->redirectScreen("Wpis zapisany!", $this->registry->output->buildUrl('module=admin&section=char_edit&desc=edit_penalty&uid='.$log_uid, 'publicWithApp'));
		}
		$log = MMClass::showPenalty(_, $log_uid);
		
		$template = $this->registry->output->getTemplate('game')->game_admin_main();
		ipsRegistry::getClass('output')->addContent($template);
		$this->registry->output->setTitle($this->lang->words['admin_cp']);
		$this->registry->output->addNavigation($this->lang->words['game_cp'], 'app=game');
		$this->registry->output->addNavigation($this->lang->words['admin_cp'], 'app=game&module=admin');
		$this->registry->output->addNavigation('Wyszukaj postać', 'app=game&module=admin&section=char_edit');
		$this->registry->output->addNavigation($this->lang->words['char'].': '.$log['name'], 'app=game&module=admin&section=char_edit&desc=edit&uid='.$player_uid);
		$this->registry->output->addNavigation('Wpis: '.$log['reason'], 'app=game&module=admin&section=char_edit&desc=edit_penalty&uid='.$player_uid.'&luid='.$log_uid);
		ipsRegistry::getClass('output')->sendOutput();
	}
	
	protected function deletePenalty($log_uid)
	{
		$this->DB->query("DELETE FROM `all_logs` WHERE `uid` = ".$log_uid);
		if($this->request['fromGID'])
			$this->registry->output->redirectScreen("Wpis skasowany!", "index.php?app=members&showuser=".intval($this->request['fromGID'])."?tab=characters");
	}
	
	protected function editCharacter($player_uid)
	{
		if(isset($this->request['admin_save_char']) && $this->request['request_method'] == 'post')
		{
			if(strlen($this->request['player_name']) > 24)
				$messages[] = 'Za długa nazwa.';

			if(strlen($this->request['player_name']) < 3)
				$messages[] = 'Za krótka nazwa.';
	
			if(!preg_match('/^[-0-9A-Z_\[\]_()=@]+$/i', $this->request['player_name']))
				$messages[] = 'Powód ma niedozwolone znaki.';
				
			$this->DB->query("SELECT `uid`, `name` FROM mini_players WHERE name LIKE '".$this->DB->addSlashes($this->request['player_name'])."' AND `uid` != ".$player_uid."");
			if($this->DB->getTotalRows())
			{
				$existing = $this->DB->fetch();
				$messages[] = 'Podana nazwa postaci jest zbyt podobna do już istniejącej <br />('.$existing['name'].', UID: '.$existing['uid'].').';
			}
				
			if(count($messages))
				$this->registry->output->redirectScreen("<li>".implode('</li><li>',$messages)."</li>", $this->registry->output->buildUrl('module=admin&section=char_edit&desc=edit&uid='.$player_uid, 'publicWithApp'));

			if($this->request['player_adminlvl'] < 0) $this->request['player_adminlvl'] = 0;
			if($this->request['player_skin'] < 0) $this->request['player_skin'] = 0;
			if($this->request['player_klan'] < 0) $this->request['player_klan'] = 0;
			
			if(empty($this->request['player_glob'])) 
				$member['member_id'] = -1;
			else
			{
				$this->DB->query('SELECT `member_id` FROM '.$this->DB->obj['sql_tbl_prefix'].'members WHERE `members_display_name` LIKE "'.$this->DB->addSlashes($this->request['player_glob']).'"');
				$member = $this->DB->fetch();
			}
			$this->DB->query("UPDATE `mini_players` SET `guid` = ".$member['member_id'].", `name` = '".$this->DB->addSlashes($this->request['player_name'])."', `skin` = ".intval($this->request['player_skin']).", `klan` = '".intval($this->request['player_klan'])."', `adminlvl` = '".intval($this->request['player_adminlvl'])."' WHERE `uid` = ".$player_uid);
				
			$this->registry->output->redirectScreen("Postać zapisana!", $this->registry->output->buildUrl('module=admin&section=char_edit&desc=edit&uid='.$player_uid, 'publicWithApp'));
		}
		else if(isset($this->request['admin_add_log']) && $this->request['request_method'] == 'post')
		{
			if(empty($this->request['l_reason']))
				$messages[] = 'Nie podałeś powodu.';
			else if(!preg_match('/^[-0-9A-Z_\[\]_ ()=@]+$/i', $this->request['l_reason']))
				$messages[] = 'Powód ma niedozwolone znaki.';
			
			if(count($messages))
				$this->registry->output->redirectScreen("<li>".implode('</li><li>',$messages)."</li>", $this->registry->output->buildUrl('module=admin&section=char_edit&desc=edit&uid='.$player_uid, 'publicWithApp'));

			$this->DB->query("INSERT INTO `all_logs` (`player`, `victim`, `reason`, `time`, `server`) VALUES (".intval($this->request['l_from']).", ".$player_uid.", '".$this->DB->addSlashes($this->request['l_reason'])."', ".time().", ".MMClass::getServerID().")");
			$this->registry->output->redirectScreen("Wpis dodany!", $this->registry->output->buildUrl('module=admin&section=char_edit&desc=edit&uid='.$player_uid, 'publicWithApp'));
		}

		$this->DB->query('SELECT p.*, IFNULL(m.members_display_name, \'\') as glob_name FROM `mini_players`p LEFT JOIN '.$this->DB->obj['sql_tbl_prefix'].'members m ON p.guid = m.member_id WHERE p.uid = '.$player_uid);
		$player = $this->DB->fetch();
		
		$this->DB->query('SELECT `uid`, `name` FROM `mini_klan`');
		while( $k = $this->DB->fetch() ) $klans[] = $k;
		
		$penalty = MMClass::showPenalty($player_uid);
		$pen_type = MMClass::getPenalty();
		
		$this->DB->query('SELECT `uid`, `name` FROM `mini_players` WHERE `guid` = '.$this->memberData['member_id']);
		while( $a = $this->DB->fetch() ) $adm_char[] = $a;
		
		$template = $this->registry->output->getTemplate('game')->game_admin_char($player, $klans, $penalty, $pen_type, $adm_char);
		ipsRegistry::getClass('output')->addContent($template);
		$this->registry->output->setTitle($this->lang->words['admin_cp']);
		$this->registry->output->addNavigation($this->lang->words['game_cp'], 'app=game');
		$this->registry->output->addNavigation($this->lang->words['admin_cp'], 'app=game&module=admin');
		$this->registry->output->addNavigation('Wyszukaj postać', 'app=game&module=admin&section=char_edit');
		$this->registry->output->addNavigation($this->lang->words['char'].': '.$player['name'], 'app=game&module=admin&section=char_edit&desc=edit&uid='.$player['uid']);
		ipsRegistry::getClass('output')->sendOutput();
	}
	
	protected function showCharacter()
	{
		if(isset($this->request['admin_search_char']) && $this->request['request_method'] == 'post')
		{
			if(empty($this->request['player_name']) && empty($this->request['player_uid']))
				$this->registry->output->redirectScreen("", $this->registry->output->buildUrl('module=admin&section=char_edit', 'publicWithApp'));

			if(!empty($this->request['player_name']) && empty($this->request['player_uid']))
				$this->DB->query("SELECT `uid`, `name` FROM `mini_players` WHERE `name` LIKE '%%".$this->DB->addSlashes($this->request['player_name'])."%%' LIMIT 30");
			else if(empty($this->request['player_name']) && !empty($this->request['player_uid']))
			{
				$this->DB->query("SELECT 1 FROM `mini_players` WHERE `uid` = '".intval($this->request['player_uid'])."' LIMIT 30");
				if($this->DB->getTotalRows())
				{
					$this->registry->output->redirectScreen("", $this->registry->output->buildUrl('module=admin&section=char_edit&desc=edit&uid='.intval($this->request['player_uid']), 'publicWithApp'));
				}
			}
			else
				$this->DB->query("SELECT `uid`, `name` FROM `mini_players` WHERE `name` LIKE '%%".$this->DB->addSlashes($this->request['player_name'])."%%' OR `uid` = '".intval($this->request['player_uid'])."' LIMIT 30");

			if(!$this->DB->getTotalRows())
				$this->registry->output->redirectScreen("Nie znaleziono takiej postaci.", $this->registry->output->buildUrl('module=admin&section=char_edit', 'publicWithApp'));
		}
		else $this->DB->query('SELECT * FROM `mini_players` ORDER BY RAND() LIMIT 30 ');
		
		while( $r = $this->DB->fetch() )
		{
			if($idx >= $this->DB->getTotalRows()/2 && $idx >= 15)
				$players2[] = $r;
			else
			{
				$idx++;
				$players[] = $r;
			}
		}
		$template = $this->registry->output->getTemplate('game')->game_admin_chars($players, $players2);
		ipsRegistry::getClass('output')->addContent($template);
		$this->registry->output->setTitle($this->lang->words['admin_cp']);
		$this->registry->output->addNavigation($this->lang->words['game_cp'], 'app=game');
		$this->registry->output->addNavigation($this->lang->words['admin_cp'], 'app=game&module=admin');
		$this->registry->output->addNavigation('Wyszukaj postać', 'app=game&module=admin&section=char_edit');
		ipsRegistry::getClass('output')->sendOutput();
	}
}
?>
