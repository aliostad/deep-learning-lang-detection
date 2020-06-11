<?php

namespace OpenOrchestra\MediaAdminBundle\Facade;

use OpenOrchestra\BaseApi\Facade\AbstractFacade;
use JMS\Serializer\Annotation as Serializer;
use OpenOrchestra\BaseApi\Facade\FacadeInterface;

/**
 * Class FolderTreeFacade
 */
class FolderTreeFacade extends AbstractFacade
{
    /**
     * @Serializer\Type("string")
     */
    public $collectionName = 'children';

    /**
     * @Serializer\Type("OpenOrchestra\MediaAdminBundle\Facade\FolderFacade")
     */
    public $folder;

    /**
     * @Serializer\Type("array<OpenOrchestra\MediaAdminBundle\Facade\FolderTreeFacade>")
     */
    protected $children = array();

    /**
     * @param FacadeInterface $facade
     */
    public function addChild(FacadeInterface $facade)
    {
        $this->children[] = $facade;
    }

    /**
     * @return array
     */
    public function getChildren()
    {
        return $this->children;
    }
}
