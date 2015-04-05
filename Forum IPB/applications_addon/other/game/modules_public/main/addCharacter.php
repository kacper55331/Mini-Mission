<?php

class public_game_main_addCharacter extends ipsCommand
{
	public function doExecute( ipsRegistry $registry ) 
	{
		ipsRegistry::getClass('class_localization')->loadLanguageFile( array( 'public_game' ) );
		require_once(IPSLib::getAppDir('game') . '/sources/classes/global.php');

		if(!$this->memberData['member_id'])
			$this->registry->getClass('output')->showError( $this->lang->words['no_member'] );

		$this->DB->query('SELECT 1 FROM `mini_players` WHERE `guid` = '.$this->memberData['member_id']);
		$count = $this->DB->getTotalRows();

		if(isset($this->request['addchar']) && $this->request['request_method'] == 'post')
		{
			if($count >= MMClass::getMaxPlayers($this->memberData['premium']) && !IPSMember::isInGroup($this->memberData, MMClass::getAdminGroupAcces()))
				$this->registry->getClass('output')->showError("Osiągnąłeś limit postaci!");

			if(empty($this->request['name']))
				$messages[] = 'Nie podałeś nazwy.';
			if(empty($this->request['password']))
				$messages[] = 'Nie podałeś nazwy.';
				
			$this->DB->query("SELECT `guid`, `uid`, `password` FROM `mini_players` WHERE `name` LIKE '".$this->DB->addSlashes($this->request['name'])."'");
			if(!$this->DB->getTotalRows())
				$messages[] = 'Nie znaleziono takiej postaci.';
				
			$data = $this->DB->fetch();
			if($data['guid'] == $this->memberData['member_id'])
				$messages[] = 'Ta postać jest już do Ciebie przypisana.';
			else if($data['guid'] != -1)
				$messages[] = 'Ta postać jest już przypisana do jakiegoś konta.';
			
			if($data['password'] != md5($this->request['password']))
				$messages[] = 'Hasło się nie zgadza.';
				
			if(count($messages))
				$this->registry->output->redirectScreen("<li>".implode('</li><li>',$messages)."</li>", $this->registry->output->buildUrl('module=main&section=addCharacter', 'publicWithApp'));

			$this->DB->query("UPDATE `mini_players` SET `guid` = ".$this->memberData['member_id'].", `password` = 'NULL' WHERE `uid` = ".$data['uid']);
			MMClass::givePlayerAchiv($data['uid'], 16);
			$this->registry->output->redirectScreen("Postać przypisana pomyślnie!", $this->registry->output->buildUrl('module=main&section=player&uid='.$data['uid'], 'publicWithApp'));
		}
		$template = $this->registry->output->getTemplate('game')->game_addCharacter($count);
		ipsRegistry::getClass('output')->addContent($template);
		$this->registry->output->setTitle('Panel gracza');
		$this->registry->output->addNavigation('Panel gracza', 'app=game');
		$this->registry->output->addNavigation('Przypisz postać', 'app=game&module=main&section=addCharacter');
		ipsRegistry::getClass('output')->sendOutput();
	}
}
?>
