<?php

namespace SoftUni\EntityManager;

class DatabaseContext
{
    private $buildingsRepository;

    private $usersRepository;

    private $repositories = [];

    /**
     * DatabaseContext constructor.
     * @param $buildingsRepository
     * @param $usersRepository
     */
    public function __construct($buildingsRepository, $usersRepository)
    {
        $this->buildingsRepository = $buildingsRepository;
        $this->usersRepository = $usersRepository;

        $this->repositories[] = $this->buildingsRepository;
        $this->repositories[] = $this->usersRepository;
    }


    /**
     * @return \SoftUni\Repositories\BuildingsRepository
     */
    public function getBuildingsRepository()
    {
        return $this->buildingsRepository;
    }

    /**
     * @param mixed $buildingsRepository
     * @return $this
     */
    public function setBuildingsRepository($buildingsRepository)
    {
        $this->buildingsRepository = $buildingsRepository;
        return $this;
    }

    /**
     * @return \SoftUni\Repositories\UsersRepository
     */
    public function getUsersRepository()
    {
        return $this->usersRepository;
    }

    /**
     * @param mixed $usersRepository
     * @return $this
     */
    public function setUsersRepository($usersRepository)
    {
        $this->usersRepository = $usersRepository;
        return $this;
    }

    public function saveChanges()
    {
        foreach ($this->repositories as $repository) {
            $repositoryName = get_class($repository);
            $repositoryName::save();
        }
    }

}