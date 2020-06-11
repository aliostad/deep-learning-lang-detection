<?php

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

namespace LabManager\Facade;

use LabManager\Negocio\SalaNegocio;
use LabManager\Facade\AbstractFacade;

/**
 * Description of SalaFacade
 *
 * @author Lázaro Henrique <lazarohcm@gmail.com>
 * @version string
 */
class SalaFacade extends AbstractFacade {
    function __construct() {
        parent::__construct();
        $this->setNegocio(new SalaNegocio());
    }
}
