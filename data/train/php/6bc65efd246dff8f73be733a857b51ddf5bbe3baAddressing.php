<?php
namespace Sule\Addressing;

/**
 * Part of the Addressing package.
 *
 * NOTICE OF LICENSE
 *
 * Licensed under the MIT License.
 *
 * This source file is subject to the MIT License that is
 * bundled with this package in the LICENSE file.  It is also available at
 * the following URL: http://opensource.org/licenses/MIT
 *
 * @package    Addressing
 * @version    1.0.0
 * @author     Sulaeman <me@sulaeman.com>
 * @license    MIT License
 */

use Sule\Addressing\Repositories\AddressRepositoryInterface;
use Sule\Addressing\Repositories\CountryRepositoryInterface;
use Sule\Addressing\Repositories\ProvinceRepositoryInterface;
use Sule\Addressing\Repositories\ZoneRepositoryInterface;

class Addressing
{

    /**
     * Address repository.
     *
     * @var AddressRepositoryInterface
     */
    protected $repository;

    /**
     * Country repository.
     *
     * @var CountryRepositoryInterface
     */
    protected $countryRepository;

    /**
     * Province repository.
     *
     * @var ProvinceRepositoryInterface
     */
    protected $provinceRepository;

    /**
     * Zone repository.
     *
     * @var ZoneRepositoryInterface
     */
    protected $zoneRepository;

    /**
     * Create a new Addressing object.
     *
     * @param  AddressRepositoryInterface $repository
     * @param  CountryRepositoryInterface $countryRepository
     * @param  ProvinceRepositoryInterface $provinceRepository
     * @param  ZoneRepositoryInterface $zoneRepository
     *
     * @return void
     */
    public function __construct(
        AddressRepositoryInterface $repository, 
        CountryRepositoryInterface $countryRepository, 
        ProvinceRepositoryInterface $provinceRepository, 
        ZoneRepositoryInterface $zoneRepository
    )
    {
        $this->repository                   = $repository;
        $this->countryRepository            = $countryRepository;
        $this->provinceRepository           = $provinceRepository;
        $this->zoneRepository               = $zoneRepository;
    }

    /**
     * Set address repository
     *
     * @param  AddressRepositoryInterface $repository
     *
     * @return void
     */
    public function setRepository(AddressRepositoryInterface $repository)
    {
        $this->repository = $repository;
    }

    /**
     * Return the address repository
     *
     * @return AddressRepositoryInterface
     */
    public function getRepository()
    {
        return $this->repository;
    }

    /**
     * Set country repository
     *
     * @param  CountryRepositoryInterface $repository
     *
     * @return void
     */
    public function setCountryRepository(CountryRepositoryInterface $repository)
    {
        $this->countryRepository = $repository;
    }

    /**
     * Return the country repository
     *
     * @return CountryRepositoryInterface
     */
    public function getCountryRepository()
    {
        return $this->countryRepository;
    }

    /**
     * Set province repository
     *
     * @param  ProvinceRepositoryInterface $repository
     *
     * @return void
     */
    public function setProvinceRepository(ProvinceRepositoryInterface $repository)
    {
        $this->provinceRepository = $repository;
    }

    /**
     * Return the province repository
     *
     * @return ProvinceRepositoryInterface
     */
    public function getProvinceRepository()
    {
        return $this->provinceRepository;
    }

    /**
     * Set zone repository
     *
     * @param  ZoneRepositoryInterface $repository
     *
     * @return void
     */
    public function setZoneRepository(ZoneRepositoryInterface $repository)
    {
        $this->zoneRepository = $repository;
    }

    /**
     * Return the zone repository
     *
     * @return ZoneRepositoryInterface
     */
    public function getZoneRepository()
    {
        return $this->zoneRepository;
    }

}