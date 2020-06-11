<?php
namespace Core\View\Helper;

use Zend\View\Helper\AbstractHelper;
use Zend\ServiceManager\ServiceLocatorAwareInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

/**
*inclui a sessão nas views
*
*/
class Session extends AbstractHelper implements ServiceLocatorAwareInterface
{
/**
* 
*
* @param ServiceLocatorInterface $serviceLocator
* @return CustomHelper
*/
public function setServiceLocator(ServiceLocatorInterface $serviceLocator)
{
    $this->serviceLocator = $serviceLocator;
    return $this;
}
/**
* 
*
* @return \Zend\ServiceManager\ServiceLocatorInterface
*/
public function getServiceLocator()
{
    return $this->serviceLocator;
}
public function __invoke()
{
    $helperPluginManager = $this->getServiceLocator();
    $serviceManager = $helperPluginManager->getServiceLocator();
    return $serviceManager->get('Session');
}
}