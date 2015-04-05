<?php

class public_dashboard_online_main extends ipsCommand
{
	public function doExecute( ipsRegistry $registry ) 
	{
		ipsRegistry::getClass('class_localization')->loadLanguageFile( array( 'public_dashboard' ) );
		$players_query = $this->DB->query('SELECT o.time, p.guid, p.name FROM all_online o JOIN mini_players p ON p.uid = o.player AND p.uid != -1 WHERE o.type = 7');
		while( $r = $this->DB->fetch( $players_query ) )
		{
			if( $r['guid'] != -1 )
			{
				$r['member'] = IPSMember::load( $r['guid'] );
				$r['member'] = IPSMember::buildProfilePhoto( $r['member']['member_id'] );
			}
			$r['time'] = time() - $r['time'];
			$r['hours'] = floor($r['time'] / 3600);
			$r['minutes'] = floor(($r['time'] - floor($r['time'] / 3600) * 3600) / 60);

			$playerList[] = $r;
		}
		$template = $this->registry->output->getTemplate('dashboard')->dash_online($playerList);
		ipsRegistry::getClass('output')->addContent($template);
		$this->registry->output->setTitle('Gracze online');
		ipsRegistry::getClass('output')->sendOutput();
	}
}
?>

