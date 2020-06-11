<?php

namespace App\Services\Admin\Http\Controllers;

use App\Http\Controllers\Controller;
use PragmaRX\Sdk\Services\Clipping\Data\Repositories\Clipping as ClippingRepository;

class Admin extends Controller
{
	/**
	 * @var ClippingRepository
	 */
	private $clippingRepository;

	public function __construct(ClippingRepository $clippingRepository)
	{
		$this->clippingRepository = $clippingRepository;
	}

	public function index()
	{
		$posts = $this->clippingRepository->paginated();

		return view('admin.index')
				->with('posts', $this->clippingRepository->paginated());
	}
}

