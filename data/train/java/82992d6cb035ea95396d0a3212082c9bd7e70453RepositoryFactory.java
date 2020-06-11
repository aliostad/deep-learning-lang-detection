package repository.factory;

import repository.order.OrderRepository;
import repository.product.CategoryRepository;
import repository.product.LaptopRepository;
import repository.product.ProducerRepository;
import repository.user.UserRepository;

import javax.sql.DataSource;

/**
 * @author Arsalan
 */
public class RepositoryFactory {

    private UserRepository userRepository;
    private LaptopRepository laptopRepository;
    private ProducerRepository producerRepository;
    private CategoryRepository categoryRepository;
    private OrderRepository orderRepository;

    public RepositoryFactory(DataSource dataSource) {
        this.userRepository = new UserRepository(dataSource);
        this.laptopRepository = new LaptopRepository(dataSource);
        this.producerRepository = new ProducerRepository(dataSource);
        this.categoryRepository = new CategoryRepository(dataSource);
        this.orderRepository = new OrderRepository(dataSource);
    }

    public UserRepository getUserRepository() {
        return userRepository;
    }

    public LaptopRepository getLaptopRepository() {
        return laptopRepository;
    }

    public ProducerRepository getProducerRepository() {
        return producerRepository;
    }

    public CategoryRepository getCategoryRepository() {
        return categoryRepository;
    }

    public OrderRepository getOrderRepository() {
        return orderRepository;
    }
}
