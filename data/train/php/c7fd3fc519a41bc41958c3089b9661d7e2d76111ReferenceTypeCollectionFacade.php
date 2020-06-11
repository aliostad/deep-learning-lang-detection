<?php

namespace Itkg\ReferenceApiBundle\Facade;

use OpenOrchestra\ApiBundle\Facade\PaginateCollectionFacade;
use OpenOrchestra\BaseApi\Facade\FacadeInterface;
use JMS\Serializer\Annotation as Serializer;

/**
 * Class ReferenceTypeCollectionFacade
 */
class ReferenceTypeCollectionFacade extends PaginateCollectionFacade
{
    /**
     * @Serializer\Type("string")
     */
    public $collectionName = 'reference_types';

    /**
     * @Serializer\Type("array<Itkg\ReferenceApiBundle\Facade\ReferenceTypeFacade>")
     */
    protected $referenceTypes = array();

    /**
     * @param FacadeInterface|ReferenceTypeFacade $facade
     */
    public function addReferenceType(FacadeInterface $facade)
    {
        $this->referenceTypes[] = $facade;
    }
}
