package com.tigrang.mvc.model;

import java.util.HashMap;
import java.util.Map;

public class RepositoryManager {

	private static final RepositoryManager INSTANCE = new RepositoryManager();

	private Map<Class, Repository> repositoryMap;

	private RepositoryManager() {
		repositoryMap = new HashMap<>();
	}

	public static RepositoryManager getInstance() {
		return INSTANCE;
	}

	public <E extends Entity> void register(Class<E> eClass, Repository<E> repository) {
		repositoryMap.put(eClass, repository);
	}

	public <E extends Entity, R extends Repository<E>> R get(Class<E> eClass) {
		return (R) repositoryMap.get(eClass);
	}
}
