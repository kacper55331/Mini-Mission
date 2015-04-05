<?php

class public_dashboard_partners_main extends ipsCommand
{
	public function doExecute( ipsRegistry $registry ) 
	{
		ipsRegistry::getClass('class_localization')->loadLanguageFile( array( 'public_dashboard' ) );
		$template = $this->registry->output->getTemplate('dashboard')->dash_partners();
		ipsRegistry::getClass('output')->addContent($template);
		$this->registry->output->setTitle('Strona główna');
		ipsRegistry::getClass('output')->sendOutput();
	}
}
?>
