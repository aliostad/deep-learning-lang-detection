<?php

class My_customer extends CI_Controller {

    public function __construct() {
        parent::__construct();

        $this->load->model('customer/customer_model');
        $this->load->model('customer/customer_service');
    }

    public function index() {
        $customer_service = new Customer_service();
        $data['customers'] = $customer_service->get_all_customers();
        return $this->load->view('customer_views/customer_main', $data);
    }

    function save_customer() {
        $customer_model = new Customer_model();
        $customer_service = new Customer_service();

        $customer_model->set_name($this->input->post('name_text'));
        $customer_model->set_age($this->input->post('age_text'));

        echo $customer_service->insert_customer($customer_model);
    }

    function load_edit_customer($id) {

        $customer_service = new Customer_service();
        $data['customer'] = $customer_service->get_customer($id);

        return $this->load->view('customer_views/edit_view', $data);
    }

    function delete_customer() {
        $customer_model = new Customer_model();
        $customer_service = new Customer_service();

        $customer_model->set_id($this->input->post('id'));

        echo $customer_service->delete_customer($customer_model);
    }

    function edit_customer() {

        $customer_model = new Customer_model();
        $customer_service = new Customer_service();

        $customer_model->set_id($this->input->post('id_text'));
        $customer_model->set_name($this->input->post('name_text'));
        $customer_model->set_age($this->input->post('age_text'));

        echo $customer_service->insert_customer($customer_model);
    }

}
