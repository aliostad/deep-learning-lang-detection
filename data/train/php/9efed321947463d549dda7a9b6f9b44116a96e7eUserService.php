<?php

namespace Services\User;

use Repositories\User\IUserRepository as IUserRepository;

class UserService implements IUserService
{
	protected $userRepository;
	public function __construct(IUserRepository $userRepository)
	{
		$this->userRepository = $userRepository;
	}

	public function all()
	{
		$users = $this->userRepository->all();

		return $users;
	}

	public function create(array $data)
	{
		$this->userRepository->create($data);

		return true;
	}

	public function get($email)
	{
		$user = $this->userRepository->get($email);

		return $user;
	}

	public function getLogin()
	{
		$user = $this->userRepository->getLogin();

		return $user;
	}
}