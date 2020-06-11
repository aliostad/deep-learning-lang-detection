<?php

namespace App\Http\Controllers;

use App\Facades\DummyFacade;
use App\Libraries\Dummy;
use DummyFacadeAlias;

class HomeController extends Controller
{
    public function index(Dummy $dummy) {
//        if (Auth::check()) {
//            echo Auth::user()->id . "  " . Auth::user()->email;
//        }

        ob_start();
        if (auth()->check())
        {
            echo auth()->user()->id;
        }

        $this->serviceContainerExample($dummy);
        $this->facadeExample();
        $this->facadeAliasExample();
        $data = ob_get_clean();

        return view('home.index', ['data' => $data]);
    }

    private function serviceContainerExample(Dummy $dummy) {
        echo '<br />Service Container Example: ' . $dummy->getString();
    }

    private function facadeExample() {
        echo '<br />Facade Example' . DummyFacade::getString();
    }

    private function facadeAliasExample() {
        echo '<br />Facade Alias Example' . DummyFacadeAlias::getString();
    }
}