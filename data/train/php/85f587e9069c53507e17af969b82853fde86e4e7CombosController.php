<?php namespace Direco\Http\Controllers;

use Direco\Base\Controller;
use Direco\Repositories\ModelosRepository;
use Direco\Repositories\MotoresRepository;
use Direco\Repositories\MunicipiosRepository;
use Direco\Repositories\ParroquiasRepository;

class CombosController extends Controller {

    public function getModels($brandId, ModelosRepository $modelosRepository)
    {
        return $modelosRepository->listFromMarca($brandId);
    }

    public function getMotors($modelId, MotoresRepository $motoresRepository)
    {
        return $motoresRepository->listFromModelo($modelId);
    }

    public function getMunicipios($estadoId, MunicipiosRepository $municipiosRepository)
    {
        return $municipiosRepository->listFromEstado($estadoId);
    }

    public function getParroquias($municipioId, ParroquiasRepository $parroquiasRepository)
    {
        return $parroquiasRepository->listFromMunicipio($municipioId);
    }

} 