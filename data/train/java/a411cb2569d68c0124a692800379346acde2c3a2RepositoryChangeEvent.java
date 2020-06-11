package org.middleheaven.domain.repository;


public class RepositoryChangeEvent<E> {


	private Repository<E> repository;
	private E instance;
	private boolean removed;
	private boolean added;
	private boolean updated;
	
	public RepositoryChangeEvent(Repository<E> repository,
		    E instance, boolean removed, boolean added,
			boolean updated) {
		super();
		this.repository = repository;
		this.instance = instance;
		this.removed = removed;
		this.added = added;
		this.updated = updated;
	}

	public Repository<E> getRepository() {
		return repository;
	}

	public E getInstance() {
		return instance;
	}

	public boolean isRemoved() {
		return removed;
	}

	public boolean isAdded() {
		return added;
	}

	public boolean isUpdated() {
		return updated;
	}
	
	
}
