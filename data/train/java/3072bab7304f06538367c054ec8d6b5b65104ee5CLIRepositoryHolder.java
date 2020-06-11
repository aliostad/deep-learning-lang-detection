package com.tuneit.salsa3.cli;

import org.springframework.stereotype.Component;

import com.tuneit.salsa3.model.Repository;
import com.tuneit.salsa3.model.Source;

@Component
public class CLIRepositoryHolder {
	private Repository repository;
	private Source source;
	
	public CLIRepositoryHolder() {
		this.repository = null;
		this.source = null;
	}

	public Repository getRepository() {
		return repository;
	}

	public void setRepository(Repository repository) {
		this.repository = repository;
	}

	public Source getSource() {
		return source;
	}

	public void setSource(Source source) {
		this.source = source;
	}
}
