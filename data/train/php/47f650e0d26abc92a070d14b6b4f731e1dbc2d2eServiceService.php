<?php

namespace ITDoors\HaccpBundle\Services;
use ITDoors\HaccpBundle\Entity\ServiceRepository;
use Symfony\Component\DependencyInjection\Container;

/**
 * ServiceService class
 */
class ServiceService
{
    /**
     * @var ServiceRepository $repository
     */
    protected $repository;

    /**
     * @var Container $container
     */
    protected $container;

    /**
     * __construct()
     *
     * @param ServiceRepository $repository
     * @param Container         $container
     */
    public function __construct(ServiceRepository $repository, Container $container)
    {
        $this->repository = $repository;
        $this->container = $container;
    }

    /**
     * Returns all data for backup (mobile sync)
     *
     * @return array
     */
    public function getBackupData()
    {
        return $this->repository->getBackupData();
    }
}
