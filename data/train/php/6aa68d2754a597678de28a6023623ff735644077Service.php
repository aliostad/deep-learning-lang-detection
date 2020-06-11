<?php

class Service extends Eloquent {
	
	public $timestamps = false;
	
	public function location() {
		return $this->belongsTo('Location');
	}
	
	public function popularity() {
		return $this->belongsTo('Popularity');
	}
	
	public function serviceName($service_id) {
		$sql = 'SELECT service_name FROM queue_service WHERE service_id=?';
		return DB::selectOne($sql, array($service_id))->service_name;
	}
	
	public function status($service_id) {
		$sql = 'SELECT status FROM queue_service WHERE service_id=?';
		return DB::selectOne($sql, array($service_id))->status;
	}
	
	public function addService($service_name) {
		$sql = 'INSERT INTO queue_service (service_name) VALUES (?)';
		DB::insert($sql, array($service_name));
	}
	
	public function updateServiceName($service_name, $service_id) {
		$sql = 'UPDATE queue_service SET service_name=? WHERE service_id=?';
		DB::update($sql, array($service_name, $service_id));
	}
	
	public function updateStatus($status, $service_id) {
		$sql = 'UPDATE queue_service SET status=? WHERE service_id=?';
		DB::update($sql, array($status, $service_id));
	}
	
	public function fetchAvailableServices() {
		$services = array();
		$sql = 'SELECT service_id, service_name FROM queue_service WHERE status=?';
		$res = DB::select($sql, array(1));
		foreach ($res as $key => $value) {
			$services[$value->service_id] = $value->service_name;
		}
		return $services;
	}
	
	public function fetchServices() {
		$sql = 'SELECT service_id, service_name, status FROM queue_service';
		return DB::select($sql);
	}
	
	public function joinService($user_id, $service_id, $others = array()) {
		$other_data = implode(";", $others);
		$sql = 'INSERT INTO user_service (user_id, service_id, other_data)
				VALUES (?, ?, ?)';
		DB::insert($sql, array($user_id, $service_id, $other_data));
	}
	
	public function deleteService($service_id) {
		$sql = 'DELETE FROM queue_service WHERE service_id=?';
		DB::delete($sql, array($service_id));
		$sql = 'DELETE FROM user_service WHERE service_id=?';
		DB::delete($sql, array($service_id));
	}
	
	public function checkSignupStatus($user_id, $service_id) {
		$sql = 'SELECT COUNT(*) AS service_count FROM user_service WHERE service_id=? AND user_id=?';
		return DB::selectOne($sql, array($service_id, $user_id))->service_count;
	}
	
	public function signup($user_id, $service_id) {
		$sql = 'INSERT INTO user_service (user_id, service_id) VALUES (?, ?)';
		DB::insert($sql, array($user_id, $service_id));
	}
	
}