<?php
session_start();

class profileController extends baseController {

    public function index() {
        $this->registry->template->show('profileheader');
        $this->registry->template->show('profileindex');
        $this->registry->template->show('profilefooter');
    }
    
    public function logout() {
        userLogout();
        $this->registry->template->show('profileheader');
        $this->registry->template->show('logout');
        $this->registry->template->show('profilefooter');
    }
    
    public function profile() {
        $this->registry->template->show('profileheader');
        $this->registry->template->show('profile');
        $this->registry->template->show('profilefooter');
    }
    
    public function members() {
        $this->registry->template->show('profileheader');
        $this->registry->template->show('members');
        $this->registry->template->show('profilefooter');
    }
    
    public function friends() {
        $this->registry->template->show('profileheader');
        $this->registry->template->show('friends');
        $this->registry->template->show('profilefooter');
    }
    
    public function messages() {
        $this->registry->template->show('profileheader');
        $this->registry->template->show('messages');
        $this->registry->template->show('profilefooter');
    }

}

?>
