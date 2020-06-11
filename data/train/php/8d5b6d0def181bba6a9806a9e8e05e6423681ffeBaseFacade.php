<?php namespace DreamFactory\Library\Utility\Facades;

use Illuminate\Contracts\Foundation\Application;
use Illuminate\Support\Facades\Facade;

class BaseFacade extends Facade
{
    //******************************************************************************
    //* Methods
    //******************************************************************************

    /**
     * Returns the/an instance of the service this facade covers
     *
     * @param \Illuminate\Contracts\Foundation\Application|null $app
     *
     * @return mixed
     */
    public static function service(Application $app = null)
    {
        $_app = $app ?: app();

        /** @noinspection PhpUndefinedMethodInspection */
        return $_app->make(static::getFacadeAccessor());
    }
}
