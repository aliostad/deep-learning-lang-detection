<?php


use Illuminate\Support\Facades\View;
use na2ashet\Draws\DrawsRepository;
use na2ashet\Forms\CreateNewsForm;
use na2ashet\News\NewsRepository;
use na2ashet\Testimonials\TestimonialsRepository;
use na2ashet\Promotions\PromotionsRepository;


class PaymentController extends \BaseController {


    /**
     * @var TestimonialsRepository
     */
    private $testimonialsRepository;
    /**
     * @var NewsRepository
     */
    private $newsRepository;
    /**
     * @var DrawsRepository
     */
    private $drawsRepository;

    /**
     * @var DrawsRepository
     */
    private $promotionsRepository;

    function __construct(TestimonialsRepository $testimonialsRepository, NewsRepository $newsRepository, DrawsRepository $drawsRepository,
        PromotionsRepository $promotionsRepository)
    {

        $this->testimonialsRepository = $testimonialsRepository;
        $this->newsRepository = $newsRepository;
        $this->drawsRepository = $drawsRepository;
        $this->promotionsRepository = $promotionsRepository;
    }


    public function index()
    {
        $pagename = pageName();
        $incomeList = $this->drawsRepository->getIncomeList();
        $professionsList = $this->drawsRepository->getProfessionsList();
        $testimonialsList = $this->testimonialsRepository->displayTestimonialsList();
        $newsList = $this->newsRepository->displayNewsList();
        $drawsList = $this->drawsRepository->displayDrawsList(5);
        $drawsList2 = $this->drawsRepository->displayDrawsList(2);


        return View::make('payment.index', array('pagename' => $pagename, 'testimonialsList' => $testimonialsList,
                                            'newsList' => $newsList, 'drawsList' => $drawsList, 'drawsList2' => $drawsList2,
                                            'incomeList' => $incomeList, 'professionsList' => $professionsList));
    }

    public function pay()
    {
        $pagename = pageName();
        $incomeList = $this->drawsRepository->getIncomeList();
        $professionsList = $this->drawsRepository->getProfessionsList();
        $testimonialsList = $this->testimonialsRepository->displayTestimonialsList();
        return View::make('payment.pay', array('pagename' => $pagename, 'testimonialsList' => $testimonialsList,
            'incomeList' => $incomeList, 'professionsList' => $professionsList));
    }

}
