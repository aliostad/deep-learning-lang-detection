<?php

namespace ZFBrasil\RepositoryManager\Service;

use ZFBrasil\RepositoryManager\DTO\Repository;
use ZFBrasil\RepositoryManager\Model\SelectableRepository;

/**
 * @author  Fábio Carneiro <fahecs@gmail.com>
 * @license MIT
 */
interface RepositoryManagerInterface
{
    /**
     * Add a repository to the repository list
     *
     * @param Repository $repository
     *
     * @return SelectableRepository
     */
    public function addRepository(Repository $repository);

    /**
     * Gets the repository for a given id
     *
     * @param int $id
     *
     * @return SelectableRepository
     */
    public function getRepository($id);
}
