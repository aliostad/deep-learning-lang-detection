<?php
namespace Cli\Service;

use Zend\ServiceManager\ServiceLocatorAwareInterface,
    Zend\ServiceManager\ServiceLocatorInterface;

class MessageService implements ServiceLocatorAwareInterface
{
    public function setServiceLocator(ServiceLocatorInterface $serviceLocator)
    {
        $this->serviceLocator = $serviceLocator;
    }

    public function getServiceLocator()
    {
        return $this->serviceLocator;
    }

    public function import()
    {
        $import = $this->getServiceLocator()->get('ImportEmail');
        $import->import();
        $import = $this->getServiceLocator()->get('ImportFacebook');
        $import->import();
    }
}