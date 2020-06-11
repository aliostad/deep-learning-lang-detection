<?php
	namespace Redmine\Service;
	
	use Zend\ServiceManager\ServiceLocatorAwareInterface;
	use Zend\ServiceManager\ServiceLocatorInterface;

	class ManageDatabaseAdapters implements ServiceLocatorAwareInterface{
		
		protected $serviceLocator;
		
		public function setServiceLocator(ServiceLocatorInterface $serviceLocator) {
			$this->serviceLocator = $serviceLocator;
		}
		// public function getServiceLocator() {
		// 	return $this->serviceLocator;
		// }
		
		public function getTableInstance($className, $adapterName){
                        $adapter = $this->getServiceLocator()->get($adapterName);      
			return $className($adapter);
		}		
	}
