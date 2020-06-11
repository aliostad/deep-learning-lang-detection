<?php

namespace EasyClient\Client;

use Illuminate\Support\Facades\Facade as LaravelFacade;

class Facade extends LaravelFacade
{
    /**
     * 默认为 Server.
     *
     * @return string
     */
    public static function getFacadeAccessor()
    {
        return 'client';
    }

    /**
     * 获取SSO Server服务
     *
     * @param string $name
     * @param array  $args
     *
     * @return mixed
     */
    public static function __callStatic($name, $args)
    {
        $app = static::getFacadeRoot();

        if (method_exists($app, $name)) {
            return call_user_func_array([$app, $name], $args);
        }

        return $app->$name;
    }
}
