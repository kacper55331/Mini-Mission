<?php 

class publicSessions__dashboard
{
	public function getSessionVariables()
	{
		//-----------------------------------------
		// INIT
		//-----------------------------------------
		
		$array = array( 'location_1_type'   => '',
						'location_1_id'     => 0,
						'location_2_type'   => '',
						'location_2_id'     => 0 );

		return $array;
	}
	public function parseOnlineEntries( $rows )
	{
		if( !is_array($rows) OR !count($rows) )
		{
			return $rows;
		}
		
		$final		= array();
		
		//-----------------------------------------
		// Extract the topic/forum data
		//-----------------------------------------

		foreach( $rows as $row )
		{
			if( $row['current_appcomponent'] != 'dashboard' OR !$row['current_module'] )
			{
				continue;
			}
		}


		foreach( $rows as $row )
		{
			if( $row['current_appcomponent'] == 'dashboard')
			{
				if( $row['current_module'] == 'online' )
				{
					$row['where_line'] = 'Przegląda graczy online';
				}
				if( $row['current_module'] == 'best' )
				{
					$row['where_line'] = 'Przegląda spis rekordów';
				}
				else
				{
					$row['where_line'] = 'Przegląda portal';
				}
			}
			$final[ $row['id'] ] = $row;
		}
		
		return $final;
	}
}

?>