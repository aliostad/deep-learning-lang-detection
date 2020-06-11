<?php

namespace OpenOrchestra\UserAdminBundle\Facade;

use JMS\Serializer\Annotation as Serializer;
use OpenOrchestra\ApiBundle\Facade\PaginateCollectionFacade;
use OpenOrchestra\BaseApi\Facade\FacadeInterface;

/**
 * Class UserListGroupCollectionFacade
 */
class UserListGroupCollectionFacade extends PaginateCollectionFacade
{
    /**
     * @Serializer\Type("string")
     */
    public $collectionName = 'users';

    /**
     * @Serializer\Type("array<OpenOrchestra\UserAdminBundle\Facade\UserListGroupFacade>")
     */
    protected $users = array();

    /**
     * @param FacadeInterface $facade
     */
    public function addUser(FacadeInterface $facade)
    {
        $this->users[] = $facade;
    }
}
