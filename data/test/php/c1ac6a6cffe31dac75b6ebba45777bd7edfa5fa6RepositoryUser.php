<?php

/**
 * Created by PhpStorm.
 * User: Sameque
 * Date: 13/09/2015
 * Time: 17:06
 */

namespace App\Libraries\CrawlerRepository;

class RepositoryUser
{

    public static function getRepositoryUser($repository_id,$username)
    {
        if ($repository_id == 1) {
            $repository = new RepositoryUserSpoj();
        } elseif ($repository_id == 2) {
            $repository = new RepositoryUserUri();
        } elseif ($repository_id == 3) {
            $repository = new RepositoryUserUva();
        } else $repository = null;

        if (!empty($repository)) {
            return $repository->getUserRepository($username);
        } else
            return false;
    }
}