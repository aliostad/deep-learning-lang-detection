package edu.cs.ubbcluj.ro.repository.beans;

import javax.ejb.Stateless;

import edu.cs.ubbcluj.ro.model.Graveyard;
import edu.cs.ubbcluj.ro.repository.GraveyardRepository;
import edu.cs.ubbcluj.ro.repository.RepositoryException;

@Stateless(name = "GraveyardRepository", mappedName = "GraveyardRepository")
public class GraveyardRepositoryBean extends
		BaseRepositoryBean<Graveyard, Integer> implements GraveyardRepository{

	public GraveyardRepositoryBean() {
		super(Graveyard.class);
	}

	@Override
	public Graveyard getById(Integer id) throws RepositoryException {
		return this.getEntityManager().find(Graveyard.class, id);
	}

}
