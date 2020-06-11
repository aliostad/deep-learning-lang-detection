<?php
namespace GftHint\Di\Web;
use GftHint\Core\User\Service\AccountService;
use GftHint\Core\User\Service\UserService;
use GftHint\Infrastructure\Shared\ServiceProviderInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

/**
 * @author Igor Vorobiov<igor.vorobioff@gmail.com>
 */
class ServiceProvider implements ServiceProviderInterface
{
	/**
	 * @var ServiceLocatorInterface
	 */
	private $serviceLocator;

	public function __construct(ServiceLocatorInterface $serviceLocator)
	{
		$this->serviceLocator = $serviceLocator;
	}

	/**
	 * @return UserService
	 */
	public function getUserService()
	{
		return $this->serviceLocator->get('UserService');
	}

	/**
	 * @return AccountService
	 */
	public function getAccountService()
	{
		return $this->serviceLocator->get('AccountService');
	}
}