package com.zli.todo.service;

import com.zli.todo.model.User;
import com.zli.todo.repository.UserRepository;

public class UserService {

   private final UserRepository userRepository;

   public UserService(UserRepository userRepository) {
      this.userRepository = userRepository;
   }

   public User getUser(String username) {
      return userRepository.findByUsername(username);
   }

   public boolean add(User user) {
      // return false for duplicated username
      if (userRepository.findByUsername(user.getUsername()) != null) {
         return false;
      }

      userRepository.save(user);
      return true;
   }
}
