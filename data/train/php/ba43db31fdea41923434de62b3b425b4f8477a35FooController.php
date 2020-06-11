<?php namespace App\Http\Controllers;

use App\Http\Requests;
use App\Repositories\FooRepository;

class FooController extends Controller
{

    /**
     * @var FooRepository
     */
    //    private $repository;
    //    public function __construct(FooRepository $repository)
    //    {
    //        $this->repository = $repository;
    //    }

    /**
     * method injection
     *
     * @param FooRepository $repository
     *
     * @return array
     */
    public function foo( FooRepository $repository )
    {
        return $repository->get();
    }

}
