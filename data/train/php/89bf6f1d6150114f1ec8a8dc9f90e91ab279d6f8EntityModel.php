<?php

namespace Application\Model;

use Application\Entity\InstitutionRepository;
use Application\Entity\UserRepository;
use Application\Entity\DoctorRepository;
use Application\Entity\PatientRepository;
use Application\Entity\ScheduleRepository;
use Application\Entity\StreamRepository;
use Application\Entity\DayRepository;
use Application\Entity\EventRepository;

abstract class EntityModel {
    
    /**
     * @var Mandango
     */
    protected $mandango;
    
    /**
     * @var InstitutionRepository
     */
    private $institutionRepository;
    
    /**
     * @var UserRepository
     */
    private $userRepository;
    
    /**
     * @var DoctorRepository
     */
    private $doctorRepository;
    
    /**
     * @var PatientRepository
     */
    private $patientRepository;
    
    /**
     * @var ScheduleRepository
     */
    private $scheduleRepository;
    
    /**
     * @var StreamRepository
     */
    private $streamRepository;
    
    /**
     * @var DayRepository
     */
    private $dayRepository;
    
    /**
     * @var EventRepository
     */
    private $eventRepository;
    
    function __construct($mandango) {
        $this->mandango = $mandango;
    }
    
    /**
     * @var InstitutionRepository
     */
    protected function institutionRepository() {
        if(!$this->institutionRepository) {
            $this->institutionRepository = new InstitutionRepository($this->mandango);
        }
        return $this->institutionRepository;
    }
    
    /**
     * @var UserRepository
     */
    protected function userRepository() {
        if(!$this->userRepository) {
            $this->userRepository = new UserRepository($this->mandango);
        }
        return $this->userRepository;
    }
    
    /**
     * @var DoctorRepository
     */
    protected function doctorRepository() {
        if(!$this->doctorRepository) {
            $this->doctorRepository = new DoctorRepository($this->mandango);
        }
        return $this->doctorRepository;
    }
    
    /**
     * @var PatientRepository
     */
    protected function patientRepository() {
        if(!$this->patientRepository) {
            $this->patientRepository = new PatientRepository($this->mandango);
        }
        return $this->patientRepository;
    }
    
    /**
     * @var ScheduleRepository
     */
    protected function scheduleRepository() {
        if(!$this->scheduleRepository) {
            $this->scheduleRepository = new ScheduleRepository($this->mandango);
        }
        return $this->scheduleRepository;
    }
    
    /**
     * @var StreamRepository
     */
    protected function streamRepository() {
        if(!$this->streamRepository) {
            $this->streamRepository = new StreamRepository($this->mandango);
        }
        return $this->streamRepository;
    }
    
    /**
     * @var DayRepository
     */
    protected function dayRepository() {
        if(!$this->dayRepository) {
            $this->dayRepository = new DayRepository($this->mandango);
        }
        return $this->dayRepository;
    }
    
    /**
     * @var EventRepository
     */
    protected function eventRepository() {
        if(!$this->eventRepository) {
            $this->eventRepository = new EventRepository($this->mandango);
        }
        return $this->eventRepository;
    }
    
}
