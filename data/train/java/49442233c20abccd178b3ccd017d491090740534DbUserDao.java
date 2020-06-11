package camt.se331.shoppingcart.dao;

import camt.se331.shoppingcart.entity.User;
import camt.se331.shoppingcart.repository.RoleRepository;
import camt.se331.shoppingcart.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

/**
 * Created by USER on 18/5/2558.
 */
@Repository
public class DbUserDao implements UserDao {
    @Autowired
    UserRepository userRepository;
    @Autowired
    RoleRepository roleRepository;

    @Override
    public User addUser(User user) {
       user.getRoles().add(roleRepository.findOne(2L));
        return userRepository.save(user);
    }
}
