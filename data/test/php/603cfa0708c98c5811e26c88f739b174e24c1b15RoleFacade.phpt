<?php

namespace Test\Model\Facade;

use App\Model\Entity\Role;
use Kdyby\Doctrine\EntityDao;
use Nette\DI\Container;
use Tester\Assert;

$container = require __DIR__ . '/../../bootstrap.php';

/**
 * TEST: RoleFacade
 *
 * @testCase
 * @phpVersion 5.4
 */
class RoleFacadeTest extends BaseFacade
{

	/** @var EntityDao */
	private $roleDao;

	public function __construct(Container $container)
	{
		parent::__construct($container);
		$this->roleDao = $this->em->getDao(Role::getClassName());
	}

	public function testCreate()
	{
		$role = $this->roleFacade->create(Role::GUEST);
		Assert::type(Role::getClassName(), $role);
		Assert::same(Role::GUEST, $role->name);
		Assert::null($this->roleFacade->create(Role::GUEST));
	}

	public function testFinds()
	{
		$this->createAllRoles();

		$role = $this->roleFacade->findByName(Role::CANDIDATE);
		Assert::same(Role::CANDIDATE, $role->name);

		$roles = [Role::CANDIDATE, Role::COMPANY, Role::ADMIN];
		$lowers = [1 => Role::GUEST, Role::SIGNED, Role::CANDIDATE, Role::COMPANY];
		Assert::same($lowers, $this->roleFacade->findLowerRoles($roles));
		$lowers[] = Role::ADMIN;
		Assert::same($lowers, $this->roleFacade->findLowerRoles($roles, TRUE));
	}

	public function testIsUnique()
	{
		$this->roleFacade->create(Role::CANDIDATE);
		$this->roleDao->clear();
		Assert::false($this->roleFacade->isUnique(Role::CANDIDATE));
		Assert::true($this->roleFacade->isUnique(Role::GUEST));
	}

	public function testIsRegistrable()
	{
		$this->roleFacade->create(Role::CANDIDATE);
		$this->roleFacade->create(Role::COMPANY);
		$this->roleFacade->create(Role::ADMIN);
		$this->roleDao->clear();

		$modules = ['registrableRole' => TRUE];
		$settings = ['registrableRole' => ['roles' => [Role::CANDIDATE, Role::COMPANY]]];
		$this->defaultSettings->setModules($modules, $settings);

		Assert::true($this->roleFacade->isRegistrable(Role::CANDIDATE));
		Assert::true($this->roleFacade->isRegistrable(Role::COMPANY));
		Assert::false($this->roleFacade->isRegistrable(Role::ADMIN));
	}

	private function createAllRoles()
	{
		$this->roleFacade->create(Role::GUEST);
		$this->roleFacade->create(Role::SIGNED);
		$this->roleFacade->create(Role::CANDIDATE);
		$this->roleFacade->create(Role::COMPANY);
		$this->roleFacade->create(Role::ADMIN);
		$this->roleFacade->create(Role::SUPERADMIN);
		$this->roleDao->clear();
	}

}

$test = new RoleFacadeTest($container);
$test->run();
