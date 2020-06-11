<?php
/*
 *
 */

namespace RDF\GithubBotBundle\Entity\Repository;

use RDF\GithubBotBundle\Entity\Project;
use Doctrine\ORM\EntityRepository;

/**
 * @author Richard Fullmer <richard.fullmer@opensoftdev.com>
 */
class ProjectRepository extends EntityRepository
{

    /**
     * @param $username
     * @param $repository
     * @return null|Project
     */
    public function findOneByUsernameAndRepository($username, $repository)
    {
        return $this->findOneBy(array('username' => $username, 'repository' => $repository));
    }
}
