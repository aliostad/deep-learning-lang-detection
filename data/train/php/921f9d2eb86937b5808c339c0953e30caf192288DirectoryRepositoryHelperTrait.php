<?php

namespace mikemeier\ConsoleGame\Command\Helper\Traits;

use mikemeier\ConsoleGame\Filesystem\Directory;
use mikemeier\ConsoleGame\Repository\DirectoryRepository;
use mikemeier\ConsoleGame\Command\Helper\RepositoryHelper;

trait DirectoryRepositoryHelperTrait
{
    /**
     * @return DirectoryRepository
     */
    public function getDirectoryRepository(){
        return $this->getRepositoryHelper()->getRepository(new Directory());
    }

    /**
     * @return RepositoryHelper
     */
    abstract protected function getRepositoryHelper();
}
