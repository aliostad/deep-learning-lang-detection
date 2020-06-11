<?php


namespace Aysheka\Git\Repository;


use Aysheka\Git\Repository;
use Aysheka\Git\Tests\Command\CommandTestCase;

class RepositoryTest extends CommandTestCase
{
    function testInit()
    {
        $repository = new Repository($this->getTemporaryDir(), $this->getGitInstance());

        $repository->init();

        $this->assertFileExists($repository->getWorkingDirectory() . DIRECTORY_SEPARATOR . '.git');
    }

    function testInitBareRepository()
    {
        $repository = new Repository($this->getTemporaryDir(), $this->getGitInstance());

        $repository->init(true);

        $this->assertFileExists($repository->getWorkingDirectory() . DIRECTORY_SEPARATOR . 'branches');
        $this->assertFileExists($repository->getWorkingDirectory() . DIRECTORY_SEPARATOR . 'config');
        $this->assertFileExists($repository->getWorkingDirectory() . DIRECTORY_SEPARATOR . 'description');
        $this->assertFileExists($repository->getWorkingDirectory() . DIRECTORY_SEPARATOR . 'HEAD');
        $this->assertFileExists($repository->getWorkingDirectory() . DIRECTORY_SEPARATOR . 'hooks');
        $this->assertFileExists($repository->getWorkingDirectory() . DIRECTORY_SEPARATOR . 'info');
        $this->assertFileExists($repository->getWorkingDirectory() . DIRECTORY_SEPARATOR . 'objects');
    }

    function testIsBare()
    {
        $repository = new Repository($this->getTemporaryDir(), $this->getGitInstance());

        $repository->init(true);

        $this->assertTrue($repository->isBare());
    }

    function testIsBareFalse()
    {
        $repository = new Repository($this->getTemporaryDir(), $this->getGitInstance());

        $repository->init();

        $this->assertFalse($repository->isBare());
    }

    function testIsGitRepository()
    {
        $repository = new Repository($this->getTemporaryDir(), $this->getGitInstance());

        $repository->init();

        $this->assertTrue($repository->isGitRepository());
    }

    function testIsGitRepositoryFailed()
    {
        $tmpDir = $this->getTemporaryDir() . DIRECTORY_SEPARATOR . time();
        mkdir($tmpDir, 0755, true);

        $repository = new Repository($tmpDir, $this->getGitInstance());

        $this->assertFalse($repository->isGitRepository());
    }

    function testDelete()
    {
        $repository = new Repository($this->getTemporaryDir(), $this->getGitInstance());

        $repository->init();

        $this->assertFileExists($repository->getWorkingDirectory());

        $repository->delete();

        $this->assertFileNotExists($repository->getWorkingDirectory());
    }
}
