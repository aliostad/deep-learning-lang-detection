<?php

namespace CodeDelivery\Http\Controllers;

use CodeDelivery\Repositories\OrderRepository;
use CodeDelivery\Repositories\UserRepository;


class HomeController extends Controller
{
    private $repository;
    /**
     * @var UserRepository
     */
    private $userRepository;

    public function  __construct(OrderRepository $repository, UserRepository $userRepository){
        $this->repository = $repository;
        $this->userRepository = $userRepository;
    }
    public function index()
    {
        $abertas = $this->repository->orders_abertas();
        $dia = $this->repository->orders_dia();
        $fechadas = $this->repository->orders_dia_fechadas();
        $users = $this->userRepository->countUsers();
        return view('home',compact('abertas','dia','fechadas','users'));
    }


}
