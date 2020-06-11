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

interface RepositoryManagerAwareInterface
{

    /**
     * Set repository manager
     *
     * @param RepositoryManagerInterface $repositoryManager
     */
    public function setRepositoryManager(RepositoryManagerInterface $repositoryManager);

    /**
     * Returns the RepositoryManager
     *
     * @return RepositoryManagerInterface
     */
    public function getRepositoryManager();
}
