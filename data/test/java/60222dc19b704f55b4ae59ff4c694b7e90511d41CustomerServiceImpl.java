package com.terrydhariwal.service;

import com.terrydhariwal.model.Customer;
import com.terrydhariwal.repository.CustomerRepository;
import com.terrydhariwal.repository.HibernateCustomerRepositoryImpl;

import java.util.List;

public class CustomerServiceImpl implements CustomerService {

    private CustomerRepository customerRepository;

    public CustomerServiceImpl(){}

    public CustomerServiceImpl(CustomerRepository customerRepository) {
        System.out.println("we are using constructor injection");
        this.customerRepository = customerRepository;
    }

    public void setCustomerRepository(CustomerRepository customerRepository) {
        this.customerRepository = customerRepository;
    }

    @Override
    public List<Customer> findAll() {
        return customerRepository.findAll();
    }
}
