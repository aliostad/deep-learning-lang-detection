<?php

namespace Athene2\Versioning\Manager;

/**
 * Class RepositoryManagerAwareTrait
 *
 * @package Versioning\Manager
 * @author Aeneas Rekkas
 */
trait RepositoryManagerAwareTrait
{

    /**
     * The RepositoryManager
     *
     * @var RepositoryManagerInterface
     */
    protected $repositoryManager;

    /**
     * {@inheritDoc}
     */
    public function getRepositoryManager()
    {
        return $this->repositoryManager;
    }

    /**
     * {@inheritDoc}
     */
    public function setRepositoryManager(RepositoryManagerInterface $repositoryManager)
    {
        $this->repositoryManager = $repositoryManager;
    }
}
