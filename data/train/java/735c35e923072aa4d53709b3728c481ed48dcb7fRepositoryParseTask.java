package com.tuneit.salsa3;

import java.util.List;

import com.tuneit.salsa3.model.Repository;
import com.tuneit.salsa3.model.Source;

public class RepositoryParseTask extends Task {
	private Repository repository;
			
	public RepositoryParseTask(Repository repository) {
		this.repository = repository;
		
		setDescription("Parsing repository '" + repository.getRepositoryName() + 
				   		"' path " + repository.getPath());
	}
	
	@Override
	public void run() {
		RepositoryManager rm = RepositoryManager.getInstance();
		TaskManager tm = TaskManager.getInstance();
		
		List<Source> sources = rm.getSources(repository);
		
		for(Source source : sources) {
			SourceParseTask parseTask = new SourceParseTask(source);
			tm.addTask(parseTask);
		}
	}
}
