<?php

namespace App\Services\Category\Repository;

use App\Services\Category\Repository;
use Illuminate\Contracts\Cache\Repository as CacheContract;

class Cache implements Repository
{
    /** @var Repository */
    private $repository;

    /** @var CacheContract */
    private $cache;

    public function __construct(Repository $repository, CacheContract $cache)
    {
        $this->repository = $repository;
        $this->cache = $cache;
    }

    public function findBySlug($slug)
    {
        return $this->cache->sear("category:slug:{$slug}", function() use ($slug) {
            return $this->repository->findBySlug($slug);
        });
    }
}
