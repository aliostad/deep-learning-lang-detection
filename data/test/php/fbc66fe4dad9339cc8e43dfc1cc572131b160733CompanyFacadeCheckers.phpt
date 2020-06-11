<?php

namespace Test\Model\Facade;

use App\Model\Entity\Company;
use Tester\Assert;

$container = require __DIR__ . '/../../../bootstrap.php';

/**
 * TEST: CompanyFacade Checkers
 *
 * @testCase
 * @phpVersion 5.4
 */
class CompanyFacadeCheckersTest extends CompanyFacade
{

	public function testCheckers()
	{
		$company = new Company('my company');
		$company->companyId = 'myCompany';
		$company->mail = self::MAIL;
		$this->em->persist($company);
		$this->em->flush();

		Assert::false($this->companyFacade->isUniqueId($company->companyId));
		Assert::true($this->companyFacade->isUniqueId($company->companyId, $company->id));
		Assert::true($this->companyFacade->isUniqueId('uniqueId'));

		Assert::false($this->companyFacade->isUniqueName($company->name));
		Assert::true($this->companyFacade->isUniqueName($company->name, $company->id));
		Assert::true($this->companyFacade->isUniqueName('unique name'));
	}

}

$test = new CompanyFacadeCheckersTest($container);
$test->run();
