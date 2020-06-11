package com.aldercape.internal.economics.persistence;

import static org.junit.Assert.*;

import org.junit.Test;

import com.aldercape.internal.economics.model.ClientRepository;

public class RepositoryRegisterTest {

	@Test
	public void test() {
		RepositoryRegistry registry = new RepositoryRegistry();
		ClientRepository repository = registry.getRepository(ClientRepository.class);
		assertNull(repository);
		registry.setRepository(ClientRepository.class, new InMemoryClientRepository());
		repository = registry.getRepository(ClientRepository.class);
		assertNotNull(repository);

	}

}
