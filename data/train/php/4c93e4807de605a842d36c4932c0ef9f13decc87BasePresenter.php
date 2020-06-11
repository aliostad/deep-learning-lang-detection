<?php

namespace App\Presenters;

use Nette,
    App\Model;

/**
 * Base presenter for all application presenters.
 * @property-read \SystemContainer $context
 */
abstract class BasePresenter extends Nette\Application\UI\Presenter {

    /** @var App\Model\UsersRepository Description */
    protected $usersRepository;

    /** @var App\Model\AdressRepository Description */
    protected $addressRepository;

    /** @var App\Model\RequestsRepository Description */
    protected $requestsRepository;

    /** @var App\Model\ShopsRepository Description */
    protected $shopsRepository;

    /** @var App\Model\TeaRepository Description */
    protected $teaRepository;

    /** @var App\Model\CommentsRepository Description */
    protected $commentsRepository;

    /**
     * Injektuje třídy reprezentující mdoely pro práci s databází
     */
    public function injectsModels(\App\Model\UsersRepository $usersRepository, \App\Model\AddressRepository $addressRepository) {
        $this->usersRepository = $usersRepository;
        $this->addressRepository = $addressRepository;
    }

    public function handleSignIn(){
        
    }


    public function handleLogOut() {
        $this->getUser()->logout();
        $this->redirect(':Front:Homepage:default');
    }
    protected function createComponentSingFormAdmin() {
        $singForm = new \App\Forms\SignFormFactory($this->getUser());
        return $singForm->createAdminModule();
    }
    

    /**
     * Return users repository
     * @return \App\Model\UsersRepository
     */
    public function getUsersRepository() {
        return $this->usersRepository;
    }

    /**
     * Return users repository
     * @return \App\Model\AddressRepository
     */
    public function getAddressRepository() {
        return $this->addressRepository;
    }

    /**
     * Return users repository
     * @return \App\Model\TeaRepository
     */
    public function getTeaRepository() {
        return $this->teaRepository;
    }

    /**
     * Return users repository
     * @return \App\Model\CommentsRepository
     */
    public function getCommentsRepository() {
        return $this->commentsRepository;
    }

    /**
     * Return users repository
     * @return \App\Model\RequestsRepository
     */
    public function getRequestsRepository() {
        return $this->requestsRepository;
    }

}
