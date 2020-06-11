package com.pluralsight.service;

import com.pluralsight.model.Customer;
import com.pluralsight.repository.CustomerRepository;
import com.pluralsight.repository.HibernateCustomerRepositoryImpl;

import java.util.List;

/**
 * Created by aviv on 2/11/2015.
 */
public class CustomerServiceImpl implements CustomerService {
    private CustomerRepository customerRepository;
    
    public CustomerServiceImpl() {
		// TODO Auto-generated constructor stub
	}
    
    //constructor injection
    public CustomerServiceImpl(CustomerRepository customerRepository) {
		this.customerRepository = customerRepository;
	}

    //property injection
	public void setCustomerRepository(CustomerRepository customerRepository) {
		this.customerRepository = customerRepository;
	}

    public List<Customer> findAll() {
        return customerRepository.findAll();
    }
}
