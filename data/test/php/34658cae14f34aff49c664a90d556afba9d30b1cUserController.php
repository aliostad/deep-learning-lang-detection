<?php
class Tx_DdSponsorship_Controller_UserController extends Tx_Extbase_MVC_Controller_ActionController {
 
    /**
     * userRepository
     *
     * @var Tx_DdSponsorship_Domain_Repository_UserRepository
     */
    protected $userRepository;
 
    /**
     * injectUserRepository
     *
     * @param Tx_DdSponsorship_Domain_Repository_UserRepository $userRepository
     * @return void
     */
    public function injectUserRepository(Tx_DdSponsorship_Domain_Repository_UserRepository $userRepository) {
        $this->userRepository = $userRepository;
    }
 
    /**
     * action list
     *
     * @return void
     */
    public function listAction() {
        $users = $this->userRepository->findAll();
        $this->view->assign('users', $users);
    }
}

?>