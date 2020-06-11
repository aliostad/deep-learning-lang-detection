<?php declare(strict_types=1);

namespace WikiBundle\Domain\Context;

class RepositoryProcessContext extends AbstractContext
{
    protected $repositoryPath = '';
    protected $repositoryName = '';
    protected $files = [];

    public function getRepositoryPath(): string
    {
        return $this->repositoryPath;
    }

    public function getRepositoryName(): string
    {
        return $this->repositoryName;
    }

    public function getFiles(): array
    {
        return $this->files;
    }

    public function setRepositoryPath(string $repositoryPath)
    {
        $this->repositoryPath = $repositoryPath;
        return $this;
    }

    public function setRepositoryName(string $repositoryName)
    {
        $this->repositoryName = $repositoryName;
        return $this;
    }

    public function setFiles(array $files)
    {
        $this->files = $files;
        return $this;
    }
}
