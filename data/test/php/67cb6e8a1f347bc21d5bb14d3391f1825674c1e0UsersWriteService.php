<?php

namespace Users;

class UsersWriteService
{
    /**
     * @var \Users\UserRepository
     */
    private $userRepository;

    /**
     * @param \Users\UserRepository $userRepository
     */
    public function __construct(UserRepository $userRepository)
    {
        $this->userRepository = $userRepository;
    }

    /**
     * @param array $data
     *
     * @return string
     */
    public function createUser(array $data)
    {
        $user = User::create($data);
        $this->userRepository->persist($user);

        return $user->getID();
    }
}
