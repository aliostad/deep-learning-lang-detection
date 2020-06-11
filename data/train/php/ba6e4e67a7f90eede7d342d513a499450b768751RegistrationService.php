<?php namespace services;

use repositories\PersonRepository;
use repositories\ThingRepository;
use repositories\UserRepository;

class RegistrationService {

    protected $userRepository;

    protected $personRepository;

    protected $thingRepository;

    /**
     * @param UserRepository $userRepository
     * @param PersonRepository $personRepository
     * @param ThingRepository $thingRepository
     */
    public function __construct(UserRepository $userRepository, PersonRepository $personRepository, ThingRepository $thingRepository)
    {
        $this->userRepository = $userRepository;
        $this->personRepository = $personRepository;
        $this->thingRepository = $thingRepository;
    }

    public function registerAUser($data)
    {
        $thing = $this->thingRepository->create(array('name' => $data['name']));

        $person = $this->personRepository->create(array('id' => $thing->id, 'lastName' => $data['lastName'], 'birthDate' => $data['birthDate'], 'nationality' => $data['nationality'], 'gender' => $data['gender']));

        $user = $this->userRepository->create(array('email' => $data['email'], 'password' => $data['password'], 'person' => $thing->id));

        return $user;
    }


}