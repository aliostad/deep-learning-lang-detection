<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');
/**
 * @category	Customer
 * @author		Midin
 * @copyright 2011
 * @version	 0.1
*/

class Customer extends CI_Controller
{
	function __construct()
	{
		parent::__construct();
		
		$this->load->helper('url');
		$this->load->helper('form');
		$this->load->library('session');
		$this->load->model('Customer_Model');
		$this->load->model('Common_Model');
	}
		
	function pop_up()
	{
		$customer_id	= $this->session->userdata('CURRENT_CUSTOMER_ID');
		$data['current_customer_id'] = $customer_id;
		// tabs 1
		$data['customer_data'] = $this->config->item('base_url').'index.php/customer/get_data_customer/?xid=0';
		//$data['customer_phones'] = $this->Customer_Model->getCustomerPhone($customer_id);
		
		//print_r($data['customer_phones']);
		$this->load->vars($data);
		$this->load->view('cockpit_view');
	}
	
	function get_data_customer()
	{
		$customer_id	= $this->session->userdata('CURRENT_CUSTOMER_ID');
		$data['current_customer_id'] = $customer_id;
		
		$data['customer_data'] 		= $this->Customer_Model->getCustomerData($customer_id);
		$data['customer_phones'] 	= $this->Customer_Model->getCustomerPhone($customer_id);
		$this->load->vars($data);
		$this->load->view('cockpit_customer_data_view');
	}
	
	function get_data_customer_update()
	{
		$this->load->model('Reference_Model');
		$customer_id	= $this->session->userdata('CURRENT_CUSTOMER_ID');
		$data['current_customer_id'] = $customer_id;
		
		$data['province_list'] = $this->Common_Model->getRefMaster('id value, upper(name) item', 'cc_province', 'status=1', 'sequence');
		$data['customer_data'] 		= $this->Customer_Model->getCustomerData($customer_id);
		$data['customer_phones'] 	= $this->Customer_Model->getCustomerPhone($customer_id);
		$data['gender']						= $this->Reference_Model->getReference('GENDER', true);
		$this->load->vars($data);
		$this->load->view('cockpit_update_customer_view');
	}
	
	function update_customer()
	{
		$customer_id = $this->session->userdata('CURRENT_CUSTOMER_ID');
		if ($this->Customer_Model->updateCustomer($customer_id))
		{
			echo "updated";
		}
		else
		{
			echo "Failed";
		}
	}
	function update_customer_phone()
	{
		$customer_id = $this->session->userdata('CURRENT_CUSTOMER_ID');
		if ($this->Customer_Model->updateCustomerPhone($customer_id))
		{
			echo "updated";
		}
		else
		{
			echo "Failed";
		}
	}
}
	
/* End of file customer.php */
/* Location: ./system/application/controllers/customer.php */