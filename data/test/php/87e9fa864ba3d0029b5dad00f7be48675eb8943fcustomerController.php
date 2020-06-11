<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Http\Requests;
use Session;
use App\cart as cart;
use App\product as product;
use App\category as category;
use App\customer as customer;
class customerController extends Controller
{
  public function index(){
    $category=category::all();
    $customer=customer::all();
    return view('admin.customer',[
      'category'=>$category,
      'customer'=>$customer
    ]);
  }
    public function search(Request $request){
      $name=$request->sCustomer;
      $customer=customer::where('name','like','%'.$name.'%')->get();
      $category= category::all();
      return view('admin.customer',[
        'category'=>$category,
        'customer'=>$customer
      ]);
    }
    public function new(Request $request){
      $category= category::all();
      return view('form.addCustomer',['category'=>$category]);
    }
    public function addNew(Request $request){
      $category=category::all();
      $customer=new customer;
      $customer->customer_id =$request->customer_id;
      $customer->name =$request->name;
      $customer->phone =$request->phone;
      $customer->email =$request->email;
      $customer->address =$request->address;
      $customer->poin = 0;
      $customer->save();
      return view('form.addCustomer',['category'=>$category]);
    }
    public function pilih($id){
      $get=customer::where('customer_id',$id)->get();
      $save=Session::put('customer',$get);
      return redirect('/');
    }
}
