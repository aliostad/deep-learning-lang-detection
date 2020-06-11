<?php

namespace RSchedule\Bundle\RScheduleBundle\Tests\Entity;

use Doctrine\ORM\EntityRepository;
use RSchedule\Bundle\RScheduleBundle\RScheduleBundle;
use RSchedule\Bundle\RScheduleBundle\Tests\RScheduleBundleTestCase;

/**
 * RepositoryRegisterTest
 *
 */
class RepositoryRegistryTest extends RScheduleBundleTestCase
{

    public function _getObj()
    {
        return $this->getBundle()->getRepositoryRegistry();
    }

    public function testGetUserRepository()
    {
        $bundle = $this->getBundle();
        $this->assertEquals(false, $bundle->isInstanceRepositoryRegistry());

        $repositoryRegistry = $bundle->getRepositoryRegistry();
        $this->assertEquals(true, $bundle->isInstanceRepositoryRegistry());

        $userRepository = $repositoryRegistry->getUserRepository();
        $expected = 'RSchedule\Bundle\RScheduleBundle\Entity\User\UserRepository';
        $this->assertInstanceOf($expected, $userRepository);

    }

}
