<?php

namespace Itkg\ReferenceApiBundle\Facade;

use OpenOrchestra\BaseApi\Facade\FacadeInterface;
use OpenOrchestra\ApiBundle\Facade\PaginateCollectionFacade;
use JMS\Serializer\Annotation as Serializer;

/**
 * Class ReferenceCollectionFacade
 */
class ReferenceCollectionFacade extends PaginateCollectionFacade
{
    /**
     * @Serializer\Type("string")
     */
    public $collectionName = 'references';

    /**
     * @Serializer\Type("array<Itkg\ReferenceApiBundle\Facade\ReferenceFacade>")
     */
    protected $references = array();

    /**
     * @param FacadeInterface $facade
     */
    public function addReference(FacadeInterface $facade)
    {
        $this->references[] = $facade;
    }

    /**
     * @return FacadeInterface[]
     */
    public function getReferences()
    {
        return $this->references;
    }
}
