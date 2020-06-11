package com.scorpio4.vendor.sesame;

import org.openrdf.repository.Repository;
import org.openrdf.repository.RepositoryException;
import org.openrdf.repository.config.RepositoryConfigException;
import org.openrdf.repository.sail.config.RepositoryResolver;

public class MockRepositoryManager implements RepositoryResolver {
	Repository repository;

	public MockRepositoryManager(Repository repository) {
		this.repository=repository;
	}

	@Override
	public Repository getRepository(String s) throws RepositoryException, RepositoryConfigException {
		return repository;
	}
}