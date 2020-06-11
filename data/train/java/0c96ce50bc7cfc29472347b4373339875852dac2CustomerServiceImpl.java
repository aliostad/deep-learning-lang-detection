package com.pluralsight.service;

import com.pluralsight.model.Customer;
import com.pluralsight.repository.CustomerRepository;

import java.util.List;

public class CustomerServiceImpl implements CustomerService
{
    public CustomerServiceImpl()
    {}

    public CustomerServiceImpl(CustomerRepository customerRepository)
    {
        this.customerRepository = customerRepository;
    }

    private CustomerRepository customerRepository;

    public void setCustomerRepository(CustomerRepository customerRepository) {
        this.customerRepository = customerRepository;
    }

    public List<Customer> findAll()
    {
        return customerRepository.findAll();
    }
}
