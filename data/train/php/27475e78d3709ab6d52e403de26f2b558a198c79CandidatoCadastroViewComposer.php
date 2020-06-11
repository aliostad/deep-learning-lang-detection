<?php

namespace Concursos\ViewComposers;
use Concursos\Model\Repositories\EstadosRepositoryInterface;
use Concursos\Model\Repositories\TiposLogradouroRepositoryInterface;
use Concursos\Model\Repositories\SexoRepositoryInterface;
use Concursos\Model\Repositories\CidadesRepositoryInterface;
use Illuminate\View\View;

class CandidatoCadastroViewComposer {
    
    private $estadosRepository;
    private $logradourosRepository;
    private $sexoRepository;
    
    public function __construct(
            EstadosRepositoryInterface $estadosRepository,
            TiposLogradouroRepositoryInterface $logradourosRepository,
            SexoRepositoryInterface $sexoRepository) {
        
        $this->estadosRepository = $estadosRepository;
        $this->logradourosRepository = $logradourosRepository;
        $this->sexoRepository = $sexoRepository;
    }
    
    public function compose(View $view) {
        $componentes['estados']  = $this->estadosRepository->all();
        $componentes['logradouros']  = $this->logradourosRepository->all();
        $componentes['sexo']  = $this->sexoRepository->all();
        $view->with('componentes', $componentes);
    }
}