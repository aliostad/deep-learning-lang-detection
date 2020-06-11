<?php

namespace Topicmine\Core\Models;

/**
 * Class Repo
 * @package Topicmine\Core\Models
 *
 * Used to load repositories
 *
 */

class Repo
{
    public function __construct($app)
    {
        $this->app = $app;
    }

    public function make($repository)
    {
        return app()->make($this->path($repository));
    }
    
    public function path($repository)
    {
        $repository = str_replace('/', '\\',$repository);

        // Add first backslash
//        $repository = preg_replace('/^(?!\).*/', '\\'. $repository, $repository);

        return "{$repository}RepositoryInterface";
    }
}
