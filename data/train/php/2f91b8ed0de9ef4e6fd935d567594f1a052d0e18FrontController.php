<?php
/**
 * Created by PhpStorm.
 * User: veoc
 * Date: 14/01/17
 * Time: 2:42 PM
 */

namespace App\Http\Controllers;


use App\Entities\Repositories\ProductRepository;
use App\Entities\Repositories\SlideshowRepository;

class FrontController extends Controller
{
    /**
     * @var SlideshowRepository
     */
    private $slideshowRepository;
    /**
     * @var ProductRepository
     */
    private $productRepository;

    /**
     * FrontController constructor.
     * @param SlideshowRepository $slideshowRepository
     * @param ProductRepository $productRepository
     */
    public function __construct(SlideshowRepository $slideshowRepository, ProductRepository $productRepository)
    {
        $this->slideshowRepository = $slideshowRepository;
        $this->productRepository = $productRepository;
    }

    public function home()
    {
        $slideshows = $this->slideshowRepository->where('active', '=', 1)->findAll();

        $products = $this->productRepository->active()->limit(4)->findAll();

        return view('front.home', compact('slideshows', 'products'));
    }
}