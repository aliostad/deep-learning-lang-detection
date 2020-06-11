package org.dmdpp.twitter;

public class Fixtures {

	public static UserRepository repositoryWithOneUser() {
		UserRepository userRepository = new Users();
		userRepository.save(new User("@pasku1"));
		return userRepository;
	}

	public static User userWithTwoFollowings() {
		User user = new User("@nick");

		user.follow(new User("@uno"));
		user.follow(new User("@dos"));

		return user;
	}
	
	public static UserRepository repositoryWithOneUserAndTwoFollowings() {
		UserRepository userRepository = new Users();
		userRepository.save(userWithTwoFollowings());
		return userRepository;
	}

	public static UserRepository repositoryWithTwoUser() {
		UserRepository userRepository = new Users();
		userRepository.save(new User("@pasku1"));
		userRepository.save(new User("@rober"));
		return userRepository;
	}
}
