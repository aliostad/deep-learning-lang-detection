<?php
namespace Forum\Factory;

use Forum\Service\RecruitService;
use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

class RecruitServiceFactory implements FactoryInterface
{
    /**
     * Create service
     *
     * @param ServiceLocatorInterface $serviceLocator
     * @return mixed
     */
    public function createService(ServiceLocatorInterface $serviceLocator)
    {
        return new RecruitService(
            $serviceLocator->get('Forum\Mapper\RecruitMapperInterface')
        );
    }
}

?>