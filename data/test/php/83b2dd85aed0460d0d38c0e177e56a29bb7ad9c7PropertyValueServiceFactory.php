<?php

namespace Property\Factory\Service;

use Property\Service\PropertyValueService;
use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;
/**
 *
 * @author imaleo
 *        
 */
class PropertyValueServiceFactory implements FactoryInterface
{

    /**
     * (non-PHPdoc)
     *
     * @see FactoryInterface::createService()
     *
     */
    public function createService(ServiceLocatorInterface $serviceLocator)
    {
        return new PropertyValueService($serviceLocator->get('Property\Mapper\PropertyValue'));
    }
}

?>