<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');
class Customer_get_by_id extends CI_Controller 
{ 
	public function index()
	{
            
            // Not Request Ajax
            if (!$this->input->is_ajax_request()){
                die ('ERROR_BAD_REQUEST');
            }
            
            // Check For Token
            if (!$this->security->check_get_token()){
                die ('ERROR_TOKEN');
            }
            
            // Only Manager
            if (!$this->auth->isAdmin() && !$this->auth->isEditor()){
                die ('ERROR_AUTH');
            }
            
            // Edit Action
            if ($this->security->is_action('customer_get_by_id'))
            {
                $customer_username = trim($this->input->post('customer_username'));
                $customer_id = trim($this->input->post('customer_id'));
                $customer_email = trim($this->input->post('customer_email'));
                $customer_phone = trim($this->input->post('customer_phone'));
                
                $this->load->model('customer/customer_customer_model');
                $customer = $this->customer_customer_model->getDetail(array(
                    'customer_username_int' => username_hash($customer_username),
                    'customer_id' => $customer_id,
                    'customer_email' => $customer_email,
                    'customer_phone' => $customer_phone
                ));
                
                if (!$customer){
                    die ('ERROR_NOT_FOUND');
                }
                
                if ($customer['customer_status'] == '0'){
                    die ('ERROR_CUS_BAND');
                }
                
                die (json_encode($customer));
            }
            
            die ('ERROR_BAD_REQUEST');
	}
        
}
?>
