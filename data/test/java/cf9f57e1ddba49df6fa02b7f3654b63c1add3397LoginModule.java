package se.coredev.mocking;

import se.coredev.mocking.repository.RepositoryException;
import se.coredev.mocking.repository.UserRepository;

public final class LoginModule {

	private static final int MAX_NUMBER_OF_RETRIES = 3;
	private final UserRepository userRepository;

	public LoginModule(UserRepository userRepository) {
		this.userRepository = userRepository;
	}

	public boolean login(String username, String password) {

		int retries = 0;
		
		while (retries < MAX_NUMBER_OF_RETRIES) {
			try {
				return userRepository.authenticate(username, password);
			}
			catch (RepositoryException e) {
				retries++;
			}
		}

		return false;
	}

}
