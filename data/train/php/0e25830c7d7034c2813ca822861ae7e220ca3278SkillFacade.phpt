<?php

namespace Test\Model\Facade;

use Tester\Assert;

$container = require __DIR__ . '/../../../bootstrap.php';

/**
 * TEST: SkillFacade
 *
 * @testCase
 * @phpVersion 5.4
 */
class SkillFacadeTest extends BaseFacade
{

	protected function setUp()
	{
		parent::setUp();
		$this->importDbDataFromFile(__DIR__ . '/sql/skills.sql');
	}

	public function testGetTopCategories()
	{
		$topCategories = $this->skillFacade->getTopCategories();
		Assert::count(20, $topCategories);
	}

}

$test = new SkillFacadeTest($container);
$test->run();
