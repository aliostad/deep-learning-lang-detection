<?php
/**
 * This file is part of the Oaza Framework
 *
 * Copyright (c) 2012 Jan Svantner (http://www.janci.net)
 *
 * For the full copyright and license information, please view
 * the file license.txt that was distributed with this source code.
 */

namespace Oaza\Application\Adapter\Drivers\DummyDriver;

use \Oaza\Application\Adapter\IDriver,
    Oaza\Application\Adapter\Drivers\DummyDriver\ControlRepository\ControlRepository,
    Oaza\Application\Adapter\Drivers\DummyDriver\TranslateRepository\TranslateRepository,
    Oaza\Application\Adapter\Drivers\DummyDriver\RouteRepository\RouteRepository;

/**
 * Dummy implementation of Oaza Adapter
 *
 * @author Jan Svantner
 */
class DummyDriver extends \Oaza\Object implements IDriver
{

    /** @var ControlRepository */
    private $controlRepository;

    /** @var TranslateRepository */
    private $translateRepository;

    /** @var RouteRepository */
    private $routeRepository;

    /**
     * Returns Control Repository implement in driver
     * @return ControlRepository
     */
    public function getControlRepository() {
        return isset($this->controlRepository) ? $this->controlRepository : $this->controlRepository = new ControlRepository;
    }

    /**
     * Returns Translate Repository implement in driver
     * @return TranslateRepository
     */
    public function getTranslateRepository() {
        return isset($this->translateRepository) ? $this->translateRepository : $this->translateRepository = new TranslateRepository;
    }

    /**
     * Returns Router Repository implement in driver
     * @return RouteRepository
     */
    public function getRouteRepository() {
        return isset($this->routeRepository) ? $this->routeRepository : $this->routeRepository = new RouteRepository();
    }
}
