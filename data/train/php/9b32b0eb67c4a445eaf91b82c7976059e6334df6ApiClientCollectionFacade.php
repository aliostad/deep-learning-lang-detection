<?php

namespace OpenOrchestra\ApiBundle\Facade;

use JMS\Serializer\Annotation as Serializer;
use OpenOrchestra\BaseApi\Facade\FacadeInterface;

/**
 * Class ApiClientCollectionFacade
 */
class ApiClientCollectionFacade extends PaginateCollectionFacade
{
    /**
     * @Serializer\Type("string")
     */
    public $collectionName = 'api_clients';

    /**
     * @Serializer\Type("array<OpenOrchestra\ApiBundle\Facade\ApiClientFacade>")
     */
    protected $apiClients = array();

    /**
     * @param FacadeInterface $facade
     */
    public function addApiClient(FacadeInterface $facade)
    {
        $this->apiClients[] = $facade;
    }
}
