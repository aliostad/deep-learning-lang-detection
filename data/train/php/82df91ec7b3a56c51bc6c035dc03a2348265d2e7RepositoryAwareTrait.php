<?php


namespace Mabes\Core\CommonBehaviour;

use Doctrine\ORM\EntityRepository;

/**
 * Class RepositoryAwareTrait
 * @package Mabes\Core\CommonBehaviour
 */
trait RepositoryAwareTrait
{
    /**
     * @var
     */
    private $repository;

    /**
     * @param EntityRepository $repository
     */
    public function setRepository(EntityRepository $repository)
    {
        $this->repository = $repository;
    }

    /**
     * @return EntityRepository
     */
    public function getRepository()
    {
        return $this->repository;
    }
}

// EOF
