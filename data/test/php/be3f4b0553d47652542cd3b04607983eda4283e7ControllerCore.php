<?php

namespace Todo\TaskBundle\Core;

use Silex\Application;
use Silex\Route;
use Silex\ControllerCollection;
use Silex\ControllerProviderInterface;
use Symfony\Component\HttpFoundation\Request;

class ControllerCore implements ControllerProviderInterface {

    protected $repository;

    protected $controller;

    public function setRepository($repository) {
        $this->repository = $repository;
    }

    public function setController($controller) {
        $this->controller = $controller;
    }

    public function __construct() {
        $calledClass = explode('\\', get_called_class());

        $this->setRepository($this->getRepositoryFromCalledClass($calledClass));
        $this->setController(new ControllerCollection(new Route()));
    }

    private function getRepositoryFromCalledClass($calledClass)
    {
        $class = substr(end($calledClass), 0, -10);
        $repository = $calledClass[0] . "\\" . $calledClass[1] . "\\Repository\\" . $class . "Repository";

        return $repository;
    }

    public function connect(Application $app)
    {
        $controller = $this->controller;

        $targetRepository = $this->repository;

        $controller->get("/", function() use ($app, $targetRepository) {
            $repository = new $targetRepository($app['db']);
            $results = $repository->findAll();

            return $app->json($results);
        });

        $controller->get("/{id}", function($id) use ($app, $targetRepository) {
            $repository = new $targetRepository($app['db']);
            $result = $repository->find($id);

            return $app->json($result);
        })
        ->assert('id', '\d+');

        $controller->post("/", function(Request $request) use ($app, $targetRepository) {
            $repository = new $targetRepository($app['db']);
            $params = $request->request->all();

            return $app->json($repository->insert($params));
        });

        $controller->put("/{id}", function(Request $request, $id) use ($app, $targetRepository) {
            $repository = new $targetRepository($app['db']);
            $params = $request->request->all();

            return $app->json($repository->update($id, $params));
        })
        ->assert('id', '\d+');

        $controller->delete("/{id}", function($id) use ($app, $targetRepository) {
            $repository = new $targetRepository($app['db']);

            return $app->json($repository->delete($id));
        })
        ->assert('id', '\d+');

        return $controller;
    }
}
