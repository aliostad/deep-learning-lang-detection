<?php

namespace Detail\File\Repository;

trait RepositoryCollectionAwareTrait
{
    /**
     * @var RepositoryCollectionInterface
     */
    protected $fileRepositoryCollection;

    /**
     * @return RepositoryCollectionInterface
     */
    public function getFileRepositoryCollection()
    {
        return $this->fileRepositoryCollection;
    }

    /**
     * @param RepositoryCollectionInterface $fileRepositoryCollection
     */
    public function setFileRepositoryCollection(RepositoryCollectionInterface $fileRepositoryCollection)
    {
        $this->fileRepositoryCollection = $fileRepositoryCollection;
    }
}
