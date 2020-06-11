<?php

namespace Zds\Builder;

use Zds\Repository\AbstractRepository;
use Zds\Specification\SpecificationInterface;

abstract class AbstractBuilder implements BuilderInterface
{
    /**
     * the repository
     * @var \Zds\Repository\AbstractRepository
     */
    protected $repository;

    protected $on;

    protected $with = [];

    public function __construct(AbstractRepository $repository)
    {
        $this->repository = $repository;
    }

    public function on(SpecificationInterface $specification)
    {
        $this->on = $specification;
        return $this;
    }
}
