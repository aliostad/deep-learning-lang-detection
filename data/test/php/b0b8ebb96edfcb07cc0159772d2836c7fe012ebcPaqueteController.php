<?php
/**
 * Created by PhpStorm.
 * User: juan
 * Date: 23/08/2015
 * Time: 0:27
 */

namespace WSPturismo\Http\Controllers;


use WSPturismo\Repository\PaqueteRepository;

class PaqueteController extends Controller
{
    private $PaqueteRepository;

    public function  __construct(PaqueteRepository $paqueteRepository){


        $this->PaqueteRepository = $paqueteRepository;
    }

    public function  index(){

        return $this->PaqueteRepository->paqueteTotales();
    }

    public function  show($idPaquete){
        return "";
    }
}