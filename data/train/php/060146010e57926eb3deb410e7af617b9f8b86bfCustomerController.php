<?php

namespace App\Http\Controllers;

use App\Customer;
use Illuminate\Http\Request;
use function redirect;

class CustomerController extends Controller
{
	// 목록 표시
	public function index(Request $request)
	{
		$parameter = [
			// 검색 내용
		];

		$customer_list = Customer::customer_list($parameter);

		return view('customer.list', compact('customer_list', 'parameter'));
    }

    // 고객 상세
	public function view(Customer $customer, Request $request)
	{
		$customer->load(['address' => function($query) {
			$query->with('contact');
		}], 'orderer', 'staff');

		return response()->json($customer);
	}

	// 고객 추가
	public function store(Request $request)
	{
		$customer_data = [

		];

		$customer = Customer::create($customer_data);
//		$addresses_data = [
//
//		];
//		foreach ($aaa as $a) {
//			$address_data = [
//
//			];
//			array_push($addresses_data, $address_data);
//		}
//		$customer->address->insert($addresses_data);
//		$customer->orderer->insert($ordereres_data); // 대충 이런식

		return redirect()->intended(route('customer.list'));
	}

	// 고객 수정
	public function modify(Customer $customer, Request $request)
	{
		$customer_data = [

		];

		$customer->update($customer_data);
		return redirect()->intended(route('customer.list'));
	}

	// 고객 삭제
	public function delete(Customer $customer)
	{
		$customer->delete(); // softDelete
//		$customer->forceDelete(); // 완전히 삭제

		return redirect()->intended(route('customer.list'));
	}


}
