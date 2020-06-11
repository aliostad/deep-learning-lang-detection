<?php

namespace Test\Model\Facade;

use App\Model\Entity\Company;
use App\Model\Entity\CompanyRole;
use App\Model\Entity\Role;
use App\Model\Entity\User;
use Tester\Assert;

$container = require __DIR__ . '/../../../bootstrap.php';

/**
 * TEST: CompanyFacade
 *
 * @testCase
 * @phpVersion 5.4
 */
class CompanyFacadeTest extends CompanyFacade
{

	public function testCreate()
	{
		$companyRole = new CompanyRole(CompanyRole::ADMIN);
		$this->em->persist($companyRole);
		$this->em->flush();

		$role = $this->roleFacade->findByName(Role::ADMIN);
		$user = $this->userFacade->create('user', 'user', $role);

		$company1 = new Company('company1');
		$company1->companyId = 'id123';
		$company1->mail = self::MAIL;
		$this->companyFacade->create($company1, $user);
		$company2 = $this->companyFacade->create('comapany2', $user);

		$permission1 = $this->companyFacade->findPermission($company1, $user);
		$permission2 = $this->companyFacade->findPermission($company2, $user);

		Assert::same($user->id, $permission1->user->id);
		Assert::same($user->id, $permission1->user->id);

		Assert::same($company1->id, $permission1->company->id);
		Assert::same($company2->id, $permission2->company->id);
	}

	public function testCreateRole()
	{
		Assert::same('new role', $this->companyFacade->createRole('new role')->name);
		Assert::null($this->companyFacade->createRole(CompanyRole::EDITOR));
	}

	public function testAddPermission()
	{
		$company = new Company('new company');
		$company->mail = self::MAIL;
		$this->em->persist($company);
		$this->em->flush();
		$user = new User('new.user@mail.com');
		$this->userRepo->save($user);
		$roleAdmin = $this->companyFacade->findRoleByName(CompanyRole::ADMIN);
		$roleManager = $this->companyFacade->findRoleByName(CompanyRole::MANAGER);
		$roleEditor = $this->companyFacade->findRoleByName(CompanyRole::EDITOR);

		Assert::null($this->companyFacade->addPermission($company, $user, []));
		$permission1 = $this->companyFacade->addPermission($company, $user, [$roleAdmin]);
		Assert::same($company->name, $permission1->company->name);
		Assert::same($user->mail, $permission1->user->mail);
		Assert::count(1, $permission1->roles);

		$permission2 = $this->companyFacade->addPermission($company, $user, [$roleAdmin, $roleManager, $roleEditor]);
		Assert::count(3, $permission2->roles);
	}

	public function testDelete()
	{
		$company = new Company('new company');
		$company->mail = self::MAIL;
		$this->em->persist($company);
		$this->em->flush();
		$this->companyDao->save($company);
		$user = new User('new.user@mail.com');
		$this->userRepo->save($user);

		$roleAdmin = $this->companyFacade->findRoleByName(CompanyRole::ADMIN);
		$roleManager = $this->companyFacade->findRoleByName(CompanyRole::MANAGER);

		$permission = $this->companyFacade->addPermission($company, $user, [$roleAdmin, $roleManager]);
		Assert::count(2, $permission->roles);
		Assert::count(1, $this->companyFacade->findPermissions($company));
		$this->companyFacade->clearPermissions($company);
		Assert::count(0, $this->companyFacade->findPermissions($company));
		Assert::count(6, $this->companyFacade->getCompaniesNames());

		$this->companyFacade->addPermission($company, $user, [$roleAdmin, $roleManager]);
		$this->companyFacade->delete($company);
		Assert::count(0, $this->companyFacade->findPermissions($company));
		Assert::count(5, $this->companyFacade->getCompaniesNames());
	}

}

$test = new CompanyFacadeTest($container);
$test->run();
