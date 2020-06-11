<?php

namespace OpenTribes\Core\Test\Repository;


use OpenTribes\Core\Silex\Repository;
use OpenTribes\Core\Test\SilexApplicationTest;

class DirectionsRepositoryTest extends SilexApplicationTest{
    public function testCanFindAll(){
        $app = $this->getApplication();
        /**
         * @var Repository\ConfigDirectionsRepository $directionRepository
         */
        $directionRepository = $app[Repository::DIRECTION];
        $directions = $directionRepository->findAll();
        $this->assertEquals(8,count($directions));
    }
}