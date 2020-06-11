<?php namespace src\Storage;
 
use Illuminate\Support\ServiceProvider;
 
class StorageServiceProvider extends ServiceProvider 
{ 
  public function register()
  {
    $this->app->bind(
      'src\Repository\Interfaces\ITypeItemRepository',
      'src\Repository\TypeItemRepository'
    );

    $this->app->bind(
      'src\Repository\Interfaces\IRealtyRepository',
      'src\Repository\RealtyRepository'
    );

    $this->app->bind(
      'src\Repository\Interfaces\IRealtyCodeRepository',
      'src\Repository\RealtyCodeRepository'
    );

    $this->app->bind(
      'src\Repository\Interfaces\IRealtorRepository',
      'src\Repository\RealtorRepository'
    );

    $this->app->bind(
      'src\Repository\Interfaces\IRealtyImageRepository',
      'src\Repository\RealtyImageRepository'
    );

    $this->app->bind(
      'src\Repository\Interfaces\IRealtyPropertyRepository',
      'src\Repository\RealtyPropertyRepository'
    );
  }
}