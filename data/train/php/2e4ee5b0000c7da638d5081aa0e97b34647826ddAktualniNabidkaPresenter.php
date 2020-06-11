<?php
namespace FrontModule;
/**
 * Homepage presenter.
 */
class AktualniNabidkaPresenter extends BasePresenter {

	private $productsRepository;
	private $aktualityRepository;


	public function __construct(\AdminModule\ProductsRepository $productsRepository, \AdminModule\AktualityRepository $aktualityRepository) {
		parent::__construct();
		$this->productsRepository		= $productsRepository;
		$this->aktualityRepository	= $aktualityRepository;
	}

	public function renderDefault() {
		$this->template->anyVariable = 'any value';
	}

	public function renderHodinky() {
		$this->template->hodinky = $this->productsRepository->getAllHodinky();
	}

	public function renderKlenoty() {
		$this->template->klenoty = $this->productsRepository->getAllKlenoty();
	}

	public function createComponentAktualityList() {
		return new AktualityControl($this->aktualityRepository->findAll(), $this->aktualityRepository);
	}
}