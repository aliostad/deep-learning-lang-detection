package com.costomerService;

import com.CustomerRepository.CustomerRepository;
import com.com.customer.Customer;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service("customerService")
public class CustomerServiceImpl implements CustomerService {

    @Autowired
    private CustomerRepository customerRepository;

    public CustomerRepository getCustomerRepository() {
        return customerRepository;
    }

    public void setcustomerRepository(CustomerRepository customerRepository) {
        this.customerRepository = customerRepository;
    }

    public List<Customer> FindALL() {
        return customerRepository.findAll();
    }

}
