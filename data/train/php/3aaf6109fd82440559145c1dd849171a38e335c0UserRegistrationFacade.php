<?php

class UserRegistrationFacade {
	/** @var UsersService */
	private $Service;

	/** @var UsersRepository */
	private $Repository;

	/**
	 * @param UsersService $Service
	 * @param UsersRepository $Repository
	 */
	public function __construct(UsersService $Service, UsersRepository $Repository) {
		$this->Service = $Service;
		$this->Repository = $Repository;
	}

	/**
	 * @param string $login
	 * @param string $password
	 */
	public function registerNewUser($login, $password) {
		$User = $this->Service->create($login, $password);
		$this->Repository->addNewUser($User);
	}
}
