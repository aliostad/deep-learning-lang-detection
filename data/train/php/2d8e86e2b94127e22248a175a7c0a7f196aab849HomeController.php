<?php

use Acme\Ad\AdRepository;
use Acme\EventModel\EventRepository;

class HomeController extends BaseController {

    private $eventRepository;

    private $adRepository;

    /**
     * @param EventRepository $eventRepository
     * @param AdRepository $adRepository
     */
    function __construct(EventRepository $eventRepository, AdRepository $adRepository)
    {
        $this->eventRepository = $eventRepository;
        $this->adRepository    = $adRepository;
        parent::__construct();
    }

    public function index()
    {
        $events = $this->eventRepository->getSliderEvents();
        $ads    = $this->adRepository->getAds();

        $this->render('site.home', compact('events', 'ads'));
    }

    /**
     * @return array|null|static[]
     * just for test purpose
     */
    public function slider()
    {
        $events = $this->eventRepository->getSliderEvents();
        return $events;
    }

}