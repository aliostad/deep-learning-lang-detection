package com.annotation.repository.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import com.annotation.repository.UserRepository;

@Service
public class UserService {
	
//	@Autowired
//	@Qualifier("userRepositoryImpl")	//可以在这里设置对应的bean
	private UserRepository userRepository;
	
	
	
	public UserRepository getUserRepository() {
		return userRepository;
	}



	@Autowired
//	@Qualifier("userRepositoryImpl")	//可以在这里设置对应的bean
	public void setUserRepository(@Qualifier("userRepositoryImpl") UserRepository userRepository) {
		this.userRepository = userRepository;
	}



	public void add()
	{
		System.out.println("UserService Add...");
		userRepository.save();
	}

}
