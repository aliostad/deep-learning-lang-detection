<?php

require_once 'UserRepository.php';

/**
 * @property UserRepository $userRepository
 */
class UserService
{
    private $userRepository;

    /**
     * @return User[]
     */
    public function getActiveUsers()
    {
        $users = $this->userRepository->getUserList();
        $result = array();
        foreach ($users as $user) {
            if ($user->isActive) {
                $result[] = $user;
            }
        }
        return $result;
    }

    /**
     * @param UserRepository $userRepository
     */
    public function setUserRepository($userRepository)
    {
        $this->userRepository = $userRepository;
    }
}