package com.tuenti.supernanny.repo.artifacts;

import java.io.File;

import com.tuenti.supernanny.repo.Repository;

public class Export {
	private Repository repository;
	private String name;
	private File folder;

	public Export(Repository repository, String name, File folder) {
		super();
		this.repository = repository;
		this.name = name;
		this.folder = folder;
	}
	
	public Repository getRepository() {
		return repository;
	}
	
	@Override
	public String toString() {
		return "Export [repository=" + repository + ", name=" + name + ", folder=" + folder + "]";
	}

	public String getName() {
		return name;
	}
	
	public File getFolder() {
		return folder;
	}
}
