<?php
class Kutu_Session_SaveHandler_Manager
{
	public function setSaveHandler()
	{
		$registry = Zend_Registry::getInstance(); 
		$config = $registry->get('config');
	
		$saveHandler = $config->session->savehandler;
	
		switch (strtolower($saveHandler))
		{
			case 'remote':
			case 'proxydb':
				$sessionHandler = new Kutu_Session_SaveHandler_Remote();
				Zend_Session::setSaveHandler($sessionHandler);
				break;
			default:
			case 'directdb':
				require_once('Kutu/Session/SaveHandler/DirectDb.php');
				$sessionHandler = new Kutu_Session_SaveHandler_DirectDb();
				Zend_Session::setSaveHandler($sessionHandler);
				break;
		}
	}
}
?>