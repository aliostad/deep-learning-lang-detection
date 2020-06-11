<?php

namespace OpenOrchestra\MediaAdminBundle\Facade;

use JMS\Serializer\Annotation as Serializer;
use OpenOrchestra\BaseApi\Facade\AbstractFacade;
use OpenOrchestra\BaseApi\Facade\FacadeInterface;

/**
 * Class MediaTypeCollectionFacade
 */
class MediaTypeCollectionFacade extends AbstractFacade
{
    /**
     * @Serializer\Type("string")
     */
    public $collectionName = 'mediaTypes';

    /**
     * @Serializer\Type("array<OpenOrchestra\MediaAdminBundle\Facade\MediaTypeFacade>")
     */
    protected $mediaTypes = array();

    /**
     * @param FacadeInterface $facade
     */
    public function addMediaType(FacadeInterface $facade)
    {
        if (!in_array($facade, $this->mediaTypes)) {
            $this->mediaTypes[] = $facade;
        }
    }
}
