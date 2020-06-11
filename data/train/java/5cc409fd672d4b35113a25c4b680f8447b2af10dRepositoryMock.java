package com.sky.mock;

import com.sky.entity.Customer;
import com.sky.entity.Product;
import com.sky.model.Category;
import com.sky.model.Location;
import com.sky.repository.CustomerRepository;
import com.sky.repository.ProductRepository;

public class RepositoryMock
{
    private CustomerRepository customerRepository;

    private ProductRepository productRepository;

    private static RepositoryMock instance;

    static
    {
        RepositoryMock.instance = new RepositoryMock();
    }

    public static void initializeFactory(final CustomerRepository customerRepository, final ProductRepository productRepository)
    {
        if (RepositoryMock.instance.customerRepository == null)
        {
            RepositoryMock.instance.customerRepository = customerRepository;
            RepositoryMock.instance.productRepository = productRepository;
            RepositoryMock.instance.buildCustomers();
            RepositoryMock.instance.buildProducts();
        }
    }

    private void buildCustomers()
    {
        Customer customer = new Customer(Location.LIVERPOOL);
        this.customerRepository.save(customer);

        customer = new Customer(Location.LIVERPOOL);
        this.customerRepository.save(customer);

        customer = new Customer(Location.LONDON);
        this.customerRepository.save(customer);

        customer = new Customer(Location.LONDON);
        this.customerRepository.save(customer);
    }

    private void buildProducts()
    {
        Product product = new Product("Arsenal TV", Category.SPORTS, Location.LONDON);
        this.productRepository.save(product);

        product = new Product("Chelsea TV", Category.SPORTS, Location.LONDON);
        this.productRepository.save(product);

        product = new Product("Liverpool TV", Category.SPORTS, Location.LIVERPOOL);
        this.productRepository.save(product);

        product = new Product("Sky News", Category.NEWS);
        this.productRepository.save(product);

        product = new Product("Sky Sports News", Category.NEWS);
        this.productRepository.save(product);
    }
}