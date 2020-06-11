<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Customer;

class CustomerController extends Controller
{
    public function index()
    {
        $customer = new Customer();
        $data = $customer->orderBy('id', 'desc')->get();
        return view('customer', compact('data'));
    }

    public function create()
    {
        return view('add_customer');
    }

    public function store(Request $request)
    {
        $customer = new Customer();
        $customer->customer_first_name = $request->input('fname');
        $customer->customer_last_name = $request->input('lname');
        $customer->customer_address = $request->input('address');
        $customer->customer_state = $request->input('state');
        $customer->customer_city = $request->input('city');
        $customer->customer_zip = $request->input('zip');
        $customer->customer_phone = $request->input('phone');
        $customer->save();

        return redirect('customer')->with('status', 'User saved successfully.');
    }

    public function edit($id)
    {
        $customer = new Customer();
        $data = $customer->where('id', $id)->first();
        return view('edit_customer', compact('data'));
    }

//    public function update(Request $request)
//    {
//        $customer = Customer::where('id', $request->input('id'))->first();
//        $customer->customer_first_name = $request->input('fname');
//        $customer->customer_last_name = $request->input('lname');
//        $customer->customer_address = $request->input('address');
//        $customer->customer_state = $request->input('state');
//        $customer->customer_city = $request->input('city');
//        $customer->customer_zip = $request->input('zip');
//        $customer->customer_phone = $request->input('phone');
//        $customer->save();
//        return redirect('customer')->with('status', 'User updated successfully.');
////
//    }
}
