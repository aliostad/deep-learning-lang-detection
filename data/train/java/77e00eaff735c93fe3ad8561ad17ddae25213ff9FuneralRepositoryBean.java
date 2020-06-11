package edu.cs.ubbcluj.ro.repository.beans;

import javax.ejb.Stateless;

import edu.cs.ubbcluj.ro.model.Funeral;
import edu.cs.ubbcluj.ro.repository.FuneralRepository;
import edu.cs.ubbcluj.ro.repository.RepositoryException;

@Stateless(name = "FuneralRepository", mappedName = "FuneralRepository")
public class FuneralRepositoryBean extends BaseRepositoryBean<Funeral, Integer>
		implements FuneralRepository {

	public FuneralRepositoryBean() {
		super(Funeral.class);
	}

	@Override
	public Funeral getById(Integer id) throws RepositoryException {
		return this.getEntityManager().find(Funeral.class, id);

	}

}
