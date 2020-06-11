<?php

namespace BrainpopUser\Repository;

use Application\Service\RepositoryWatcher;

use BrainpopUser\Repository\AccountRepository;
use BrainpopUser\Repository\GroupRepository;
use BrainpopUser\Repository\UserRepository;

trait RepositoryGetterTrait
{

    /** @var AccountRepository */
    protected $accountRepository;

    /** @var GroupRepository */
    protected $groupRepository;

    /** @var UserRepository */
    protected $userRepository;

    /**
     * Get the Account repository
     * @return AccountRepository
     */
    public function getAccountRepository()
    {
        if (!$this->accountRepository) {
            $this->accountRepository = RepositoryWatcher::get(RepositoryWatcher::ACCOUNT_REPOSITORY);
        }
        return $this->accountRepository;
    }

    /**
     * Get the Group repository
     * @return GroupRepository
     */
    public function getGroupRepository()
    {
        if (!$this->groupRepository) {
            $this->groupRepository = RepositoryWatcher::get(RepositoryWatcher::GROUP_REPOSITORY);
        }
        return $this->groupRepository;
    }

    /**
     * Get the User repository
     * @return UserRepository
     */
    public function getUserRepository()
    {
        if (!$this->userRepository) {
            $this->userRepository = RepositoryWatcher::get(RepositoryWatcher::USER_REPOSITORY);
        }
        return $this->userRepository;
    }

}