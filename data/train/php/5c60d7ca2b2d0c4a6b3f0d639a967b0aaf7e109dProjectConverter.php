<?php

namespace FHJ\Converters;

use FHJ\Repositories\ProjectDbRepositoryInterface;

/**
 * ProjectConverter
 * @package FHJ\Converters
 */
class ProjectConverter extends AbstractConverter {

	/**
	 * @var ProjectDbRepositoryInterface
	 */
	private $repository;

	public function __construct(ProjectDbRepositoryInterface $userRepository) {
		$this->repository = $userRepository;
	}

	public function convert($value) {
		$repository = $this->repository;

		return $this->handleConversion($value, function($theProjectId) use ($repository) {
			return $repository->findProjectById(intval($theProjectId));
		});
	}

} 