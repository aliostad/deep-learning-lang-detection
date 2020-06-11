package net.domain;

import static org.junit.Assert.assertThat;
import static org.hamcrest.core.Is.is;
import net.domain.Repository;
import net.domain.RepositoryContext;

import org.junit.Test;

public class TestRepositoryContext {

	@Test
	public void testRepositoryContext() {
		RepositoryContext context = new RepositoryContext();
		
		MockRepository repository = new MockRepository();
		context.add(Domain.class, repository);
		
		MockRepository result = context.get(Domain.class);
		
		assertThat(result, is(repository));
	}
	
	@Test
	public void testRegister() {
		MockRepository repository = new MockRepository();
		Repository.register(Domain.class, repository);
		
		MockRepository result = Repository.find(Domain.class);
		
		assertThat(result, is(repository));
	}
}

class Domain {
}

class MockRepository {
}
