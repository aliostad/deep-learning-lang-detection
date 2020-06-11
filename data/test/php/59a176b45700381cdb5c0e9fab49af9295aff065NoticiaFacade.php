<?php

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
namespace LabManager\Facade;

use LabManager\Negocio\NoticiaNegocio;
use LabManager\Facade\AbstractFacade;
/**
 * Description of NoticiaFacade
 *
 * @author Lázaro Henrique <lazarohcm@gmail.com>
 * @version string
 */
class NoticiaFacade extends AbstractFacade{
    function __construct() {
        parent::__construct();
        $this->setNegocio(new NoticiaNegocio());
    }
}
