<?php

namespace OpenOrchestra\ApiBundle\Facade;

use JMS\Serializer\Annotation as Serializer;
use OpenOrchestra\BaseApi\Facade\Traits\BaseFacade;
use OpenOrchestra\BaseApi\Facade\Traits\TimestampableFacade;
use OpenOrchestra\BaseApi\Facade\FacadeInterface;

/**
 * Class DeletedFacade
 */
abstract class DeletedFacade implements FacadeInterface
{
    use TimestampableFacade;
    use BaseFacade;

    /**
     * @Serializer\Type("boolean")
     */
    public $deleted;

    /**
     * @Serializer\Type("string")
     */
    public $name;
}
