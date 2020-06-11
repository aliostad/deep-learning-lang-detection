<?php

namespace unittests;
include "./test_include.php";

class api_test extends \PHPUnit_Framework_TestCase {
    
    public function testInstantiate($api = 'api\api') {
        $api = $api::get_instance();
        $this->assertInstanceOf('api\api', $api);
        return $api;
    }

    /**
    * @depends testInstantiate
    */   
    public function testSetApi($api){

        $api = $api->set_api();
        $this->assertInstanceOf('api\api', $api);
        return $api;
    }

    /**
    * @depends testSetApi
    */   
    public function testSetAggregates($api){

        $api = $api->set_aggregates();
        $this->assertInstanceOf('api\api', $api);
        return $api;
    }

    /**
    * @depends testSetApi
    */   
    public function testLoader($api){

        $loader = $api->loader();
        $this->assertInstanceOf('api\loader', $loader);
        return $loader;
    }

    /**
    * @depends testSetApi
    */   
    public function testFactory($api){

        $factory = $api->factory();
        $this->assertInstanceOf('api\factory',  $factory );
        return $api;
    }

    /**
    * @depends testSetApi
    */   
    public function testFactoryInstance($api){

        $factory = $api->factory_instance();
        $this->assertInstanceOf('api\factory_instance', $factory);
        return $api;
    }

    /**
    * @depends testSetApi
    */   
    public function testReusable($api){

        $reusable = $api->reusable();
        $this->assertInstanceOf('api\reusable', $reusable);
        return $api;
    }

    /**
    * @depends testSetApi
    */   
    public function testReusableInstance($api){

        $reusable = $api->reusable_instance();
        $this->assertInstanceOf('api\reusable_instance', $reusable);
        return $api;
    }
 
}

