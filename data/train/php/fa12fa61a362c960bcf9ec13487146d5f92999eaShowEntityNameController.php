<?php

namespace Acme;

class ShowEntityNameController
{
    /**
     * @var EntityRepository
     */
    private $entityRepository;

    /**
     * @param EntityRepository $entityRepository
     */
    public function __construct(EntityRepository $entityRepository)
    {
        $this->entityRepository = $entityRepository;
    }

    /**
     * @param int $id
     *
     * @return Entity
     *
     * @throws \Exception
     */
    public function showEntityNameAction($id)
    {
        if ($entity = $this->entityRepository->find($id)) {
            return $entity->getName();
        }

        throw new \Exception();
    }
}
