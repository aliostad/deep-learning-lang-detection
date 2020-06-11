<?php

namespace Gks\Works\Handlers;

use Gks\Works\Commands\RemoveWork as RemoveWorkCommand;
use Gks\Works\WorksRepository;

class RemoveWork
{
    /**
     * @var WorksRepository
     */
    private $repository;

    /**
     * RemoveWork constructor.
     *
     * @param WorksRepository $repository
     */
    public function __construct(WorksRepository $repository)
    {
        $this->repository = $repository;
    }

    /**
     * @param RemoveWorkCommand $command
     */
    public function handle(RemoveWorkCommand $command)
    {
        $this->repository->remove($command->getWorkId());
    }
}
