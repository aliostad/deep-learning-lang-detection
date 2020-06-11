<?php

namespace CodeDelivery\Http\Controllers;

use CodeDelivery\Http\Requests\CheckoutRequest;
use CodeDelivery\Repositories\CategoryRepository;
use CodeDelivery\Http\Requests;
use CodeDelivery\Repositories\OrderRepository;
use CodeDelivery\Repositories\ProductRepository;
use CodeDelivery\Repositories\UserRepository;
use CodeDelivery\Services\OrderService;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class CheckoutController extends Controller
{

    /**
     * @var OrderRepository
     */
    private $repository;
    /**
     * @var UserRepository
     */
    private $userRepository;
    /**
     * @var ProductRepository
     */
    private $productRepository;
    /**
     * @var OrderService
     */
    private $service;

    /**
     * @param CategoryRepository|OrderRepository $repository
     * @param UserRepository $userRepository
     * @param ProductRepository $productRepository
     * @param OrderService $service
     */
    public function __construct(
        OrderRepository $repository,
        UserRepository $userRepository,
        ProductRepository $productRepository,
        OrderService $service)
    {
        $this->repository = $repository;
        $this->userRepository = $userRepository;
        $this->productRepository = $productRepository;
        $this->service = $service;
    }

    public function index()
    {
        #dd(Auth::user()->id);
        $clientId = $this->userRepository->skipPresenter()->find(Auth::user()->id)->client->id;
        #dd($clientId);
        $orders = $this->repository->scopeQuery(function($query) use ($clientId){
            return $query->where('client_id', '=', $clientId);
        })->paginate();

        return view('customer.order.index', compact('orders'));
    }

    public function create()
    {
        $products = $this->productRepository->lists();

        return view('customer.order.create', compact('products'));
    }

    public function store(CheckoutRequest $request)
    {
        $data = $request->all();
        $clientId = $this->userRepository->skipPresenter()->find(Auth::user()->id)->client->id;
        $data['client_id'] = $clientId;
        $this->service->create($data);

        return redirect()->route('customer.order.index');
    }
}