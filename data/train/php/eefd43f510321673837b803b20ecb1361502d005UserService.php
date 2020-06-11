<?php namespace Services;

use Repositories\UserRepositoryInterface as UserRepository;
use Services\UserServiceInterface;

class UserService extends AbstractRepositoryService implements UserServiceInterface
{
    protected $errors;
    protected $userRepository;

    public function __construct(UserRepository $userRepository)
    {
        $this->userRepository = $this->setRepository($userRepository);
    }

    public function getActiveUsers()
    {
        return $this->userRepository->getManyBy("active", "=", true)->lists("name", "id");
    }
}
