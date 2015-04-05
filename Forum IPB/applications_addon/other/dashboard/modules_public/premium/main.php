<?php

class public_dashboard_premium_main extends ipsCommand
{
	public function doExecute( ipsRegistry $registry ) 
	{
		ipsRegistry::getClass('class_localization')->loadLanguageFile( array( 'public_dashboard' ) );
		if(!$this->memberData['member_id'])
		{
			$this->registry->getClass('output')->showError( $this->lang->words['no_member'] );
		}
		
		$template = $this->registry->output->getTemplate('dashboard')->dash_premium();
		ipsRegistry::getClass('output')->addContent($template);
		$this->registry->output->setTitle('Strona główna');
		ipsRegistry::getClass('output')->sendOutput();
	}
}
?>
