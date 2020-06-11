<?php
namespace Application\Service;

use ZfcRbac\Service\AuthorizationService;

trait AuthorizationServiceAwareTrait
{
    /**
     * @var \ZfcRbac\Service\AuthorizationService
     */
    protected $authorizationService;

    /**
     * @param \ZfcRbac\Service\AuthorizationService $authorizationService
     */
    public function setAuthorizationService(AuthorizationService $authorizationService)
    {
        $this->authorizationService = $authorizationService;
    }

    /**
     * @return \ZfcRbac\Service\AuthorizationService
     */
    public function getAuthorizationService()
    {
        return $this->authorizationService;
    }
}
