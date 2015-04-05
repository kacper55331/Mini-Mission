<?php

class public_game_admin_objects extends ipsCommand
{
	public function doExecute( ipsRegistry $registry ) 
	{
		ipsRegistry::getClass('class_localization')->loadLanguageFile( array( 'public_game' ) );
		require_once(IPSLib::getAppDir('game') . '/sources/classes/global.php');
		
		if(!$this->memberData['member_id'])
			$this->registry->getClass('output')->showError( $this->lang->words['no_member'] );
		
		if(!IPSMember::isInGroup($this->memberData['member_id'], MMClass::getAdminGroupAcces()))
			$this->registry->getClass('output')->showError( $this->lang->words['no_acces'] );

		if($this->request['admin_object_add'] && $this->request['request_method'] == 'post')
		{
			if(empty($this->request['object_game']))
				$this->registry->output->redirectScreen("Podaj UID gry!", $this->registry->output->buildUrl('module=admin&section=objects', 'publicWithApp'));

			if(empty($this->request['object_file']))
				$this->registry->output->redirectScreen("Brak pliku!", $this->registry->output->buildUrl('module=admin&section=objects', 'publicWithApp'));

			$game = intval($this->request['object_game']);
			$mapa = $this->request['object_file'];
			
			$mapa = htmlspecialchars_decode($mapa);
			$mapa = str_replace("<br />", "\n", $mapa);
			try
			{
				$simpleXML = new simpleXMLElement($mapa);
			}
			catch(Exception $e)
			{
				$this->registry->output->showError("Wystąpił błąd parsowania - upewnij się, że wrzuciłeś całą zawartość pliku .map!<br /><br />Błąd: ".$e->getMessage()."<br /><br /><br />Zawartość zmiennej: ".$mapa);
			}
			foreach($simpleXML->children() as $child)
			{
				foreach($child->attributes() as $nazwa => $atrybut) $dataObject[$nazwa] = $atrybut;
				if($child->getName() == "object") $data['zapytaniedodaj'][] = $dataObject;
			}
			if(!count($data['zapytaniedodaj']))
				$this->registry->output->showError("W podanym pliku nie znaleziono żadnych obiektów do dodania.");
			
			$text = "INSERT INTO `mini_objects` (`gameuid`, `model`, `X`, `Y`, `Z`, `rX`, `rY`, `rZ`) VALUES ";
			foreach($data['zapytaniedodaj'] as $key => $zapytanie)
			{
				$text.= "(".$game.", '".$zapytanie['model']."', '".$zapytanie['posX']."', '".$zapytanie['posY']."', '".$zapytanie['posZ']."', '".$zapytanie['rotX']."', '".$zapytanie['rotY']."', '".$zapytanie['rotZ']."')";
				if(count($data['zapytaniedodaj']) != $key + 1) 
				{
					$text.= ", ";
				}
			}
			$this->DB->query($text);
			$this->registry->output->redirectScreen("Dodano ".count($data['zapytaniedodaj'])." obiektów.", $this->registry->output->buildUrl('module=admin&section=objects', 'publicWithApp'));
		}
		$template = $this->registry->output->getTemplate('game')->game_admin_objects();
		ipsRegistry::getClass('output')->addContent($template);
		$this->registry->output->setTitle($this->lang->words['admin_cp']);
		$this->registry->output->setTitle($this->lang->words['admin_cp']);
		$this->registry->output->addNavigation($this->lang->words['game_cp'], 'app=game');
		$this->registry->output->addNavigation($this->lang->words['admin_cp'], 'app=game&module=admin');
		$this->registry->output->addNavigation('Wgraj obiekty', 'app=game&module=admin&section=objects');
		ipsRegistry::getClass('output')->sendOutput();
	}
}
?>
