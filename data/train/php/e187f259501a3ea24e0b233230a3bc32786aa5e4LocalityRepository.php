<?php
namespace Weasty\Bundle\GeonamesBundle\Entity;

use JJs\Bundle\GeonamesBundle\Entity\Timezone;
use JJs\Bundle\GeonamesBundle\Model\LocalityRepositoryInterface;
use JJs\Bundle\GeonamesBundle\Model\LocalityInterface;
use JJs\Bundle\GeonamesBundle\Entity\TimezoneRepository;

/**
 * Class LocalityRepository
 * @package Weasty\Bundle\GeonamesBundle\Entity
 */
abstract class LocalityRepository extends GeonameRepository implements LocalityRepositoryInterface {

    /**
     * State Repository
     *
     * @var StateRepository
     */
    protected $stateRepository;

    /**
     * Country Repository
     *
     * @var CountryRepository
     */
    protected $countryRepository;

    /**
     * Timezone Repository
     *
     * @var TimezoneRepository
     */
    protected $timezoneRepository;

    /**
     * Returns the country repository
     *
     * @return CountryRepository
     */
    public function getCountryRepository()
    {
        return $this->countryRepository;
    }

    /**
     * Sets the country repository
     *
     * @param CountryRepository $countryRepository Country repository
     */
    public function setCountryRepository(CountryRepository $countryRepository)
    {
        $this->countryRepository = $countryRepository;
    }

    /**
     * Returns the timezone repository
     *
     * @return TimezoneRepository
     */
    public function getTimezoneRepository()
    {
        return $this->timezoneRepository;
    }

    /**
     * Sets the timezone repository
     *
     * @param TimezoneRepository $timezoneRepository Timezone repository
     */
    public function setTimezoneRepository(TimezoneRepository $timezoneRepository)
    {
        $this->timezoneRepository = $timezoneRepository;
    }

    /**
     * @param \Weasty\Bundle\GeonamesBundle\Entity\StateRepository $stateRepository
     */
    public function setStateRepository(StateRepository $stateRepository)
    {
        $this->stateRepository = $stateRepository;
    }

    /**
     * @return \Weasty\Bundle\GeonamesBundle\Entity\StateRepository
     */
    public function getStateRepository()
    {
        return $this->stateRepository;
    }

    /**
     * Returns a locality from this repository which matches the data in the
     * specified locality
     *
     * @param LocalityInterface $locality Locality instance
     * @return Locality
     */
    public function getLocality(LocalityInterface $locality)
    {
        $entityClass = $this->getClassName();

        if ($locality instanceof $entityClass) return $locality;

        return $this->findOneBy(['geonameIdentifier' => $locality->getGeonameIdentifier()]);
    }

    /**
     * Copies locality data from a locality interface to a locality entity
     *
     * @param LocalityInterface $source      Source locality
     * @param Locality          $destination Destination locality
     */
    public function copyLocality(LocalityInterface $source, Locality $destination)
    {
        $countryRepository  = $this->getCountryRepository();
        $timezoneRepository = $this->getTimezoneRepository();

        // Copy the geoname identifier
        if ($geonameIdentifier = $source->getGeonameIdentifier()) {
            $destination->setGeonameIdentifier($geonameIdentifier);
        }

        // Copy the country
        if ($country = $countryRepository->getCountry($source->getCountry())) {
            $destination->setCountry($country);
        }

        // Copy the UTF-8 encoded name
        if ($nameUtf8 = $source->getNameUtf8()) {
            $destination->setNameUtf8($nameUtf8);
        }

        // Copy the ASCII encoded name
        if ($nameAscii = $source->getNameAscii()) {
            $destination->setNameAscii($nameAscii);
        }

        // Copy the latitude
        if ($latitude = $source->getLatitude()) {
            $destination->setLatitude($latitude);
        }

        // Copy the longitude
        if ($longitude = $source->getLongitude()) {
            $destination->setLongitude($longitude);
        }

        // Copy the timezone
        if ($timezone = $timezoneRepository->getTimezone($source->getTimezone())) {
            if($timezone instanceof Timezone){
                $destination->setTimezone($timezone);
            }
        }
    }
} 