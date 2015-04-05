<?php

class public_game_ajax_delete_admin_log extends ipsAjaxCommand 
{
	public function doExecute( ipsRegistry $registry ) 
	{			
		ipsRegistry::getClass('class_localization')->loadLanguageFile( array( 'public_game' ) );
		$this->DB->query("DELETE FROM `all_logs` WHERE `uid` = ".intval($this->request['delete_id']));
		$this->returnJsonArray( array( 'deleted' => 1 ) );
	}
}
?>