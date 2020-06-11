<?php

class controlpanelController extends controller {
  public function index() {
    $this->view->title = 'Control Panel';

    $this->view->show('head');

    if (isAdmin()) {
      $this->view->show('headerAdmin');
      $this->view->show('greetAdmin');
    }

    else {
      $this->view->show('sidebar');
      $this->view->show('header');
      $this->view->show('banner');
      $this->view->show('navbar');
      $this->view->show('userSide');
      $this->view->show('userProfile');
    }

    $this->view->show('footer');
  }
}

?>
