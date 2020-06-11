<?php

namespace OpenOrchestra\MediaAdminBundle\Facade;

use OpenOrchestra\BaseApi\Facade\AbstractFacade;
use JMS\Serializer\Annotation as Serializer;
use OpenOrchestra\BaseApi\Facade\Traits\TimestampableFacade;

/**
 * Class FolderFacade
 */
class FolderFacade extends AbstractFacade
{
    use TimestampableFacade;

    /**
     * @Serializer\Type("string")
     */
    public $folderId;

    /**
     * @Serializer\Type("string")
     */
    public $name;

    /**
     * @Serializer\Type("string")
     */
    public $type;

    /**
     * @Serializer\Type("string")
     */
    public $parentId;

    /**
     * @Serializer\Type("string")
     */
    public $siteId;
}
