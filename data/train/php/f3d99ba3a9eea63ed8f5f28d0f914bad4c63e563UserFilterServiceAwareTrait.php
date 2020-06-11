<?php

namespace SampleService\Service\Feature;

use SampleService\Service\UserFilterService;
use Zend\Stdlib\Exception\LogicException;

trait UserFilterServiceAwareTrait {

    /**
     * @var UserFilterService
     */
    protected $userFilterService;

    public function setUserFilterService($userFilterService)
    {
        $this->userFilterService = $userFilterService;
    }

    public function getUserFilterService()
    {
        if(null === $this->userFilterService) {
            throw new LogicException("UserFilter service must be defined");
        }

        return $this->userFilterService;
    }

} 