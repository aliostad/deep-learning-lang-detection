<?php

namespace Itkg\ReferenceApiBundle\Facade;

use OpenOrchestra\BaseApi\Facade\FacadeInterface;
use OpenOrchestra\BaseApi\Facade\AbstractFacade;
use JMS\Serializer\Annotation as Serializer;

/**
 * Class ReferenceTypeFacade
 */
class ReferenceTypeFacade extends AbstractFacade
{
    /**
     * @Serializer\Type("string")
     */
    public $referenceTypeId;

    /**
     * @Serializer\Type("string")
     */
    public $name;

    /**
     * @Serializer\Type("array<OpenOrchestra\ApiBundle\Facade\FieldTypeFacade>")
     */
    protected $fields = array();

    /**
     * @param FacadeInterface $facade
     */
    public function addField(FacadeInterface $facade)
    {
        $this->fields[] = $facade;
    }

    /**
     * @return array
     */
    public function getFields()
    {
        return $this->fields;
    }
}
