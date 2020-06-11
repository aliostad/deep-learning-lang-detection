<?php namespace Direco\Http\ViewComposers;

use Direco\Repositories\ActividadesEconomicasRepository;
use Direco\Repositories\EstadosRepository;
use Direco\Repositories\MunicipiosRepository;
use Direco\Repositories\ParroquiasRepository;
use Illuminate\Session\Store as Session;
use Illuminate\Contracts\View\View;
use Illuminate\Support\Facades\Auth;

class UserForm {

    /**
     * @var EstadosRepository
     */
    private $estadosRepository;
    /**
     * @var MunicipiosRepository
     */
    private $municipiosRepository;
    /**
     * @var ParroquiasRepository
     */
    private $parroquiasRepository;
    /**
     * @var ActividadesEconomicasRepository
     */
    private $actividadesRepository;
    /**
     * @var Store
     */
    private $session;

    public function __construct(
        EstadosRepository $estadosRepository,
        MunicipiosRepository $municipiosRepository,
        ParroquiasRepository $parroquiasRepository,
        ActividadesEconomicasRepository $actividadesRepository,
        Session $session
    )
    {
        $this->estadosRepository = $estadosRepository;
        $this->municipiosRepository = $municipiosRepository;
        $this->parroquiasRepository = $parroquiasRepository;
        $this->actividadesRepository = $actividadesRepository;
        $this->session = $session;
    }

    public function compose(View $view)
    {
        $estados = $this->estadosRepository->getList();
        $municipios = $parroquias = array();

        $estado = $this->session->getOldInput('estado', Auth::check() ? Auth::user()->estado : null);

        if ($estado) {
            $municipios = $this->municipiosRepository->listFromEstado($estado);

            $municipio = $this->session->getOldInput('municipio', Auth::check() ? Auth::user()->municipio : null);

            if ($municipio) {
                $parroquias = $this->parroquiasRepository->listFromMunicipio($municipio);
            }
        }

        $actividades = $this->actividadesRepository->getList();

        $view->with(compact('estados', 'municipios', 'parroquias', 'actividades'));
    }

} 