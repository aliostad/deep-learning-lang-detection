<?php

namespace Basic\Login;

use Basic\Login\Entity\User;
use Basic\Login\Repository\UserRepository;

class Authenticator
{
    protected $userRepository;

    public function __construct(UserRepository $repository)
    {
        $this->userRepository = $repository;
    }

    public function authenticate($username, $password)
    {
        $userRepository = $this->userRepository;
        $user = $userRepository->findByUsername($username);

        if (!$user instanceof User) {
            return false;
        }

        if (!password_verify($password, $user->getPassword())) {
            return false;
        }

        return $user;
    }
}
