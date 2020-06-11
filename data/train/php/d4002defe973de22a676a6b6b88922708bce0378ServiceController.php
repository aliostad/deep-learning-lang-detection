<?php

class ServiceController extends BaseController {
	
	protected $layout = 'service.service';
	
	public function __construct() {
		$this->beforeFilter('csrf', array('on'=>'post'));
	}
	
	public function getList() {
		if (Auth::check()) {
			if (Auth::user()->user_id == 1) {
				$Service = new Service();
				$services = $Service->fetchServices();
				$service_array = array();
				if (isset($services)) {
					foreach ($services as $key => $object) {
						$service_array[$key]['service_id'] = $object->service_id;
						$service_array[$key]['service_name'] = $object->service_name;
						$service_array[$key]['status'] = $object->status;
					}
				}
				$this->layout->content = View::make('service.service-list')
					->with('services', $service_array);
			}
			else {
				return Redirect::to('/')
					->with('error' , 'You need to be an admin to view this page.');
			}
		}
		else {
			return Redirect::to('/')
				->with('error' , 'You need to be logged in to view this page.');
		}
	}
	
	public function postCreate() {
		$service_name = Input::get('service_name');
		$Service = new Service();
		$Service->addService($service_name);
		return Redirect::to('service/add')
			->with('message', 'The service ' . $service_name . ' has been added.');
	}
	
	public function getAdd() {
		if (Auth::user()->user_id == 1) {
			$this->layout->content = View::make('service.service-add');
		}
		else {
			return Redirect::to('/')
			->with('error', 'You are not allowed to view that page.');
		}
	}
	
	public function postEdit() {
		$service_id = Input::get('service_list');
		$service_name = Input::get('new_service_name');
		$Service = new Service();
		$Service->updateServiceName($service_name, $service_id);
		return Redirect::to('service/list')
		->with('message', 'A service has been renamed to ' . $service_name . '.');
	}
	
	public function postUpdatedelete() {
		$for_deletion = Input::get('service_delete');
		$Service = new Service();
		$delete_message = '';
		$service_ids = $Service->fetchServices();
		foreach ($service_ids as $key => $object) {
			$count = 0;
						
			// update the status of the service (active/inactive)
			$status = Input::get('service_status_' . $object->service_id);
			$Service->updateStatus($status, $object->service_id);
			
			while ($count < count($for_deletion)) {
				if ($object->service_id == $for_deletion[$count]) {
					$delete_message .= 'Service ' . $object->service_name . ' has been removed.<br/>';
					$Service->deleteService($object->service_id);
				}
				$count++;
			}
		}
		return Redirect::to('service/list')
			->with('message', $delete_message . '<br>The changes have been saved.');
	}
	
	public function postSignupRemove() {
		
	}
	
}