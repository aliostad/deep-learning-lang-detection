<?php

namespace FHJ\Converters;

use FHJ\Repositories\UserDbRepositoryInterface;

/**
 * UserConverter
 * @package FHJ\Converters
 */
class UserConverter extends AbstractConverter {

	/**
	 * @var UserDbRepositoryInterface
	 */
	private $repository;

	public function __construct(UserDbRepositoryInterface $userRepository) {
		$this->repository = $userRepository;
	}

	public function convert($value) {
		$repository = $this->repository;

		return $this->handleConversion($value, function($theUserId) use ($repository) {
			return $repository->findUserById(intval($theUserId));
		});
	}

}