<?php

namespace Detail\File\Repository;

use Countable;
use ArrayAccess;
use IteratorAggregate;

interface RepositoryCollectionInterface extends Countable, ArrayAccess, IteratorAggregate
{
    /**
     * Register a repository in the collection.
     *
     * @param RepositoryInterface $repository
     * @param string $name Name of the repository within the collection (alias)
     * @return void
     */
    public function add(RepositoryInterface $repository, $name = null);

    /**
     * Check if a repository is registered in the collection.
     *
     * @param string|RepositoryInterface $nameOrRepository
     * @return boolean
     */
    public function has($nameOrRepository);

    /**
     * Retrieve a repository from the collection.
     *
     * @param string|RepositoryInterface $nameOrRepository
     * @return RepositoryInterface
     */
    public function get($nameOrRepository);

    /**
     * Retrieve all repositories from the collection.
     *
     * @return RepositoryInterface[]
     */
    public function getAll();

    /**
     * Retrieve a new collection sub-collection.
     *
     * @param string|string[] $names
     * @return RepositoryCollectionInterface
     */
    public function getCollection($names);

    /**
     * Remove a repository from the collection.
     *
     * @param string|RepositoryInterface $nameOrRepository
     * @return void
     */
    public function remove($nameOrRepository);

    /**
     * Clear the collection (remove all repositories).
     *
     * @return void
     */
    public function removeAll();
}
