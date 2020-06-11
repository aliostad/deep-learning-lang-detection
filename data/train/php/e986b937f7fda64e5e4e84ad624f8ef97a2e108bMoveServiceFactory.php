<?php

namespace Action\Service;

use Path\Service\PathFinderService;
use Position\Service\PositionService;
use User\Collection\User as UserCollection;
use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

class MoveServiceFactory implements FactoryInterface
{
	public function createService(ServiceLocatorInterface $serviceLocator)
	{
		return new MoveService(
			$serviceLocator->get(PathFinderService::class),
			$serviceLocator->get(UserCollection::class),
			$serviceLocator->get(PositionService::class)
		);
	}
}