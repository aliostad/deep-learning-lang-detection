<?php


namespace Dothiv\BusinessBundle\Service\Traits;

use Dothiv\BusinessBundle\Service\UserServiceInterface;

trait UserServiceTrait
{
    /**
     * @var UserServiceInterface
     */
    protected $userService;

    /**
     * @param UserServiceInterface $userService
     *
     * @return self
     */
    public function setUserService(UserServiceInterface $userService)
    {
        $this->userService = $userService;
        return $this;
    }

    /**
     * @return UserServiceInterface
     */
    public function getUserService()
    {
        return $this->userService;
    }
}
