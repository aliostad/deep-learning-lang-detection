<?php
/**
 * Created by PhpStorm.
 * User: melodic
 * Date: 03.10.16
 * Time: 16:23
 */
namespace App\Domain\Factory\Service;


use App\Domain\Repository\CityRepositoryInterface;
use App\Domain\Repository\HotelRepositoryInterface;
use App\Domain\Repository\InterestRepositoryInterface;
use App\Domain\Repository\PlaceRepositoryInterface;
use App\Domain\Service\CityService;
use Interop\Container\ContainerInterface;


class CityServiceFactory
{

    public function __invoke(ContainerInterface $container)
    {
        /**
         * @var CityRepositoryInterface $cityRepository
         */
        $cityRepository = $container->get(CityRepositoryInterface::class);

        /**
         * @var InterestRepositoryInterface $interestRepository
         */
        $interestRepository = $container->get(InterestRepositoryInterface::class);

        /**
         * @var PlaceRepositoryInterface $placeRepository
         */
        $placeRepository = $container->get(PlaceRepositoryInterface::class);

        /**
         * @var HotelRepositoryInterface $hotelRepository
         */
        $hotelRepository = $container->get(HotelRepositoryInterface::class);

        return new CityService($cityRepository, $interestRepository, $placeRepository, $hotelRepository);
    }
}