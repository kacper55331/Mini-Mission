<?php

class public_game_admin_klan_new extends ipsCommand
{
	public function doExecute( ipsRegistry $registry ) 
	{
		ipsRegistry::getClass('class_localization')->loadLanguageFile( array( 'public_game' ) );
		require_once(IPSLib::getAppDir('game') . '/sources/classes/global.php');
		
		if(!$this->memberData['member_id'])
			$this->registry->getClass('output')->showError( $this->lang->words['no_member'] );
		
		if(!IPSMember::isInGroup($this->memberData['member_id'], MMClass::getAdminGroupAcces()))
			$this->registry->getClass('output')->showError( $this->lang->words['no_acces'] );

		if($this->request['admin_create_klan'] && $this->request['request_method'] == 'post')
		{
			$klan_name = $this->request['klan_name'];
			$player_name = $this->request['player_name'];
			
			if(empty($klan_name))
				$messages[] = "Nazwa klanu jest pusta!";
			
			if(empty($player_name))
				$messages[] = "Nie podałeś nazwy gracza!";
			
			$this->DB->query("SELECT `uid`, `name`, `klan` FROM `mini_players` WHERE `name` LIKE '".$this->DB->addSlashes($player_name)."'");
			if(!$this->DB->getTotalRows())
				$messages[] = 'Taka postać nie istnieje!';
			$player = $this->DB->fetch();

			if($player['klan'])
				$messages[] = 'Gracz jest już w jakimś klanie!';

			$this->DB->query("SELECT 1 FROM `mini_klan` WHERE `name` LIKE '".$this->DB->addSlashes($klan_name)."'");
			if($this->DB->getTotalRows())
				$messages[] = 'Taki klan już istnieje!';
			
			if(count($messages))
				$this->registry->output->redirectScreen("<li>".implode('</li><li>',$messages)."</li>", $this->registry->output->buildUrl('module=admin&section=klan_new', 'publicWithApp'));

			$this->DB->query("INSERT INTO `mini_klan` (`name`) VALUES ('".$this->DB->addSlashes($klan_name)."')");
			$klan_uid = $this->DB->getInsertId();
			
			$this->DB->query("INSERT INTO `mini_ranks` (`klanuid`, `name`, `lvl`) VALUES (".$klan_uid.", 'Lider', 255)");
			$rank_uid = $this->DB->getInsertId();
			
			$this->DB->query('UPDATE `mini_players` SET `klan` = '.$klan_uid.', `klanrank` = '.$rank_uid.' WHERE `uid` = '.$player['uid']);
			$this->registry->output->redirectScreen("Klan ".$klan_name." stworzony pomyślnie<br />Lider: ".$player['name']."!", $this->registry->output->buildUrl('module=admin&section=klan_new', 'publicWithApp'));
		}
		$template = $this->registry->output->getTemplate('game')->game_admin_klan_create();
		ipsRegistry::getClass('output')->addContent($template);
		$this->registry->output->setTitle($this->lang->words['admin_cp']);
		$this->registry->output->addNavigation($this->lang->words['game_cp'], 'app=game');
		$this->registry->output->addNavigation($this->lang->words['admin_cp'], 'app=game&module=admin');
		$this->registry->output->addNavigation('Stwórz klan', 'app=game&module=admin&section=klan_new');
		ipsRegistry::getClass('output')->sendOutput();
	}
}
?>
