<?php

namespace App\Test\Model;

use App\Model\RepositoryInterface;
use App\Model\RepositoryManager;

class RepositoryManagerTest extends \PHPUnit_Framework_TestCase
{
    public function testRepositoryManager()
    {
        $repositoryDescriptor = [
            'repo' => [
                'path' => __DIR__ . '/repo/',
            ],
            'helper' => [
                'path' => 'dummy',
            ],
        ];

        $repositoryManager = new RepositoryManager($repositoryDescriptor);

        $repository = $repositoryManager->getRepository('repo');
        $this->assertInstanceOf(RepositoryInterface::class, $repository);
        $this->assertCount(1, $repository->getAll());

        try {
            $repositoryManager->getRepository('lalalalala');
            $this->fail('should have thrown exception for unregistered repository');
        } catch (\Exception $exception) { }
    }
}
