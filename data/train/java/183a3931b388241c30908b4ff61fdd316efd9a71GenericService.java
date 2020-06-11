package br.com.sgd.generic;

import java.util.List;



public abstract class GenericService<T> {

	private GenericRepository<T> repository;

	public GenericRepository<T> getRepository() {
		return repository;
	}

	public void setRepository(GenericRepository<T> repository) {
		this.repository = repository;
	}

	public T salvar(T entidade) {
		setRepository(repository);
		return getRepository().salvar(entidade);
	}

	public List<T> findAll() {
		return getRepository().findAll();
	}
	
	public void delete(T entidade){
		getRepository().delete(entidade);
		
	}

}
