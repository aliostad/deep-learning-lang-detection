<?php
namespace Model\Factory;

use Zend\ServiceManager\FactoryInterface;
use Model\Facade\GroupFacade;
use Model\Facade\MessageFacade;

/**
 *
 * @author Jan Macháček
 *        
 */
class MessageFacadeFactory implements FactoryInterface
{
    /*
     * (non-PHPdoc)
     * @see \Zend\ServiceManager\FactoryInterface::createService()
     */
    public function createService(\Zend\ServiceManager\ServiceLocatorInterface $serviceLocator)
    {
        $em = $serviceLocator->get('Doctrine\ORM\EntityManager');
        $f = new MessageFacade($em);
        return $f;
    }
}

