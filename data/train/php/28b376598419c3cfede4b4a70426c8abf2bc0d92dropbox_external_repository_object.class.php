<?php
namespace common\extensions\external_repository_manager\implementation\dropbox;

use common\extensions\external_repository_manager\ExternalRepositoryObject;
use repository\RepositoryDataManager;

class DropboxExternalRepositoryObject extends ExternalRepositoryObject
{
    const OBJECT_TYPE = 'dropbox';

    static function get_object_type()
    {
    	return self :: OBJECT_TYPE;
	}
    
    function get_content_data($external_object)
	{		
		$external_repository = RepositoryDataManager :: get_instance()->retrieve_external_instance($this->get_external_repository_id());
		return DropboxExternalRepositoryManagerConnector :: get_instance($external_repository)->download_external_repository_object($external_object);
	}
}
?>