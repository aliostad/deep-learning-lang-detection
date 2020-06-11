<?php
namespace Acelaya\Controller;

use Acelaya\Service\ItemService;
use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

/**
 * Class UserControllerFactory
 * @author
 * @link
 */
class ItemControllerFactory implements FactoryInterface
{
    /**
     * Create service
     *
     * @param ServiceLocatorInterface $serviceLocator
     * @return mixed
     */
    public function createService(ServiceLocatorInterface $serviceLocator)
    {
        /** @var ItemService $itemService */
        $itemService = $serviceLocator->get(ItemService::class);
        return new ItemController($itemService);
    }
}
