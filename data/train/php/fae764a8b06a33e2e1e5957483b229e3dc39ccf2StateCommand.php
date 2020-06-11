<?php

require_once PUREMVC.'patterns/command/SimpleCommand.php';  
require_once PUREMVC.'interfaces/INotification.php';
require_once BASEDIR.'ApplicationFacade.php';

class StateCommand extends SimpleCommand
{
	public function execute( INotification $notification )
	{		
		$view = ( isset( $_REQUEST['view'] ) ) ? $_REQUEST['view'] : 'default';	
		
		switch( $view )
		{
			default:        $this->facade->sendNotification( ApplicationFacade::VIEW_HOME ); break;		
			case "ajax":    $this->facade->sendNotification( ApplicationFacade::VIEW_AJAX ); break;		
			case "login":   $this->facade->sendNotification( ApplicationFacade::VIEW_LOGIN ); break;		
			case "films":   $this->facade->sendNotification( ApplicationFacade::VIEW_FILMS ); break;		
		}
	}
}

?>
