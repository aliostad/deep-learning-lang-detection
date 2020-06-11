package com.yespapi.service;

import java.util.List;

import com.yespapi.model.Customer;
import com.yespapi.repository.CustomerRepository;
import com.yespapi.repository.HibernateCustomerRepositoryImpl;

public class CustomerServiceImpl implements CustomerService {

	private CustomerRepository customerRepository;
	
	public CustomerServiceImpl() {
		
	}
	
	public CustomerServiceImpl(CustomerRepository customerRepository) {
		this.customerRepository = customerRepository;
	}
	
	public void setCustomerRepository(CustomerRepository customerRepository) {
		this.customerRepository = customerRepository;
	}
	
	public List <Customer> findAll() {
		return customerRepository.findAll();
	}

}
