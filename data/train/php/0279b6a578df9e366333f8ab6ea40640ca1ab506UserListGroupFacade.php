<?php

namespace OpenOrchestra\UserAdminBundle\Facade;

use JMS\Serializer\Annotation as Serializer;
use OpenOrchestra\BaseApi\Facade\AbstractFacade;

/**
 * Class UserListGroupFacade
 */
class UserListGroupFacade extends AbstractFacade
{
    /**
     * @Serializer\Type("string")
     */
    public $username;

    /**
     * @Serializer\Type("string")
     */
    public $firstName;

    /**
     * @Serializer\Type("string")
     */
    public $lastName;

    /**
     * @Serializer\Type("string")
     */
    public $email;
}
