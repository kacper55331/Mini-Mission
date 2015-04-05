<?php

class public_game_main_createCharacter extends ipsCommand
{
	public function doExecute( ipsRegistry $registry ) 
	{
		ipsRegistry::getClass('class_localization')->loadLanguageFile( array( 'public_game' ) );
		require_once(IPSLib::getAppDir('game') . '/sources/classes/global.php');

		if(!$this->memberData['member_id'])
			$this->registry->getClass('output')->showError( $this->lang->words['no_member'] );

		$this->DB->query('SELECT 1 FROM `mini_players` WHERE `guid` = '.$this->memberData['member_id']);
		$count = $this->DB->getTotalRows();
		
		if(isset($this->request['newchar']) && $this->request['request_method'] == 'post')
		{
			if($count >= MMClass::getMaxPlayers($this->memberData['premium']) && !IPSMember::isInGroup($this->memberData, MMClass::getAdminGroupAcces()))
				$this->registry->getClass('output')->showError("Osiągnąłeś limit postaci!");

			if(empty($this->request['name']))
				$messages[] = 'Nie podałeś nazwy.';
			if(!preg_match('/^[-0-9A-Z_\[\]_()=@]+$/i', $this->request['name']))
				$messages[] = 'Podana nazwa postaci nie jest dozwolona.';
			if(strlen($this->request['name']) > 24)
				$messages[] = 'Za długa nazwa.';
			if(strlen($this->request['name']) < 3)
				$messages[] = 'Za krótka nazwa.';
			
			$this->DB->query("SELECT name FROM mini_players WHERE name LIKE '".$this->DB->addSlashes($this->request['name'])."'");
			if($this->DB->getTotalRows())
			{
				$existing = $this->DB->fetch();
				$messages[] = 'Podana nazwa postaci jest zbyt podobna do już istniejącej ('.$existing['name'].').';
			}
			
			if(count($messages))
				$this->registry->output->redirectScreen("<li>".implode('</li><li>',$messages)."</li>", $this->registry->output->buildUrl('module=main&section=createCharacter', 'publicWithApp'));
			if($this->memberData['language'] == 2)
				$lang = 0;
			else if($this->memberData['language'] == 3)
				$lang = 2;
			$lang = $this->memberData['language'];
			
			$this->DB->query("INSERT INTO `mini_players` (`guid`, `name`, `lang`, `joined`) VALUES (".$this->memberData['member_id'].", '".$this->DB->addSlashes($this->request['name'])."', ".$lang.", ".time().")");
			$uid = $this->DB->getInsertId();
			MMClass::givePlayerAchiv($uid, 16);
			$this->registry->output->redirectScreen("Postać stworzona!", $this->registry->output->buildUrl('module=main&section=player&uid='.$uid, 'publicWithApp'));
		}
		$template = $this->registry->output->getTemplate('game')->game_createCharacter($count);
		ipsRegistry::getClass('output')->addContent($template);
		$this->registry->output->setTitle('Panel gracza');
		$this->registry->output->addNavigation('Panel gracza', 'app=game');
		$this->registry->output->addNavigation('Stwórz postać', 'app=game&module=main&section=createCharacter');
		ipsRegistry::getClass('output')->sendOutput();
	}
}
?>
