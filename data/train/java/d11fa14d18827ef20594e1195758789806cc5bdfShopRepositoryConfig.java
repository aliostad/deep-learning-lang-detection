package org.shop.config;

import org.shop.repository.ItemRepository;
import org.shop.repository.OrderRepository;
import org.shop.repository.ProductRepository;
import org.shop.repository.ProposalRepository;
import org.shop.repository.SellerRepository;
import org.shop.repository.UserRepository;
import org.shop.repository.factory.UserRepositoryFactory;
import org.shop.repository.map.ItemMapRepository;
import org.shop.repository.map.OrderMapRepository;
import org.shop.repository.map.ProductMapRepository;
import org.shop.repository.map.ProposalMapRepository;
import org.shop.repository.map.SellerMapRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.ImportResource;

@Configuration
@ImportResource("classpath:resource-config.xml")
public class ShopRepositoryConfig {
    
    @Value("${repository.order.pk}")
    private long initialSequence;
    
    @Autowired
    private UserRepositoryFactory userRepositoryFactory;
    
    @Bean
    public ItemRepository itemRepository() {
        return new ItemMapRepository();
    }
    
    @Bean
    public OrderRepository orderRepository() {
        return new OrderMapRepository(initialSequence);
    }
    
    @Bean
    public ProductRepository productRepository() {
        return new ProductMapRepository();
    }
    
    @Bean
    public ProposalRepository proposalRepository() {
        return new ProposalMapRepository();
    }
    
    @Bean
    public SellerRepository sellerRepository() {
        return new SellerMapRepository();
    }
    
    @Bean
    public UserRepository userRepository() {
        return userRepositoryFactory.createUserRepository();
    }
}
