<?php
/**
 * Created by PhpStorm.
 * User: krajewski
 * Date: 25.8.14
 * Time: 14:32
 * Data Access Layer Pattern
 */

namespace TaskManager\Repository;


use TaskManager\Enum\RepositoryTypeEnum;
use TaskManager\Environment;
use TaskManager\Model\AbstractModel;
use TaskManager\Repository\FileRepository\FileRepository;
use TaskManager\Repository\DatabaseRepository\DatabaseRepository;
use TaskManager\Repository\RepositoryInterface\RepositoryInterface;

/**
 * Class AbstractRepository
 * @package TaskManager\Repository
 */
abstract class AbstractRepository
{
	/**
	 * @var string
	 * Model Class Name
	 */
	private $model;

	/**
	 * @var string
	 * Value of RepositoryTypeEnum
	 */
	private $repositoryType;

	/**
	 * @var RepositoryInterface
	 */
	private $repository;

	/**
	 * @param string $model
	 */
	public function __construct($model)
	{
		$this->model = $model;

		$this->repositoryType = Environment::getRepositoryType();

		if ($this->repositoryType == RepositoryTypeEnum::DATABASE) {
			$this->repository = new DatabaseRepository($this->model);

		} else if ($this->repositoryType == RepositoryTypeEnum::FILE) {
			$this->repository = new FileRepository($this->model);
		}
	}

	/**
	 * @return AbstractModel[]
	 */
	public function readList()
	{
		return $this->repository->readList();
	}

	/**
	 * @param $id
	 * @return AbstractModel
	 */
	public function read($id)
	{
		return $this->repository->read($id);
	}

	/**
	 * @param AbstractModel $entity
	 * @return bool
	 */
	public function save(AbstractModel &$entity)
	{
		return $this->repository->save($entity);
	}

	/**
	 * @param $id
	 * @return bool
	 */
	public function delete($id)
	{
		return $this->repository->delete($id);
	}
}