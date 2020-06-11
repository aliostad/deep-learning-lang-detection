<?php

namespace Sof\ApiBundle\Controller\CommonFunc;

use Sof\ApiBundle\Service\EntityService;

class CommonService
{
    //use C00CommonApiFunc;

    /**
     * @var EntityService
     */
    private $entityService;

    /**
     * @param $entityService
     */
    public function __construct($entityService)
    {
        $this->entityService = $entityService;
    }

    /**
     * @return \Sof\ApiBundle\Service\EntityService
     */
    public function getEntityService()
    {
        return $this->entityService;
    }
}
