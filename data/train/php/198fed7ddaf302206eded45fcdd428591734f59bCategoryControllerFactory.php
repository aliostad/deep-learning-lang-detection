<?php
namespace Quiz\Controller;

use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

class CategoryControllerFactory implements FactoryInterface
{
    /**
     * Create service
     *
     * @param ServiceLocatorInterface $serviceLocator
     * @return mixed
     */
    public function createService(ServiceLocatorInterface $serviceLocator)
    {
        $services = $serviceLocator->getServiceLocator();

        /** @var \Quiz\Service\Category $categoryService */
        $categoryService = $services->get('Quiz\Service\Category');

        return new CategoryController(
            $categoryService
        );
    }
}
