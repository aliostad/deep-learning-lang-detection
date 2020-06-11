<?php

namespace Asiel\CustomerBundle\DataFixtures\ORM;

use Asiel\CustomerBundle\Entity\PrivateCustomer;
use Doctrine\Common\DataFixtures\FixtureInterface;
use Doctrine\Common\Persistence\ObjectManager;

class LoadCustomerData implements FixtureInterface
{
    public function load(ObjectManager $manager)
    {
        $customer  = new PrivateCustomer();
        $customer->setFirstname('Jan');
        $customer->setLastname('de Tester');
        $customer->setDayOfBirth(new \DateTime('now'));
        $customer->setCitizenServiceNumber(1111);
        $customer->setEmail('test@example.com');
        $customer->setPhone(12345);
        $customer->setAddress('Buiten');
        $customer->setHouseNumber(1);
        $customer->setZipcode('4700AA');
        $customer->setMunicipality('As');
        $customer->setCountry('Netherlands');
        $customer->setBlacklisted(false);
        $customer->setMunicipality('Roosendaal');

        $manager->persist($customer);
        $manager->flush();
    }
}