<?php
// src/XarismaBundle/DataFixtures/ORM/LoadCustomerData.php

namespace XarismaBundle\DataFixtures\ORM;

use Doctrine\Common\DataFixtures\AbstractFixture;
use Doctrine\Common\DataFixtures\OrderedFixtureInterface;
use Doctrine\Common\Persistence\ObjectManager;
use XarismaBundle\Entity\Customer;

class LoadCustomerData extends AbstractFixture implements OrderedFixtureInterface
{
    /**
     * {@inheritDoc}
     */
    public function getOrder()
    {
        return 3;
    }
    
    public function load(ObjectManager $manager)
    {
        $customer = new Customer();
        $customer->setCustomernumber(12975);
        $customer->setAccountname('Church On Wheels');
        $customer->setDeleted(0);
        $manager->persist($customer);
        
        $customer = new Customer();
        $customer->setCustomernumber(10719);
        $customer->setAccountname('Tidmore Flags');
        $customer->setDeleted(0);
        $manager->persist($customer);
        
        $customer = new Customer();
        $customer->setCustomernumber(12758);
        $customer->setAccountname('Americanflagstore.com INC');
        $customer->setDeleted(0);
        $manager->persist($customer);
        
        $customer = new Customer();
        $customer->setCustomernumber(13276);
        $customer->setAccountname('Flutter Flag Source');
        $customer->setDeleted(0);
        $manager->persist($customer);
        
        $customer = new Customer();
        $customer->setCustomernumber(13884);
        $customer->setAccountname('Carrot-Top Industries, Inc.');
        $customer->setDeleted(0);
        $manager->persist($customer);
        
        $customer = new Customer();
        $customer->setCustomernumber(11157);
        $customer->setAccountname('Oates Flag Co. Inc.');
        $customer->setDeleted(0);
        $manager->persist($customer);
        
        $customer = new Customer();
        $customer->setCustomernumber(14584);
        $customer->setAccountname('US Flag Supply');
        $customer->setDeleted(0);
        $manager->persist($customer);
        
        $manager->flush();
    }
}