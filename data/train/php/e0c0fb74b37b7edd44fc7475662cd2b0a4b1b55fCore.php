<?php
namespace Plugins\FluxAPI\Core;

class Core extends \FluxAPI\Plugin
{
    public static $rest;

    public static function register(\FluxAPI\Api $api)
    {
        self::_registerValidators($api);
        self::_registerModelEvents($api);
    }

    public static function getRest()
    {
        return self::$rest;
    }

    protected static function _registerValidators(\FluxAPI\Api $api)
    {
        // register validator service if not present yet
        if (!isset($api->app['validator'])) {
            $api->app->register(new \Silex\Provider\ValidatorServiceProvider());
        }
    }

    protected static function _registerModelEvents(\FluxAPI\Api $api)
    {
        if (!in_array('FluxAPI/Core/ModelEvents', $api->config['plugin.options']['disabled'])) {
            ModelEvents::register($api);
        }
    }
}
