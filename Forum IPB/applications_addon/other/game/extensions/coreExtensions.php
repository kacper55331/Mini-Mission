<?php 

class publicSessions__game
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
			if( $row['current_appcomponent'] != 'game' OR !$row['current_module'] )
			{
				continue;
			}
		}


		foreach( $rows as $row )
		{
			if( $row['current_appcomponent'] == 'game' && $row['current_module'] == 'main')
			{
				if( $row['current_section'] == 'createCharacter' )
				{
					$row['where_line'] = 'Tworzy postać';
				}
				else if( $row['current_section'] == 'addCharacter' )
				{
					$row['where_line'] = 'Przypisuje postać';
				}
				else
				{
					$row['where_line'] = 'Przegląda panel gracza';
				}
			}
			$final[ $row['id'] ] = $row;
		}
		
		return $final;
	}
}

?>