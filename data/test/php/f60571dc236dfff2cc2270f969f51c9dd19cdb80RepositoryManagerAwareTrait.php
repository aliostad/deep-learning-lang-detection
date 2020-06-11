<?php
/**
 * Athene2 - Advanced Learning Resources Manager
 *
 * @author      Aeneas Rekkas (aeneas.rekkas@serlo.org)
 * @license     LGPL-3.0
 * @license     http://opensource.org/licenses/LGPL-3.0 The GNU Lesser General Public License, version 3.0
 * @link        https://github.com/serlo-org/athene2 for the canonical source repository
 */
namespace Versioning;

trait RepositoryManagerAwareTrait
{

    /**
     * The RepositoryManager
     *
     * @var RepositoryManagerInterface
     */
    protected $repositoryManager;

    /**
     * Gets the RepositoryManager
     *
     * @return RepositoryManagerInterface $repositoryManager
     */
    public function getRepositoryManager()
    {
        return $this->repositoryManager;
    }

    /**
     * Sets the RepositoryManager
     *
     * @param RepositoryManagerInterface $repositoryManager
     * @return self
     */
    public function setRepositoryManager(RepositoryManagerInterface $repositoryManager)
    {
        $this->repositoryManager = $repositoryManager;
        return $this;
    }
}
