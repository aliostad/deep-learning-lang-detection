<?php

use EDM\Series\SeriesRepository;

class PagesController extends BaseController {

    /**
     * @var EDM\Series\SeriesRepository
     */
    private $seriesRepository;

    function __construct(SeriesRepository $seriesRepository) {
        $this->seriesRepository = $seriesRepository;
    }

    public function home() {
        $series = $this->seriesRepository->getPaginated(20);
        return View::make('home', compact('series'));
    }

    public function join() {
        return View::make('join');
    }
} 