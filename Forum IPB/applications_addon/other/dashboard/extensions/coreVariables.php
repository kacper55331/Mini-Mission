<?php 
if( ! $_REQUEST['module'] AND $_REQUEST['app'] == 'dashboard' )
{
	$_RESET['module'] = 'main';
}
if( ! isset( $_REQUEST['module'] ) )
{
	$_RESET['app']  = 'dashboard';
	$_RESET['module'] = 'main';
}
?>