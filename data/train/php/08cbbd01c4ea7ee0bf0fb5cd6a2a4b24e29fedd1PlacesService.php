<?php namespace services;

use repositories\AdministrativeAreaRepository;
use repositories\CountryRepository;
use repositories\PlaceRepository;
use repositories\ThingRepository;

class PlacesService {

    protected $countryRepository;

    protected $placeRepository;

    protected $administrativeAreaRepository;

    protected $thingRepository;

    /**
     * @param PlaceRepository $placeRepository
     * @param AdministrativeAreaRepository $administrativeAreaRepository
     * @param CountryRepository $countryRepository
     * @param ThingRepository $thingRepository
     */
    function __construct(PlaceRepository $placeRepository, AdministrativeAreaRepository $administrativeAreaRepository, CountryRepository $countryRepository, ThingRepository $thingRepository)
    {
        $this->placeRepository = $placeRepository;
        $this->administrativeAreaRepository = $administrativeAreaRepository;
        $this->countryRepository = $countryRepository;
        $this->thingRepository = $thingRepository;
    }

    public function getAllTheCountries()
    {
        $countries = $this->countryRepository->all();

        $countryNames = array();

        foreach ($countries as $country)
        {
            $countryNames[$country->id] = $country->administrativeArea->place->thing->name;
        }

        return $countryNames;
    }

    public function addCountries($countries)
    {
        foreach($countries as $countryName)
        {
            $thing = $this->thingRepository->create(array('name' => trim($countryName)));

            $this->placeRepository->create(array('id' => $thing->id));

            $this->administrativeAreaRepository->create(array('id' => $thing->id));

            $this->countryRepository->create(array('id' => $thing->id));
        }
    }
}