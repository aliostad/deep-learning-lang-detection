<?php

use Orm\RepositoryContainer;
use Orm\IRepository;

class Repository_flush_Model extends RepositoryContainer
{
	public $count = 0;
	public function flush(IRepository $checkRepository = NULL)
	{
		$this->count++;
		parent::flush($checkRepository);
	}
}

class Repository_flush_Repository extends TestsRepository
{
}

class Repository_flush_Mapper extends TestsMapper
{
	public $count = 0;
	public function flush()
	{
		$this->count++;
		return parent::flush();
	}
}

class Repository_flush2_Repository extends TestsRepository
{
}

class Repository_flush2_Mapper extends Repository_flush_Mapper
{
}
