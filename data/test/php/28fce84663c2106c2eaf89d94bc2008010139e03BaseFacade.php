<?php

namespace Test\Model\Facade;

use App\Extensions\Settings\Model\Storage\DefaultSettingsStorage;
use App\Model\Facade\CompanyFacade;
use App\Model\Facade\CvFacade;
use App\Model\Facade\JobFacade;
use App\Model\Facade\RoleFacade;
use App\Model\Facade\SkillFacade;
use App\Model\Facade\UserFacade;
use Test\DbTestCase;

abstract class BaseFacade extends DbTestCase
{

	/** @var RoleFacade @inject */
	public $roleFacade;

	/** @var UserFacade @inject */
	public $userFacade;

	/** @var CompanyFacade @inject */
	public $companyFacade;

	/** @var JobFacade @inject */
	public $jobFacade;

	/** @var CvFacade @inject */
	public $cvFacade;

	/** @var SkillFacade @inject */
	public $skillFacade;

	/** @var DefaultSettingsStorage @inject */
	public $defaultSettings;

	protected function setUp()
	{
		parent::setUp();
		$this->updateSchema();
	}

	protected function tearDown()
	{
		$this->dropSchema();
		parent::tearDown();
	}

}
