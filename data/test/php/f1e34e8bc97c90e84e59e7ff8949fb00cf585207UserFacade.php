<?php

namespace App\Model\Facade;

use App\Extensions\Settings\SettingsStorage;
use App\Model\Entity\Address;
use App\Model\Entity\Registration;
use App\Model\Entity\Role;
use App\Model\Entity\User;
use App\Model\Facade\Traits\UserFacadeCreates;
use App\Model\Facade\Traits\UserFacadeDelete;
use App\Model\Facade\Traits\UserFacadeFinders;
use App\Model\Facade\Traits\UserFacadeGetters;
use App\Model\Facade\Traits\UserFacadeRecovery;
use App\Model\Facade\Traits\UserFacadeSetters;
use App\Model\Repository\RegistrationRepository;
use App\Model\Repository\UserRepository;
use h4kuna\Exchange\Exchange;
use Kdyby\Doctrine\EntityDao;
use Kdyby\Doctrine\EntityManager;
use Kdyby\Doctrine\EntityRepository;
use Kdyby\Translation\Translator;
use LogicException;
use Nette\Object;

class UserFacade extends Object
{

	use UserFacadeCreates;
	use UserFacadeDelete;
	use UserFacadeFinders;
	use UserFacadeGetters;
	use UserFacadeSetters;
	use UserFacadeRecovery;

	/** @var EntityManager @inject */
	public $em;
	
	/** @var SettingsStorage @inject */
	public $settings;
	
	/** @var Exchange @inject */
	public $exchange;
	
	/** @var Translator @inject */
	public $translator;
	
	/** @var OrderFacade @inject */
	public $orderFacade;
	
	/** @var SubscriberFacade @inject */
	public $subscriberFacade;

	/** @var UserRepository */
	private $userRepo;

	/** @var EntityRepository */
	private $addressRepo;

	/** @var RegistrationRepository */
	private $registrationRepo;

	/** @var EntityDao */
	private $roleDao;

	public function __construct(EntityManager $em)
	{
		$this->em = $em;
		$this->userRepo = $this->em->getRepository(User::getClassName());
		$this->addressRepo = $this->em->getRepository(Address::getClassName());
		$this->registrationRepo = $this->em->getRepository(Registration::getClassName());
		$this->roleDao = $this->em->getDao(Role::getClassName());
	}

	public function isUnique($mail)
	{
		return $this->findByMail($mail) === NULL;
	}
	
	public function recountBonus(User $user)
	{
		if ($user->isDealer()) {
			return $this;
		}
		$user->bonusCount = $this->orderFacade->getActualBonusCount($user);
		$this->userRepo->save($user);
		
		$this->setBonusGroup($user);
		return $this;
	}

}

class CantDeleteUserException extends LogicException
{

}
