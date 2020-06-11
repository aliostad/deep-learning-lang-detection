<?php

class Customer_model extends CI_Model{
    function __construct(){
        parent::__construct();
    }
// ===================================================================================================== //
//                                                                                                       //
//                                              PELANGGAN                                                //
//                                                                                                       //
// ===================================================================================================== //

    public function getKodeCustomer(){
        $q = $this->db->query("select MAX(SUBSTR(ID_CUSTOMER,-3,3)) as ID_MAX from TBL_CUSTOMER");
        $ID = "";
        if($q->num_rows()>0){
            foreach($q->result() as $k){
                $tmp = ((int)$k->ID_MAX)+1;
                $ID = sprintf("%03s", $tmp);
            }
        }else{
            $ID = "001";
        }
        return "ct".$ID;
    }

    function getIdCustomer($id){
        return $this->db->query("SELECT * from TBL_CUSTOMER where ID_CUSTOMER = '$id'")->result();
    }

//    public function insertCustomer($id_customer,$nm_customer,$almt_customer,$email_customer)
    public function insertCustomer()
    {
        $id_customer    = $this->input->post('id_customer');
        $nm_customer    = $this->input->post('nm_customer');
        $almt_customer  = $this->input->post('almt_customer');
        $email_customer = $this->input->post('email_customer');

        $data=array(
            'ID_CUSTOMER'=> $this->input->post('id_customer'),
            'NM_CUSTOMER'=>$this->input->post('nm_customer'),
            'ALMT_CUSTOMER'=>$this->input->post('almt_customer'),
            'EMAIL_CUSTOMER'=>$this->input->post('email_customer'),
        );

        $this->db->insert('TBL_CUSTOMER',$data);
    }

}