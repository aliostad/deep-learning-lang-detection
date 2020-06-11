<?php


namespace T4web\Crud\Service;

use T4webDomainInterface\ServiceInterface;
use T4webDomainInterface\Infrastructure\RepositoryInterface;

class ListService implements ServiceInterface
{
    /**
     * @var RepositoryInterface
     */
    private $repository;

    /**
     * @param RepositoryInterface $repository
     */
    public function __construct(RepositoryInterface $repository)
    {
        $this->repository = $repository;
    }

    public function handle($criteria, $changes)
    {
        if (empty($criteria['limit'])) {
            $criteria['limit'] = 20;
        }
        if (!isset($criteria['offset']) && empty($criteria['page'])) {
            $criteria['page'] = 1;
        }
        if (empty($criteria['order'])) {
            $criteria['order'] = 'id DESC';
        }

        $criteria = $this->repository->createCriteria($criteria);

        return $this->repository->findMany($criteria);
    }
}
