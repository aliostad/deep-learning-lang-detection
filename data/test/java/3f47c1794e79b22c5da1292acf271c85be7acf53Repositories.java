package demo.batch.customer;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

/**
 * Repositories
 */
@Repository
public class Repositories {

    @Autowired
    CustomerRepository customerRepository;

    @Autowired
    ProductRepository productRepository;

    @Autowired
    OrderRepository orderRepository;

    /**
     * @return the customerRepository
     */
    public CustomerRepository getCustomerRepository() {
        return customerRepository;
    }

    /**
     * @return the productRepository
     */
    public ProductRepository getProductRepository() {
        return productRepository;
    }

    /**
     * @return the orderRepository
     */
    public OrderRepository getOrderRepository() {
        return orderRepository;
    }

}
