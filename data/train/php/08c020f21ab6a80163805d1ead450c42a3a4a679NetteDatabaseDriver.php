<?php
/**
 * This file is part of the Oaza Framework
 *
 * Copyright (c) 2012 Jan Svantner (http://www.janci.net)
 *
 * For the full copyright and license information, please view
 * the file license.txt that was distributed with this source code.
 */

namespace Oaza\Application\Adapter\Drivers\NetteDatabaseDriver;

use \Oaza\Application\Adapter\IDriver,
    \Oaza\Application\Adapter\Drivers\NetteDatabaseDriver\ControlRepository\ControlRepository,
    \Oaza\Application\Adapter\Drivers\NetteDatabaseDriver\TranslateRepository\TranslateRepository,
    \Oaza\Application\Adapter\Drivers\NetteDatabaseDriver\RouteRepository\RouteRepository;

/**
 * Oaza adapter driver for \Nette\Database
 *
 * @author Filip Vozar
 */
class NetteDatabaseDriver extends \Oaza\Object implements IDriver
{

    /** @var \Oaza\Application\Adapter\ControlRepository\IControlRepository */
    private $controlRepository;

    /** @var \Oaza\Application\Adapter\TranslateRepository\ITranslateRepository */
    private $translateRepository;

    /** @var \Oaza\Application\Adapter\RouteRepository\IRouteRepository */
    private $routeRepository;

    /** @var \Nette\Database\Connection */
    private $connection;

    public function __construct(\Nette\Database\Connection $connection)
    {
        $this->connection = $connection;
    }

    /**
     * Returns ControlRepository ControlRepository implement in driver
     * @return \Oaza\Application\Adapter\ControlRepository\IControlRepository
     */
    public function getControlRepository()
    {
        return isset($this->controlRepository) ? $this->controlRepository : $this->controlRepository = $this->createControlRepository();
    }

    /**
     * @return ControlRepository
     */
    private function createControlRepository()
    {
        $tableSelection = $this->connection->table('component');
        return new ControlRepository($tableSelection);
    }

    /**
     * Returns Translate Repository
     * @return \Oaza\Application\Adapter\TranslateRepository\ITranslateRepository
     */
    public function getTranslateRepository()
    {
        return isset($this->translateRepository) ? $this->translateRepository : $this->translateRepository = $this->createTranslateRepository();
    }

    /**
     * @return TranslateRepository
     */
    private function createTranslateRepository()
    {
        return new TranslateRepository($this->connection->table('translator'));
    }

    /**
     * Returns Router Repository implement in driver
     * @return \Oaza\Application\Adapter\RouteRepository\IRouteRepository
     */
    public function getRouteRepository()
    {
        return isset($this->routeRepository) ? $this->routeRepository : $this->routeRepository = $this->createRouteRepository();
    }

    /**
     * @return RouteRepository
     */
    private function createRouteRepository()
    {
        return new RouteRepository($this->connection->table('router'));
    }
}
