<?php

namespace AnyContent\Repository\Modules\Core\SuperAdmin;

use AnyContent\Repository\Modules\Core\Application\Application;

class Module extends \AnyContent\Repository\Modules\Core\Application\Module
{

    public function init(Application $app, $options = array())
    {
        parent::init($app, $options);

        $app->post('/1/{repositoryName}', 'AnyContent\Repository\Modules\Core\SuperAdmin\RepositoryController::createRepository');
        $app->delete('/1/{repositoryName}', 'AnyContent\Repository\Modules\Core\SuperAdmin\RepositoryController::discardRepository');

    }

}