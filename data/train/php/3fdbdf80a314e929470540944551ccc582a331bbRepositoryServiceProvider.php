<?php
namespace Transnatal\Providers;

use Illuminate\Support\ServiceProvider;

class RepositoryServiceProvider extends ServiceProvider {

	public function register() {

		$this->app->bind('Transnatal\Interfaces\AddressRepositoryInterface', 
			'Transnatal\Repositories\DbAddressRepository');

		$this->app->bind('Transnatal\Interfaces\ClientRepositoryInterface',
			'Transnatal\Repositories\DbClientRepository');

		$this->app->bind('Transnatal\Interfaces\EmployeeRepositoryInterface',
			'Transnatal\Repositories\DbEmployeeRepository');

		$this->app->bind('Transnatal\Interfaces\UserRepositoryInterface',
			'Transnatal\Repositories\DbUserRepository');

		$this->app->bind('Transnatal\Interfaces\VehicleRepositoryInterface',
			'Transnatal\Repositories\DbVehicleRepository');

		$this->app->bind('Transnatal\Interfaces\TravelRepositoryInterface',
			'Transnatal\Repositories\DbTravelRepository');

		$this->app->bind('Transnatal\Interfaces\ServiceOrderTravelRentedCarRepositoryInterface',
			'Transnatal\Repositories\DbServiceOrderTravelRentedCarRepository');

		$this->app->bind('Transnatal\Interfaces\TravelRentedCarRepositoryInterface',
			'Transnatal\Repositories\DbTravelRentedCarRepository');

		$this->app->bind('Transnatal\Interfaces\NewsRepositoryInterface',
			'Transnatal\Repositories\DbNewsRepository');

		$this->app->bind('Transnatal\Interfaces\ServiceOrderRepositoryInterface',
			'Transnatal\Repositories\DbServiceOrderRepository');
	}
}