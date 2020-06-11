<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\ApiController;
use App\Repositories\UsersRepository;

class UsersController extends ApiController
{
	/**
	 * The users repository instance.
	 * 
	 * @var UsersRepository
	 */
	private $usersRepository;
	
	/**
	 * UsersController.
	 * 
	 * @param UserRepository $usersRepository
	 */
	public function __construct(UsersRepository $usersRepository)
	{
		$this->usersRepository = $usersRepository;
	}
	
	/**
	 * Returns a listing of all users.
	 */
	public function index()
	{
		$users = $this->usersRepository->getAll();
		
		return $this->respondOk($users);
	}
}