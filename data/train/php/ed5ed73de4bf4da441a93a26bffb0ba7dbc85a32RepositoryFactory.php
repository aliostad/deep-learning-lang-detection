<?php namespace Digbang\Security\Factories;

use Digbang\Security\Activations\ActivationRepository;
use Digbang\Security\Permissions\PermissionRepository;
use Digbang\Security\Persistences\PersistenceRepository;
use Digbang\Security\Reminders\ReminderRepository;
use Digbang\Security\Roles\RoleRepository;
use Digbang\Security\Throttling\ThrottleRepository;
use Digbang\Security\Users\UserRepository;

interface RepositoryFactory
{
	/**
	 * @param string $context
	 * @return PersistenceRepository
	 */
	public function createPersistenceRepository($context);

	/**
	 * @param string                $context
	 * @param PersistenceRepository $persistenceRepository
	 * @param RoleRepository        $roleRepository
	 *
	 * @return UserRepository
	 */
	public function createUserRepository($context, PersistenceRepository $persistenceRepository, RoleRepository $roleRepository);

	/**
	 * @param string $context
	 * @return RoleRepository
	 */
	public function createRoleRepository($context);

	/**
	 * @param string $context
	 * @return ActivationRepository
	 */
	public function createActivationRepository($context);

	/**
	 * @param string $context
	 * @param UserRepository $userRepository
	 * @return ReminderRepository
	 */
	public function createReminderRepository($context, UserRepository $userRepository);

	/**
	 * @param string $context
	 * @return PermissionRepository
	 */
	public function createPermissionRepository($context);

	/**
	 * @param string $context
	 * @return ThrottleRepository
	 */
	public function createThrottleRepository($context);
}
