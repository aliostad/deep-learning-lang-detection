/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.bakujug.springrental;

import java.util.Date;

/**
 *
 * @author Administrator
 */
public class RentalServiceImpl implements RentalService{

    private CustomerRepository customerRepository;
    private RentalRepository rentRepository;
   

    public Rental rentACar(String customerName, Car car, Date begin, Date end) {

        Customer customer = customerRepository.getCustomerByName(customerName);
        if (customer == null) {
            customer = new Customer(customerName);
            customerRepository.save(customer);
        }

        Rental rental = new Rental();
        rental.setCar(car);
        rental.setCustomer(customer);
        rentRepository.save(rental);
        return rental;
    }

    public CustomerRepository getCustomerRepository() {
        return customerRepository;
    }

    public void setCustomerRepository(CustomerRepository customerRepository) {
        this.customerRepository = customerRepository;
    }

    public RentalRepository getRentRepository() {
        return rentRepository;
    }

    public void setRentRepository(RentalRepository rentRepository) {
        this.rentRepository = rentRepository;
    }
    
    
}
