<?php

include_once 'entity/Customer.php';

class CustomerService {
    
    public function insertCustomer($nama,$alamat,$telp,$email){
        $customer = new Customer(null, $nama, $alamat, $telp, $email);
        $customer->save();        
    }
    
    public function updateCustomer($id,$nama,$alamat,$telp,$email){
        $customer = Customer::load($id);
        $customer->setNama($nama);
        $customer->setAlamat($alamat);
        $customer->setTelp($telp);
        $customer->setEmail($email);
        $customer->update();
    }
    
    public function loadAllCustomer(){
        return Customer::loads();
    }
    
    public function countRow(){
        return Customer::countRow();
    }
    
    public function loadCustomerByPage($page){
        return Customer::loadsByPage($page);
    }


    public function loadById($id){
        return Customer::load($id);
    }
    
    public function deleteById($id){
        Customer::delete($id);
    }
}

?>
