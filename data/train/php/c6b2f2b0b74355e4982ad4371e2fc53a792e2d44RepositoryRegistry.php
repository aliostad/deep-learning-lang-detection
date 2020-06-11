<?php

namespace Devhelp\UserAccount\Repository;

use Symfony\Component\Security\Core\User\UserInterface;

/**
 * @author <michal@devhelp.pl>
 */
interface RepositoryRegistry
{
    /**
     * @param RepositoryId $id
     * @return Repository
     */
    public function find(RepositoryId $id);

    /**
     * @param Repository $repository
     * @return Repository
     */
    public function add(Repository $repository);

    /**
     * @param UserInterface $user
     * @return Repository[]
     */
    public function getForUser(UserInterface $user);
}
