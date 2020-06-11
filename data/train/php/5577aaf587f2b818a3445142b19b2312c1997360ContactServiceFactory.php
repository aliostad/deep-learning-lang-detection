<?php
namespace Phonebook\Factory;

use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;
use Phonebook\Service\Contact;

/**
 *
 * @author julien
 *        
 */
class ContactServiceFactory implements FactoryInterface
{
    /**
     * Create service
     *
     * @param  ServiceLocatorInterface $serviceLocator
     * @return mixed
     */
    public function createService(ServiceLocatorInterface $serviceLocator)
    {
        $contactTable = $serviceLocator->get('Phonebook\Model\ContactTable');
        return new Contact($contactTable);
    }
}
