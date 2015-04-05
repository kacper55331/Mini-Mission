<?php

class public_game_admin_graph extends ipsCommand
{
	public function doExecute( ipsRegistry $registry ) 
	{
		$days	= intval( $this->request['days'] );
			
		if( !$days ) $days	= 7;

		require_once( IPS_KERNEL_PATH . '/classGraph.php' );

		$cutoff			= time() - ( $days * 86400 );
		$_check			= time();
		$_tzOffset		= $this->settings['time_offset'] * 3600;
		$registrations	= array();
		$members		= array();
		$log			= array();
		$labels			= array();
		$_ttl			= 0;

		while( $_check > $cutoff )
		{
			$_day	= strftime( '%b %d', $_check + $_tzOffset );
			$_key	= strftime( '%Y-%m-%d', $_check + $_tzOffset );

			$labels[ $_key ]		= $_day;
			$registrations[ $_key ]	= 0;
			$members[ $_key ] = 0;
			$log[ $_key ] = 0;

			$_check	-= 86400;
		}		
		switch($this->request['type'])
		{
			case 'register':
				$this->DB->query( 'SELECT `joined` FROM `mini_players` WHERE `joined` > '.$cutoff);
				while( $r = $this->DB->fetch() )
				{
					//$_day	= strftime( '%b %d', $r['joined'] );
					$_key	= strftime( '%Y-%m-%d', $r['joined'] + $_tzOffset );

					if( isset($registrations[ $_key ]) )
					{
						$registrations[ $_key ]	+= 1;
						$_ttl++;
					}
				}

				$this->DB->query( 'SELECT `time` FROM `all_logs` WHERE `server` = 7 AND `time` > '.$cutoff);
				while( $r = $this->DB->fetch() )
				{
					//$_day	= strftime( '%b %d', $r['time'] );
					$_key	= strftime( '%Y-%m-%d', $r['time'] + $_tzOffset );

					if( isset($log[ $_key ]) )
					{
						$log[ $_key ]	+= 1;
						$_ttl++;
					}
				}			
				$this->DB->build( array( 'select' => 'member_id, joined', 'from' => 'members', 'where' => 'joined > ' . $cutoff ) );
				$this->DB->execute();
				while( $r = $this->DB->fetch() )
				{
					//$_day	= strftime( '%b %d', $r['joined'] );
					$_key	= strftime( '%Y-%m-%d', $r['joined'] + $_tzOffset );

					if( isset($members[ $_key ]) )
					{
						$members[ $_key ]	+= 1;
						$_ttl++;
					}
				}					
				ksort( $registrations );	
				ksort( $members );	
				ksort( $log );	
				ksort( $labels );
				
				$graph	= new classGraph();
				$graph->options['title']			= sprintf( 'Rejestracje przez ostatnie %d dni', $days );
				$graph->options['font']				= DOC_IPS_ROOT_PATH . '/public/style_captcha/captcha_fonts/DejaVuSans.ttf';
				$graph->options['width']			= 1024;
				$graph->options['height']			= 400;
				$graph->options['style3D']			= 1;
				$graph->options['showlegend']		= 1;
				$graph->options['showgridlinesx']	= 0;
				$graph->options['numticks']		= 5;
				
				if( $_ttl )
				{			
					$graph->addLabels( array_values($labels) );
					$graph->addSeries( 'Konta globalne', array_values($members) );
					$graph->addSeries( 'Postacie', array_values($registrations) );
					//$graph->addSeries( 'Kary', array_values($log) );
				}
				else
				{
					$graph->options['title']	= sprintf( 'Brak rejestracji przez %d dni', $days );
					$graph->addLabels( array( 0 ) );
					$graph->addSeries( 'Konta globalne', array( 0 ) );
					$graph->addSeries( 'Postacie', array( 0 ) );
				}
				$graph->options['charttype'] = 'Line';
				$graph->display();				
				break;
				
			case 'online':
				$this->DB->query( 'SELECT `time`, `timehere` FROM `mini_connect` WHERE `time` > '.$cutoff);
				while( $r = $this->DB->fetch() )
				{
					//$_day	= strftime( '%b %d', $r['time'] );
					$_key	= strftime( '%Y-%m-%d', $r['time'] + $_tzOffset );

					if( isset($log[ $_key ]) )
					{
						$log[ $_key ]	+= sprintf('%f', ($r['timehere'] / 3600));
						$members[ $_key ] += 1;
						$_ttl++;
					}
				}
				/*
				$this->DB->query( 'SELECT `lastlogged` FROM `mini_players` WHERE `lastlogged` > '.$cutoff);
				while( $r = $this->DB->fetch() )
				{
					//$_day	= strftime( '%b %d', $r['time'] );
					$_key	= strftime( '%Y-%m-%d', $r['lastlogged'] + $_tzOffset );

					if( isset($log[ $_key ]) )
					{
						$registrations[ $_key ]	+= 1;
						$_ttl++;
					}
				}*/
				
				ksort( $members );	
				ksort( $registrations );	
				ksort( $log );	
				ksort( $labels );

				$graph	= new classGraph();
				$graph->options['title']			= sprintf( 'Czas online przez ostatnie %d dni', $days );
				$graph->options['font']				= DOC_IPS_ROOT_PATH . '/public/style_captcha/captcha_fonts/DejaVuSans.ttf';
				$graph->options['width']			= 1024;
				$graph->options['height']			= 400;
				$graph->options['style3D']			= 1;
				$graph->options['showlegend']		= 1;
				$graph->options['showgridlinesx']	= 0;
				$graph->options['numticks']		= 5;
				
				if( $_ttl )
				{			
					$graph->addLabels( array_values($labels) );
					$graph->addSeries( 'Czas online (h)', array_values($log) );
					$graph->addSeries( 'Wizyt', array_values($members) );
					//$graph->addSeries( 'Osób online', array_values($registrations) );
				}
				else
				{
					$graph->options['title']	= sprintf( 'Brak graczy online przez %d dni', $days );
					$graph->addLabels( array( 0 ) );
					$graph->addSeries( 'Czas online (h)', array( 0 ) );
					$graph->addSeries( 'Wizyt', array( 0 ) );
				}
				$graph->options['charttype'] = 'Line';
				$graph->display();
				break;
		}
	}
}
?>