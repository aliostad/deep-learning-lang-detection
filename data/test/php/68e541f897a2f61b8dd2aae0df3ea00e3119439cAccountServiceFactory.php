<?php
namespace GftHint\Di\Web;
use GftHint\Core\User\Service\AccountService;
use GftHint\Infrastructure\User\Account\AccountManager;
use Zend\Authentication\AuthenticationServiceInterface;
use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

/**
 * @author Igor Vorobiov<igor.vorobioff@gmail.com>
 */
class AccountServiceFactory implements FactoryInterface
{
	public function createService(ServiceLocatorInterface $serviceLocator)
	{
		$serviceProvider = new ServiceProvider($serviceLocator);
		/**
		 * @var AuthenticationServiceInterface $authService
		 */
		$authService = $serviceLocator->get('Zend\Authentication\AuthenticationService');

		$accountManager = new AccountManager($authService, $serviceProvider);
		$accountService = new AccountService($accountManager);

		return $accountService;
	}
}