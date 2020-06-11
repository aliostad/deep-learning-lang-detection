<?php

namespace lbarulski\CacheTagsBundle\Invalidator;

use lbarulski\CacheTagsBundle\Service\Repository;
use lbarulski\CacheTagsBundle\Tag\CacheTagInterface;

class Invalidator implements InvalidatorInterface
{
	/**
	 * @var Repository
	 */
	private $repository;

	/**
	 * @param Repository $repository
	 */
	public function __construct(Repository $repository)
	{
		$this->repository = $repository;
	}

	/**
	 * @param CacheTagInterface $tag
	 */
	public function invalidate(CacheTagInterface $tag)
	{
		$this->repository->add($tag);
	}
}