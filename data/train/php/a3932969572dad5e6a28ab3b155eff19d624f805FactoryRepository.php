<?php

namespace Cobbler\Model;

use Cobbler\Factory\Factory;

class FactoryRepository implements Factory
{
    public static function create($name)
    {
        $entityName = 'App\Model\\' . $name;
        $repositoryPath = __DIR__ . '..\..\..\app\Model\Repository\\' . $name . ".php";
        $repositoryName = 'App\Model\Repository\\' . $name . 'Repository';

        if (file_exists($repositoryPath) && class_exists($repositoryName)) {
            $repository = new $repositoryName();
        } else {
            $repository = new Repository();
        }
        $repository->setProvider(DatabaseProvider::getConnect());
        $repository->setEntityName($entityName);
        $repository->setTableName($entityName::getTableName());

        return $repository;
    }
}