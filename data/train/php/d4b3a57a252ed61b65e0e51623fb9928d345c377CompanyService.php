<?php

namespace ITDoors\HaccpBundle\Services;
use ITDoors\HaccpBundle\Entity\CompanyRepository;
use Symfony\Component\DependencyInjection\Container;

/**
 * CompanyService class
 */
class CompanyService
{
    /**
     * @var CompanyRepository $repository
     */
    protected $repository;

    /**
     * @var Container $container
     */
    protected $container;

    /**
     * __construct()
     *
     * @param CompanyRepository $repository
     * @param Container         $container
     */
    public function __construct(CompanyRepository $repository, Container $container)
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
