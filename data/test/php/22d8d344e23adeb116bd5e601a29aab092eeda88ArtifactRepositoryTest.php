<?php

namespace MarthaTest\Core\Persistence\Repository;

use Martha\Core\Persistence\Repository\Test\PHPUnit\AbstractRepositoryTest;

/**
 * Class ArtifactRepositoryTest
 * @package MarthaTest\Core\Persistence\Repository
 */
class ArtifactRepositoryTest extends AbstractRepositoryTest
{
    /**
     * @var string
     */
    protected $testEntity = '\Martha\Core\Domain\Entity\Artifact';

    /**
     * @var string
     */
    protected $testRepository = '\Martha\Core\Persistence\Repository\ArtifactRepository';
}
