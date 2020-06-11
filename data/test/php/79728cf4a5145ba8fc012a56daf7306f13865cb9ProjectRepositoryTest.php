<?php

namespace MarthaTest\Core\Persistence\Repository;

use Martha\Core\Persistence\Repository\Test\PHPUnit\AbstractRepositoryTest;

/**
 * Class ProjectRepositoryTest
 * @package MarthaTest\Core\Persistence\Repository
 */
class ProjectRepositoryTest extends AbstractRepositoryTest
{
    /**
     * @var string
     */
    protected $testEntity = '\Martha\Core\Domain\Entity\Project';

    /**
     * @var string
     */
    protected $testRepository = '\Martha\Core\Persistence\Repository\ProjectRepository';
}
