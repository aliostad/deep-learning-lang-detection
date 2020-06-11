package demo.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import demo.repository.UserRepository;

@Component
public class TestServiceImpl implements TestService {

	private UserRepository userRepository;

	@Autowired
	public TestServiceImpl(UserRepository userRepository) {
		this.userRepository = userRepository;
	}

	@Override
	public String getMessage() {
		return "hello " + userRepository.findByUsername("user").getUsername();
	}

}
