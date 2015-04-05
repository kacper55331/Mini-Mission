<?php
$_SEOTEMPLATES = array(
						'game'    => array(
                        'app'            => 'game',
                        'allowRedirect' => 1,
                        'out'            => array( '#app=game(&|$)#i', 'game' ),
                        'in'            => array( 'regex'   => "#/game(/|$)#i",
                                                  'matches' => array( array( 'app', 'game' ) ) ) ),

						'shopseo'     => array( 
						'app'		      => 'game',
						'allowRedirect' => 1,
						//'isPagesMode'   => 1,
						'out'           => array( '#app=game(&|$)((?:&|&amp;)module=shop#i', 'shop/$3' ),
                        'in'            => array( 'regex'   => "#/shop(/|$)#i",
												  'matches' => array( array( 'app', 'game' ), array( 'module', 'shop' ) ) ) ),	
						'ticketseo'     => array( 
						'app'		      => 'game',
						'allowRedirect' => 1,
						//'isPagesMode'   => 1,
						'out'           => array( '#app=game(&|$)((?:&|&amp;)module=tickets#i', 'tickets/$3' ),
                        'in'            => array( 'regex'   => "#/tickets(/|$)#i",
												  'matches' => array( array( 'app', 'game' ), array( 'module', 'tickets' ) ) ) ),		
						'gameseo'     => array( 
						'app'		      => 'game',
						'allowRedirect' => 1,
						//'isPagesMode'   => 1,
						'out'           => array( '#app=game(&|$)((?:&|&amp;)module=admin#i', 'gamecp/$3' ),
                        'in'            => array( 'regex'   => "#/gamecp(/|$)#i",
												  'matches' => array( array( 'app', 'game' ), array( 'module', 'admin' ) ) ) ),	
						'gamedseo'     => array( 
						'app'		      => 'game',
						'allowRedirect' => 1,
						//'isPagesMode'   => 1,
						'out'           => array( '#app=game(&|$)((?:&|&amp;)module=admin(&|$)((?:&|&amp;)section=doors#i', 'gamecp/doors/$4' ),
                        'in'            => array( 'regex'   => "#/gamecp/doors(/|$)#i",
												  'matches' => array( array( 'app', 'game' ), array( 'module', 'admin' ), array( 'section', 'doors' ) ) ) ),													  
                   );
	
 
?>