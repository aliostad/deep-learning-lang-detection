<?php

namespace Laravel5Fundatmentals\Http\Controllers;

use Laravel5Fundatmentals\Repositories\FooRepository;
use Illuminate\Http\Request;
use Laravel5Fundatmentals\Http\Requests;


class FooController extends Controller
{
    /**
     * @var FooRepository
     */
    private $fooRepository;

    /**
     * Demo constructor injection
     * @param FooRepository $fooRepository
     */
    public function __construct(FooRepository $fooRepository)
    {
        $this->fooRepository = $fooRepository;
    }


    /**
     *
     */
    public function foo(){
        //$repository = new FooRepository();
        //return $repository->get();
        return $this->fooRepository->get();
    }


    /**
     * Demo method injection
     * @param FooRepository $fooRepository
     * @return array
     */
//    public function foo(FooRepository $fooRepository){
//        return fooRepository->get();
//    }


}
