package edu.cs.ubbcluj.ro.repository.beans;

import javax.ejb.Stateless;

import edu.cs.ubbcluj.ro.model.Concession;
import edu.cs.ubbcluj.ro.repository.ConcessionRepository;
import edu.cs.ubbcluj.ro.repository.RepositoryException;

@Stateless(name = "ConcessionRepository", mappedName = "ConcessionRepository")
public class ConcessionRepositoryBean extends BaseRepositoryBean<Concession, Integer>
		implements ConcessionRepository {

	public ConcessionRepositoryBean() {
		super(Concession.class);
	}

	@Override
	public Concession getById(Integer id) throws RepositoryException {
		return this.getEntityManager().find(Concession.class, id);

	}

}
