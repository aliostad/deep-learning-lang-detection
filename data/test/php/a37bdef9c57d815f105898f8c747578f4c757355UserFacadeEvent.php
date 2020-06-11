<?php

namespace OpenOrchestra\UserAdminBundle\Event;

use OpenOrchestra\UserAdminBundle\Facade\UserFacade;
use OpenOrchestra\UserBundle\Model\UserInterface;
use Symfony\Component\EventDispatcher\Event;

/**
 * Class UserFacadeEvent
 */
class UserFacadeEvent extends Event
{
    protected $userFacade;
    protected $user;

    /**
     * @param UserFacade    $userFacade
     * @param UserInterface $user
     */
    public function __construct(UserFacade $userFacade, UserInterface $user)
    {
        $this->userFacade = $userFacade;
        $this->user = $user;
    }

    /**
     * @return UserFacade
     */
    public function getUserFacade()
    {
        return $this->userFacade;
    }

    /**
     * @return UserInterface
     */
    public function getUser()
    {
        return $this->user;
    }
}
