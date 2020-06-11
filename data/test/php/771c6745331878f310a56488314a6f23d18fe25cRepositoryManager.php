<?php

namespace Portal\Bundle\GithubBundle\Entity;

use Sonata\CoreBundle\Model\BaseEntityManager;

/**
 * Class RepositoryManager.
 *
 * @author  Quentin Somazzi <qsomazzi@gmail.com>
 */
class RepositoryManager extends BaseEntityManager
{
    /**
     * @param array $repositories
     */
    public function addRepositories(array $repositories)
    {
        foreach ($repositories as $repository) {
            if (!$repositoryEntity = $this->find($repository['id'])) {
                $repositoryEntity = new Repository();
                $repositoryEntity->setId($repository['id']);
            }

            $repositoryEntity->setName($repository['name']);
            $repositoryEntity->setDescription($repository['description']);
            $repositoryEntity->setPublic(!$repository['private']);
            $repositoryEntity->setLanguage($repository['language']);
            $repositoryEntity->setFork($repository['fork']);

            $this->save($repositoryEntity, false);
        }

        $this->getObjectManager()->flush();
    }
}
