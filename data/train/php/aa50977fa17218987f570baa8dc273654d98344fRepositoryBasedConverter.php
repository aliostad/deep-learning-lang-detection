<?php

namespace Branchology\Api\Converter;

use Branchology\Domain\Entity\AbstractUuidEntity;
use Branchology\Domain\Repository\EntityRepository;

/**
 * Class AbstractConverter
 * @package Branchology\Api\Converter
 */
class RepositoryBasedConverter
{
    /**
     * @var EntityRepository
     */
    private $repository;

    /**
     * @param EntityRepository $repository
     */
    public function __construct(EntityRepository $repository)
    {
        $this->repository = $repository;
    }

    /**
     * @param string $id
     * @return AbstractUuidEntity
     */
    public function convert($id)
    {
        return $this->repository->get($id);
    }
}
