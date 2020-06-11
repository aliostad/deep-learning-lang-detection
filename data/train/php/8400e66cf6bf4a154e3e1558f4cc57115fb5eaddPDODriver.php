<?php
/**
 * This file is part of the Oaza Framework
 *
 * Copyright (c) 2012 Jan Svantner (http://www.janci.net)
 *
 * For the full copyright and license information, please view
 * the file license.txt that was distributed with this source code.
 */

namespace Oaza\Application\Adapter\Drivers\PDODriver;

use \Oaza\Application\Adapter\IDriver,
    \Oaza\Application\Adapter\Drivers\PDODriver\ControlRepository\ControlRepository,
    \Oaza\Application\Adapter\Drivers\PDODriver\TranslateRepository\TranslateRepository,
    \Oaza\Application\Adapter\Drivers\PDODriver\RouteRepository\RouteRepository;

/**
 * Oaza adapter driver implementation for PDO
 *
 * @author Filip Vozar
 */
class PDODriver extends \Oaza\Object implements IDriver
{

    /** @var \Oaza\Application\Adapter\ControlRepository\IControlRepository */
    private $controlRepository;

    /** @var \Oaza\Application\Adapter\TranslateRepository\ITranslateRepository */
    private $translateRepository;

    /** @var \Oaza\Application\Adapter\RouteRepository\IRouteRepository */
    private $routeRepository;

    /** @var \PDO */
    private $connection;

    public function __construct(\PDO $connection)
    {
        $this->connection = $connection;
    }

    /**
     * Returns ControlRepository ControlRepository implement in driver
     * @return \Oaza\Application\Adapter\ControlRepository\IControlRepository
     */
    public function getControlRepository()
    {
        if (isset($this->controlRepository)) {
            $repository = $this->controlRepository;
        } else {
            $PDOStatement = $this->connection->prepare("SELECT * FROM component");
            $PDOStatement->execute();
            $this->controlRepository = new ControlRepository($PDOStatement);
            $repository = $this->controlRepository;
            $statement = null;
        }

        return $repository;
    }

    /**
     * Returns Translate Repository implement in driver
     * @return \Oaza\Application\Adapter\TranslateRepository\ITranslateRepository
     */
    public function getTranslateRepository()
    {
        if (isset($this->translateRepository)) {
            $repository = $this->translateRepository;
        } else {
            $PDOStatement = $this->connection->prepare("SELECT * FROM translator");
            $PDOStatement->execute();
            $this->translateRepository = new TranslateRepository($PDOStatement);
            $repository = $this->translateRepository;
            $statement = null;
        }

        return $repository;
    }

    /**
     * Returns Router Repository implement in driver
     * @return \Oaza\Application\Adapter\RouteRepository\IRouteRepository
     */
    public function getRouteRepository()
    {
        if (isset($this->routeRepository)) {
            $repository = $this->routeRepository;
        } else {
            $PDOStatement = $this->connection->prepare("SELECT * FROM router");
            $PDOStatement->execute();
            $this->routeRepository = new RouteRepository($PDOStatement);
            $repository = $this->routeRepository;
            $statement = null;
        }

        return $repository;
    }
}
