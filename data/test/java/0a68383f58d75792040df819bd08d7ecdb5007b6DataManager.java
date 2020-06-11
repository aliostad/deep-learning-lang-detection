package com.example.bugrap.data;

import org.vaadin.bugrap.domain.BugrapRepository;

/**
 * The data repository manager.
 * 
 * @author bogdan
 */
public class DataManager {

	/*
	 * The single instance.
	 */
	private static DataManager manager = new DataManager();

	/**
	 * Gets the single instance of login manager.
	 * @return	the single instance of login manager.
	 */
	public static DataManager getManager() {
		return manager;
	}

	/**
	 * Sets the data repository.
	 * @param repository	the data repository.
	 */
	public static void setBugrapRepository(BugrapRepository repository) {
		manager.repository = repository;
	}

	/**
	 * Gets the repository.
	 * @return	the repository.
	 */
	public static BugrapRepository getBugrapRepository() {
		return manager.repository;
	}

	/*
	 * The data repository.
	 */
	private BugrapRepository repository;

	/**
	 * Gets the data repository.
	 * @return	the data repository.
	 */
	public BugrapRepository getRepository() {
		return repository;
	}

}
