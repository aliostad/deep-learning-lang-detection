package service.impl;

import model.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import repository.MessageRepository;
import repository.UserRepository;
import service.UserService;

@Service
public class UserServiceImpl implements UserService {

    private UserRepository userRepository;
    private MessageRepository messageRepository;

    @Autowired
    public UserServiceImpl(UserRepository userRepository, MessageRepository messageRepository) {
        this.userRepository = userRepository;
        this.messageRepository = messageRepository;
    }




    @Override
    public User getUserById(Long id) {
        return userRepository.findOne(id);
    }

    @Override
    public User getUserByName(String name) {
        return userRepository.findByName(name);
    }

//    @Override
//    public Message saveMessage(Message m) {
//        return messageRepository.save(m);
//    }

}
