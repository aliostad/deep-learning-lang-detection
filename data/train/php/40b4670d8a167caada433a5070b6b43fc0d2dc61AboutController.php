<?php

use Acme\Country\CountryRepository;
use Acme\User\UserRepository;

class AboutController extends BaseController {

    private $userRepository;

    private $countryRepository;

    /**
     * @param UserRepository $userRepository
     * @param CountryRepository $countryRepository
     */
    public function __construct(UserRepository $userRepository, CountryRepository $countryRepository)
    {
        $this->userRepository    = $userRepository;
        $this->countryRepository = $countryRepository;
        parent::__construct();
    }

    public function index(){
        return true;
    }

}