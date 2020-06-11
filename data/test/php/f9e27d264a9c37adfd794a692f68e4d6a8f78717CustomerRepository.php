<?php namespace AlistairShaw\Vendirun\App\Entities\Customer;

interface CustomerRepository {

    /**
     * @return Customer
     */
    public function find();

    /**
     * @param Customer $customer
     * @param bool $is_registration
     * @param null $password
     * @param bool $fetch_duplicate
     * @return Customer
     */
    public function save(Customer $customer, $is_registration = false, $password = null, $fetch_duplicate = false);

    /**
     * @param Customer $originator
     * @param Customer $receiver
     * @param string $link
     * @return mixed
     */
    public function recommendFriend(Customer $originator, Customer $receiver, $link);

    /**
     * @param Customer $customer
     * @param array $data
     */
    public function registerFormCompletion(Customer $customer, $data);

}