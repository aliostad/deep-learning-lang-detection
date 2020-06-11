<?php

namespace Member\View\Helper;

use Zend\View\Helper\AbstractHelper;
use Zend\Authentication\AuthenticationService;
use Member\Service\MemberService;

class MemberData extends AbstractHelper
{

	/**
	 * @var AuthenticationService
	 */
	protected $authService;

	/**
	 * @var MemberService
	 */
	protected $memberService;

	/**
	 * __invoke
	 *
	 * @access public
	 */
	public function __invoke()
	{
		if ($this->getAuthService()->hasIdentity()) {
			$identity = $this->getAuthService()->getIdentity();
		} else {
			return false;
		}

		return $this->memberService->findByUid($identity);
	}

	/**
	 * Get memberService.
	 *
	 * @return MemberService
	 */
	public function getMemberService()
	{
		return $this->memberService;
	}

	/**
	 * Set memberService.
	 *
	 * @param MemberService $memberService
	 * @return \Member\View\Helper\MemberData
	 */
	public function setMemberService(MemberService $memberService)
	{
		$this->memberService = $memberService;
		return $this;
	}

	/**
	 * Get authService.
	 *
	 * @return AuthenticationService
	 */
	public function getAuthService()
	{
		return $this->authService;
	}

	/**
	 * Set authService.
	 *
	 * @param AuthenticationService $authService
	 * @return \Member\View\Helper\MemberData
	 */
	public function setAuthService(AuthenticationService $authService)
	{
		$this->authService = $authService;
		return $this;
	}

}
