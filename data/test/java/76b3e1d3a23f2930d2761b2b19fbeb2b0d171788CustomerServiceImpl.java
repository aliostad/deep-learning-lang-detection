package com.pluralsight.service;

import com.pluralsight.model.Customer;
import com.pluralsight.repository.CustomerRepository;

import java.util.List;

public class CustomerServiceImpl implements CustomerService {
    // Spring use setter to init this
    private CustomerRepository customerRepository;

    // Spring use constructor to init this
    private CustomerRepository customerRepository2;

    public CustomerServiceImpl(CustomerRepository customerRepository) {
        this.customerRepository2 = customerRepository;
    }

    @Override
    public List<Customer> findAll(){
        System.out.println(customerRepository + " " + customerRepository2);
        return customerRepository2.findAll();
    }

    public void setCustomerRepository(CustomerRepository customerRepository) {
        this.customerRepository = customerRepository;
    }

    public CustomerRepository getCustomerRepository(CustomerRepository customerRepository) {
        return this.customerRepository ;
    }
}
