package Service;

import Model.User;

import Repository.RoleRepository;
import Repository.UserRepository;

public class UserService {
	
	private UserRepository _userRepository;
	private RoleRepository _roleRepository;

	public UserService() {
		//Poor Mans Dependency Injection
		_userRepository = new UserRepository();
		_roleRepository = new RoleRepository();
	}
	
	public UserService(UserRepository userRepository) {
		//Poor Mans Dependency Injection
		_userRepository = userRepository;
		_roleRepository = new RoleRepository();
	}
	
	public User login(String email, String password) {
		
		User user = _userRepository.getByEmail(email);
		
		if (user != null) {
			return user.getPassword().equals(password) ? user : null;
		}
		
		return null;
	}
	
	public void register(User user) {
		
		user.setRole(_roleRepository.getById(3));
		
		_userRepository.add(user);
	}

}
