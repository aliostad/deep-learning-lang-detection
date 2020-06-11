<?php

namespace Conferences\View\Helper;

use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

class SearchFormFactory implements FactoryInterface {

	public function createService(ServiceLocatorInterface $serviceLocator) {
		
	    $conferenceService = $serviceLocator->getServiceLocator()->get('conference.service');
        $tagService = $serviceLocator->getServiceLocator()->get('Conferences\Service\TagService');
        $routeMatch = $serviceLocator->getServiceLocator()->get('Application')->getMvcEvent()->getRouteMatch();

        $request = $serviceLocator->getServiceLocator()->get('Request');

        $currentDatas = array();
	    $currentDatas['region'] = $routeMatch->getParam('region');
        $currentDatas['period'] = $request->getQuery('period',null);
                            
	    return new SearchForm($conferenceService, $tagService, $currentDatas);
		
	}

}