<?php


namespace Avent\Core\Repository;

use Doctrine\ORM\EntityRepository;

/**
 * Class RepositoryAwareTrait
 * @package Avent\Core\Repository
 */
trait RepositoryAwareTrait
{
    /**
     * @var EntityRepository
     */
    protected $repository;

    /**
     * {@inheritdoc}
     */
    public function getRepository()
    {
        return $this->repository;
    }

    /**
     * {@inheritdoc}
     */
    public function setRepository(EntityRepository $repository)
    {
        $this->repository = $repository;
    }
}

// EOF
