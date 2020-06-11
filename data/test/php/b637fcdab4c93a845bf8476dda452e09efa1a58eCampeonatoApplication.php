<?php

class CampeonatoApplication {
	
	private $dados;
	private $campeonatoRepository;
	private $clubeRepository;

	function setDados($dados){
		$this->dados = $dados;
	}

	function setCampeonatoRepository($campeonatoRepository){
		$this->campeonatoRepository = $campeonatoRepository;
	}

	function setClubeRepository($clubeRepository){
		$this->clubeRepository = $clubeRepository;
	}

	function post(){
		$campeonatoBuild = Campeonato::builder($this->dados->campeonato->nome, $this->campeonatoRepository, $this->clubeRepository)
				->clubes($this->dados->clubes)
				->jogadores($this->dados->jogadores)
				->build();

		$campeonatoBuild->gerarRodadas();
				
		$campeonato = $this->campeonatoRepository->save($campeonatoBuild);

		return $campeonato;		
	}

}