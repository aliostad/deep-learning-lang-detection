<?php

namespace App\Events;

use Illuminate\Queue\SerializesModels;
use App\Models\Repository\Repository;

class RepositoryWasReleased extends Event
{
    use SerializesModels;

    /**
     * The repository.
     *
     * @var \App\Models\Repository\Repository
     */
    public $repository;

    /**
     * The tag.
     *
     * @var string
     */
    public $tag;

    /**
     * Create a new event instance.
     *
     * @param \App\Models\Repository\Repository $repository
     * @param string                                 $tag
     *
     * @return void
     */
    public function __construct(Repository $repository, $tag)
    {
        $this->repository = $repository;
        $this->tag = $tag;
    }
}
