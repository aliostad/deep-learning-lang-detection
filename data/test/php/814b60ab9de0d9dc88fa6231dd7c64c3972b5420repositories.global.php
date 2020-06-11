<?php
return [

    'dependencies' => [
        'factories' => [
            \App\Domain\Repository\CountryRepositoryInterface::class => \App\Infrastructure\Factory\Repository\Country\MySQLCountryRepositoryFactory::class,
            \App\Domain\Repository\CityRepositoryInterface::class => \App\Infrastructure\Factory\Repository\City\MySQLCityRepositoryFactory::class,
            \App\Domain\Repository\InterestRepositoryInterface::class => \App\Infrastructure\Factory\Repository\Interest\MySQLInterestRepositoryFactory::class,
            \App\Domain\Repository\HotelRepositoryInterface::class => \App\Infrastructure\Factory\Repository\Hotel\MySQLHotelRepositoryFactory::class,
            \App\Domain\Repository\PlaceRepositoryInterface::class => \App\Infrastructure\Factory\Repository\Place\MySQLPlaceRepositoryFactory::class,
            \App\Domain\Repository\TourRepositoryInterface::class => \App\Infrastructure\Factory\Repository\Tour\MySQLTourRepositoryFactory::class,

            //
            \App\Infrastructure\Repository\City\MySQLCityHydrator::class => \App\Infrastructure\Factory\Repository\City\MySQLCityHydratorFactory::class
        ]
    ]
];