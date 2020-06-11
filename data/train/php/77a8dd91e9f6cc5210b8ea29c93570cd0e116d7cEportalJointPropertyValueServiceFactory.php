<?php


namespace EportalAdmin\Factory\Service;

use EportalAdmin\Service\EportalJointPropertyValueService;
use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

/**
 * Description of EportalJointPropertyValueServiceFactory
 *
 * @author imaleo
 */
class EportalJointPropertyValueServiceFactory implements FactoryInterface{
    public function createService(ServiceLocatorInterface $serviceLocator) {
        $propertyService = $serviceLocator->get('Property\Service\Property');
        $jpvService = $serviceLocator->get('Property\Service\JointPropertyValueService');
        return new EportalJointPropertyValueService($jpvService, $propertyService);
    }

}
