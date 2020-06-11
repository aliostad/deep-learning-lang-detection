package com.pc.service;

import java.util.List;

import com.pc.model.Customer;
import com.pc.repository.CustomerRepository;

public class CustomerServiceImpl implements CustomerService {
	
	private CustomerRepository customerRepository;
	
	public CustomerServiceImpl(){
		
	}
	
	public CustomerServiceImpl(CustomerRepository customerRepository){
		this.customerRepository = customerRepository;
	}
	
	public void setCustomerRepository(CustomerRepository customerRepository) {
		this.customerRepository = customerRepository;
	}

	public List<Customer> findAll() {
		return customerRepository.findAll();
	}
}
