<?php

namespace Devhelp\UserAccount\UseCase\Query;

use Devhelp\UserAccount\Repository\RepositoryId;
use Devhelp\UserAccount\Repository\Repository;
use Devhelp\Github\Repository\RepositoryListInterface;
use Symfony\Component\Security\Core\User\UserInterface;

/**
 * @author <michal@devhelp.pl>
 */
class GetRemoteRepositoriesQuery
{
    /**
     * @var RepositoryListInterface
     */
    private $repositoryList;

    public function __construct(RepositoryListInterface $repositoryList)
    {
        $this->repositoryList = $repositoryList;
    }

    /**
     * @param UserInterface $user
     * @return Repository[]
     */
    public function getRemoteRepositories(UserInterface $user)
    {
        $results = [];
        foreach ($this->repositoryList->call() as $repository) {
            $results[] = new Repository(
                new RepositoryId($repository['id']),
                $repository['owner']['login'],
                $repository['name'],
                $repository['url'],
                $repository['full_name'],
                $repository['language'],
                $user
            );
        }

        return $results;
    }
}
