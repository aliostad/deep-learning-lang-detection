<?php

use Japan\Food\FoodRepository;
use Japan\Categories\CategoryRepository;

class FoodController extends BaseController {

    /**
     * @var FlavourRepository
     */
    private $foodRepository;
    private $categoryRepository;

    function __construct(FoodRepository $foodRepository, CategoryRepository $categoryRepository)
    {
        $this->foodRepository = $foodRepository;
        $this->categoryRepository = $categoryRepository;
    }

    public function index($name)
    {
        $all = $this->foodRepository->allFromCategory($name);

        return $all;
    }

}
