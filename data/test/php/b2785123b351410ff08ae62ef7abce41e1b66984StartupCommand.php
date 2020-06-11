<?php

require_once '_libs/PureMVC_PHP_1_0_2.php';
require_once 'model/URIProxy.php';
require_once 'model/UserProxy.php';

class StartupCommand extends SimpleCommand implements ICommand {
	
	public function execute(INotification $notification) {
		$this->facade->registerProxy(new URIProxy());
		$params = $this->facade->retrieveProxy(URIProxy::NAME)->getData();

		switch($params[0]) {
			case URIProxy::HOME:
				if(isset($_REQUEST['xid']) && $_REQUEST['xid'] != "" && isset($_REQUEST['answer']) && $_REQUEST['answer'] != "") {
					$this->facade->sendNotification(ApplicationFacade::USER_COMMAND);
				} else {
					echo file_get_contents("view/templates/access_denied.html");
				}
				break;
			case URIProxy::RESET:
				if(isset($_REQUEST['xid']) && $_REQUEST['xid'] != "") {
					$this->facade->sendNotification(ApplicationFacade::RESET_COMMAND);
				}
				break;
				
			case URIProxy::GENERATE:
				$this->facade->sendNotification(ApplicationFacade::GENERATE_COMMAND);
				break;
		}
	}
}

?>