package at.badgateway.spring.data.osgi.tests;

import at.badgateway.osgi.integration.mongodb.domain.User;
import at.badgateway.osgi.integration.mongodb.repository.UserRepository;

public class AuditorTest extends PluginDependencyOsgiAbstractTests {

	private UserRepository repository;

	public void setRepository(UserRepository repository) {
		this.repository = repository;
	}

	public void testInsert() {
		User u = new User();
		u.setFirstname("foo");
		u.setLastname("bar");
		repository.save(u);
	}

	public void testFindAllAndDelete() {
		Iterable<User> users = repository.findAll();
		for (User u : users) {
			repository.delete(u);
		}

	}

}
