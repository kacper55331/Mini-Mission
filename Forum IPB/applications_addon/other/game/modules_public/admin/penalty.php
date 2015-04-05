<?php

class public_game_admin_penalty extends ipsCommand
{
	public function doExecute( ipsRegistry $registry ) 
	{
		ipsRegistry::getClass('class_localization')->loadLanguageFile( array( 'public_game' ) );
		$query = $this->DB->query('SELECT * FROM `mini_players` WHERE `guid` = '.$this->memberData['member_id']);
		while( $r = $this->DB->fetch($query) )
		{
			$players[] = $r;
		}
		$template = $this->registry->output->getTemplate('game')->game_main($players);
		ipsRegistry::getClass('output')->addContent($template);
		$this->registry->output->setTitle('Panel gracza');
		ipsRegistry::getClass('output')->sendOutput();
	}
}
?>
