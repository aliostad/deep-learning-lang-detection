<?php
class Kutu_Session_SaveHandler_Manager
{
	public function setSaveHandler()
	{
		//trigger_error('Use Bar instead', E_USER_NOTICE);
		
		$registry = Zend_Registry::getInstance(); 
		$application = $registry->get(ZEND_APP_REG_ID);
		
		//print_r($application->getOption('guid'));
		//die();
		
		//ensure resource Session has/is initialized;
		$application->getBootstrap()->bootstrap('session');
		
		$saveHandler = $application->getBootstrap()->getResource('session');
		//$saveHandler->getSaveHandler();
		//echo $saveHandler->init();
		Zend_Session::setSaveHandler($saveHandler);
	}
	
	public function setSaveHandlerORI()
	{
		$registry = Zend_Registry::getInstance(); 
		$config = $registry->get('config');
	
		$saveHandler = $config->session->savehandler;
		$params = $config->session->config->db->param;
	
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
				$sessionHandler = new Kutu_Session_SaveHandler_DirectDb($config->session->config->db->adapter, $params->toArray());
				Zend_Session::setSaveHandler($sessionHandler);
				break;
		}
	}
}
?>