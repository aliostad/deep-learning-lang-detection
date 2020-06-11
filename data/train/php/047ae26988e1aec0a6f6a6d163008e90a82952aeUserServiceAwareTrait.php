<?php

namespace ZenDesk\Service\Feature;

use Zend\Stdlib\Exception\LogicException;

use ZenDesk\Service\UserService;

trait UserServiceAwareTrait
{
    /**
     * @var UserService
     */
    protected $userService;

    /**
     * @param UserService $userService
     */
    public function setUserService(UserService $userService)
    {
        $this->userService = $userService;
    }

    /**
     * @return UserService
     * @throws \Zend\Stdlib\Exception\LogicException
     */
    public function getUserService()
    {
        if (null === $this->userService) {
            throw new LogicException('User service must be defined');
        }

        return $this->userService;
    }
}
