<?php namespace Dubaisi\Blogger\Dashboard\Sections;


use Dubaisi\Blogger\Repositories\UserRepository;
use Illuminate\Support\Facades\View;

class Users implements Section{


    /**
     * @var UserRepository
     */
    private $userRepository;

    /**
     * @param UserRepository $userRepository
     */
    function __construct(UserRepository $userRepository)
    {
        $this->userRepository = $userRepository;
    }

    public function getView(){

        $users = $this->userRepository->all();
        return View::make('admin.users.index', compact('users'));
    }
}