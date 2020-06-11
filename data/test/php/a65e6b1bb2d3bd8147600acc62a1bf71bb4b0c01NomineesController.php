<?php namespace App\Controllers;

use App\Repositories\CategoriesRepository;
use App\Repositories\NomineesRepository;
use View;

class NomineesController extends \BaseController
{

    /**
     * @var \App\Repositories\VotesRepository
     */
    private $nomineesRepository;
    /**
     * @var \App\Repositories\CategoriesRepository
     */
    private $categoriesRepository;

    public function __construct(NomineesRepository $nomineesRepository, CategoriesRepository $categoriesRepository)
    {
        $this->nomineesRepository = $nomineesRepository;
        $this->categoriesRepository = $categoriesRepository;
    }

    /**
     * Display nominees for the categories.
     *
     * @return Response
     */
    public function index()
    {
        $categories = $this->categoriesRepository->all();

        return View::make('nominees.index')->withCategories($categories);
    }

}
