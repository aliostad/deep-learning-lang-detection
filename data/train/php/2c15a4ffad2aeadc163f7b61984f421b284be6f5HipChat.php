<?php namespace Jessu\LaravelHipChat\Facades;

use Illuminate\Support\Facades\Facade;

/**
 * This is the hipchat facade class.
 *
 * @author    Jesus Leon <git@jes.mx>
 * @copyright 2014 Jesus Leon
 * @license   <https://github.com/Jessu/laravel-hipchat/blob/master/LICENSE> The MIT License (MIT)
 */
class HipChat extends Facade {

    /**
     * Get the registered name of the component.
     *
     * @return string
     */
    protected static function getFacadeAccessor()
    {
        return 'hipchat';
    }
} 