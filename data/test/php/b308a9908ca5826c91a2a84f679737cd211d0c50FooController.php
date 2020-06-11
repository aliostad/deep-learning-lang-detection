<?php namespace App\Http\Controllers;

use App\Http\Requests;
use App\Http\Controllers\Controller;

use App\Repositories\FooRepository;
use Illuminate\Http\Request;

class FooController extends Controller {

    private $repository;

    public function __construct(FooRepository $repository)
	{
        $this->repository = $repository;
	}

    public function foo()
    {
        return $this->repository->get();
    }

    // Another Way [ Method Injection ]
    /*
    public function foo(FooRepository $repository)
    {
        return $repository->get();
    }
     */
}
