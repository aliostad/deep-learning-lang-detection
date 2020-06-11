<?php namespace redhotmayo\dataaccess;

use Illuminate\Support\ServiceProvider;
use redhotmayo\dataaccess\repository\sql\AccountRepositorySQL;
use redhotmayo\dataaccess\repository\sql\BillingRepositorySQL;
use redhotmayo\dataaccess\repository\sql\CuisineRepositorySQL;
use redhotmayo\dataaccess\repository\sql\FoodServicesRepositorySQL;
use redhotmayo\dataaccess\repository\sql\MobileDeviceRepositorySQL;
use redhotmayo\dataaccess\repository\sql\SubscriptionRepositorySQL;
use redhotmayo\dataaccess\repository\sql\ThrottleRegistrationRepositorySQL;
use redhotmayo\dataaccess\repository\sql\UserRepositorySQL;
use redhotmayo\dataaccess\repository\sql\ZipcodeRepositorySQL;
use redhotmayo\registration\exceptions\ThrottleException;

class DataAccessServiceProvider extends ServiceProvider {

    /**
     * Register the service provider.
     *
     * @return void
     */
    public function register() {
        //todo: if we're using SQL... :
//        $this->app->bind('redhotmayo\dataaccess\repository\dao\BillingDAO', BillingSQL::DAO);

        $this->app->bind('redhotmayo\dataaccess\repository\AccountRepository', AccountRepositorySQL::SERVICE);
        $this->app->bind('redhotmayo\dataaccess\repository\UserRepository', UserRepositorySQL::SERVICE);
        $this->app->bind('redhotmayo\dataaccess\repository\SubscriptionRepository', SubscriptionRepositorySQL::SERVICE);
        $this->app->bind('redhotmayo\dataaccess\repository\ZipcodeRepository', ZipcodeRepositorySQL::SERVICE);
        $this->app->bind('redhotmayo\dataaccess\repository\CuisineRepository', CuisineRepositorySQL::SERVICE);
        $this->app->bind('redhotmayo\dataaccess\repository\FoodServicesRepository', FoodServicesRepositorySQL::SERVICE);
        $this->app->bind('redhotmayo\dataaccess\repository\MobileDeviceRepository', MobileDeviceRepositorySQL::SERVICE);
        $this->app->bind('redhotmayo\dataaccess\repository\BillingRepository', BillingRepositorySQL::SERVICE);
        $this->app->bind('redhotmayo\dataaccess\repository\ThrottleRegistrationRepository', ThrottleRegistrationRepositorySQL::SERVICE);

        $this->app->bind('AccountRepository', AccountRepositorySQL::SERVICE);
        $this->app->bind('UserRepository', UserRepositorySQL::SERVICE);
        $this->app->bind('SubscriptionRepository', SubscriptionRepositorySQL::SERVICE);
        $this->app->bind('ZipcodeRepository',ZipcodeRepositorySQL::SERVICE);
        $this->app->bind('CuisineRepository',CuisineRepositorySQL::SERVICE);
        $this->app->bind('FoodServicesRepository',FoodServicesRepositorySQL::SERVICE);
        $this->app->bind('MobileDeviceRepository',MobileDeviceRepositorySQL::SERVICE);
        $this->app->bind('BillingRepository',BillingRepositorySQL::SERVICE);
        $this->app->bind('ThrottleRegistrationRepository',ThrottleRegistrationRepositorySQL::SERVICE);
    }
}
