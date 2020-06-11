<?php

namespace Terminal42\ActiveCollabApi\Model;

use Terminal42\ActiveCollabApi\Repository\AbstractRepository;

trait RepositoryAwareTrait
{
    /**
     * @var AbstractRepository
     */
    protected $repository;

    /**
     * Set repository
     * @param AbstractRepository $repository
     * @return $this
     */
    public function setRepository(AbstractRepository $repository)
    {
        $this->repository = $repository;

        return $this;
    }

    /**
     * Get repository
     * @return AbstractRepository
     */
    public function getRepository()
    {
        return $this->repository;
    }
} 