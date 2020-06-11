<?php
namespace kinncj\Forker\Service;

use kinncj\Forker\Repository\RepositoryInterface;
use Github\Exception\RuntimeException as GithubRuntimeException;

class CollectionForkService implements ForkServiceInterface
{
    protected $repository;

    /**
     *
     * @param \kinncj\Forker\Repository\RepositoryInterface $repository
     */
    public function __construct(RepositoryInterface $repository)
    {
        $this->repository = $repository;
    }

    /**
     * (non-PHPdoc)
     * @see \kinncj\Forker\Service\ForkServiceInterface::fork()
     */
    public function fork()
    {
        $repositoryList       = $this->getRepositoryList();
        $forkedRepositoryList = array("success" => array(), "error" => array());

        foreach ($repositoryList as $id => $repository) {
            $repositoryName = $repository['name'];
            try {
                $forkResponse = $this->repository->fork($repositoryName);
                $forkedRepositoryList['success'][$repositoryName] = $forkResponse;
            } catch (GithubRuntimeException $exception) {
                $forkedRepositoryList['error'][$repositoryName] = $exception;
            }
        }

        return $forkedRepositoryList;
    }

    /**
     *
     * @return array
     */
    protected function getRepositoryList()
    {
        return $this->repository->findAll();
    }
}
