<?php
class Member_MyCollaborationController extends  Boilerplate_Controller_Action_Abstract
{
	
	private $project_id; // int id
	private $project;  // project object
	private $facadeComment;
	private $facadeProject;
	private $facadeProjectUpdate;

	public function init(){	
		parent::init();
		// check project existance for user and project
		$this->facadeProject = new \App\Facade\ProjectFacade($this->_em);	
		$this->facadeComment = new \App\Facade\Project\CommentFacade($this->_em);
		$this->facadeProjectUpdate = new \App\Facade\Project\UpdateFacade($this->_em);
	}

    
    /*
     * Check all neccessary things
     */
    public function checkProjectAndUser(){
    	$id = $this->_request->getParam("id");
    	// check id param for project
    	if(!is_numeric($id)){
   			$this->_helper->FlashMessenger(array('error' => 'This project is not found, are you trying to hack us? :D '));
    		$this->_redirect('/member/error/');
    	}
    	try{
    		// init basic things
    		$this->project = $this->facadeProject->findProjectForUser($this->_member_id, $id);
    		$this->project_id = $id;
    	
    		
    	} catch (\Exception $e){
    		$this->_helper->FlashMessenger(array('error' => 'This project is not found, are you trying to hack us? :D '));
    		$this->_helper->FlashMessenger(array('error' => $e->getMessage()));
    		$this->_redirect('/member/error/');	
    	}	
    }
    



    /**
     * Display Creators project for sign user
     */
    public function indexAction()
    {
    	$this->view->pageTitle = "My Collaborations - Accepted" ;
    	// get categories for form
    	$facadeCollaboration = new \App\Facade\Project\CollaborationFacade($this->_em);
    	$applications = $facadeCollaboration->findApplications($this->_member_id, array('state'=>\App\Entity\ProjectApplication::APPLICATION_ACCEPTED ));
    	$this->view->applications = $applications;

    }
    
    
    /**
     * Display members application he is waiting for
     */
    public function waitingAction()
    {
    	$this->view->pageTitle = "My Collaborations - Waiting" ;
    	// get categories for form
    	$facadeCollaboration = new \App\Facade\Project\CollaborationFacade($this->_em);
    	$applications = $facadeCollaboration->findApplications($this->_member_id, array('state'=>\App\Entity\ProjectApplication::APPLICATION_NEW ));
    	$this->view->applications = $applications;
    
    }
    
    /**
     * Display members application he has been denied
     */
    public function deniedAction()
    {
    	$this->view->pageTitle = "My Collaborations - Kicked" ;
    	// get categories for form
    	$facadeCollaboration = new \App\Facade\Project\CollaborationFacade($this->_em);
    	$applications = $facadeCollaboration->findApplications($this->_member_id, array('state'=>\App\Entity\ProjectApplication::APPLICATION_DENIED ));
    	$this->view->applications = $applications;
    
    }
    
    
    
}





