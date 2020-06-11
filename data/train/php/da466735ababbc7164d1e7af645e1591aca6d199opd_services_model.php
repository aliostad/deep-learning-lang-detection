<?php
class opd_services_model extends IgnitedRecord {
	function save_service($service_name,$service_desc,$service_price) {
		$value = $this->new_record();		
		$value->name = $service_name;
		$value->description = $service_desc;
		$value->price = $service_price;
		$value->save();
		return $value;
	}
	
	function block_service($service_id) {		
		$service = $this->find_by('id', $service_id);
		$service->status = 0;
		$service->save();	
	}
	
	function unblock_service($service_id) {		
		$service = $this->find_by('id', $service_id);
		$service->status = 1;
		$service->save();
	}	
	
}