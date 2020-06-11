<?php

namespace Components\Database\Repository\Factory;

use Components\Database\Repository\Repository;
use Components\Database\Repository\RepositoryInterface\RepositoryFactoryInterface;
use Components\Database\Repository\RepositoryInterface\RepositoryInterface;

class RepositoryFactory implements RepositoryFactoryInterface {

    public function create($className, $repositoryBuilder)
    {
        $object = new $className;
        if ($object instanceof RepositoryInterface) {
            return new Repository($object, $repositoryBuilder);
        }
        throw new \Exception("'{$className}' must implement the RepositoryInterface");
    }
}