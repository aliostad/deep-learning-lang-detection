<?php
/**
 * api
 * ----------------------------------------------
 * author AT
 * ----------------------------------------------
 * time 2016-12-22
 *----------------------------------------------
 */


namespace App\Libraries;

use RuntimeException;

abstract class Facade {
	static public $resolvedInstance;
	static public $app;
	/**
	 * [getFacadeAccessor 获取访问器]
	 * @return [type] [description]
	 */
	static public function getFacadeAccessor() {
		throw new RuntimeException('Facade does not implement getFacadeAccessor method.');
	}

	/**
	 * [getInstance 获取实例]
	 * @return [object] [instance]
	 */
	static public function getFacadeRoot() {
		return static::resolveFacadeInstance(static::getFacadeAccessor());

	}

	static function resolveFacadeInstance($name) {

		if( is_object($name) ) {
			return $name;
		}
		if (isset(static::$resolvedInstance[$name])) {
            return static::$resolvedInstance[$name];
        }

        return static::$resolvedInstance[$name] = new $name();

	}

	/**
	 * [__callStatic 魔术方法]
	 * @param  [string] $method [调用的方法]
	 * @param  [array] $args   [参数]
	 * @return [mixed]         [mixed]
	 */
	static public function __callStatic($method,$args) {
	
		$instance = self::getFacadeRoot();

		if (! $instance) {
            throw new RuntimeException('A facade root has not been set.');
        }
     
        return $instance->$method(...$args);
	}

}
