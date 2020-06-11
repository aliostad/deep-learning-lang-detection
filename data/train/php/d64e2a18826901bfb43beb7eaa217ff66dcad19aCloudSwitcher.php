<?php

namespace Movent\ProfilerBundle\Services;

use Movent\ProfilerBundle\Repository\RepositoryInterface;

class CloudSwitcher
{
	protected $repository;
	protected $class;

	public function __construct(RepositoryInterface $repository = null, $class)
	{
		$this->repository = $repository;
		$this->class      = $class;
	}
	
	public function getProfile()
	{
		if ($this->repository) {
			$this->repository->setClass($this->class);
			return $this->repository->getData(); 
		}
		return null;
	}
	
    public function save()
    {
		$this->repository->save();
	}
}
