<?php
/**
 * Created by PhpStorm.
 * User: Max
 * Date: 7-2-2015
 * Time: 16:04
 */

include_once 'helper/database.php';
include_once 'model/customer.php';

class customerMapper {

    private $database;

    public function __construct() {
        if(is_null($this->database)) {
            $this->database = new database();
        }
    }

    public function getAllCustomers() {
        $this->database->query('SELECT * FROM customer');
        $result = $this->database->resultset();
        return $this->createCustomers($result);
    }

    public function getCustomerById($customerId) {
        $this->database->query('SELECT * FROM customer WHERE customerID = :customerId');
        $this->database->bind(':customerId', $customerId);
        $result = $this->database->single();
        return $this->createCustomer($result);
    }

    public function getCustomerByUsername($email) {
        $this->database->query('SELECT * FROM customer WHERE email = :email');
        $this->database->bind(':email', $email);
        $result = $this->database->single();
        return $this->createCustomer($result);
    }

    public function customerExistsById($customerId) {
        $this->database->query('SELECT * FROM customer WHERE customerID = :customerId');
        $this->database->bind(':customerId', $customerId);
        $result =  $this->database->single();
        return $this->createCustomer($result);
    }

    public function customerExistsByEmail($email) {
        $this->database->query('SELECT * FROM customer WHERE email = :email');
        $this->database->bind(':email', $email);
        $result = $this->database->single();
        return $this->createCustomer($result);
    }

    public function insertCustomer($customer) {
        $this->database->query('INSERT INTO customer (forname, surname, phonenumber, email, password) VALUES (:forname, :surname, :phonenumber, :email, :password)');
        $this->database->bind(':forname', $customer->getForname());
        $this->database->bind(':surname', $customer->getSurname());
        $this->database->bind('phonenumber', $customer->getPhonenumber());
        $this->database->bind(':email', $customer->getEmail());
        $this->database->bind(':password', $customer->getPassword());

        $this->database->execute();
    }

    private function createCustomer($customerRow) {
        //create new customer
        $customer = new customer();
        //initialize customer
        $customer->setCustomerID($customerRow['customerID']);
        $customer->setForname($customerRow['forname']);
        $customer->setSurname($customerRow['surname']);
        $customer->setPhonenumber($customerRow['phonenumber']);
        $customer->setEmail($customerRow['email']);
        $customer->setPassword($customerRow['password']);

        //return customer
        return $customer;
    }

    private function createCustomers($customerRows) {
        $customers = array();
        //iterate over returned category records
        for($i = 0; $i < count($customerRows); $i++) {
            $customers[] = $this->createCustomer($customerRows[$i]);
        }
        return $customers;
    }
}