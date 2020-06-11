package com.farata.course.mwd.auction.data;

import javax.annotation.PostConstruct;
import javax.inject.Singleton;

@Singleton
public class DataEngine {

    @PostConstruct void init() {
        initAll();
    }

    private ProductRepository productRepository;
    private BidRepository bidRepository;
    private UserRepository userRepository;

    private void initAll()
    {
        productRepository = new ProductRepository();
        userRepository = new UserRepository();
        bidRepository = new BidRepository(productRepository, userRepository);
    }

    public BidRepository getBidRepository() {return bidRepository;}

    public ProductRepository getProductRepository() {return productRepository;}

    public UserRepository getUserRepository() {return  userRepository;}
}
