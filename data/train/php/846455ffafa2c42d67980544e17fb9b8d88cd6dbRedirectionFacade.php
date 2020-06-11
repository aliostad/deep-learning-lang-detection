<?php

namespace OpenOrchestra\ApiBundle\Facade;

use JMS\Serializer\Annotation as Serializer;
use OpenOrchestra\BaseApi\Facade\AbstractFacade;

/**
 * Class RedirectionFacade
 */
class RedirectionFacade extends AbstractFacade
{
    /**
     * @Serializer\Type("string")
     */
    public $siteName;

    /**
     * @Serializer\Type("string")
     */
    public $routePattern;

    /**
     * @Serializer\Type("string")
     */
    public $locale;

    /**
     * @Serializer\Type("string")
     */
    public $redirection;

    /**
     * @Serializer\Type("boolean")
     */
    public $permanent;
}
