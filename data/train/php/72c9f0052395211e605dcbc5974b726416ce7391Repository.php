<?php

namespace Components\Database\Repository;

use Components\Database\Repository\Builder\RepositoryBuilder;
use Components\Database\Repository\RepositoryInterface\RepositoryInterface;

class Repository {

    /**
     * @var RepositoryBuilder
     */
    private $builder;

    private $name;

    /**
     * @var RepositoryInterface
     */
    private $entity;

    public function __construct(RepositoryInterface $entity, RepositoryBuilder $builder)
    {
        $this->entity = $entity;
        $this->builder = $builder;
        $this->name = $entity->getRepositoryName();
    }

    /**
     * @return mixed
     */
    public function getName()
    {
        return $this->name;
    }

    /**
     * @return mixed
     */
    public function getEntity()
    {
        return $this->entity;
    }

}