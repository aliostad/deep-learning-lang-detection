<?php namespace App\Http\Controllers\Admin;

use App\Http\Requests;
use App\Http\Controllers\Controller;

use App\Option;
use App\Repositories\CategoryRepository;
use App\Repositories\PaymentRepository;
use App\Repositories\ProductRepository;
use App\Repositories\TagRepository;
use App\Repositories\UserRepository;
use Illuminate\Http\Request;

class DashboardController extends Controller {

    /**
     * @var UserRepository
     */
    private $userRepository;
    /**
     * @var ProductRepository
     */
    private $productRepository;
    /**
     * @var CategoryRepository
     */
    private $categoryRepository;
    /**
     * @var TagRepository
     */
    private $tagRepository;
    /**
     * @var PaymentRepository
     */
    private $paymentRepository;

    /**
     * @param UserRepository $userRepository
     * @param ProductRepository $productRepository
     * @param CategoryRepository $categoryRepository
     * @param TagRepository $tagRepository
     * @param PaymentRepository $paymentRepository
     */
    function __construct(UserRepository $userRepository, ProductRepository $productRepository, CategoryRepository $categoryRepository, TagRepository $tagRepository, PaymentRepository $paymentRepository)
    {
        $this->userRepository = $userRepository;
        $this->productRepository = $productRepository;
        $this->categoryRepository = $categoryRepository;
        $this->tagRepository = $tagRepository;
        $this->paymentRepository = $paymentRepository;
    }

    /**
	 * Display a listing of the resource.
	 *
	 * @return Response
	 */
	public function index()
	{

        $tu = $this->userRepository->getTotal();
        $tp = $this->productRepository->getTotal();
        $tc = $this->categoryRepository->getTotal();
        $tt = $this->tagRepository->getTotal();
        $op = Option::count();
        $pm = $this->paymentRepository->getTotal();
        return View('admin.dashboard.index')->with(compact('tu','tp','tc','tt','op','pm'));
	}



}
