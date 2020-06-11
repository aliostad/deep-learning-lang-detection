<?php

use Orm\Repository;
use Orm\ArrayMapper;
use Orm\IRepository;
use Orm\IEntity;

/**
 * @property Repository_persist_recursion1_Entity $m1 {m:1 Repository_persist_recursion1_}
 * @property Orm\OneToMany $1m {1:m Repository_persist_recursion1_ m1}
 */
class Repository_persist_recursion1_Entity extends TestEntity
{
}

class Repository_persist_recursion1_Repository extends Repository
{
	protected $entityClassName = 'Repository_persist_recursion1_Entity';
}

class Repository_persist_recursion1_Mapper extends Repository_persist_cascade1_Mapper
{
}

/**
 * @property Orm\ManyToMany $mma {m:m Repository_persist_recursion2_ mmb mapped}
 * @property Orm\ManyToMany $mmb {m:m Repository_persist_recursion2_ mma}
 */
class Repository_persist_recursion2_Entity extends TestEntity
{
	protected function onAfterPersist(IRepository $repository)
	{
		parent::onAfterPersist($repository);
		$this->markAsChanged();
	}
}

class Repository_persist_recursion2_Repository extends Repository
{
	protected $entityClassName = 'Repository_persist_recursion2_Entity';
}

class Repository_persist_recursion2_Mapper extends Repository_persist_cascade3_Mapper
{
	public function persist(IEntity $entity)
	{
		$result = ArrayMapper::persist($entity);
		$this->dump[] = array($entity->mma->getInjectedValue(), $entity->mmb->getInjectedValue());
		return $result;
	}
}

/**
 * @property Repository_persist_recursion3_Entity $11 {1:1 Repository_persist_recursion3_Repository}
 */
class Repository_persist_recursion3_Entity extends TestEntity
{
}

/** @mapper TestsMapper */
class Repository_persist_recursion3_Repository extends Repository
{
	protected $entityClassName = 'Repository_persist_recursion3_Entity';
}

/**
 * @property Repository_persist_recursion5_Entity|NULL $11 {1:1 Repository_persist_recursion5_Repository}
 */
class Repository_persist_recursion4_Entity extends TestEntity
{
}

/** @mapper TestsMapper */
class Repository_persist_recursion4_Repository extends Repository
{
	protected $entityClassName = 'Repository_persist_recursion4_Entity';
}

/**
 * @property Repository_persist_recursion4_Entity $11 {1:1 Repository_persist_recursion4_Repository}
 */
class Repository_persist_recursion5_Entity extends TestEntity
{
}

/** @mapper TestsMapper */
class Repository_persist_recursion5_Repository extends Repository
{
	protected $entityClassName = 'Repository_persist_recursion5_Entity';
}



/** @property Repository_persist_recursion7_Entity $11 {1:1 Repository_persist_recursion7_Repository} */
class Repository_persist_recursion6_Entity extends TestEntity
{
}
/** @mapper TestsMapper */
class Repository_persist_recursion6_Repository extends Repository
{
	protected $entityClassName = 'Repository_persist_recursion6_Entity';
}

/** @property Repository_persist_recursion8_Entity $11 {1:1 Repository_persist_recursion8_Repository} */
class Repository_persist_recursion7_Entity extends TestEntity
{
}
/** @mapper TestsMapper */
class Repository_persist_recursion7_Repository extends Repository
{
	protected $entityClassName = 'Repository_persist_recursion7_Entity';
}

/** @property Repository_persist_recursion9_Entity $11 {1:1 Repository_persist_recursion9_Repository} */
class Repository_persist_recursion8_Entity extends TestEntity
{
}
/** @mapper TestsMapper */
class Repository_persist_recursion8_Repository extends Repository
{
	protected $entityClassName = 'Repository_persist_recursion8_Entity';
}
/** @property Repository_persist_recursion6_Entity|NULL $11 {1:1 Repository_persist_recursion6_Repository} */
class Repository_persist_recursion9_Entity extends TestEntity
{
}
/** @mapper TestsMapper */
class Repository_persist_recursion9_Repository extends Repository
{
	protected $entityClassName = 'Repository_persist_recursion9_Entity';
}
