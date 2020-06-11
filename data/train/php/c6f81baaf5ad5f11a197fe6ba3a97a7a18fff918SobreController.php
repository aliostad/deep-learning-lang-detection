<?php

namespace Toyopecas\Http\Controllers;

use Illuminate\Http\Request;
use Toyopecas\Repositories\SobreRepository;
use Toyopecas\Repositories\SobreRepositoryEloquent;

class SobreController extends Controller
{
    /**
     * @var SobreRepository
     */
    private $repository;

    public function __construct ( SobreRepository $repository  )
    {

        $this->repository = $repository;
    }

    public function index (  )
    {
        return view('admin.sobre');
    }

    public function create ( Request $request )
    {
        $data = $request->all();

        $this->repository->create($data);
        return view('admin.sobre');
    }
}
