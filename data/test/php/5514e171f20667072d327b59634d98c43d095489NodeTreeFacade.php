<?php

namespace OpenOrchestra\ApiBundle\Facade;

use OpenOrchestra\BaseApi\Facade\FacadeInterface;
use JMS\Serializer\Annotation as Serializer;
use OpenOrchestra\BaseApi\Facade\AbstractFacade;

/**
 * Class NodeTreeFacade
 */
class NodeTreeFacade extends AbstractFacade
{
    /**
     * @Serializer\Type("string")
     */
    public $collectionName = 'children';

    /**
     * @Serializer\Type("OpenOrchestra\ApiBundle\Facade\NodeFacade")
     */
    public $node;

    /**
     * @Serializer\Type("array<OpenOrchestra\ApiBundle\Facade\NodeTreeFacade>")
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
