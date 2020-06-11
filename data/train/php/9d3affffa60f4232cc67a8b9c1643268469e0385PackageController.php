<?php namespace App\Http\Controllers;

use App\Http\Requests;
use App\Http\Requests\PackageRequest;
use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Package;
use App\Service;
use Auth;
use App\User;
use DB;

class PackageController extends Controller {


	public function __construct()
	{
		$this->middleware('auth');
	}

	/**
	 * Display a listing of the resource.
	 *
	 * @return Response
	 */
	public function index()
	{
		$thisUser = Auth::user();
		$packages = Package::where('user_id', $thisUser->id)->orderBy('package_name', 'ASC')->get();
		return view('packages', compact('packages', 'thisUser'));
	}

	public function index2()
	{
		$thisUser = Auth::user();
		$packages = Package::where('user_id', $thisUser->id)->orderBy('category', 'ASC')->get();
		return view('packages', compact('packages', 'thisUser'));
	}

	/**
	 * Show the form for creating a new resource.
	 *
	 * @return Response
	 */
	public function create()
	{
		//
	}

	/**
	 * Store a newly created resource in storage.
	 *
	 * @return Response
	 */
	public function store(Request $request)
	{
		$packageName = $request['package_name'];
		$category = $request['gig_category'];
		$service0 = [$request['service-quantity0'], $request['service-name0'], $request['service-price0']];
		$service1 = [$request['service-quantity1'], $request['service-name1'], $request['service-price1']];
		$service2 = [$request['service-quantity2'], $request['service-name2'], $request['service-price2']];
		$service3 = [$request['service-quantity3'], $request['service-name3'], $request['service-price3']];
		$service4 = [$request['service-quantity4'], $request['service-name4'], $request['service-price4']];
		$service5 = [$request['service-quantity5'], $request['service-name5'], $request['service-price5']];
		$service6 = [$request['service-quantity6'], $request['service-name6'], $request['service-price6']];
		$service7 = [$request['service-quantity7'], $request['service-name7'], $request['service-price7']];
		$service8 = [$request['service-quantity8'], $request['service-name8'], $request['service-price8']];
		$service9 = [$request['service-quantity9'], $request['service-name9'], $request['service-price9']];

		$package = new Package;
		$package->user_id = Auth::id();
		$package->package_name = $packageName;
		$package->category = $category;
		$package->save();
		$packageID = $package->id;

		if (!empty($service0[1])) {
			$service = new Service;
			$service->service_qty = $service0[0];
			$service->service_name = $service0[1];
			$service->service_price = $service0[2];
			$service->package_id = $packageID;
			$service->save();
		}
		if (!empty($service1[1])) {
			$service = new Service;
			$service->service_qty = $service1[0];
			$service->service_name = $service1[1];
			$service->service_price = $service1[2];
			$service->package_id = $packageID;
			$service->save();
		}
		if (!empty($service2[1])) {
			$service = new Service;
			$service->service_qty = $service2[0];
			$service->service_name = $service2[1];
			$service->service_price = $service2[2];
			$service->package_id = $packageID;
			$service->save();
		}
		if (!empty($service3[1])) {
			$service = new Service;
			$service->service_qty = $service3[0];
			$service->service_name = $service3[1];
			$service->service_price = $service3[2];
			$service->package_id = $packageID;
			$service->save();
		}
		if (!empty($service4[1])) {
			$service = new Service;
			$service->service_qty = $service4[0];
			$service->service_name = $service4[1];
			$service->service_price = $service4[2];
			$service->package_id = $packageID;
			$service->save();
		}
		if (!empty($service5[1])) {
			$service = new Service;
			$service->service_qty = $service5[0];
			$service->service_name = $service5[1];
			$service->service_price = $service5[2];
			$service->package_id = $packageID;
			$service->save();
		}
		if (!empty($service6[1])) {
			$service = new Service;
			$service->service_qty = $service6[0];
			$service->service_name = $service6[1];
			$service->service_price = $service6[2];
			$service->package_id = $packageID;
			$service->save();
		}
		if (!empty($service7[1])) {
			$service = new Service;
			$service->service_qty = $service7[0];
			$service->service_name = $service7[1];
			$service->service_price = $service7[2];
			$service->package_id = $packageID;
			$service->save();
		}
		if (!empty($service8[1])) {
			$service = new Service;
			$service->service_qty = $service8[0];
			$service->service_name = $service8[1];
			$service->service_price = $service8[2];
			$service->package_id = $packageID;
			$service->save();
		}
		if (!empty($service9[1])) {
			$service = new Service;
			$service->service_qty = $service9[0];
			$service->service_name = $service9[1];
			$service->service_price = $service9[2];
			$service->package_id = $packageID;
			$service->save();
		}

		return redirect('packages');
	}

	/**
	 * Display the specified resource.
	 *
	 * @param  int  $id
	 * @return Response
	 */
	public function show(Package $package)
	{
		return view ('packageDetail')->with('package', $package);
	}

	/**
	 * Show the form for editing the specified resource.
	 *
	 * @param  int  $id
	 * @return Response
	 */
	public function edit(Package $package)
	{
		//
	}

	/**
	 * Update the specified resource in storage.
	 *
	 * @param  int  $id
	 * @return Response
	 */
	public function update(Package $package, Request $request, Service $service)
	{
		$packageName = $request['edit_package_name'];
		$category = $request['edit_gig_category'];
		$service0 = [$request['service-quantity-edit0'], $request['service-name-edit0'], $request['service-price-edit0']];
		$service1 = [$request['service-quantity-edit1'], $request['service-name-edit1'], $request['service-price-edit1']];
		$service2 = [$request['service-quantity-edit2'], $request['service-name-edit2'], $request['service-price-edit2']];
		$service3 = [$request['service-quantity-edit3'], $request['service-name-edit3'], $request['service-price-edit3']];
		$service4 = [$request['service-quantity-edit4'], $request['service-name-edit4'], $request['service-price-edit4']];
		$service5 = [$request['service-quantity-edit5'], $request['service-name-edit5'], $request['service-price-edit5']];
		$service6 = [$request['service-quantity-edit6'], $request['service-name-edit6'], $request['service-price-edit6']];
		$service7 = [$request['service-quantity-edit7'], $request['service-name-edit7'], $request['service-price-edit7']];
		$service8 = [$request['service-quantity-edit8'], $request['service-name-edit8'], $request['service-price-edit8']];
		$service9 = [$request['service-quantity-edit9'], $request['service-name-edit9'], $request['service-price-edit9']];

		$updatedPackage = $package;
		$updatedPackage->user_id = Auth::id();
		$updatedPackage->package_name = $packageName;
		$updatedPackage->category = $category;
		$updatedPackage->save();
		$packageID = $request->edit_package_id;

		DB::table('services')->where('package_id', $packageID)->delete();

		if (!empty($service0[1])) {
			$service = new Service;
			$service->service_qty = $service0[0];
			$service->service_name = $service0[1];
			$service->service_price = $service0[2];
			$service->package_id = $packageID;
			$service->save();
		}
		if (!empty($service1[1])) {
			$service = new Service;
			$service->service_qty = $service1[0];
			$service->service_name = $service1[1];
			$service->service_price = $service1[2];
			$service->package_id = $packageID;
			$service->save();
		}
		if (!empty($service2[1])) {
			$service = new Service;
			$service->service_qty = $service2[0];
			$service->service_name = $service2[1];
			$service->service_price = $service2[2];
			$service->package_id = $packageID;
			$service->save();
		}
		if (!empty($service3[1])) {
			$service = new Service;
			$service->service_qty = $service3[0];
			$service->service_name = $service3[1];
			$service->service_price = $service3[2];
			$service->package_id = $packageID;
			$service->save();
		}
		if (!empty($service4[1])) {
			$service = new Service;
			$service->service_qty = $service4[0];
			$service->service_name = $service4[1];
			$service->service_price = $service4[2];
			$service->package_id = $packageID;
			$service->save();
		}
		if (!empty($service5[1])) {
			$service = new Service;
			$service->service_qty = $service5[0];
			$service->service_name = $service5[1];
			$service->service_price = $service5[2];
			$service->package_id = $packageID;
			$service->save();
		}
		if (!empty($service6[1])) {
			$service = new Service;
			$service->service_qty = $service6[0];
			$service->service_name = $service6[1];
			$service->service_price = $service6[2];
			$service->package_id = $packageID;
			$service->save();
		}
		if (!empty($service7[1])) {
			$service = new Service;
			$service->service_qty = $service7[0];
			$service->service_name = $service7[1];
			$service->service_price = $service7[2];
			$service->package_id = $packageID;
			$service->save();
		}
		if (!empty($service8[1])) {
			$service = new Service;
			$service->service_qty = $service8[0];
			$service->service_name = $service8[1];
			$service->service_price = $service8[2];
			$service->package_id = $packageID;
			$service->save();
		}
		if (!empty($service9[1])) {
			$service = new Service;
			$service->service_qty = $service9[0];
			$service->service_name = $service9[1];
			$service->service_price = $service9[2];
			$service->package_id = $packageID;
			$service->save();
		}



		return redirect('packages');
	}

	/**
	 * Remove the specified resource from storage.
	 *
	 * @param  int  $id
	 * @return Response
	 */
	public function destroy(Package $package)
	{
		//
	}

	public function delete(Package $package, Request $request)
	{
		$uri = $request->url();
		$packageId = filter_var($uri, FILTER_SANITIZE_NUMBER_INT);
		DB::table('packages')->where('id', $packageId)->delete();
		return redirect('packages');
	}

}
