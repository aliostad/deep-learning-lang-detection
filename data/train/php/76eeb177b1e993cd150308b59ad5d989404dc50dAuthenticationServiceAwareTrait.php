<?php
namespace Common\Traits;

use Zend\Authentication\AuthenticationService;

trait AuthenticationServiceAwareTrait
{
    /**
     * @var AuthenticationService
     */
    protected $authenticationService;

    /**
     * @return AuthenticationService $authService
     */
    public function getAuthenticationService()
    {
        return $this->authenticationService;
    }

    /**
     * @param AuthenticationService $authService
     * @return self
     */
    public function setAuthenticationService(AuthenticationService $authService)
    {
        $this->authenticationService = $authService;
    }
}
