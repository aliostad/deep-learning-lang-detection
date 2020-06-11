package com.springsample.service;

import java.util.List;

import com.springsample.model.Customer;
import com.springsample.repository.CustomerRepository;

public class CustomerServiceImpl implements CustomerService {

	private CustomerRepository customerRepository;

	public CustomerServiceImpl() {
	}

	// for constructor injection
	public CustomerServiceImpl(CustomerRepository customerRepository) {
		this.customerRepository = customerRepository;
	}

	// for setter injection
	public void setCustomerRepository(CustomerRepository customerRepository) {
		this.customerRepository = customerRepository;
	}
	
	@Override
	public List<Customer> finaAll() {
		return customerRepository.findAll();
	}
}
