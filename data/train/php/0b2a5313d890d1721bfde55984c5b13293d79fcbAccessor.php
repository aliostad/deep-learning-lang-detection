<?php
/*
 * AtlivaDomainModeling_Repository_Accessor
 * Global accessor for all repositories
 */
class AtlivaDomainModeling_Repository_Accessor {
    /*
     * $_repositories
     * array of repository instances
     */
    private static $_repositories = array();
    /*
     * getInstance
     * retrieves the desired repository based on $repositoryClassName
     * @param string $repositoryClassName class name of desired repository
     */
    public static function getInstance( $repositoryClassName ){
        if(!isset(self::$_repositories[$repositoryClassName])){
            $newRepositoryInstance = new $repositoryClassName();
            if(!is_subclass_of($newRepositoryInstance, 'AtlivaDomainModeling_Repository_RepositoryAbstract')){
                return false;
            }
            self::$_repositories[$repositoryClassName] = $newRepositoryInstance;
        }
        return self::$_repositories[$repositoryClassName];
    }
}