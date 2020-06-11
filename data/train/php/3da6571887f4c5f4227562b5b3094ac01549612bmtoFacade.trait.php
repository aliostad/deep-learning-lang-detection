<?php
trait mtoFacade
{
    public static function __callStatic($method, $args)
    {
        $obj = static :: resolveFacadeInstance();
        switch (count($args))
        {
            case 0:
                return $obj->$method();
            break;
            case 1:
                return $obj->$method($args[0]);
            break;
            case 2:
                return $obj->$method($args[0], $args[1]);
            break;
            case 3:
                return $obj->$method($args[0], $args[1], $args[2]);
            break;
            case 4:
                return $obj->$method($args[0], $args[1], $args[2], $args[3]);
            break;
            case 5:
                return $obj->$method($args[0], $args[1], $args[2], $args[3], $args[4]);
            break;
            default:
                return call_user_func_array(array($obj, $method), $args);
            break;
        }
    }

    private static function resolveFacadeInstance()
    {
        if (empty(static :: $_facade_owner))
        {
            throw new mtoException("Facade methods can not be called directly");
        }
        $class = static :: $_facade_owner;
        return $class :: instance();
    }

    function createFacade($facade)
    {
        $code = 'class ' . $facade . ' {use mtoFacade; private static $_facade_owner="'.get_class($this).'";}';
        eval($code);
    }

}