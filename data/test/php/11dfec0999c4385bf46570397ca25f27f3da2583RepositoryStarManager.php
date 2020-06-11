<?php

namespace AppBundle\Manager;

use AppBundle\Entity\Repository;
use AppBundle\Entity\RepositoryStar;
use AppBundle\Entity\User;
use Doctrine\Common\Persistence\ObjectManager;

class RepositoryStarManager
{
    /** @var ObjectManager */
    protected $om;

    public function __construct(ObjectManager $om)
    {
        $this->om = $om;
    }

    protected function getRepository()
    {
        return $this->om->getRepository('AppBundle:RepositoryStar');
    }

    public function isStarredByUser(Repository $repository, User $user)
    {
        $repositoryStar = $this->getRepository()->findOneByRepositoryAndUser($repository, $user);

        return null !== $repositoryStar;
    }

    public function star(Repository $repository, User $user)
    {
        $repositoryStar = RepositoryStar::create($repository, $user);

        $this->om->persist($repositoryStar);
        $this->om->flush();
    }

    public function unstar(Repository $repository, User $user)
    {
        $repositoryStar = $this->getRepository()->findOneByRepositoryAndUser($repository, $user);

        $this->om->remove($repositoryStar);
        $this->om->flush();
    }
}
