<?php
/**
 * @author  brooke.bryan
 */

namespace Cubex\Core\Loader;

class ClassAliasLoader
{
  public static $registered;

  public static $aliases = [
    'Log'               => '\Cubex\Log\Log',
    'Auth'              => '\Cubex\Facade\Auth',
    'Cache'             => '\Cubex\Facade\Cache',
    'Cassandra'         => '\Cubex\Facade\Cassandra',
    'DB'                => '\Cubex\Facade\DB',
    'Email'             => '\Cubex\Facade\Email',
    'Encryption'        => '\Cubex\Facade\Encryption',
    'FeatureSwitch'     => '\Cubex\Facade\FeatureSwitch',
    'PlatformDetection' => '\Cubex\Facade\PlatformDetection',
    'Queue'             => '\Cubex\Facade\Queue',
    'Redirect'          => '\Cubex\Facade\Redirect',
    'Session'           => '\Cubex\Facade\Session',
  ];

  public static function register()
  {
    if(!static::$registered)
    {
      spl_autoload_register([__CLASS__, "load"]);
    }
    static::$registered = true;
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
