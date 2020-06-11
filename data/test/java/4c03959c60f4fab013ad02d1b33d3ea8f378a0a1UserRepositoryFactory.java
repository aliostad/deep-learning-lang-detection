package com.epam.jmp.spring.repository;

import org.apache.log4j.Logger;

/**
 * Date: 12/14/2014
 * Time: 1:06 PM
 *
 * @author Artur Memekh
 */
public class UserRepositoryFactory {

    private static final Logger logger = Logger.getLogger(UserRepositoryFactory.class);

    private static final UserRepository userRepository = new UserRepository();

    private UserRepository createUserRepository() {
        logger.info("inside \'createUserRepository\' method...");
        return userRepository;
    }
}
