<?php namespace Carbontwelve\Menu\Facades;
/**
 * --------------------------------------------------------------------------
 * Carbontwelve\Menu\Facades
 * --------------------------------------------------------------------------
 *
 * Menu Facade for Laravel
 *
 * @package  Carbontwelve\Menu
 * @category Facade
 * @version  1.0.0
 * @author   Simon Dann <simon.dann@gmail.com>
 */

use Illuminate\Support\Facades\Facade;

class Menu extends Facade {

    /**
     * Get the registered name of the component.
     *
     * @return string
     */
    protected static function getFacadeAccessor()
    {
        return 'carbontwelve.menu';
    }

}
