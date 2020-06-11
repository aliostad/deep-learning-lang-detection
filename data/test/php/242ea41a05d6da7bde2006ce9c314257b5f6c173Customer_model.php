<?php

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 * Description of Customer_model
 *
 * @author Administrator
 */
class Customer_model extends CI_Model {

    function __construct() {
        parent::__construct();
        $this->load->library('upload');
    }

    public function _insert_customer($customer) {
        $dataCustomer = array(
            'customer_name' => $customer['txtCusname'],
            'customer_status' => $customer['selCusStatus'],
            'customer_tax_id' => $customer['txtNumTax'],
            'customer_band_id' => $customer['txtNumBand'],
            'customer_addr_th' => $customer['txtAddrTh'],
            'customer_addr_en' => $customer['txtAddrEn'],
            'customer_tel' => $customer['txtCusTel'],
            'customer_fax' => $customer['txtCusFax'],
            'customer_web' => $customer['txtCusWeb'],
            'customer_mail' => $customer['txtCusMail'],
            'customer_condition' => $customer['txtConditionNam'],
            'customer_coor_name' => $customer['txtContractName'],
            'customer_coor_tel' => $customer['txtContractTel'],
            'customer_coor_mail' => $customer['txtContractMail'],
            'customer_lat' => $customer['txtLat'],
            'customer_long' => $customer['txtLong'],
            'customer_note' => $customer['txtCustomerMark'],
            'customer_level' => $customer['selLevelCus']
        );



        $this->db->insert('customer', $dataCustomer);
    }

    public function _sel_customer_id($tax_number) {

        $query = $this->db->select('customer_id')
                        ->where('customer_tax_id', $tax_number)
                        ->get('customer')->result();

        foreach ($query as $row) {
            $customerId = $row->customer_id;
        }

        return $customerId;
    }

    public function _insert_sign($customer, $customer_id, $count) {
        $dataConditionSign = array(
            'txtNameCon' => $customer['txtNameCon'], /* อาเรย์ข้างใน */
            'selStatusCondition' => $customer['selStatusCondition'] /* อาเรย์ข้างใน */
        );

        for ($i = 0; $i < $count; $i++) { //วนนำข้อมูลเข้า
            // $dataConditionSign['txtNameCon']['$i'];
            //$dataConditionSign['selStatusCondition']['$i'];
            $query = $this->db->set('sing_name', $dataConditionSign['txtNameCon'][$i])
                    ->set('sign_status', $dataConditionSign['selStatusCondition'][$i])
                    ->set('customer_id', $customer_id)
                    ->insert('sign');
        }
    }

    public function _insert_file($file_name, $customer_id) {

        $query = $this->db->set('file_name', 'รูปถ่ายลูกค้า')
                ->set('file_path', $file_name)
                ->set('customer_id', $customer_id)
                ->insert('file');
    }

    public function _sel_customer_details() {
        $query = $this->db->get('customer')->result();
        return $query;
    }

    public function _sel_customer_details_by_id($id) {
        $query = $this->db->where('customer_id', $id)
                        ->get('customer')->result();
        foreach ($query as $row) {
            $dataReturn = array(
                'customer_name' => $row->customer_name,
                'customer_status' => $row->customer_status,
                'customer_tax_id' => $row->customer_tax_id,
                'customer_band_id' => $row->customer_band_id,
                'customer_addr_th' => $row->customer_addr_th,
                'customer_addr_en' => $row->customer_addr_en,
                'customer_tel' => $row->customer_tel,
                'customer_fax' => $row->customer_fax,
                'customer_web' => $row->customer_web,
                'customer_mail' => $row->customer_mail,
                'customer_condition' => $row->customer_condition,
                'customer_coor_name' => $row->customer_coor_name,
                'customer_coor_tel' => $row->customer_coor_tel,
                'customer_coor_mail' => $row->customer_coor_mail,
                'customer_lat' => $row->customer_lat,
                'customer_long' => $row->customer_long,
                'customer_note' => $row->customer_note,
                'customer_level' =>$row->customer_level
            );
        }
        return $dataReturn;
    }

    public function _sel_file($id) {
        $query = $this->db->where('customer_id', $id)
                        ->get('file')->result();
        foreach ($query as $row) {
            return $row->file_path;
        }
    }

    public function _sel_sign($id) {
        $qyery = $this->db->where('customer_id', $id)
                        ->get('sign')->result();
        foreach ($qyery as $row) {
            $dataRe[] = array(
                'name' => $row->sing_name,
                'status' => $row->sign_status
            );
        }
        return @$dataRe;
    }

    public function _update_customer_by_id($customer) {
        $dataCustomer = array(
            'customer_name' => $customer['txtCusname'],
            'customer_status' => $customer['selCusStatus'],
            'customer_tax_id' => $customer['txtNumTax'],
            'customer_band_id' => $customer['txtNumBand'],
            'customer_addr_th' => $customer['txtAddrTh'],
            'customer_addr_en' => $customer['txtAddrEn'],
            'customer_tel' => $customer['txtCusTel'],
            'customer_fax' => $customer['txtCusFax'],
            'customer_web' => $customer['txtCusWeb'],
            'customer_mail' => $customer['txtCusMail'],
            'customer_condition' => $customer['txtConditionNam'],
            'customer_coor_name' => $customer['txtContractName'],
            'customer_coor_tel' => $customer['txtContractTel'],
            'customer_coor_mail' => $customer['txtContractMail'],
            'customer_lat' => $customer['txtLat'],
            'customer_long' => $customer['txtLong'],
            'customer_note' => $customer['txtCustomerMark'],
            'customer_level' => $customer['customer_level']
        );
        $this->db->where('customer_id', $customer['customer_id']);
        $this->db->update('customer', $dataCustomer);
    }

    public function _del_sign($customer) {
        $this->db->where('customer_id', $customer['customer_id']);
        $this->db->from('sign');

        if (!empty($this->db->count_all_results())) {
            $this->db->where('customer_id', $customer['customer_id']);
            $this->db->delete('sign');
        }
    }

    public function _delete_photo($customer_id) {
        $this->db->where('customer_id', $customer_id)
                ->delete('file');
    }
    
    public function _del_file($cusotmer_id){
        $this->db->where('customer_id',$cusotmer_id);
        $this->db->delete('file');
    }
    
    public function _del_sign2($customer_id) {
            $this->db->where('customer_id', $customer_id);
            $this->db->delete('sign');
        
    }
    
    public function _del_customer($customerId){
        $this->db->where('customer_id',$customerId)
                ->delete('customer');
    }
    
    
    
    

}
