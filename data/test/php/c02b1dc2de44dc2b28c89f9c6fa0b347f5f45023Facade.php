<?php
/**
 * Sourcecode modified from Laravel Framework
 * 
 */
namespace GL\Core\Facades;
 
use RuntimeException;
 

abstract class Facade
{
    
   
    protected static $resolvedInstance;

  
    public static function getFacadeRoot()
    {
        return static::resolveFacadeInstance(static::getFacadeAccessor());
    }

  
    protected static function getFacadeAccessor()
    {
        throw new RuntimeException('Facade does not implement getFacadeAccessor method.');
    }

    
    protected static function resolveFacadeInstance($name)
    {
        if (is_object($name)) {
            return $name;
        }

        if (isset(static::$resolvedInstance[$name])) {
            return static::$resolvedInstance[$name];
        }

        return static::$resolvedInstance[$name] = \GL\Core\DI\ServiceProvider::GetDependencyContainer()->get($name);
    }

  
    public static function clearResolvedInstance($name)
    {
        unset(static::$resolvedInstance[$name]);
    }

   
    public static function clearResolvedInstances()
    {
        static::$resolvedInstance = [];
    }
 
   
    public static function __callStatic($method, $args)
    {
        $instance = static::getFacadeRoot();

        if (! $instance) {
            throw new RuntimeException('A facade root has not been set.');
        }

        return call_user_func_array(array($instance, $method), $args);
    }
}
