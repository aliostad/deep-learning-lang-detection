<?php

namespace App\Events;

use Illuminate\Queue\SerializesModels;
use App\Models\Repository\Repository;

class ReleaseWasDeleted extends Event
{
    use SerializesModels;

    /**
     * The repository.
     *
     * @var \App\Models\Repository\Repository
     */
    public $repository;

    /**
     * Create a new event instance.
     *
     * @param \App\Models\Repository\Repository $repository
     *
     * @return void
     */
    public function __construct(Repository $repository)
    {
        $this->repository = $repository;
    }
}
