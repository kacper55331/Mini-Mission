<?php

class public_game_admin_main extends ipsCommand
{
	public function doExecute( ipsRegistry $registry ) 
	{
		ipsRegistry::getClass('class_localization')->loadLanguageFile( array( 'public_game' ) );
		require_once(IPSLib::getAppDir('game') . '/sources/classes/global.php');
		
		if(!$this->memberData['member_id'])
			$this->registry->getClass('output')->showError( $this->lang->words['no_member'] );
		
		if(!IPSMember::isInGroup($this->memberData, MMClass::getAdminGroupAcces()))
			$this->registry->getClass('output')->showError( $this->lang->words['no_acces'] );

		$days = 7;
		if(isset($this->request['admin_show']) && $this->request['request_method'] == 'post')
		{
			if($this->request['admin_days'] < 2) $this->request['admin_days'] = $days;
			else if($this->request['admin_days'] > 30) $this->request['admin_days'] = $days;
			$days = intval($this->request['admin_days']);
		}
		$template = $this->registry->output->getTemplate('game')->game_admin_main($days);
		ipsRegistry::getClass('output')->addContent($template);
		$this->registry->output->setTitle($this->lang->words['admin_cp']);
		$this->registry->output->addNavigation($this->lang->words['game_cp'], 'app=game');
		$this->registry->output->addNavigation($this->lang->words['admin_cp'], 'app=game&module=admin');
		ipsRegistry::getClass('output')->sendOutput();
	}
}
?>
