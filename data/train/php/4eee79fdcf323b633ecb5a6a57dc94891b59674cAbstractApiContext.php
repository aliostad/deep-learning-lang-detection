<?php
/**
 * Created by PhpStorm.
 * User: nbmac4
 * Date: 7/14/16
 * Time: 2:50 PM
 */

namespace Nbos\Api;


abstract class AbstractApiContext implements ApiContext {
    public static $apiContexts = array();
    public  $name;

    public static function registerApiContext($apiContext) {
        self::$apiContexts[$apiContext->getName()] = $apiContext;
    }

    public static function get($name) {
        /*if (!array_key_exist($name, self::$apiContexts)) {
            self::$apiContext[$name] = new InMemoryApiContext();
        }
        */
        return self::$apiContexts[$name];
    }
    public function __construct($name){
        $this->name = $name;
    }
} 