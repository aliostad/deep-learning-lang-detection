<?php namespace App\Http\Controllers;

use App\CustomerCustomerDemo;
use App\Http\Requests;
use App\Http\Controllers\Controller;

use Illuminate\Http\Request;

class CustomerCustomerDemoController extends Controller {

    /**
     * Display a listing of the resource.
     *
     * @return Response
     */
    public function index()
    {
        $customerCustomerDemoControllers=CustomerCustomerDemoController::all();
        return view('customerCustomerDemoControllers.index',compact('customerCustomerDemoControllers'));
    }

    /**
     * Show the form for creating a new resource.
     *
     * @return Response
     */
    public function create()
    {
        return view('customerCustomerDemoControllers.create');
    }

    /**
     * Store a newly created resource in storage.
     *
     * @return Response
     */
    public function store()
    {
        $customerCustomerDemoController=Request::all();
        CustomerCustomerDemoController::create($customerCustomerDemoController);
        return redirect('customerCustomerDemoControllers');
    }

    /**
     * Display the specified resource.
     *
     * @param  int  $id
     * @return Response
     */
    public function show($id)
    {
        $customerCustomerDemoController = CustomerCustomerDemoController::find($id);
        return view('customerCustomerDemoControllers.show', array('customerCustomerDemoController' => $customerCustomerDemoController));
    }

    /**
     * Show the form for editing the specified resource.
     *
     * @param  int  $id
     * @return Response
     */
    public function edit($id)
    {
        $customerCustomerDemoController=CustomerCustomerDemoController::find($id);
        return view('customerCustomerDemoControllers.edit',compact('customerCustomerDemoController'));
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  int  $id
     * @return Response
     */
    public function update($id)
    {
        $customerCustomerDemoControllerUpdate=Request::all();
        $customerCustomerDemoController=CustomerCustomerDemoController::find($id);
        $customerCustomerDemoController->update($customerCustomerDemoControllerUpdate);
        return redirect('customerCustomerDemoControllers');
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  int  $id
     * @return Response
     */
    public function destroy($id)
    {
        CustomerCustomerDemoController::find($id)->delete();
        return redirect('customerCustomerDemoControllers');
    }

}
