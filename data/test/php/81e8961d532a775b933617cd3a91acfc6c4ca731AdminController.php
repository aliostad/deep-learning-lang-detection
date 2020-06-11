<?php

use Foodtrucker\Spots\SpotRepository;
use Foodtrucker\Tags\TagRepository;
use Foodtrucker\Trucks\TruckRepository;

class Admin_AdminController extends BaseController {

	private $spotRepository;
	/**
	 * @var TagRepository
	 */
	private $tagRepository;
	/**
	 * @var TruckRepository
	 */
	private $truckRepository;

	/**
	 * @param SpotRepository $spotRepository
	 * @param TagRepository $tagRepository
	 */
	function __construct( SpotRepository $spotRepository, TagRepository $tagRepository, TruckRepository $truckRepository) {
		$this->spotRepository = $spotRepository;
		$this->tagRepository = $tagRepository;
		$this->truckRepository = $truckRepository;
	}

	public function dashboard()
	{
		$data['title'] = 'Dashboard';
		$data['trucks'] = $this->truckRepository->getTrucks();
		$data['tags'] = $this->tagRepository->getTagsPaginatated();
		$data['spots'] = $this->spotRepository->getSpots();
		return View::make('back.pages.dashboard', compact('data'));
	}

}
