<?php

class LimonadeFactory{

    private $apis;

    public function __construct(){
        $this->apis = array();
    }
    
    public function instantiate_api($api_prefix, $api_name){
        return new LimonadeAPI($api_prefix, $api_name);
    }

    public function create_api($api_prefix, $api_name){
        $created_api = $this->instantiate_api($api_prefix, $api_name);
        return $this->register_api($created_api);
    }
    
    protected function register_api($created_api){
        $this->apis[] = $created_api;
        return $created_api;
    }

    public function serve(){
        foreach($this->apis as $api){
            $api->serve();
        }
        run();
    }
}