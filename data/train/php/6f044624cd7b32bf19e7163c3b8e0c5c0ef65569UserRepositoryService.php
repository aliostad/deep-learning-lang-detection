<?php

namespace Services;

use Entities\Repositories\UserRepository;
use Entities\User;
use Mpwarfwk\Component\Db\PDODatabase;

class UserRepositoryService implements ServiceInterface{

    private $repository;

    public function __construct(UserRepository $repository, PDODatabase $pdoDatabase, User $user){
        $repository->setDatabaseConnection($pdoDatabase);
        $repository->setUserEntity($user);
        $this->repository = $repository;
    }

    public function run(){
        return $this->repository;
    }
}