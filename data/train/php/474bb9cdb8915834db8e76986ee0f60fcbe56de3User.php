<?php
/**
 * User.php
 *
 * @author  Jiří Šifalda <sifalda.jiri@gmail.com>
 * @date    02.03.13
 */

namespace Flame\CMS\UserBundle\Security;

class User extends \Nette\Security\User
{

	/** @var \Flame\CMS\UserBundle\Model\UserFacade */
	private $userFacade;

	/**
	 * @param \Flame\CMS\UserBundle\Model\UserFacade $userFacade
	 */
	public function injectUserFacade(\Flame\CMS\UserBundle\Model\UserFacade $userFacade)
	{
		$this->userFacade = $userFacade;
	}

	/**
	 * @return \Flame\CMS\UserBundle\Model\User
	 */
	public function getModel()
	{
		return $this->userFacade->getOne($this->getId());
	}

}
