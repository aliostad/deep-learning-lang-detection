<?php
/**
 * Widget for public project page
 * @author misteryyy
 *
 */
class MemberProfile_WidgetController extends  Boilerplate_Controller_Action_Abstract
{

	private $facadeProject;
	
	public function init(){
		parent::init();

	}

	
    /**
	 * Menu with basic structure
	 */ 
    public function memberRightMenuAction(){
    	
    	// count of collaborations
    	$facadeCollaboration = new \App\Facade\Project\CollaborationFacade($this->_em);
    	$countOfCollaborations = $facadeCollaboration->findApplicationsCount($this->_member_id, array('state'=>\App\Entity\ProjectApplication::APPLICATION_ACCEPTED ));
    	$this->view->collaborationsCount = $countOfCollaborations;
    	
    	
    }
    
    
    
    /**
     * Notification widget
     */
    public function notificationAction(){
    	
    	try{
    		$facadeUser = new \App\Facade\UserFacade($this->_em);
    		$paginator = $facadeUser->findPublicLogForUserPaginator($this->_member_id);
    		$paginator->setItemCountPerPage(10);
    		$page = $this->_request->getParam('page', 1);
    		$paginator->setCurrentPageNumber($page);
    		$this->view->paginator = $paginator;
    		$this->view->paginator = $paginator;
    	
    	}catch(\Exception $e){
    		$this->_helper->FlashMessenger( array('error' =>  $e->getMessage()));
    	}    	
    }
   
    /**
     * Survey widget
     */
    public function surveyAction(){
    	$facadeProjectSurvey = new \App\Facade\Project\SurveyFacade($this->_em);
    	// set empty answers
    	$this->view->unfinishedSurveys = $facadeProjectSurvey->findProjectsWithEmptySurveysForUser($this->_member_id);	
    }
    
    
    /**
     * Recent projects widget
     */
    public function recentProjectAction(){
    	$facadeProject = new \App\Facade\ProjectFacade($this->_em);
    	$paginator = $facadeProject->findProjectsFromMyFriendPaginator($this->_member_id);    	
     	$paginator->setItemCountPerPage(4);
     	$page = $this->_request->getParam('page', 1);
     	$paginator->setCurrentPageNumber($page);
     	$this->view->paginator = $paginator;
    	 
    	
    }
    
    
    /**
     * Feature projects widget
     */
    public function featureProjectAction(){
    	
    	$facadeProject = new \App\Facade\ProjectFacade($this->_em);
    	$paginator = $facadeProject->findFeaturedProjectsPaginator($this->_member_id);
    	$paginator->setItemCountPerPage(5);
    	$page = $this->_request->getParam('page', 1);
    	$paginator->setCurrentPageNumber($page);
    	$this->view->paginator = $paginator;
    	
    	 
    }

    /**
     * My projects widget
     */
    public function myProjectAction(){
        
        $facadeProject = new \App\Facade\ProjectFacade($this->_em);
        $paginator = $facadeProject->findAllProjectsForUserPaginator($this->_member_id);
        $paginator->setItemCountPerPage(4);
        $page = $this->_request->getParam('page', 1);
        $paginator->setCurrentPageNumber($page);
        $this->view->paginator = $paginator;
        
         
    }
    
    
}

