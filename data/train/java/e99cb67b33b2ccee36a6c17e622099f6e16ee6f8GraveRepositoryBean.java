package edu.cs.ubbcluj.ro.repository.beans;

import javax.ejb.Stateless;

import edu.cs.ubbcluj.ro.model.Grave;
import edu.cs.ubbcluj.ro.repository.GraveRepository;
import edu.cs.ubbcluj.ro.repository.RepositoryException;

@Stateless(name = "GraveRepository", mappedName = "GraveRepository")
public class GraveRepositoryBean extends BaseRepositoryBean<Grave,Integer> implements GraveRepository{

	
	public GraveRepositoryBean(){
		super(Grave.class);
	}

	@Override
	public Grave getById(Integer id) throws RepositoryException {
		return this.getEntityManager().find(Grave.class, id);

	}
}
