<?php

class public_dashboard_best_main extends ipsCommand
{
	public function doExecute( ipsRegistry $registry ) 
	{
		$idx = 0;
		ipsRegistry::getClass('class_localization')->loadLanguageFile( array( 'public_dashboard' ) );
		$query = $this->DB->query('SELECT `guid`, `uid`, `name`, `timehere` FROM `mini_players` ORDER BY `timehere` DESC LIMIT 10');
		while( $r = $this->DB->fetch( $query ) )
		{
			$r['hours'] = floor( $r['timehere'] / 3600 );
			$r['minutes'] = floor( ( $r['timehere'] - floor( $r['timehere'] / 3600 ) * 3600 ) / 60 );
			if( !$r['hours'] && !$r['minutes'] ) 
				continue;
			$idx++;
			if( $idx == 1 ) $r['cup'] = "<img src='{style_images_url}/cup/gold.png' />";
			else if( $idx == 2 ) $r['cup'] = "<img src='{style_images_url}/cup/silver.png' />";
			else if( $idx == 3 ) $r['cup'] = "<img src='{style_images_url}/cup/bronze.png' />";
			else $r['cup'] = "<img src='{style_images_url}/cup/none.png' />";
			if( $r['guid'] != -1 )
			{
				$r['member'] = IPSMember::load( $r['guid'] );
				$r['member'] = IPSMember::buildProfilePhoto( $r['member']['member_id'] );
			}
			
			$best['timehere'][] = $r;
		}
		
		$idx = 0;
		$query = $this->DB->query('SELECT `guid`, `uid`, `name`, `kills` AS `value` FROM `mini_players` ORDER BY `kills` DESC LIMIT 10');
		while( $r = $this->DB->fetch( $query ) )
		{
			if( !$r['value'] ) 
				continue;
			$idx++;
			if( $idx == 1 ) $r['cup'] = "<img src='{style_images_url}/cup/gold.png' />";
			else if( $idx == 2 ) $r['cup'] = "<img src='{style_images_url}/cup/silver.png' />";
			else if( $idx == 3 ) $r['cup'] = "<img src='{style_images_url}/cup/bronze.png' />";
			else $r['cup'] = "<img src='{style_images_url}/cup/none.png' />";
			if( $r['guid'] != -1 )
			{
				$r['member'] = IPSMember::load( $r['guid'] );
				$r['member'] = IPSMember::buildProfilePhoto( $r['member']['member_id'] );
			}
			
			$best['kills'][] = $r;
		}
		
		$idx = 0;
		$query = $this->DB->query('SELECT `guid`, `uid`, `name`, `death` AS `value` FROM `mini_players` ORDER BY `death` DESC LIMIT 10');
		while( $r = $this->DB->fetch( $query ) )
		{
			if( !$r['value'] ) 
				continue;
			$idx++;
			if( $idx == 1 ) $r['cup'] = "<img src='{style_images_url}/cup/gold.png' />";
			else if( $idx == 2 ) $r['cup'] = "<img src='{style_images_url}/cup/silver.png' />";
			else if( $idx == 3 ) $r['cup'] = "<img src='{style_images_url}/cup/bronze.png' />";
			else $r['cup'] = "<img src='{style_images_url}/cup/none.png' />";
			if( $r['guid'] != -1 )
			{
				$r['member'] = IPSMember::load( $r['guid'] );
				$r['member'] = IPSMember::buildProfilePhoto( $r['member']['member_id'] );
			}
			
			$best['deaths'][] = $r;
		}
		$template = $this->registry->output->getTemplate('dashboard')->dash_best($best['timehere'], $best['kills'], $best['deaths']);
		ipsRegistry::getClass('output')->addContent($template);
		$this->registry->output->setTitle('The best of');
		ipsRegistry::getClass('output')->sendOutput();
	}
}
?>

