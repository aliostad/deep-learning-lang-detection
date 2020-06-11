<?php

namespace App\Http\Controllers;

use \Illuminate\Http\Request;
use \App\Repositories\Users\IUsersRepository;
use \App\Repositories\Administrators\IAdministratorsRepository;

/**
 * Class responsible for the requests
 * Regarding the administrators.
 */
class AdministratorsController extends Controller
{
    // TODO: Add a middleware

    /**
     * @var IUsersRepository $usersRepository
     */
    protected $usersRepository;

    /**
     * @var IAdministratorsRepository $administratorsRepository
     */
    protected $administratorsRepository;

    /**
     * Constructor
     *
     * @param IUsersRepository
     * @param IAdministratorsRepository
     */
    public function __construct(
        IUsersRepository $usersRepository,
        IAdministratorsRepository $administratorsRepository
    ) {
        $this->usersRepository = $usersRepository;
        $this->administratorsRepository = $administratorsRepository;
    }

    /**
     * Registers a new admin into the system.
     *
     * @param Request $request
     *
     * @return Response
     */
    public function registerAdministrator(Request $request)
    {
        $data = $request->all();

        // TODO: Validate the data.

        $user = $this->usersRepository->addUser(
            $data['email'],
            $data['name'],
            $data['password']
        );
        $admin = $this->administratorsRepository->addAdministrator(
            $user,
            $user->name // TODO: Add a default nickname.
        );
        return ['administrator' => $admin->toArray()];
    }
}

