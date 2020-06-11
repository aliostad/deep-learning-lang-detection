<?php

namespace RabbitHole\Interactor;

use RabbitHole\Repository\TaskRepository;
use RabbitHole\Task\TaskInterface;

class DispatchTask
{

    /**
     * @var TaskInterface
     */
    private $task;

    /**
     * @var TaskRepository
     */
    private $taskRepository;

    /**
     * @param TaskInterface $task
     * @param TaskRepository $taskRepository
     */
    public function __construct(TaskInterface $task, TaskRepository $taskRepository)
    {
        $this->task = $task;
        $this->taskRepository = $taskRepository;
    }

    /**
     * @return bool
     */
    public function execute()
    {
        return $this->taskRepository->dispatchTask($this->task);
    }
}
