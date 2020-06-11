<?php

use Larabook\Statuses\StatusRepository;
use Larabook\Users\UserRepository;

class UsersController extends \BaseController {

    /**
     * @var
     */
    public $userRepository;
    /**
     * @var StatusRepository
     */
    private $statusRepo;

    /**
     * @param UserRepository $userRepository
     * @param StatusRepository $statusRepo
     */
    function __construct(UserRepository $userRepository, StatusRepository $statusRepo)
    {
        $this->userRepository = $userRepository;
        $this->statusRepo = $statusRepo;
    }

    /**
	 * Display a listing of the resource.
	 *
	 * @return Response
	 */
	public function users()
	{
        $users = $this->userRepository->getPaginated();

		return View::make('users.users')->withUsers($users);
	}

    public function profile($username)
    {
        $user = $this->userRepository->findByUsername($username);

        $statuses = $this->statusRepo->getStatusesOf($user);

        return View::make('users.profile')->withUser($user)
                                          ->withStatuses($statuses);
    }
}
