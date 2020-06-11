<?php

class Cream_Controller_Request_Resolver_Repository extends Cream_Controller_Request_Resolver_Abstract
{
	public function process()
	{
		$repositoryName = $this->_getApplication()->getRequest()->getParam('__repository');
		
		if ($repositoryName) {
			$repository = Cream_Content_Managers_RepositoryProvider::getRepository($repositoryName);
		
			if ($repository) {
				$this->_getApplication()->getContext()->setRepository($repository);
			} else {
				throw new Cream_Controller_Exception('Could not find repository "'. $repositoryName .'" from query string.');
			}
		}
	}
}