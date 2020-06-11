<?php

namespace SyliusBot\Github\Model;

/**
 * @author Kamil Kokot <kamil.kokot@lakion.com>
 */
final class Branch implements BranchInterface
{
    /**
     * @var RepositoryInterface
     */
    private $repository;

    /**
     * @var string
     */
    private $name;

    /**
     * @param RepositoryInterface $repository
     * @param string $name
     */
    public function __construct(RepositoryInterface $repository, $name)
    {
        $this->repository = $repository;
        $this->name = $name;
    }

    /**
     * {@inheritdoc}
     */
    public function getRepository()
    {
        return $this->repository;
    }

    /**
     * {@inheritdoc}
     */
    public function getName()
    {
        return $this->name;
    }
}
