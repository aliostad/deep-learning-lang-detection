<?php
/**
 * Created by PhpStorm.
 * User: Adebola
 * Date: 03/09/2014
 * Time: 10:13
 */

namespace Samcrosoft\ActiveMenu\Facade;

/**
 * Class Facade
 * @package Samcrosoft\ActiveMenu\Facade
 */
class Facade extends \Illuminate\Support\Facades\Facade {

    /**
     * @static
     * @var string
     */
    const FACADE_NAME = "activemenu";

    /**
     * Get the registered name of the component.
     *
     * @return string
     */
    protected static function getFacadeAccessor()
    {
        return self::FACADE_NAME;
    }


} 