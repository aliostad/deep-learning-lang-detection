<?php
namespace TreeLayoutStack\Factory;
class TemplatingServiceFactory implements \Zend\ServiceManager\FactoryInterface{
    /**
     * @see \Zend\ServiceManager\FactoryInterface::createService()
	 * @param \Zend\ServiceManager\ServiceLocatorInterface $oServiceLocator
	 * @return \TreeLayoutStack\TemplatingService
	 */
	public function createService(\Zend\ServiceManager\ServiceLocatorInterface $oServiceLocator){
        //Configure the Templating service
        $aConfiguration = $oServiceLocator->get('Config');
       	return \TreeLayoutStack\TemplatingService::factory(isset($aConfiguration['tree_layout_stack'])?$aConfiguration['tree_layout_stack']:array());
    }
}