package main.routes;

import main.domain.account.Encryptor;
import main.domain.account.UserRepository;
import main.domain.product.ProductRepository;
import main.domain.salesOrder.SalesOrderRepository;
import main.persistence.mongo.MongoSalesOrderRepository;

public class Dependencies {
    private UserRepository userRepository;
    private ProductRepository productRepository;
    private Encryptor encryptor;
    private SalesOrderRepository salesOrderRepository;

    public UserRepository getUserRepository() {
        return userRepository;
    }

    public void setUserRepository(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    public ProductRepository getProductRepository() {
        return productRepository;
    }

    public void setProductRepository(ProductRepository productRepository) {
        this.productRepository = productRepository;
    }

    public Encryptor getEncryptor() {
        return encryptor;
    }

    public void setEncryptor(Encryptor encryptor) {
        this.encryptor = encryptor;
    }

    public SalesOrderRepository getSalesOrderRepository() {  return salesOrderRepository; }

    public void setSalesOrderRepository(SalesOrderRepository salesOrderRepository){ this.salesOrderRepository = salesOrderRepository;  }
}
