<?php

namespace AnyContent\Repository\Modules\Core\Repositories;

use AnyContent\Repository\Modules\Core\Application\Application;

class Module extends \AnyContent\Repository\Modules\Core\Application\Module
{

    public function init(Application $app, $options = array())
    {
        parent::init($app, $options);

        $app['repos'] = $app->share(function ($app)
        {
            return new RepositoryManager($app);
        });

        // get info on repositories
        $app->get('/1/{repositoryName}/info', 'AnyContent\Repository\Modules\Core\Repositories\RepositoryController::index');
        $app->get('/1/{repositoryName}/info/{workspace}', 'AnyContent\Repository\Modules\Core\Repositories\RepositoryController::index');

        // get cmdl for a content type
        $app->get('/1/{repositoryName}/content/{contentTypeName}/cmdl', 'AnyContent\Repository\Modules\Core\Repositories\RepositoryController::cmdl');
        $app->get('/1/{repositoryName}/content/{contentTypeName}/cmdl/{locale}', 'AnyContent\Repository\Modules\Core\Repositories\RepositoryController::cmdl');

        // update cmdl for a content type / create content type
        $app->post('/1/{repositoryName}/content/{contentTypeName}/cmdl', 'AnyContent\Repository\Modules\Core\Repositories\RepositoryController::postContentTypeCMDL');
        $app->post('/1/{repositoryName}/content/{contentTypeName}/cmdl/{locale}', 'AnyContent\Repository\Modules\Core\Repositories\RepositoryController::postContentTypeCMDL');

        // delete content type
        $app->delete('/1/{repositoryName}/content/{contentTypeName}', 'AnyContent\Repository\Modules\Core\Repositories\RepositoryController::deleteContentType');

        // update cmdl for a config type / create config type
        $app->post('/1/{repositoryName}/config/{configTypeName}/cmdl', 'AnyContent\Repository\Modules\Core\Repositories\RepositoryController::postConfigTypeCMDL');
        $app->post('/1/{repositoryName}/config/{configTypeName}/cmdl/{locale}', 'AnyContent\Repository\Modules\Core\Repositories\RepositoryController::postConfigTypeCMDL');

        // delete config type
        $app->delete('/1/{repositoryName}/config/{configTypeName}', 'AnyContent\Repository\Modules\Core\Repositories\RepositoryController::deleteConfigType');


        // simplification routes, solely for human interaction with the api
        $app->get('/', 'AnyContent\Repository\Modules\Core\Repositories\RepositoryController::welcomeShortCut');
        $app->get('/1', 'AnyContent\Repository\Modules\Core\Repositories\RepositoryController::welcome');
        $app->get('/1/', 'AnyContent\Repository\Modules\Core\Repositories\RepositoryController::welcome');
        $app->get('/1/{repositoryName}', 'AnyContent\Repository\Modules\Core\Repositories\RepositoryController::getInfoShortCut');

    }

}