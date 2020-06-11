<?php

namespace Emcodenet\SabreLaravelBridge;

use Illuminate\Support\Facades\Facade as IlluminateFacade;

class Facade extends IlluminateFacade {

    /**
     * Get the registered name of the component.
     *
     * @return string
     */
    protected static function getFacadeAccessor() { return 'soapera'; }

    /**
     * Resolve a new instance
     */
    public static function __callStatic($method, $args)
    {
        $instance = static::$app->make(static::getFacadeAccessor());

        return call_user_func_array(array($instance, $method), $args);

    }


}
