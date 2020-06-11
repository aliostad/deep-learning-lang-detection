<?php

/* * ***************************************************************************
 * Repository service factory class
 * @Author - Ajit Singh
 * Created Date: 27/01/2014
 * Updated Date: 20/01/2015
 * *************************************************************************** */
namespace Repository\Factory;
class repositoryFactory {

    /**
     * @param string $repositoryService (github or bitbucket)
     * @return $repositoryClass [github] OR [bitbucket] object
     */
    public static function getInstance($repositoryService) {
        $repositoryService = strtolower($repositoryService);
        // Attempt to include the the file containing the class
        if (include_once(dirname(__FILE__)
                . '/repository/' . $repositoryService . '.php')) {
            $repositoryClass = $repositoryService;
            return new $repositoryClass;
        } else {
            throw new Exception('Repository Service Not Found');
        }
    }

}
