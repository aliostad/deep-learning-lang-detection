<?php


class DatabaseService{

    private static $Repositories = array();


    public function __construct(){}

    public function getRepository($repositoryName)
    {
        $repositoryName .= 'Repository';
        if ( !isset(self::$Repositories[$repositoryName])) {
            require_once PATH.'/root/application/Repository/'.$repositoryName.'.php';
            self::$Repositories[$repositoryName] = new $repositoryName;
        }

        return self::$Repositories[$repositoryName];
    }

    public function getConnection()
    {
        return Model::getInstance()->DB;
    }
}
