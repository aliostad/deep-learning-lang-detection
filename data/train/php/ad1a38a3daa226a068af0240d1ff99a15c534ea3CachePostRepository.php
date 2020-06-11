<?php

namespace App\Repositories\Post;

use App\Post;
use App\Repositories\CacheRepository;

class CachePostRepository extends CacheRepository implements PostRepository
{
    /**
     * @param PostRepository $repository
     * @param Post           $model
     */
    public function __construct(PostRepository $repository, Post $model = null)
    {
        $this->repository = $repository;
        $this->model = $model ?: new Post();

        $this->tag = $this->model->getTable();
    }

    public function trashedCount()
    {
        return \Cache::tags('posts')->remember('posts.count.trashed', config('cache.time'), function () {
            return $this->repository->trashedCount();
        });
    }
}
