<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');

class SERVICECON extends CI_Controller {

 function __construct()
 {
   parent::__construct();
 }
 
function listedeService()
   {
	    $this->load->model('service');

    $data['results'] = $this->service->listeService(); 

   
    $this->load->view('serviceliste', $data);
    
   }





 function ajoutService()
 {
	
	 
	  $this->load->view('serviceajouter');
	 
        $nom_service=$this->input->post('nom_service');
        $type_service=$this->input->post('type_service');

            $this->load->model('service');
    
         $this->service->ajouterService($nom_service,$type_service);

 }
  function modifierService()
  {
	     $this->load->view('servicemodifier');
		 
		 $id_service=$this->input->post('id_service');
	    $nom_service=$this->input->post('nom_service');
        $type_service=$this->input->post('type_service');

          $this->load->model('service');
    
         $this->service->modifierService($id_service,$nom_service,$type_service);
	  
  }
   function supprimerService()
   {    $id_service = array();
        
		$id_service=$this->input->get('id_service');
		foreach($id_service as $k=>$v){
		 $this->load->model('service');
		 $this->service->supprimerService($v);
		}
		echo"sup.success";

   }
   

}

?>