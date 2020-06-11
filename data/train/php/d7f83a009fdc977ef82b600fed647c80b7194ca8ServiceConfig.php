<?php
namespace Page\Service;
use Zend\ServiceManager\Config as ServiceManagerConfig;
use Zend\ServiceManager\Di\DiAbstractServiceFactory;
use Zend\ServiceManager\Di\DiServiceInitializer;

use Page\Service;
/**
 * Description of ServiceConfig
 *
 * @author tomoaki
 */
class ServiceConfig {

    protected $config;
    
    public function __construct(array $config)
    {
        $this->config = $config;
    }
    
    public function configure(Service $service)
    {
        $config = $this->config;
        $serviceLocator = $service->getServiceLocator();
        
        if (isset($config['blocks']) && is_array($config['blocks'])) {
            $service->setBlockConfig($config['blocks']);
        }
        
    }
    
}
