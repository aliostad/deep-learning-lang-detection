<?php

namespace Infrastructure\Persistence;

class FactoryRepositoryWriter
{
    /**
     * @var Repository
     */
    private $repository;

    /**
     * @var Factory
     */
    private $factory;

    public function __construct(
        Factory $factory,
        Repository $repository)
    {
        $this->factory = $factory;
        $this->repository = $repository;
    }

    /**
     * @return Entity
     */
    public function write($data = null)
    {
        $object = $this->factory->factor($data);
        $this->repository->save($object);

        return $object;
    }
}
