<?php

class public_game_ajax_char extends ipsAjaxCommand 
{
	public function doExecute( ipsRegistry $registry ) 
	{	
		ipsRegistry::getClass('class_localization')->loadLanguageFile( array( 'public_game' ) );
		require_once(IPSLib::getAppDir('game') . '/sources/classes/global.php');

		$this->DB->query("SELECT * FROM `mini_players` WHERE `uid` = ".intval($this->request['uid']));
		$char = $this->DB->fetch();

		$char['hours'] = floor($char['timehere'] / 3600);
		$char['minutes'] = floor(($char['timehere'] - floor($char['timehere'] / 3600) * 3600) / 60);
		
		if($char['death'])
			$char['k_d'] = sprintf('%.2f', $char['kills']/$char['death']);
		
		$char['afk_hours'] = floor($char['afk'] / 3600);
		$char['afk_minutes'] = floor(($char['afk'] - floor($char['afk'] / 3600) * 3600) / 60);
		
		if($char['achiv'])
		{
			$achiv = MMClass::getPlayerAchievments(intval($this->request['uid']));
		}
		
		$this->returnHtml($this->registry->output->getTemplate('game')->ajax_profile($char, $achiv));
	}
}
?>