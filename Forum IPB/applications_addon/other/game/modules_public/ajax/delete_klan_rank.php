<?php

class public_game_ajax_delete_klan_rank extends ipsAjaxCommand 
{
	public function doExecute( ipsRegistry $registry ) 
	{			
		ipsRegistry::getClass('class_localization')->loadLanguageFile( array( 'public_game' ) );
		$this->DB->query("DELETE FROM `mini_ranks` WHERE `uid` = ".intval($this->request['delete_id']));
		$this->DB->query("UPDATE `mini_players` SET `klanrank` = '0' WHERE `klanrank` = ".intval($this->request['delete_id']));
		$this->returnJsonArray( array( 'deleted' => 1 ) );
	}
}
?>