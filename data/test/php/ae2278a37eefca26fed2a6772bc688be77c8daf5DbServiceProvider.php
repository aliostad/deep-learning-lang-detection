<?php namespace core\src\Provider;

use Illuminate\Support\ServiceProvider;

/**
 * Class DbServiceProvider
 *
 * @package zcore\src\Provider
 */
class DbServiceProvider extends ServiceProvider {

    /**
     * Register the binding
     *
     * @return void
     */
    public function register()
    {
        $app = $this->app;
        $app->bind("core\src\Repository\ProductRepositoryInterface", "core\src\Repository\AvosProductRepository");
        $app->bind("core\src\Repository\ProductRepositoryInterface", "core\src\Repository\ParseProductRepository");
    }
}
