<?php

namespace OpenOrchestra\ApiBundle\Facade;

use JMS\Serializer\Annotation as Serializer;
use OpenOrchestra\BaseApi\Facade\AbstractFacade;

/**
 * Class ApiClientFacade
 */
class ApiClientFacade extends AbstractFacade
{
    /**
     * @Serializer\Type("string")
     */
    public $name;

    /**
     * @Serializer\Type("boolean")
     */
    public $trusted;

    /**
     * @Serializer\Type("string")
     */
    public $key;

    /**
     * @Serializer\Type("string")
     */
    public $secret;

    /**
     * @Serializer\Type("string")
     */
    public $roles;
}
