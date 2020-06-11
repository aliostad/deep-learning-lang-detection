<?php
/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 * Description of Service

 */
class Service{

// Attributs
   //id:
  private $service = array(
                    'id_service' => null,
                    'nom_service' => null,
                    'date_creation_service' => null,
                    'description_service' => null
                    );

  // Constructeurs

    function __construct($serv = array()){
            if(isset($serv['id_service'])) {
                $this->service['id_service'] = htmlspecialchars(intval($serv['id_service']));
            }
            $this->service['nom_service'] = isset($serv['nom_service'])? htmlspecialchars($serv['nom_service']) : '' ;
            $this->service['date_creation_service'] = isset($serv['date_creation_service'])? htmlspecialchars($serv['date_creation_service']) : '' ;
            $this->service['description_service'] = isset($serv['description_service'])? htmlspecialchars($serv['description_service']) : '' ;
	}
	//Getters

        public function getId_Service(){
            return $this->service['id_service'];
        }

        public function getNomService(){
            return $this->service['nom_service'];
        }

        public function getDateCreatService(){
            return $this->service['date_creation_service'];
        }

        public function getDescService(){
            return $this->service['description_service'];
        }
    
	// Setters

        public function setId_Service($id){
            $this->service['id_service'] = htmlspecialchars($id);
        }

        public function setNomService($nom_service){
            $this->service['nom_service'] = htmlspecialchars($nom_service);
        }

        public function setDateCreatService($date_creation_service){
            $this->service['date_creation_service'] = htmlspecialchars($date_creation_service);
        }

        public function setDescService($description_service){
            $this->service['description_service'] = htmlspecialchars($description_service);
        }  
}
?>
