<?php
namespace Admin\View\Helper;

use Zend\Authentication\AuthenticationService, Zend\View\Helper\AbstractHelper, Zend\View\Exception, Zend\ServiceManager\ServiceLocatorAwareInterface, Zend\ServiceMAnager\ServiceLocatorInterface;

class Identity extends AbstractHelper implements ServiceLocatorAwareInterface
{

    protected $authenticationService;

    protected $serviceLocator;

    public function getAuthenticationService()
    {
        if (! $this->authenticationService) {
            $this->authenticationService = $this->getServiceLocator()
                ->getServiceLocator()
                ->get('AuthService');
        }
        return $this->authenticationService;
    }

    public function setAuthenticationService(AuthenticationService $authenticationService)
    {
        $this->authenticationService = $authenticationService;
        return $this;
    }

    public function setServiceLocator(ServiceLocatorInterface $serviceLocator)
    {
        $this->serviceLocator = $serviceLocator;
        return $this;
    }

    public function getServiceLocator()
    {
        return $this->serviceLocator;
    }

    public function __invoke()
    {
        $service = $this->getAuthenticationService();
        if (! ($service instanceof AuthenticationService)) {
            throw new Exception\RuntimeException('No AuthenticationService instance provided');
        }
        if ($service->hasIdentity()) {
            return $service->getIdentity();
        }
        return null;
    }
}


