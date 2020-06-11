<?php

namespace LaraibaTest\Resource\Ayat\Repository;

use Laraiba\Resource\Ayat\Repository\AyatRepositoryFactory;

class AyatRepositoryFactoryTest extends \PHPUnit_Framework_TestCase
{
    public function testCreateAyatRepository()
    {
        $ayatRepositoryFactory = new AyatRepositoryFactory();

        $ayatRepository = $ayatRepositoryFactory->createAyatRepository();

        $this->assertInstanceOf('Laraiba\Resource\Ayat\Repository\AyatRepositoryInterface', $ayatRepository);

        $ayat = $ayatRepository->findOneById('112:2');
        $this->assertInstanceOf('Laraiba\Resource\Ayat\AyatInterface', $ayat);
    }
}
