<?php

namespace App\Http\Controllers;

use App\Barber\BarberRepository;
use App\Service\ServiceRepository;
use Illuminate\Http\Request;

use App\Http\Requests;
use App\Http\Controllers\Controller;

class PageController extends Controller
{
    /**
     * @var ServiceRepository
     */
    private $serviceRepository;
    /**
     * @var BarberRepository
     */
    private $barberRepository;

    /**
     * PageController constructor.
     * @param ServiceRepository $serviceRepository
     * @param BarberRepository $barberRepository
     */
    public function __construct(ServiceRepository $serviceRepository, BarberRepository $barberRepository)
    {
        $this->serviceRepository = $serviceRepository;
        $this->barberRepository = $barberRepository;
    }


    /**
     * Display a home page.
     *
     * @return Response
     */
    public function home()
    {
        $services = $this->serviceRepository->all();
        $barbers = $this->barberRepository->all();

        return view('pages.home', compact('services', 'barbers'));
    }

}
