<?php

class Admin_IndexController extends Boilerplate_Controller_Action_Abstract {
		
	/*
	 * Sign up process, validation of form
	 */
	public function indexAction() {
		
		$this->view->pageTitle = 'Admin Dashboard';
		$this->_helper->_layout->setLayout('admin-dashboard');
		
		$facadeProjects = new \App\Facade\ProjectFacade($this->_em);
		$this->view->countProjects = count($facadeProjects->findAllProjects());
		
		$facadeUsers = new \App\Facade\UserFacade($this->_em);
		$this->view->countUsers = count($facadeUsers->findAllUsers());
		
	}
	
	public function adminMenuAction(){
		
	}



}





