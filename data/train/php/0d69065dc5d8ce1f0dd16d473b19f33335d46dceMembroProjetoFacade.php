<?php

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
namespace LabManager\Facade;

use LabManager\Negocio\MembroProjetoNegocio;
use LabManager\Facade\AbstractFacade;
/**
 * Description of MembroProjetoFacade
 *
 * @author Lázaro Henrique <lazarohcm@gmail.com>
 * @version string
 */
class MembroProjetoFacade extends AbstractFacade{
    function __construct() {
        parent::__construct();
        $this->setNegocio(new MembroProjetoNegocio());
    }
}
