<?php

namespace Sentient\Data;

use Doctrine\ORM\EntityManagerInterface;

interface RepositoryManagerInterface {

	public function loadRepository(EntityManagerInterface $entityManager, $entityClass);

	/**
	 * @param ManagedRepositoryInterface $repository
	 * @return mixed
	 */
	public function registerRepository(ManagedRepositoryInterface $repository);

	/**
	 * Gets the repository class for the given name
	 *
	 * @param $name
	 * @return ManagedRepositoryInterface
	 * @throws \InvalidArgumentException if repository not found
	 */
	public function getRepository($name);

	/**
	 * Get an array of registered repositories
	 *
	 * @return array
	 */
	public function getRepositoryList();

	/**
	 * Check if a repository is registered
	 *
	 * @param string $name
	 * @return bool
	 */
	public function hasRepository($name);

	/**
	 * @param $entity
	 * @return ManagedRepositoryInterface
	 */
	public function getRepositoryForEntity($entity);

}