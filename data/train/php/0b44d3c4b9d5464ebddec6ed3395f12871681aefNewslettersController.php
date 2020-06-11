<?php


use Illuminate\Support\Facades\View;
use na2ashet\Forms\SendNewslettersForm;
use Illuminate\Support\Facades\Mail;
use na2ashet\Users\UserRepository;
use na2ashet\Draws\DrawsRepository;
use na2ashet\Forms\CreateNewsForm;
use na2ashet\News\NewsRepository;
use na2ashet\Prizes\PrizesRepository;
use na2ashet\Testimonials\TestimonialsRepository;
use na2ashet\Promotions\PromotionsRepository;

class NewslettersController extends \BaseController {


    private $sendNewslettersForm;
    private $userRepository;
    private $testimonialsRepository;
    private $newsRepository;
    private $drawsRepository;
    private $promotionsRepository;
    private $prizesRepository;

    function __construct(SendNewslettersForm $sendNewslettersForm, UserRepository $userRepository,TestimonialsRepository $testimonialsRepository, NewsRepository $newsRepository, DrawsRepository $drawsRepository,
        PromotionsRepository $promotionsRepository, PrizesRepository $prizesRepository)
    {

        $this->sendNewslettersForm = $sendNewslettersForm;
        $this->userRepository = $userRepository;
        $this->testimonialsRepository = $testimonialsRepository;
        $this->newsRepository = $newsRepository;
        $this->drawsRepository = $drawsRepository;
        $this->promotionsRepository = $promotionsRepository;
        $this->prizesRepository = $prizesRepository;
    }


	public function create()
	{
        return View::make('cms.newsletters.create');
	}

    public function send()
    {
        $input = Input::all();
        $this->sendNewslettersForm->validate($input);

        $usersMails = $this->userRepository->getNewslettersSubscribers();


        $pagename = pageName();
        $incomeList = $this->drawsRepository->getIncomeList();
        $professionsList = $this->drawsRepository->getProfessionsList();
        $testimonialsList = $this->testimonialsRepository->displayTestimonialsList();
        $newsList = $this->newsRepository->displayNewsList();
        $drawsList = $this->drawsRepository->displayDrawsList(5);
        $drawsList2 = $this->drawsRepository->displayDrawsList(2);
        $d = $this->drawsRepository->getCurrentDraw();
        $drawPrizes = $this->prizesRepository->getPrizesByDraw($d[0]->draw_id);
        $currentDraw = $this->drawsRepository->getCurrentDraw();



        foreach($usersMails as $mail)
        {
           Mail::send('emails.newsletters-subscription', 
                array('input' => $input, 'pagename' => $pagename, 'testimonialsList' => $testimonialsList,
                                            'newsList' => $newsList, 'drawsList' => $drawsList, 'drawsList2' => $drawsList2,
                                            'incomeList' => $incomeList, 'professionsList' => $professionsList, 'drawPrizes' => $drawPrizes,
                                            'currentDraw' => $currentDraw), function($message) use ($input, $mail)
            {
                $message->from('info@na2ashet.com', 'Na2ashet')->subject($input['title']);
                $message->to($mail->email);
            });
        }

        Flash::success('Your newsletter has been successfully sent');
        return View::make('cms.newsletters.create');


    }






}
