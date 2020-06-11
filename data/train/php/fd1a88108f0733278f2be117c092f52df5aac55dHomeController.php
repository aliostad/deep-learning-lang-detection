<?php

use Acme\Ad\AdRepository;
use Acme\EventModel\EventRepository;
use Acme\Gallery\GalleryRepository;

class HomeController extends BaseController {

    private $eventRepository;

    private $adRepository;
    /**
     * @var GalleryRepository
     */
    private $galleryRepository;
    /**
     * @var \Acme\Blog\BlogRepository
     */
    private $blogRepository;

    /**
     * @param GalleryRepository $galleryRepository
     * @param AdRepository $adRepository
     * @param \Acme\Blog\BlogRepository $blogRepository
     * @internal param EventRepository $eventRepository
     */
    function __construct(GalleryRepository $galleryRepository, AdRepository $adRepository, \Acme\Blog\BlogRepository $blogRepository)
    {
        $this->adRepository    = $adRepository;
        $this->galleryRepository = $galleryRepository;
        $this->blogRepository = $blogRepository;
        parent::__construct();
    }

    public function index()
    {
        $gallery = $this->galleryRepository->getImageSlider();
        $description = $this->blogRepository->getHomePageDescription()->first();
        $ads    = $this->adRepository->getAds();
        $this->render('site.home', compact('gallery', 'ads','description'));
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