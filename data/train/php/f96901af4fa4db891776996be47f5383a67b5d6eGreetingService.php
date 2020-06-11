<?php

namespace Application\Service;

use Application\Repository\StaticGreetingRepository;

class GreetingService implements GreetingServiceInterface
{
    /**
     * @var StaticGreetingRepository
     */
    protected $repository;

    /**
     * @var StaticGreetingRepository $repository
     */
    public function __construct(StaticGreetingRepository $repository)
    {
        $this->repository = $repository;
    }

    /**
     * {@inheritDoc}
     */
    public function greet($name)
    {
        // this is an example method. It could perform operations such as discovering
        // the gender of the given name to customize the reply
        return $this->repository->getRandomGreeting() . ' ' . $name . '!';
    }
}