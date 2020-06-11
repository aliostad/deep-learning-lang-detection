<?php
class TasksService {
	private $context;
	private $repository;

	public function __construct(\Rokko\App $context, IItasksRepository $repository = null) {
		$this->context = $context;

		if ($repository == null) {
			$this->repository = new TasksRepository($context);
		}
	}

	public function setRepository(IItasksRepository $repository) {
		$this->repository = $repository;
	}

	public function getTasks() {
		return $this->repository->getTasks();
	}

	public function saveTask($task) {
		return $this->repository->saveTask($task);
	}

	public function deleteTask($id) {
		return $this->repository->deleteTask($id);
	}
}
