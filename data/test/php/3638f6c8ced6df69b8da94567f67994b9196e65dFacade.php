<?php
/**
 * Created by PhpStorm.
 * User: Adebola
 * Date: 29/08/2014
 * Time: 11:50
 */

namespace Samcrosoft\Accesstory\Facade;

/**
 * Class Facade
 * @package Samcrosoft\Accesstory\Facade
 */
class Facade extends \Illuminate\Support\Facades\Facade {
    /**
     * @static
     * @var string
     */
    const FACADE_NAME = "accesstory";

    /**
     * Get the registered name of the component.
     *
     * @return string
     */
    protected static function getFacadeAccessor() { return self::FACADE_NAME; }
}