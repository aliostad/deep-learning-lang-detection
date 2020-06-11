package edu.cs.ubbcluj.ro.repository.beans;

import javax.ejb.Stateless;

import edu.cs.ubbcluj.ro.model.Dead;
import edu.cs.ubbcluj.ro.repository.DeadRepository;
import edu.cs.ubbcluj.ro.repository.RepositoryException;

@Stateless(name = "DeadRepository", mappedName = "DeadRepository")
public class DeadRepositoryBean extends BaseRepositoryBean<Dead, Integer>
		implements DeadRepository {

	public DeadRepositoryBean() {
		super(Dead.class);
	}
	@Override
	public Dead getById(Integer id) throws RepositoryException {
		return this.getEntityManager().find(Dead.class, id);

	}

}
