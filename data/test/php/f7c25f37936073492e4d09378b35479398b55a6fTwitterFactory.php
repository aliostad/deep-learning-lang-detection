<?php

namespace Tweets\Service;

use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

use Tweets\Service\TwitterService;

class TwitterFactory implements FactoryInterface
{
    
    protected $serviceLocator = null;
    
    public function createService(ServiceLocatorInterface $serviceLocator)
    {
        $this->serviceLocator = $serviceLocator;
        $config = $serviceLocator->get('config');
        $twitterConfig = $config['twitter'];
        
        return new TwitterService($twitterConfig);
    }
}

