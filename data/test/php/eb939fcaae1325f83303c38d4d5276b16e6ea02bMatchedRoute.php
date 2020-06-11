<?php
namespace PtgBase\View\Helper;
 
use Zend\ServiceManager\ServiceLocatorInterface;
 
use Zend\ServiceManager\ServiceLocatorAwareInterface;
use Zend\View\Helper\AbstractHelper;
 
class MatchedRoute extends AbstractHelper implements ServiceLocatorAwareInterface {
 
private $serviceLocator;
 
 public function __invoke() {
   $routeMatch = $this->serviceLocator->getServiceLocator()->get('Application')->getMvcEvent()->getRouteMatch();
   return $routeMatch->getMatchedRouteName();
 }
 
 /**
 * Set service locator
 *
 * @param ServiceLocatorInterface $serviceLocator
 */
 public function setServiceLocator(ServiceLocatorInterface $serviceLocator) {
   $this->serviceLocator = $serviceLocator;
 }
 
 /**
 * Get service locator
 *
 * @return ServiceLocatorInterface
 */
 public function getServiceLocator() {
   return $this->serviceLocator;
 }
}