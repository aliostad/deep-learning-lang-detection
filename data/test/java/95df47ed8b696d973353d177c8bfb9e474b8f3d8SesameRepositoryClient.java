package org.biosemantics.wsd.utility.sesame;

import org.openrdf.repository.Repository;
import org.openrdf.repository.RepositoryException;
import org.openrdf.repository.http.HTTPRepository;

public class SesameRepositoryClient {

	public void setSesameServer(String sesameServer) {
		this.sesameServer = sesameServer;
	}

	public void setRepositoryId(String repositoryId) {
		this.repositoryId = repositoryId;
	}

	public void init() throws RepositoryException {
		repository = new HTTPRepository(sesameServer, repositoryId);
		repository.initialize();
	}

	public void destroy() throws RepositoryException {
		repository.shutDown();
	}
	
	

	public Repository getRepository() {
		return repository;
	}

	private String sesameServer = "http://example.org/sesame2";
	private String repositoryId = "example-db";
	private Repository repository;

}
