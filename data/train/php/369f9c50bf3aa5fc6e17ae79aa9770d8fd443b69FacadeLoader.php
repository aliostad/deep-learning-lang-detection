<?php
namespace Cubex\Facade;

class FacadeLoader
{
  public static $registered;

  public static $aliases = [
    'Log'           => '\Cubex\Facade\Log',
    'Cubex\Log\Log' => '\Cubex\Facade\Log',
    'Cookie'        => '\Cubex\Facade\Cookie',
    'Auth'          => '\Cubex\Facade\Auth',
  ];

  public static function register()
  {
    if(!static::$registered)
    {
      spl_autoload_register([__CLASS__, "load"]);
    }
    static::$registered = true;
  }

  public static function addAlias($alias, $class)
  {
    static::$aliases[$alias] = $class;
    return true;
  }

  public static function load($class)
  {
    if(isset(static::$aliases[$class]))
    {
      class_alias(static::$aliases[$class], $class);
      return true;
    }
    return false;
  }
}
