<?php
namespace Game\Service;

use Action\Service\ActionService;
use Authorize\Service\AuthenticationService;
use Event\Router\Router;
use Team\Service\TeamService;
use User\Collection\User as UserCollection;
use Game\Log\Logger;
use Position\Service\PositionService;
use Server\Service\ResponseService;
use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

class GameServiceFactory implements FactoryInterface
{
	public function createService(ServiceLocatorInterface $serviceLocator)
	{
		return new GameService(
			$serviceLocator->get(ValidationService::class),
			$serviceLocator->get(Logger::class),
			$serviceLocator->get(AuthenticationService::class),
			$serviceLocator->get(Router::class),
			$serviceLocator->get(UserCollection::class),
			$serviceLocator->get(PositionService::class),
			$serviceLocator->get(ActionService::class),
			$serviceLocator->get(ResponseService::class),
			$serviceLocator->get(TeamService::class)
		);
	}
}