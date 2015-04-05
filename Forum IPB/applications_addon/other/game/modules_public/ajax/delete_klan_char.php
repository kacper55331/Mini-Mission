<?php

class public_game_ajax_delete_klan_char extends ipsAjaxCommand 
{
	public function doExecute( ipsRegistry $registry ) 
	{			
		ipsRegistry::getClass('class_localization')->loadLanguageFile( array( 'public_game' ) );
		$this->DB->query("UPDATE `mini_players` SET `klan` = '0', `klanrank` = '0' WHERE `uid` = ".intval($this->request['delete_id']));
		$this->returnJsonArray( array( 'deleted' => 1 ) );
	}
}
?>