<?php

class public_game_admin_klan_edit extends ipsCommand
{
	public function doExecute( ipsRegistry $registry ) 
	{
		$template = $this->registry->output->getTemplate('game')->game_admin_main();
		ipsRegistry::getClass('output')->addContent($template);
		$this->registry->output->setTitle('Panel admina');
		ipsRegistry::getClass('output')->sendOutput();
	}
}
?>
