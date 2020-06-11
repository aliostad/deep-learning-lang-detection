<?php

namespace Athene2\Versioning\Manager;

/**
 * Interface RepositoryManagerAwareInterface
 *
 * @package Versioning\Manager
 * @author Aeneas Rekkas
 */
interface RepositoryManagerAwareInterface
{
    /**
     * Set repository manager
     *
     * @param RepositoryManagerInterface $repositoryManager
     */
    public function setRepositoryManager(RepositoryManagerInterface $repositoryManager);

    /**
     * Returns the RepositoryManager
     *
     * @return RepositoryManagerInterface
     */
    public function getRepositoryManager();
}
