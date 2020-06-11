package com.textprocessing.assignment.ontology.executor;

import org.openrdf.repository.Repository;
import org.openrdf.repository.RepositoryConnection;
import org.openrdf.repository.RepositoryException;
import org.openrdf.repository.http.HTTPRepository;

public class OntologyConnector {

	private String sesameServer;
	private RepositoryConnection con;

	public OntologyConnector(String sesameServer) {
		this.sesameServer = sesameServer;
	}
	
	public RepositoryConnection getConnection() {
		Repository myRepository = new HTTPRepository(sesameServer);
		try {
			myRepository.initialize();
			con = myRepository.getConnection();
		}catch(RepositoryException e){
			System.err.println(e);
		}
		return con;
	}
	
}
