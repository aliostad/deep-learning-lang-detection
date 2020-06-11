<?php
namespace common\extensions\external_repository_manager\implementation\box;

use common\extensions\external_repository_manager\ExternalRepositoryObject;
use repository\RepositoryDataManager;

class BoxExternalRepositoryObject extends ExternalRepositoryObject
{
    const OBJECT_TYPE = 'box';
    
    static function get_object_type()
    {
    	return self :: OBJECT_TYPE;
	}	      
    
	function get_content_data($external_object)
	{		
		$external_repository = RepositoryDataManager :: get_instance()->retrieve_external_instance($this->get_external_repository_id());				
		return BoxExternalRepositoryManagerConnector :: get_instance($external_repository)->download_external_repository_object($external_object);
	}
}
?>