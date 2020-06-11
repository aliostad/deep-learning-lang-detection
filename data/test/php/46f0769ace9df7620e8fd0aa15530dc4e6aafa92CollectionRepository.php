<?php declare(strict_types=1);

namespace MetadataCollectionsBundle\Repository\SharedPublic;

use MetadataCollectionsBundle\Collection\FilesCollection;
use MetadataCollectionsBundle\Repository\CollectionRepository as Repository;

class CollectionRepository
{
    /**
     * @var string $projectName
     */
    protected $projectName;

    /**
     * @var Repository $repository
     */
    protected $repository;

    public function __construct(string $projectName, Repository $repository)
    {
        $this->projectName = $projectName;
        $this->repository  = $repository;
    }

    /**
     * @param string $collectionName
     * @return FilesCollection
     */
    public function query(string $collectionName): FilesCollection
    {
        return $this->repository->getCollection($this->projectName, $collectionName);
    }
}
