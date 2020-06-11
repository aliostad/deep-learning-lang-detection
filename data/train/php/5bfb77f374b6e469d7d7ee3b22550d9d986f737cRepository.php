<?php

namespace CatSearch\Repository;

/**
 * Class Repository - repositories factory
 * @package CatSearch\Repository
 */
class Repository {

    /**
     * Return repository instance
     * @param $repositoryName
     * @return bool
     */
    public function make( $repositoryName ) {

        $className = __NAMESPACE__ . '\\' . ucfirst($repositoryName) . 'Repository';

        if ( class_exists($className) ) {
            return new $className;
        } else {
            return false;
        }

    }

} 