package org.beatific.microservice.container.repository;

public abstract class ObjectRepository<T> {
	
	protected ObjectRepository<T> repository;
	
	public void saveObject(T object) throws RepositoryException {
		repository.saveObject(object);
	}
	
	public void removeObject(T object, Object key) throws RepositoryException {
		repository.removeObject(object, key);
	}

	public void clearObject() throws RepositoryException {
		repository.clearObject();
	}
	
	public T loadObject() throws RepositoryException {
		return repository.loadObject();
	}
}
