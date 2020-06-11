<?php
class Base_Google_Map
{
	protected $_apiKey;
	
	public function getApiKey(){
		if (null === $this->_apiKey) 
		{
			$config = new Zend_Config_Ini(APPLICATION_PATH.'/configs/application.ini', APPLICATION_ENV);
	    	$apiKey=$config->google->apiKey;
			
			if($apiKey=="" || is_null($apiKey))
			{
				$settings=new Admin_Model_GlobalSettings();
				$apiKey=$settings->settingValue('google_map_api_key');	
			}
            $this->setApiKey($apiKey);
        }
		return $this->_apiKey; 
	}
	
	public function setApiKey($apiKey)
	{
		$this->_apiKey=(string)$apiKey;
	}
}
