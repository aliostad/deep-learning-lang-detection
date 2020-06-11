<?php

namespace CodeDelivery\Providers;

use CodeDelivery\Repositories\CategoryRepository;
use CodeDelivery\Repositories\CategoryRepositoryEloquent;
use CodeDelivery\Repositories\ClientRepository;
use CodeDelivery\Repositories\ClientRepositoryEloquent;
use CodeDelivery\Repositories\OrderRepository;
use CodeDelivery\Repositories\OrderRepositoryEloquent;
use CodeDelivery\Repositories\ProductRepository;
use CodeDelivery\Repositories\ProductRepositoryEloquent;
use CodeDelivery\Repositories\UserRepository;
use CodeDelivery\Repositories\UserRepositoryEloquent;
use Illuminate\Support\ServiceProvider;

class RepositoryServiceProvider extends ServiceProvider
{
    /**
     * Register the application services.
     *
     * @return void
     */
    public function register()
    {
        $models = array(
            'Category',
            'Product'
        );

        $this->app->bind(
            CategoryRepository::class,CategoryRepositoryEloquent::class
        );
        $this->app->bind(
            ProductRepository::class,ProductRepositoryEloquent::class
        );
        $this->app->bind(
            ClientRepository::class,ClientRepositoryEloquent::class
        );
        $this->app->bind(
            UserRepository::class,UserRepositoryEloquent::class
        );
        $this->app->bind(
            OrderRepository::class,OrderRepositoryEloquent::class
        );
    }
}
