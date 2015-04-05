<?php
$_SEOTEMPLATES = array(
						'dashboard'    => array(
                        'app'            => 'dashboard',
                        'allowRedirect' => 1,
                        'out'            => array( '#app=dashboard(&|$)#i', 'dashboard' ),
                        'in'            => array( 'regex'   => "#/dashboard(/|$)#i",
                                                  'matches' => array( array( 'app', 'dashboard' ) ) ) ),
                   );
?>