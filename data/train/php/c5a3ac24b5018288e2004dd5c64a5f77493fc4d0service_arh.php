<?php

class Service_arh extends APP_Model {

    public $_table = 'service_arh';
    public $primary_key = 'id_service_arh';
    protected $return_type = 'array';

    public function to_arhive($old_id_service) {
        $this->load->model('service_arh_property');
        $service = $this->service->get($old_id_service);
        unset($service['id_service']);
        $id_service=$this->insert($service);
        $properties=$this->service_property->get_many_by(array('id_service'=>$old_id_service));
        foreach ($properties as $values){
            $values['id_service_arh']=$id_service;
            $old_id_service_property=$values['id_service_property'];
            unset($values['id_service_property']);
            unset($values['id_service']);
            $this->service_arh_property->insert($values);
            $this->service_property->delete($old_id_service_property);
        }
        $this->service->delete($old_id_service);
    }

}