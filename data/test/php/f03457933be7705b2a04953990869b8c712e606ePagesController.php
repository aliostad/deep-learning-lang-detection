<?php

use BiltmorePrint\Work\WorkRepository;

class PagesController extends BaseController {

    /**
     * @var WorkRepository
     */
    private $workRepository;

    function __construct(WorkRepository $workRepository)
    {
        $this->workRepository = $workRepository;
    }

    public function home()
    {
        $recentWork = $this->workRepository->getMostRecentWork();
        return View::make('pages.home', compact('recentWork'));
    }

    public function admin()
    {
        return View::make('pages.admin');
    }

}
