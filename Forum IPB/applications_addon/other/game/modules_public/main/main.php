<?php

class public_game_main_main extends ipsCommand
{
	public function doExecute( ipsRegistry $registry ) 
	{
		ipsRegistry::getClass('class_localization')->loadLanguageFile( array( 'public_game' ) );
		require_once(IPSLib::getAppDir('game') . '/sources/classes/global.php');
		
		if(!$this->memberData['member_id'])
			$this->registry->getClass('output')->showError( $this->lang->words['no_member'] );

		$query = $this->DB->query('SELECT DISTINCT p.*, o.time FROM `mini_players` p LEFT JOIN `all_online` o ON o.player = p.uid AND o.type = 7 WHERE p.guid = '.$this->memberData['member_id']);
		while( $r = $this->DB->fetch($query) )
		{
			if(isset($r['time']))
			{			
				$r['logged'] = 1;
			}			
			$players[] = $r;
		}
		$template = $this->registry->output->getTemplate('game')->game_main($players);
		ipsRegistry::getClass('output')->addContent($template);
		$this->registry->output->setTitle('Panel gracza');
		$this->registry->output->addNavigation('Panel gracza', 'app=game');
		ipsRegistry::getClass('output')->sendOutput();
	}
}
?>
