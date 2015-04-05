<?php

class public_game_main_graph extends ipsCommand
{
	public function doExecute( ipsRegistry $registry ) 
	{
		$days	= intval( $this->request['days'] );
		$uid	= intval( $this->request['uid'] );
			
		if( !$days ) $days	= 7;
		
		$cutoff			= time() - ( $days * 86400 );
		$_check			= time();
		$_tzOffset		= $this->settings['time_offset'] * 3600;
		$log			= array();
		$visits			= array();
		$labels			= array();
		$_ttl			= 0;
		
		while( $_check > $cutoff )
		{
			$_day	= strftime( '%b %d', $_check + $_tzOffset );
			$_key	= strftime( '%Y-%m-%d', $_check + $_tzOffset );

			$labels[ $_key ]		= $_day;
			$log[ $_key ] = 0;
			$visits[ $_key ] = 0;

			$_check	-= 86400;
		}

		$this->DB->query( 'SELECT `time`, `timehere` FROM `mini_connect` WHERE `player` = '.$uid.' AND `time` > '.$cutoff);
		while( $r = $this->DB->fetch() )
		{
			//$_day	= strftime( '%b %d', $r['time'] );
			$_key	= strftime( '%Y-%m-%d', $r['time'] + $_tzOffset );

			if( isset($log[ $_key ]) )
			{
				$log[ $_key ]	+= floor( $r['timehere'] / 3600 );
				$visits[ $_key ] += 1;
				$_ttl++;
			}
		}		
		
		ksort( $labels );
		ksort( $log );	
		ksort( $visits );	
		
		require_once( IPS_KERNEL_PATH . '/classGraph.php' );
		$graph	= new classGraph();
		$graph->options['title']			= sprintf( 'Twoje wizyty na serwerze przez %d dni', $days );
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
			$graph->addSeries( 'Czas online', array_values($log) );
			$graph->addSeries( 'Ilość wizyt', array_values($visits) );
		}
		else
		{
			$graph->options['title']	= sprintf( 'Brak odwiedzin na serwerze przez %d dni', $days );
			$graph->addLabels( array( 0 ) );
			$graph->addSeries( 'Postacie', array( 0 ) );
		}
		$graph->options['charttype'] = 'Line';
		$graph->display();
	}
}
?>