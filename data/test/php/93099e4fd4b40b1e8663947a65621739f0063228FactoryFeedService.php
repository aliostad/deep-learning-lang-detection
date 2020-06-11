<?php

namespace Application\Factory;

use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;
use Zend\Feed\Reader\Reader;
use Application\Service\FeedService;

/**
 * Class for made FeedService object
 * @author erik
 *
 */
class FactoryFeedService implements FactoryInterface
{
	/**
	 * Method Relative to create object FeedReader
	 * @see \Zend\ServiceManager\FactoryInterface::createService()
	 */
	public function createService(ServiceLocatorInterface $serviceLocator)
	{
		$reader 	 = new Reader();
		$feedService = new FeedService($reader);
		
		return $feedService; 	
	}
}