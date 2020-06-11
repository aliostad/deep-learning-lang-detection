package models;

import play.*;
import play.db.jpa.Model;

import java.util.*;

public class Repositories {
	
	private List<Repository> repositories;
	private Repository repository;
	 
	public List<Repository> getRepositories() {
		return repositories;
	}

	public void setRepositories(List<Repository> repositories) {
		this.repositories = repositories;
	}
	
	public void setRepository(Repository repository) {
		this.repository = repository;
	}

	public Repository getRepository() {
		return repository;
	}

	@Override
	public String toString() {
		return "Repositories [repositories=" + repositories + "]";
	}	 
	 
}
